package architecture.community.web.spring.controller.page;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import architecture.community.menu.MenuItemTreeWalker;
import architecture.community.menu.MenuNotFoundException;
import architecture.community.menu.MenuService;
import architecture.community.page.Page;
import architecture.community.page.PageNotFoundException;
import architecture.community.page.PageService;
import architecture.community.web.util.ServletUtils;
import architecture.ee.service.ConfigService;

@Controller("welcome-page-controller")
public class WelcomePageController {

	private static final Logger log = LoggerFactory.getLogger(WelcomePageController.class);	

	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	@Inject
	@Qualifier("pageService")
	private PageService pageService;
	
	@Inject
	@Qualifier("menuService")
	private MenuService menuService;
	
	@RequestMapping(value={"/", "/index", "/index.html"} , method = { RequestMethod.POST, RequestMethod.GET } )
    public String displayWelcomePage (HttpServletRequest request, HttpServletResponse response, Model model) throws MenuNotFoundException {
		ServletUtils.setContentType(ServletUtils.DEFAULT_HTML_CONTENT_TYPE, response);
		String view = "index";
		try {
			
			Page page = pageService.getPage("index.html", 1);
			model.addAttribute("__page", page); 
			if( StringUtils.isNotEmpty( page.getTemplate() ) )
			{
				view = page.getTemplate();
				view = StringUtils.removeEnd(view, ".ftl");					
			}
			
		} catch (PageNotFoundException e) {
		}		
		
		String name = configService.getApplicationProperty("website.header.menu", null);
		if( name != null ) {
			MenuItemTreeWalker walker = menuService.getTreeWalker(name);
			model.addAttribute("__menu", walker);
		}
		
		return view;
    }

}
