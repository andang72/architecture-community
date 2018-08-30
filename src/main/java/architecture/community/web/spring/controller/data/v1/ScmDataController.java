package architecture.community.web.spring.controller.data.v1;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.tmatesoft.svn.core.io.SVNRepository;

import architecture.community.projects.Scm;
import architecture.community.projects.ScmNotFoundException;
import architecture.community.projects.ScmService;
import architecture.ee.util.StringUtils;

@Controller("scm-data-controller")
@RequestMapping("/data/api/v1/scm")
public class ScmDataController {

	public ScmDataController() { 
	}
	
	private Logger log = LoggerFactory.getLogger(getClass());
	
	@Inject
	@Qualifier("scmService")
	private ScmService scmService;
	
	@Secured({ "ROLE_DEVELOPER" })
	@RequestMapping(value = "/{scmId:[\\p{Digit}]+}/tree/{branche}/{path:.+}", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public List tree (
		@PathVariable("scmId") Long scmId, 
		@PathVariable("branche") String branche, 
		@PathVariable("path") String path, 
	    HttpServletResponse response) throws ScmNotFoundException {		
		
		log.debug("searching scm by {}", scmId );
		log.debug("list entries for {}", path);
		
		Scm scm = scmService.getScmById(scmId);
		
		SVNRepository svn = scmService.getSVNRepository(scm);
		
		return scmService.listEntries(svn, StringUtils.defaultString(path, ""));
		
	}
}
