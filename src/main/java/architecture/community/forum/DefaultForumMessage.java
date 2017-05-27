package architecture.community.forum;

import java.util.Date;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import architecture.community.model.json.JsonDateSerializer;
import architecture.community.model.json.JsonUserDeserializer;
import architecture.community.user.User;
import architecture.community.util.CommunityContextHelper;

public class DefaultForumMessage implements ForumMessage {
	
	private User user;
	
	private int objectType;
	
	private long objectId;
	
	private long threadId;
	
	private long messageId;
	
	private long parentMessageId;
		
	private String subject;
	
	private String body;
	

	private Date creationDate;

	private Date modifiedDate;

	public DefaultForumMessage() {
		this.messageId = UNKNOWN_OBJECT_ID;
	}
	
	public DefaultForumMessage(long messageId) {
		this.messageId = messageId;
	}

	public DefaultForumMessage(int objectType, long objectId, User user) {
		this.objectType = objectType;
		this.objectId = objectId;
		this.user = user;
		this.messageId = -1L;
		this.threadId = -1L;
		this.parentMessageId = -1L;
		this.subject = null;
		this.body = null;		
		Date now = new Date();
		this.creationDate = now;
		this.modifiedDate = now;
		
	}

	public User getUser() {
		return user;
	}

	@JsonDeserialize(using = JsonUserDeserializer.class)
	public void setUser(User user) {
		this.user = user;
	}

	public long getThreadId() {
		return threadId;
	}

	public void setThreadId(long threadId) {
		this.threadId = threadId;
	}


	public long getMessageId() {
		return messageId;
	}

	public void setMessageId(long messageId) {
		this.messageId = messageId;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

	@JsonSerialize(using = JsonDateSerializer.class)
	public Date getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}

	
	@JsonSerialize(using = JsonDateSerializer.class)
	public Date getModifiedDate() {
		return modifiedDate;
	}

	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}

	public long getParentMessageId() {
		return parentMessageId;
	}

	public void setParentMessageId(long parentMessageId) {
		this.parentMessageId = parentMessageId;
	}

	public int getObjectType() {
		return objectType;
	}

	public void setObjectType(int objectType) {
		this.objectType = objectType;
	}

	public long getObjectId() {
		return objectId;
	}

	public void setObjectId(long objectId) {
		this.objectId = objectId;
	}
	
	public int getReplyCount (){
		if( threadId > 0 ){
			try {
				return CommunityContextHelper.getForumService().getTreeWalker(CommunityContextHelper.getForumService().getForumThread(threadId)).getChildCount(this);
			} catch (ForumThreadNotFoundException e) {
				
			}
		}
		return 0;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("ForumMessage [");
		if (user != null)
			builder.append("user=").append(user).append(", ");
		builder.append("objectType=").append(objectType).append(", objectId=").append(objectId).append(", threadId=")
				.append(threadId).append(", messageId=").append(messageId).append(", parentMessageId=")
				.append(parentMessageId).append(", ");
		if (subject != null)
			builder.append("subject=").append(subject).append(", ");
		if (body != null)
			builder.append("body=").append(body).append(", ");
		if (creationDate != null)
			builder.append("creationDate=").append(creationDate).append(", ");
		if (modifiedDate != null)
			builder.append("modifiedDate=").append(modifiedDate);
		builder.append("]");
		return builder.toString();
	}

}
