package architecture.community.forum;

import java.util.List;

import architecture.community.user.User;

public interface ForumService {
		
	public abstract ForumMessage createMessage(int objectType, long objectId);
	
	public abstract ForumMessage createMessage(int objectType, long objectId, User user);
	
	
	
	public abstract ForumThread createThread(int objectType, long objectId, ForumMessage rootMessage);
	
	public abstract void addThread(int objectType, long objectId, ForumThread thread);
		
	public abstract List<ForumThread> getForumThreads(int objectType, long objectId );
	
	public abstract List<ForumMessage> getForumMessages(int objectType, long objectId );
		
	public abstract ForumThread getForumThread(long threadId) throws ForumThreadNotFoundException ;
	
	public abstract ForumMessage getForumMessage(long messageId) throws ForumMessageNotFoundException ;
	
	public abstract void updateThread(ForumThread thread);
	
	public abstract void updateMessage(ForumMessage message);
	
	public abstract void addMessage(ForumThread forumthread, ForumMessage parentMessage, ForumMessage newMessage);
	
}
