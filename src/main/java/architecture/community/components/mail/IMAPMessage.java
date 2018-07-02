package architecture.community.components.mail;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Iterator;

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;

public class IMAPMessage implements InboundMessage {

	private final Message original;
	
	public IMAPMessage(Message original) {
		this.original = original;
	}

	public String getBody() throws MessagingException, IOException, EmailMonitorException {
		return MessageUtils.getMessageBodyText(original);
	}

	public Iterator getAttachments() throws MessagingException, IOException {
		return MessageUtils.getMessageAttachments(original).iterator();
	}

	public Iterator getHeaders() throws MessagingException {
		final Enumeration enumeration = original.getAllHeaders();
		return new Iterator() {
			public void remove() {
				throw new UnsupportedOperationException();
			}
			public boolean hasNext() {
				return enumeration.hasMoreElements();
			}
			public Object next() {
				return enumeration.nextElement();
			}
		};
	}

	public Address[] getFrom() throws MessagingException {
		return original.getFrom();
	}

	public String getSubject() throws MessagingException {
		return original.getSubject();
	}

	public String[] getHeader(String name) throws MessagingException {
		return original.getHeader(name);
	}

}
