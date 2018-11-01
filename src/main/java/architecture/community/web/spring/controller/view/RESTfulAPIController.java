package architecture.community.web.spring.controller.view;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.common.base.Stopwatch;

import architecture.community.exception.NotFoundException;
import architecture.community.exception.UnAuthorizedException;
import architecture.community.model.Models;
import architecture.community.page.api.Api;
import architecture.community.page.api.ApiService;
import architecture.community.query.CustomQueryService;
import architecture.community.security.spring.acls.CommunityAclService;
import architecture.community.security.spring.acls.JdbcCommunityAclService.PermissionsBundle;
import architecture.community.services.CommunityGroovyService;
import architecture.community.util.SecurityHelper;
import architecture.community.viewcount.ViewCountService;
import architecture.community.web.model.json.Result;
import architecture.community.web.spring.view.DataView;
import architecture.ee.service.ConfigService;
/**
 * 
 * 
 * @author donghyuck
 *
 */
 
@RestController("restful-api-data-controller")
@RequestMapping("/data")
public class RESTfulAPIController {

	private Logger log = LoggerFactory.getLogger(getClass());
	
	@Inject
	@Qualifier("apiService")
	private ApiService apiService;
	
	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	@Inject
	@Qualifier("customQueryService")
	private CustomQueryService customQueryService;
	
	@Inject
	@Qualifier("communityAclService")
	private CommunityAclService communityAclService;
	
	@Inject
	@Qualifier("communityGroovyService")
	private CommunityGroovyService communityGroovyService;
	
	@Inject
	@Qualifier("viewCountService")
	private ViewCountService viewCountService;
	
	public RESTfulAPIController() { 
	
	}

	@RequestMapping(value = "/apis/{filename:.+}", method = { RequestMethod.POST, RequestMethod.GET })
    public Object page (
    		@PathVariable String filename,
    		@RequestParam(value = "version", defaultValue = "1", required = false) int version,
    		@RequestParam(value = "preview", defaultValue = "false", required = false) boolean preview,
	    HttpServletRequest request, 
	    HttpServletResponse response, 
	    Model model) 
	    throws NotFoundException, UnAuthorizedException , Exception {
		
		log.debug("RESTful API : {}, {}", filename, version );
		Api api = apiService.getApi(filename); 
		
		if( !api.isEnabled() )
			throw new UnAuthorizedException("RESTful API is disabled.");
		
		// checking permissions.
		if( api.getApiId() > 0 ) {
			if( api.isSecured() ) {
				PermissionsBundle bundle = communityAclService.getPermissionBundle(SecurityHelper.getAuthentication(), Models.API.getObjectClass(), api.getApiId());
				if( !bundle.isRead() )
					throw new UnAuthorizedException("Access Permission Required.");
			}
		}
		 
		
		Result result = Result.newResult();
		model.addAttribute("__page", api );
		
		if(StringUtils.isNotEmpty(api.getScriptSource())) { 
			
			Stopwatch stopwatch = Stopwatch.createStarted(); 
			try {
				DataView _view = communityGroovyService.getService(api.getScriptSource(), DataView.class);
				return _view.handle(model, request, response);
			} catch (Exception e) { 
				result.setError(e);
			} finally {
				stopwatch.stop();
				log.info("script:{}, time:{} ", filename, stopwatch);
			}
		} 
		if(result.isSuccess()) {
			result.setSuccess(false);
		}
		return result;
	
	}	
	
}
