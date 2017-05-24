package architecture.community.forum;

import java.util.Date;

import architecture.community.model.ModelObjectAware;

public interface ForumThread extends ModelObjectAware {
	
	//public static final int MODLE_ENTITY_TYPE = 6;
	
	public long getThreadId() ;

	public Date getCreationDate();

	public void setCreationDate(Date creationDate);

	public Date getModifiedDate() ;

	public void setModifiedDate(Date modifiedDate);

	public ForumMessage getLatestMessage();

	public void setLatestMessage(ForumMessage latestMessage);

	public ForumMessage getRootMessage() ;

	public void setRootMessage(ForumMessage rootMessage) ;
	
}
