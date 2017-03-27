package tests;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class NumberFormatTest {

	private static Logger log = LoggerFactory.getLogger(NumberFormatTest.class);
	
	
	@Test
	public void testFormatNumber(){
		
		log.debug(
			String.format("%02d", 11)
		);
		
	}
}
