package architecture.community.forum.dao;

import java.util.Date;
import java.util.List;

import architecture.community.forum.ForumMessage;
import architecture.community.forum.ForumThread;

public interface ForumDao {
	
	public abstract void createForumThread( ForumThread thread );
	
	public abstract void createForumMessage (ForumThread thread, ForumMessage message, long parentMessageId);
	
	public abstract List<Long> getForumThreadIds(int objectType, long objectId);
	
	public abstract long getLatestMessageId(ForumThread thread);
	
	public abstract List<Long> getAllMessageIdsInThread(ForumThread thread);
	
	public abstract ForumThread getForumThreadById(long threadId);
	
	public abstract ForumMessage getForumMessageById(long messageId) ;
	
	public abstract void updateForumMessage(ForumMessage message);
	
	public abstract void updateForumThread(ForumThread thread);
	
	public abstract void updateModifiedDate(ForumThread thread, Date date);
	
}
