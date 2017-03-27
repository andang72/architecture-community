package tests;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.codec.Base64;

public class Base64EncodeTest {

private static Logger log = LoggerFactory.getLogger(NumberFormatTest.class);
	
	@Test
	public void testEmailToUsername(){
		
		try {
			String enc = "" ; //new String( Base64.encode(FileUtils.readFileToByteArray(new File("/Users/donghyuck/Documents/podo_workspace/neuro_english/WebContent/images/common/icons/basic/color/Siren.svg")) ));
			log.debug( enc );
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
}
