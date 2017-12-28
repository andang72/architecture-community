package tests;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration("WebContent/")
@ContextConfiguration(locations = { "classpath:application-community-context.xml" })
public class MailSendTest {

	private static Logger log = LoggerFactory.getLogger(MailSendTest.class);
	
	@Autowired
	private TaskExecutor taskExecutor;

	public MailSendTest() {
	}

	@Test
	public void testTask() {
		
		log.debug("executor  {}", taskExecutor.toString());
		
		taskExecutor.execute( new Runnable() {

			public void run() {
				log.debug("run backgrounding ..... ");
				try {
					Thread.sleep(3000);
				} catch (InterruptedException e) {
				}
			}
			
		});
		
		log.debug("run forgrounding ..... ");
		
	}
}
