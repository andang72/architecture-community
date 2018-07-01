package architecture.community.components;

import java.util.Properties;

import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.Provider;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.search.FlagTerm;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import architecture.ee.util.StringUtils;
 

public class EmailMonitor {
	
	private Logger log = LoggerFactory.getLogger(EmailMonitor.class);
	
	public EmailMonitor() { 
	}

	public boolean testConnection()
    {
        boolean success = false;
        String host = "imap.worksmobile.com"; //JiveGlobals.getJiveProperty("checkmail.host");
        int port = 993; // JiveGlobals.getJiveIntProperty("checkmail.port", 110);
        boolean ssl = false; //JiveGlobals.getJiveBooleanProperty("checkmail.useSSL", false);
        String username = "dhson@podosw.com"; //JiveGlobals.getJiveProperty("checkmail.username", "");
        String password = "dhson007A"; //JiveGlobals.getJiveProperty("checkmail.password", "");
        String accountType ="imap"; // JiveGlobals.getJiveProperty("checkmail.protocol", "POP3");
        Store store = null;
        Folder folder = null;
        try
        {
        	Properties props = new Properties();
           // props.setProperty("mail.imap.host", "imap.worksmobile.com");
           // props.put("mail.imap.port", "993");
            props.put("mail.imap.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            props.put("mail.imap.socketFactory.fallback","false");
          //  props.put("mail.imap.socketFactory.port", "993");
          
        	Session session = Session.getDefaultInstance(props, null);
            session.setDebug(true);
            
            for ( Provider p: session.getProviders() )
            {	
            	log.debug("provider {}", p.getClassName());
            }
            
            if(ssl)
                store = session.getStore((new StringBuilder()).append(accountType).append("s").toString());
            else
                store = session.getStore(accountType);
            store.connect(host, port, username, password);
            String folderName = "INBOX" ; // JiveGlobals.getJiveProperty("checkmail.folderName", "INBOX");
            folder = store.getFolder(folderName);
            folder.open(Folder.READ_ONLY);
           
            //Message[] messages = folder.getMessages(1, 30); //folder.getMessages(30);
 
            Message[] messages = folder.search( new FlagTerm(new Flags(Flags.Flag.SEEN), false));
            for (int i = 0, n = messages.length; i < n; i++) {
                Message message = messages[i];
 
                int count = 0 ;
                if(message.getHeader("To") != null) {
	                for( String s : message.getHeader("To")){
	                	count = count + StringUtils.countOccurrencesOf(s, "helpdesk@podosw.com");
	                }
                }
                if( count == 0)
                	continue;
                
                java.util.Enumeration e = message.getAllHeaders();
                
 while ( e.hasMoreElements() )
 {
	 javax.mail.Header h = ((javax.mail.Header)e.nextElement());
	 
	 log.debug("header : {} = {}",h.getName(), h.getValue());
 }
 
                System.out.println("---------------------------------");
                System.out.println("Email Number " + (i + 1));
                System.out.println("Subject: " + message.getSubject());
                System.out.println("From: " + message.getFrom()[0]);
                System.out.println("Date: " +  message.getSentDate() );
                
                //System.out.println("Text: " + message.getContent().toString());
 
             }
            
            success = true;
        }
        catch(Exception ex)
        {
            success = false;
            log.info("Email connection test failed.", ex);
        }
        finally
        {
            if(folder != null)
                try
                {
                    folder.close(false);
                }
                catch(Exception ex) { }
            if(store != null)
                try
                {
                    store.close();
                }
                catch(Exception ex) { }
        }
        return success;
    }
}
