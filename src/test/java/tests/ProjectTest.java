package tests;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import architecture.community.projects.Project;
import architecture.community.projects.ProjectService;
import architecture.community.user.UserManager;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration("WebContent/")
@ContextConfiguration(locations = { "classpath:application-community-context.xml" })
public class ProjectTest {

	private static Logger log = LoggerFactory.getLogger(BoardTest.class);

	@Autowired
	private ProjectService projectService;

	@Autowired
	private UserManager userManager;
	
	public ProjectTest() { 
	}
	
	
	@Test 
	public void testNewPage() {
		
		if( projectService.getProjects().size() == 0 ){
		Project project = new Project();
		project.setName("한국항공우주산업");
		project.setSummary("한국항공우주산업 프로젝트");
		projectService.saveOrUpdateProject(project);
		}
	}

}
