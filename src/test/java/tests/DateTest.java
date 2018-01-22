package tests;

import java.util.Calendar;
import java.util.Date;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DateTest {
	private static Logger log = LoggerFactory.getLogger(DateTest.class);
	
	public DateTest() {
	}
	
	private static java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy.MM.dd");
		
	@Test 
	public void testGetSat() {
		Calendar c = Calendar.getInstance();
		
		
		
		Date today = c.getTime();
		
		c.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY );
		Date sat = c.getTime();
		
		log.debug("today is {}, saturday is {}.", formatter.format(today), formatter.format(sat));
		
		
	}
	
	@Test 
	public void testGetDays() {
		Calendar c = Calendar.getInstance();
		
		
		
		Date today = c.getTime();		
		c.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY );
		Date sat = c.getTime();
		
		log.debug("today is {}, saturday is {}.", formatter.format(today), formatter.format(sat));
		
		
	}
}
