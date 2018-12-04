package tests;

import java.net.URLEncoder;

import org.apache.commons.codec.binary.Base64;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Base64EncodeTest {

private static Logger log = LoggerFactory.getLogger(NumberFormatTest.class);
	
	@Test
	public void testEmailToUsername(){
		
		try {
			String enc = "" ; //new String( Base64.encode(FileUtils.readFileToByteArray(new File("/Users/donghyuck/Documents/podo_workspace/neuro_english/WebContent/images/common/icons/basic/color/Siren.svg")) ));
			String text = "0521.xls";
			
			enc = Base64.encodeBase64String(text.getBytes());

			/* 
			http://www.q-net.or.kr/obSearchMain.jsp?q=%C0%CE%C5%CD%B3%DD&w=qual_info&gSite=Q&gId=07
			*/	
			
			log.debug( enc );
			
			enc = URLEncoder.encode(text, "EUC-KR");
			
			log.debug( enc );
			
			enc = URLEncoder.encode(text, "UTF-8");
			
			log.debug( enc );
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
}
