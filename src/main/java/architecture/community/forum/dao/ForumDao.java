package architecture.community.forum.dao;

import java.util.Date;
import java.util.List;

import architecture.community.forum.ForumMessage;
import architecture.community.forum.ForumThread;
import architecture.community.forum.MessageTreeWalker;

public interface ForumDao {
	
	public abstract void createForumThread( ForumThread thread );
	
	public abstract void createForumMessage (ForumThread thread, ForumMessage message, long parentMessageId);
	
	public abstract int getForumThreadCount(int objectType, long objectId);
	
	public abstract List<Long> getForumThreadIds(int objectType, long objectId);
	
	public abstract long getLatestMessageId(ForumThread thread);
	
	public abstract List<Long> getAllMessageIdsInThread(ForumThread thread);
	
	public abstract ForumThread getForumThreadById(long threadId);
	
	public abstract ForumMessage getForumMessageById(long messageId) ;
	
	public abstract void updateForumMessage(ForumMessage message);
	
	public abstract void updateForumThread(ForumThread thread);
	
	public abstract void updateModifiedDate(ForumThread thread, Date date);
	
	public abstract List<Long> getMessageIds(ForumThread thread);
	
	public abstract int getMessageCount(ForumThread thread);
	
	public abstract MessageTreeWalker getTreeWalker(ForumThread thread) ;
	
}
