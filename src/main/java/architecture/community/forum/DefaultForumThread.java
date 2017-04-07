package architecture.community.forum;

import java.util.Date;
import java.util.concurrent.atomic.AtomicInteger;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import architecture.community.model.json.JsonDateSerializer;
import architecture.community.util.CommunityContextHelper;

public class DefaultForumThread implements ForumThread {

	private long threadId;
	
	private int objectType;
	
	private long objectId;
	
	private Date creationDate;

	private Date modifiedDate;
	
	private ForumMessage latestMessage;
	
	private ForumMessage rootMessage;	

    private AtomicInteger messageCount = new AtomicInteger(-1);
	
	public DefaultForumThread(long threadId) {
		this.threadId = threadId;
		this.objectType = -1;
		this.objectId = -1L;
		this.rootMessage = null;
		this.latestMessage = null;
		this.messageCount = new AtomicInteger(-1);
	}

	public DefaultForumThread(int objectType, long objectId, ForumMessage rootMessage) {
		this.threadId = -1L;
		this.objectType = objectType;
		this.objectId = objectId;
		this.rootMessage = rootMessage;
		this.latestMessage = null;
		boolean isNew = rootMessage.getThreadId() < 1L;
		if( isNew ){			
			this.creationDate = rootMessage.getCreationDate();
			this.modifiedDate = this.creationDate;
		}
		this.messageCount = new AtomicInteger(-1);
	}
	
	public void setMessageCount(int messageCount){
		this.messageCount.set(messageCount);
	}
	
	public int getViewCount(){
		if( threadId < 1)
			return -1;
		
		return CommunityContextHelper.getViewCountServive().getViewCount(this);		
	}
	
    public int getMessageCount()
    {
        int count = messageCount.get();
        if(count <= 0)
            return 1;
        else
            return count;
    }

    public void incrementMessageCount()
    {
        if(messageCount.get() < 0)
            messageCount.set(1);
        else
            messageCount.incrementAndGet();
    }

    public void decrementMessageCount()
    {
        if(messageCount.get() > 0)
            messageCount.decrementAndGet();
    }
    
	public long getThreadId() {
		return threadId;
	}

	public void setThreadId(long threadId) {
		this.threadId = threadId;
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

	public ForumMessage getLatestMessage() {
		return latestMessage;
	}

	public void setLatestMessage(ForumMessage latestMessage) {
		this.latestMessage = latestMessage;
	}

	public ForumMessage getRootMessage() {
		return rootMessage;
	}

	public void setRootMessage(ForumMessage rootMessage) {
		this.rootMessage = rootMessage;
	}
	
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("DefaultForumThread [ ");
		sb.append("threadId=").append(threadId);
		sb.append(", rootMessage=").append(rootMessage.getMessageId());
		sb.append(", latestMessage=").append(latestMessage == null ? -1L : latestMessage.getMessageId());
		 sb.append(", messageCount=").append(getMessageCount());
		sb.append(", objectType=").append(objectType);
		sb.append(", objectId=").append(objectId);
		sb.append(", creationDate=").append(creationDate);
		sb.append(", modifiedDate=").append(modifiedDate);
		sb.append("]");
		
		return sb.toString();
	}

}
