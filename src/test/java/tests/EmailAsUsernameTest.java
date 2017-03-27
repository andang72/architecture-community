package tests;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EmailAsUsernameTest {

	private static Logger log = LoggerFactory.getLogger(NumberFormatTest.class);
	
	@Test
	public void testEmailToUsername(){
		
		String email = "test@test.com";
		int index = email.indexOf('@');
		
		log.debug( email.substring(0, index ));
		
	}
}
