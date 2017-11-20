package tests;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

public class ListTest {

	@Test
	public void testList() {
		
		List<String> events = new ArrayList<String>();
		events.add("122");
		
		System.out.println(
				events.contains("122")
		);

		System.out.println(
				events.contains("123")
		);
		
	}
	
}
