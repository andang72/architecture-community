package tests;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import architecture.community.export.CommunityExportService;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration("WebContent/")
@ContextConfiguration(locations = {
	"classpath:context/default-bootstrap-context.xml", 
	"classpath:context/community-components-context.xml", 
	"classpath:application-services-context.xml" })

public class ExportTest {

	private static Logger log = LoggerFactory.getLogger(ExportTest.class);
	
	@Autowired
	private CommunityExportService exportService;
	
	public ExportTest() {
		
	}

	
	@Test
	public void testReadXml() {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("START_DATE", "20170101");
		params.put("END_DATE", "20180301");
		exportService.initialize();
		log.debug(" exportService {} ", exportService.getClass().getName());
		
		
		
	}
}
