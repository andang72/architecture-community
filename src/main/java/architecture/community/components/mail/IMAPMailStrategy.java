package architecture.community.components.mail;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Store;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import architecture.ee.service.ConfigService;
import architecture.ee.util.StringUtils;

public class IMAPMailStrategy implements CheckMailStrategy {
	
	private Logger log = LoggerFactory.getLogger(IMAPMailStrategy.class);

	private ConfigService configService;

	public IMAPMailStrategy(ConfigService configService) {
		this.configService = configService;
	}

	public EmailBatch checkForMessages(String host, int port, String user, String password, boolean useSSL)
			throws MessagingException, IOException {
		Store store = null;
		Folder folder = null;
		List<InboundMessage> messages = new ArrayList<InboundMessage>();
		String folderName = configService.getApplicationProperty("services.checkmail.folderName", "INBOX");
		boolean deleteUnused = configService.getApplicationBooleanProperty("services.checkmail.deleteUnusedMail", true);
		try {
			Properties props = new Properties();
			if (useSSL) {
				// Security.setProperty("ssl.SocketFactory.provider",
				// "com.jivesoftware.util.ssl.DummySSLSocketFactory");
				// props.setProperty("mail.imaps.socketFactory.class",
				// "com.jivesoftware.util.ssl.DummySSLSocketFactory");
				// props.setProperty("mail.imaps.socketFactory.fallback", "true");
			}
			Session session = Session.getInstance(props, null);
			if (useSSL)
				store = session.getStore("imaps");
			else
				store = session.getStore("imap");
			store.connect(host, port, user, password);
			folder = store.getFolder(folderName);
			folder.open(2);
			Message allMessages[] = folder.getMessages();
			for (int i = 0; i < allMessages.length; i++) {
				if (allMessages[i].getFlags().contains(javax.mail.Flags.Flag.SEEN)) {
					allMessages[i].setFlag(javax.mail.Flags.Flag.DELETED, true);
					continue;
				}
				if (canProcessMessage(allMessages[i])) {
					messages.add(new IMAPMessage(allMessages[i]));
					allMessages[i].setFlag(javax.mail.Flags.Flag.SEEN, true);
					continue;
				}
				if (deleteUnused)
					allMessages[i].setFlag(javax.mail.Flags.Flag.DELETED, true);
			}

			return new EmailBatch(messages, folder, store);
		} catch (MessagingException mex) {
			if (folder != null)
				try {
					folder.close(true);
				} catch (MessagingException e) {
					log.debug("Unable to close folder", e);
				}
			if (store != null)
				try {
					store.close();
				} catch (MessagingException e) {
					log.debug("Unable to close store", e);
				}
			throw mex;
		}
	}

	public boolean canProcessMessage(Message message) throws MessagingException, IOException {

		int count = 0;
		if (message.getHeader("To") != null) {
			for (String s : message.getHeader("To")) {
				count = count + StringUtils.countOccurrencesOf(s, "helpdesk@podosw.com");
			}
		}
		String subject = message.getSubject();
		if (StringUtils.isEmpty(subject)) {
			return false;
		} else {
			return count > 0 ? true : false;
		}
	}
}
