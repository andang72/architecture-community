package architecture.community.web.spring.controller.page;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.HandlerMapping;
import org.tmatesoft.svn.core.SVNDirEntry;
import org.tmatesoft.svn.core.SVNException;
import org.tmatesoft.svn.core.SVNProperties;
import org.tmatesoft.svn.core.SVNProperty;
import org.tmatesoft.svn.core.io.SVNRepository;

import architecture.community.exception.NotFoundException;
import architecture.community.exception.UnAuthorizedException;
import architecture.community.model.Models;
import architecture.community.page.PageService;
import architecture.community.projects.Project;
import architecture.community.projects.ProjectService;
import architecture.community.projects.Scm;
import architecture.community.projects.ScmService;
import architecture.community.security.spring.acls.CommunityAclService;
import architecture.community.security.spring.acls.JdbcCommunityAclService.PermissionsBundle;
import architecture.community.util.SecurityHelper;
import architecture.community.web.util.ServletUtils;
import architecture.ee.service.ConfigService;

@Controller("helpdesk-scm-display-controller")
@RequestMapping("/display/scm")
public class ScmPageController {
	
	private Logger log = LoggerFactory.getLogger(getClass());
	
	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	@Inject
	@Qualifier("pageService")
	private PageService pageService;
	
	@Inject
	@Qualifier("scmService")
	private ScmService scmService;
	
	@Inject
	@Qualifier("projectService")
	private ProjectService projectService;
	
	@Inject
	@Qualifier("communityAclService")
	private CommunityAclService communityAclService;
	
	public ScmPageController() {
	}

	@Secured({ "ROLE_USER" })
	@RequestMapping(value = { "/{scmId:[\\p{Digit}]+}/tree" , "/{scmId:[\\p{Digit}]+}/tree/**" }, method = { RequestMethod.POST, RequestMethod.GET})
    public String displayTree (
    		@PathVariable Long scmId,
    		@RequestParam(value = "path", defaultValue = "", required = false) String path,
    		HttpServletRequest request, HttpServletResponse response, Model model) throws NotFoundException, UnAuthorizedException {
 
		String pathToUse = "";
		if( StringUtils.isNotEmpty(path))
		{
			pathToUse = path ;
		}else {
			String restOfTheUrl = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);	
	 		String bestMatchPattern = (String) request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE);
			AntPathMatcher apm = new AntPathMatcher();
			pathToUse = apm.extractPathWithinPattern(bestMatchPattern, restOfTheUrl); 
			log.debug("error restOfTheUrl:" + restOfTheUrl);
		} 
			
		log.debug("searching scm by {}", scmId );
		log.debug("list entries for {}", path);		
		
		Scm scm = scmService.getScmById(scmId);
		model.addAttribute("__scm", scm);
		model.addAttribute("__path", pathToUse); 
		
		if( scm.getObjectType() == Models.PROJECT.getObjectType() ) {
			Project project = projectService.getProject(scm.getObjectId());
			PermissionsBundle bundle = communityAclService.getPermissionBundle(SecurityHelper.getAuthentication(), Models.PROJECT.getObjectClass(), project.getProjectId());
			if( !bundle.isRead() )
				throw new UnAuthorizedException();
			model.addAttribute("__project", project);
		}
		
		ServletUtils.setContentType(ServletUtils.DEFAULT_HTML_CONTENT_TYPE, response);
		return "/helpdesk/scm-default-viewer" ;
    }
	
	
	@Secured({ "ROLE_USER" })
	@RequestMapping(value = { "/{scmId:[\\p{Digit}]+}/download" }, method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
    public void download (
    		@PathVariable Long scmId,
    		@RequestParam(value = "path", defaultValue = "", required = true) String path,
    		HttpServletRequest request, HttpServletResponse response, Model model) throws NotFoundException, UnAuthorizedException, SVNException {

		log.debug("searching scm by {}", scmId );
		log.debug("list entries for {}", path);		
		
		Scm scm = scmService.getScmById(scmId); 
		if( scm.getObjectType() == Models.PROJECT.getObjectType() ) {
			Project project = projectService.getProject(scm.getObjectId());
			PermissionsBundle bundle = communityAclService.getPermissionBundle(SecurityHelper.getAuthentication(), Models.PROJECT.getObjectClass(), project.getProjectId());
			if( !bundle.isRead() )
				throw new UnAuthorizedException(); 
		} 
		
		SVNRepository repository = scmService.getSVNRepository(scm);
		SVNDirEntry info = repository.info(path, -1); 
		
		SVNProperties fileProperties = new SVNProperties();
	    ByteArrayOutputStream baos = new ByteArrayOutputStream();
	    try {
			repository.getFile(path, -1, fileProperties, baos);
		} catch (SVNException e) { 
			e.printStackTrace();
		} 
	    
		String mimeType = fileProperties.getStringValue(SVNProperty.MIME_TYPE);
		boolean isTextType = SVNProperty.isTextMimeType(mimeType);  
		
		try {
			log.debug(
				"file name : {}, type : {} , size : {} ", info.getName(), mimeType, info.getSize() 
			);
			
			if(StringUtils.isEmpty( mimeType)) {
				log.debug("mimetype is not detectable, will take default");
				mimeType = "application/octet-stream";
			}
			
			response.setContentType(mimeType);
			
			/* "Content-Disposition : inline" will show viewable types [like images/text/pdf/anything viewable by browser] right on browser 
            while others(zip e.g) will be directly downloaded [may provide save as popup, based on your browser setting.]*/
        
			response.setHeader("Content-Disposition", "inline; filename=\"" + ServletUtils.getEncodedFileName(info.getName()) +"\"");
			response.setContentLength((int)info.getSize()); 
			baos.writeTo( response.getOutputStream()); 
			response.flushBuffer(); 
		} catch (IOException e) {
			e.printStackTrace();
		}
    }	
}
