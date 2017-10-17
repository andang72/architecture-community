package architecture.community.board;

import java.util.List;

import architecture.community.user.User;

public interface ForumService {
		
	/**
	 * containerType, containerId 에 해당하는 메시지를 생성한다.
	 * 
	 * @param containerType
	 * @param containerId
	 * @return
	 */
	public abstract ForumMessage createMessage(int containerType, long containerId);
	
	public abstract ForumMessage createMessage(int containerType, long containerId, User user);
	
	
	/**
	 * containerType, containerId 에 해당하는 새로운 토픽을 생성한다.
	 * 
	 * @param containerType
	 * @param containerId
	 * @param rootMessage
	 * @return
	 */
	public abstract ForumThread createThread(int containerType, long containerId, ForumMessage rootMessage);
	
	/**
	 * containerType, containerId 에 새로운 토픽을 추가한다.
	 * 
	 * @param containerType
	 * @param containerId
	 * @param thread
	 */
	public abstract void addThread(int containerType, long containerId, ForumThread thread);
	
	/**
	 * containerType, containerId 에 등록된 모든 토픽 수를 리턴한다.
	 * 
	 * @param containerType
	 * @param containerId
	 * @return
	 */
	public abstract int getFourmThreadCount(int containerType, long containerId);	
	
	
	public abstract List<ForumThread> getForumThreads(int containerType, long containerId);
	
	public abstract List<ForumThread> getForumThreads(int objectType, long objectId, int startIndex, int numResults);
	
	public abstract List<ForumMessage> getForumMessages(int containerType, long containerId);
			
	public abstract ForumThread getForumThread(long threadId) throws ForumThreadNotFoundException ;
	
	public abstract ForumMessage getForumMessage(long messageId) throws ForumMessageNotFoundException ;
	
	public abstract void updateThread(ForumThread thread);
		
	public abstract void updateMessage(ForumMessage message);
	
	public abstract void addMessage(ForumThread forumthread, ForumMessage parentMessage, ForumMessage newMessage);
	
	public abstract int getMessageCount(ForumThread thread);
	
	public abstract List<ForumMessage> getMessages(ForumThread thread);
	
	public abstract MessageTreeWalker getTreeWalker(ForumThread thread);
}
