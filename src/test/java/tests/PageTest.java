package tests;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import architecture.community.page.BodyType;
import architecture.community.page.Page;
import architecture.community.page.PageNotFoundException;
import architecture.community.page.PageService;
import architecture.community.user.User;
import architecture.community.user.UserManager;
import architecture.community.user.UserTemplate;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration("WebContent/")
@ContextConfiguration(locations = { "classpath:application-community-context.xml" })

public class PageTest {

	private static Logger log = LoggerFactory.getLogger(BoardTest.class);

	@Autowired
	private PageService pageService;

	@Autowired
	private UserManager userManager;
	
	
	@Test 
	public void testNewPage() {
		
		String name = "test.html";
		String title = "테스트";
		Page page;
		try {
			page = pageService.getPage(1);
			log.debug("----------------------");
			log.debug(" page props : {}", page.getProperties());
			
			page.getProperties().put("forward", "true");
			//pageService.saveOrUpdatePage(page);
			
		} catch (PageNotFoundException e) {
			e.printStackTrace();
			/*
			User newUesr = new UserTemplate("king", "1234", "킹", false, "king@king.com", false);
			log.debug("---------------" + newUesr);
			User existUser = userManager.getUser(newUesr);
			
			Page newPage = pageService.createPage(existUser, BodyType.FREEMARKER, name, title, null);
			log.debug("1> new page {}, {}", newPage.getPageId(), newPage.getPageState() );
			pageService.saveOrUpdatePage(newPage);
			log.debug("2> new page {}, {}", newPage.getPageId(), newPage.getPageState() );
			*/
		}
		
	}

}
