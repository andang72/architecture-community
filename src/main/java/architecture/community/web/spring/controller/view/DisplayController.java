package architecture.community.web.spring.controller.view;

import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.ClassUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UrlPathHelper;

import architecture.community.board.Board;
import architecture.community.board.BoardNotFoundException;
import architecture.community.board.BoardService;
import architecture.community.board.BoardThread;
import architecture.community.board.DefaultBoard;
import architecture.community.board.DefaultBoardThread;
import architecture.community.exception.NotFoundException;
import architecture.community.exception.UnAuthorizedException;
import architecture.community.model.Models;
import architecture.community.page.Page;
import architecture.community.page.PageService;
import architecture.community.page.PathPattern;
import architecture.community.security.spring.acls.CommunityAclService;
import architecture.community.security.spring.acls.JdbcCommunityAclService.PermissionsBundle;
import architecture.community.util.SecurityHelper;
import architecture.community.viewcount.ViewCountService;
import architecture.community.web.spring.controller.view.binding.ObjectBinder;
import architecture.community.web.util.ServletUtils;
import architecture.ee.service.ConfigService;

@Controller("community-display-controller")
@RequestMapping("/display")
public class DisplayController {

	private static final String BINDING = "binding.";
	
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
	private CommunityAclService communityAclService;
	
	@Inject
	@Qualifier("viewCountService")
	private ViewCountService viewCountService;
	
	@Autowired
	private ConfigurableBeanFactory beanFactory;
	
	@RequestMapping(value = "/pages/{filename:.+}", method = { RequestMethod.POST, RequestMethod.GET })
    public String page (
    		@PathVariable String filename,
    		@RequestParam(value = "version", defaultValue = "1", required = false) int version,
    		@RequestParam(value = "boardId", defaultValue = "0", required = false) long boardId,
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
		
		if( Boolean.parseBoolean(StringUtils.defaultString(page.getProperties().get("pages.board"), "false")) )
		{
			Board board = new DefaultBoard();
			if( boardId > 0 ) {
				try {
					board = boardService.getBoardById(boardId);
				} catch (BoardNotFoundException e) { 
				}	
			} 
			model.addAttribute("__board", board);	 
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
	
	
	/**
	 * 
	 * binding.*.handler.class = 
	 * 
	 */
	@RequestMapping(value = "/pages/*/**", method = { RequestMethod.POST, RequestMethod.GET })
    public String pattern (
    	@RequestParam(value = "version", defaultValue = "1", required = false) int version,
    	@RequestParam(value = "preview", defaultValue = "false", required = false) boolean preview,
    	HttpServletRequest request, 
	    HttpServletResponse response, 
	    Model model) 
	    throws NotFoundException, UnAuthorizedException {	
		
		String view = null;
 		UrlPathHelper pathHelper = new UrlPathHelper();
 		String path = pathHelper.getLookupPathForRequest(request);
 		AntPathMatcher pathMatcher = new AntPathMatcher(); 
 		
 		String formatS = "/display/pages/scm/{scmId:[\\p{Digit}]+}/scm-viewer.html";
 		
 		Map<String, String> variables2 = pathMatcher.extractUriTemplateVariables(formatS, path); 
 		String pp = pathMatcher.extractPathWithinPattern(formatS, path);
 		log.debug("it's pattern : {}", pathMatcher.isPattern(formatS));
 		log.debug("patten path values {} : {} > {}" , pp, variables2, pathMatcher.match(formatS, path)); 
 		
 		for( PathPattern pattern : pageService.getPathPatterns("/display/pages") )
 		{ 	
 			
 			log.debug(" '{}' and '{}' is {}" , 
 					formatS, 
 					pattern.getPattern(), 
 					StringUtils.equals(formatS, pattern.getPattern())); 
 			boolean isPattern = pathMatcher.isPattern(pattern.getPattern()); 
 			boolean match = false;
 			Map<String, String> variables = null; 
 			if( isPattern) {
 				AntPathRequestMatcher matcher = new AntPathRequestMatcher(pattern.getPattern());
 				match = matcher.matches(request) ;
 				variables = matcher.extractUriTemplateVariables(request);  
 			}else {  
 				variables = pathMatcher.extractUriTemplateVariables(pattern.getPattern(), path); 
 				match = pathMatcher.match( pattern.getPattern(), path);
 			}	
 			
 			log.debug("Path Pattern Checking (pattern:{}) : {}, match : {}, variables: {}", isPattern, pattern.getPattern(), match, variables);
 			
 			if( match ) {  
 				Page page = pageService.getPage(pattern.getObjectId(), version);
 				if( page.getPageId() > 0 ) {
 					if( page.isSecured() ) {
 						PermissionsBundle bundle = communityAclService.getPermissionBundle(SecurityHelper.getAuthentication(), Models.PAGE.getObjectClass(), page.getPageId());
 						if( !bundle.isRead() )
 							throw new UnAuthorizedException();
 					}
 					if( viewCountService!=null && !preview  )
 						viewCountService.addViewCount(page);	
 				}
 				view = page.getTemplate();
 				model.addAttribute("__page", page); 
 				model.addAttribute("__variables", variables);  

 				Set<String> keys = page.getProperties().keySet();
 				if(!keys.isEmpty()) { 
 					for(String key : keys){ 
 						if( Pattern.matches("binding.*.handler.class", key) && StringUtils.isNotEmpty(page.getProperties().get(key))) { 
							try {
								String nameToUse = StringUtils.removeStart(key, "binding.");
								nameToUse = StringUtils.removeEnd(nameToUse, ".handler.class");
								Class<?> clazz = ClassUtils.forName(page.getProperties().get(key), this.getClass().getClassLoader());								
								ObjectBinder binder = (ObjectBinder) clazz.newInstance(); 
								try {
									binder.bind( model, nameToUse, page.getProperties(), variables , beanFactory );
								} catch (Exception e) {
									if( e instanceof NotFoundException) {
										throw (NotFoundException) e;
									}
								}
							} catch (ClassNotFoundException | LinkageError e) {
								// ignore..
							} catch (InstantiationException e) {
								// ignore ..
							} catch (IllegalAccessException e) {
								// ignore ..
							}
 						} 
 					}
 				}
 				break;
 			}
 		} 
 		
 		ServletUtils.setContentType(ServletUtils.DEFAULT_HTML_CONTENT_TYPE, response);
 		if(StringUtils.isNotEmpty( view ) )
		{
			view = StringUtils.removeEnd(view, ".ftl");			
		}else {
			view = configService.getLocalProperty("view.html.page");
		} 
		log.debug("return view [{}]", view);
 		return view;
	}
 
}
