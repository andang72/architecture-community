package architecture.community.web.spring.controller.view;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import architecture.community.board.BoardService;
import architecture.community.board.BoardThread;
import architecture.community.board.DefaultBoardThread;
import architecture.community.exception.NotFoundException;
import architecture.community.exception.UnAuthorizedException;
import architecture.community.model.Models;
import architecture.community.page.Page;
import architecture.community.page.PageService;
import architecture.community.security.spring.acls.JdbcCommunityAclService;
import architecture.community.security.spring.acls.JdbcCommunityAclService.PermissionsBundle;
import architecture.community.util.SecurityHelper;
import architecture.community.viewcount.ViewCountService;
import architecture.community.web.util.ServletUtils;
import architecture.ee.service.ConfigService;

@Controller("community-display-controller")
@RequestMapping("/display")
public class DisplayController {

	private Logger log = LoggerFactory.getLogger(getClass());

	@Inject
	@Qualifier("pageService")
	private PageService pageService;

	
	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	@Inject
    @Qualifier("boardService")
    private BoardService boardService;
	
	@Inject
	@Qualifier("communityAclService")
	private JdbcCommunityAclService communityAclService;
	
	@Inject
	@Qualifier("viewCountService")
	private ViewCountService viewCountService;
	
	
	@RequestMapping(value = "/pages/{filename:.+}", method = { RequestMethod.POST, RequestMethod.GET })
    public String page (
    		@PathVariable String filename,
    		@RequestParam(value = "version", defaultValue = "1", required = false) int version,
    		@RequestParam(value = "threadId", defaultValue = "0", required = false) long threadId,
    		@RequestParam(value = "preview", defaultValue = "false", required = false) boolean preview,
	    HttpServletRequest request, 
	    HttpServletResponse response, 
	    Model model) 
	    throws NotFoundException, UnAuthorizedException {	
		log.debug("page : {} {}", filename, version );
		Page page = pageService.getPage(filename, version);		
		log.debug("page : {}", page );
		model.addAttribute("__page", page); 
		
		if( page.getPageId() > 0 ) {
			if( page.isSecured() ) {
				PermissionsBundle bundle = communityAclService.getPermissionBundle(SecurityHelper.getAuthentication(), Models.PAGE.getObjectClass(), page.getPageId());
				if( !bundle.isRead() )
					throw new UnAuthorizedException();
			}
			if( viewCountService!=null && !preview  )
				viewCountService.addViewCount(page);	
		}
		
		if( Boolean.parseBoolean(StringUtils.defaultString(page.getProperties().get("pages.board.thread"), "false")) )
		{	
			BoardThread thread ;
			if( threadId > 0 ) {
				thread = boardService.getBoardThread(threadId);
				if( viewCountService!=null && !preview  )
					viewCountService.addViewCount(thread);			
			}else {
				thread = new DefaultBoardThread();
			}
			model.addAttribute("__thread", thread);	
		}
		
		ServletUtils.setContentType(ServletUtils.DEFAULT_HTML_CONTENT_TYPE, response);
		String view = page.getTemplate();
		if(StringUtils.isNotEmpty( view ) )
		{
			view = StringUtils.removeEnd(view, ".ftl");			
		}else {
			view = configService.getLocalProperty("view.html.page");
		}
		return view;
    }
	
}
