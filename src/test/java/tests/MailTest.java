package tests;

import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.junit.Test;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

public class MailTest {

	public MailTest() {
		// TODO Auto-generated constructor stub
	}

	
	@Test
	public void testSendMail() {
		JavaMailSender mailSender = creatJavaeMailSender() ;
	    try {
	    		MimeMessage message = mailSender.createMimeMessage();
	      message.setSubject("[공지] 회원 가입 안내", "UTF-8");
	      String htmlContent = "<strong>안녕하세요</strong>, 반갑습니다.";
	      message.setText(htmlContent, "UTF-8", "html");
	      message.setFrom(new InternetAddress("xxx@gmail.com"));
	      message.addRecipient(RecipientType.TO, new InternetAddress("dhson@podosw.com"));
	     // mailSender.send(message);
	    } catch (MessagingException e) {
	      e.printStackTrace();
	      return;
	    } catch (MailException e) {
	      e.printStackTrace();
	      return;
	    } // try - catch

 
	}
	
	private JavaMailSender creatJavaeMailSender() {
		
		JavaMailSenderImpl mailSender = new  JavaMailSenderImpl();
		mailSender.setHost("mail.podosw.com");
		mailSender.setUsername("noreply");
		mailSender.setPassword("podo))&");
		//mailSender.setPort(25);
		mailSender.setDefaultEncoding("UTF-8");
		return mailSender;
		
	}
}
