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
	public abstract BoardMessage createMessage(int containerType, long containerId);
	
	public abstract BoardMessage createMessage(int containerType, long containerId, User user);
	
	
	/**
	 * containerType, containerId 에 해당하는 새로운 토픽을 생성한다.
	 * 
	 * @param containerType
	 * @param containerId
	 * @param rootMessage
	 * @return
	 */
	public abstract BoardThread createThread(int containerType, long containerId, BoardMessage rootMessage);
	
	/**
	 * containerType, containerId 에 새로운 토픽을 추가한다.
	 * 
	 * @param containerType
	 * @param containerId
	 * @param thread
	 */
	public abstract void addThread(int containerType, long containerId, BoardThread thread);
	
	/**
	 * containerType, containerId 에 등록된 모든 토픽 수를 리턴한다.
	 * 
	 * @param containerType
	 * @param containerId
	 * @return
	 */
	public abstract int getFourmThreadCount(int containerType, long containerId);	
	
	
	public abstract List<BoardThread> getForumThreads(int containerType, long containerId);
	
	public abstract List<BoardThread> getForumThreads(int objectType, long objectId, int startIndex, int numResults);
	
	public abstract List<BoardMessage> getForumMessages(int containerType, long containerId);
			
	public abstract BoardThread getForumThread(long threadId) throws BoardThreadNotFoundException ;
	
	public abstract BoardMessage getForumMessage(long messageId) throws BoardMessageNotFoundException ;
	
	public abstract void updateThread(BoardThread thread);
		
	public abstract void updateMessage(BoardMessage message);
	
	public abstract void addMessage(BoardThread forumthread, BoardMessage parentMessage, BoardMessage newMessage);
	
	public abstract int getMessageCount(BoardThread thread);
	
	public abstract List<BoardMessage> getMessages(BoardThread thread);
	
	public abstract MessageTreeWalker getTreeWalker(BoardThread thread);
}
