package architecture.community.board;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.community.board.dao.ForumDao;
import architecture.community.board.event.BoardThreadEvent;
import architecture.community.i18n.CommunityLogLocalizer;
import architecture.community.user.User;
import architecture.community.user.UserManager;
import architecture.community.util.SecurityHelper;
import architecture.ee.spring.event.EventSupport;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

public class DefaultForumService extends EventSupport implements ForumService {

	private Logger logger = LoggerFactory.getLogger(getClass().getName());
	
	@Inject
	@Qualifier("forumDao")
	private ForumDao forumDao;
	
	@Inject
	@Qualifier("userManager")
	private UserManager userManager;
	
	@Inject
	@Qualifier("threadCache")
	private Cache threadCache;
	
	@Inject
	@Qualifier("messageCache")
	private Cache messageCache;
	
	@Inject
	@Qualifier("messageTreeWalkerCache")
	private Cache messageTreeWalkerCache;
	
		
	public BoardThread createThread(int objectType, long objectId, BoardMessage rootMessage) {		
		DefaultBoardThread newThread = new DefaultBoardThread(objectType, objectId, rootMessage);
		return newThread;
	}
 
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void addThread(int objectType, long objectId, BoardThread thread) {		
		DefaultBoardThread threadToUse = (DefaultBoardThread)thread; 
		DefaultBoardMessage rootMessage = (DefaultBoardMessage)threadToUse.getRootMessage();		
		boolean isNew = rootMessage.getThreadId() < 1L ;
		if( !isNew ){
			// get exist old value..			
		}				
		// insert thread ..
		forumDao.createForumThread(threadToUse);
		// insert message ..
		forumDao.createForumMessage(threadToUse, rootMessage, -1L );				
		fireEvent(new BoardThreadEvent(threadToUse, BoardThreadEvent.Type.CREATED));		
	}

	public BoardMessage createMessage(int objectType, long objectId) {
		DefaultBoardMessage newMessage = new DefaultBoardMessage(objectType, objectId, SecurityHelper.ANONYMOUS);
		return newMessage;
	}

	public BoardMessage createMessage(int objectType, long objectId, User user) {
		DefaultBoardMessage newMessage = new DefaultBoardMessage(objectType, objectId, user);
		return newMessage;
	}

	public List<BoardThread> getForumThreads(int objectType, long objectId, int startIndex, int numResults){
		List<Long> threadIds = forumDao.getForumThreadIds(objectType, objectId, startIndex, numResults);
		List<BoardThread> list = new ArrayList<BoardThread>(threadIds.size());
		for( Long threadId : threadIds )
		{
			try {
				list.add(getForumThread(threadId));
			} catch (BoardThreadNotFoundException e) {
				// ignore;
				logger.warn(e.getMessage(), e);
			}
		}
		return list;
	}
	
	public List<BoardThread> getForumThreads(int objectType, long objectId) {		
		List<Long> threadIds = forumDao.getForumThreadIds(objectType, objectId);
		List<BoardThread> list = new ArrayList<BoardThread>(threadIds.size());
		for( Long threadId : threadIds )
		{
			try {
				list.add(getForumThread(threadId));
			} catch (BoardThreadNotFoundException e) {
				// ignore;
				logger.warn(e.getMessage(), e);
			}
		}
		return list;
	}

	
	public List<BoardMessage> getForumMessages(int objectType, long objectId) {
		return null;
	}

	public BoardThread getForumThread(long threadId) throws BoardThreadNotFoundException {		
		if(threadId < 0L)
            throw new BoardThreadNotFoundException(CommunityLogLocalizer.format("013004", threadId ));
		
		BoardThread threadToUse = getForumThreadInCache(threadId);
		if( threadToUse == null){
			
			try {
				threadToUse = forumDao.getForumThreadById(threadId);
				threadToUse.setLatestMessage(new DefaultBoardMessage(forumDao.getLatestMessageId(threadToUse)));	
				((DefaultBoardThread)threadToUse).setMessageCount(forumDao.getAllMessageIdsInThread(threadToUse).size());
			} catch (Exception e) {
				throw new BoardThreadNotFoundException(CommunityLogLocalizer.format("013005", threadId ));
			}			
			try {
				BoardMessage rootMessage = threadToUse.getRootMessage();		
				BoardMessage latestMessage = threadToUse.getLatestMessage();					
				threadToUse.setRootMessage(getForumMessage(rootMessage.getMessageId()));					
				if(latestMessage != null && latestMessage.getMessageId() > 0){
					threadToUse.setLatestMessage(getForumMessage(latestMessage.getMessageId()));	
					threadToUse.setModifiedDate(threadToUse.getLatestMessage().getModifiedDate());
				}						
			} catch (Exception e) {
				throw new BoardThreadNotFoundException(CommunityLogLocalizer.format("013005", threadId ), e);
			}
			updateCaches(threadToUse);	
		}
		return threadToUse;
	}


	public BoardMessage getForumMessage(long messageId) throws BoardMessageNotFoundException {
		if(messageId < 0L)
            throw new BoardMessageNotFoundException(CommunityLogLocalizer.format("013006", messageId ));
		
		BoardMessage messageToUse = getForumMessageInCache(messageId);
		if( messageToUse == null){
			try {
				messageToUse = forumDao.getForumMessageById(messageId);			
				if( messageToUse.getUser().getUserId() > 0){
					((DefaultBoardMessage)messageToUse).setUser(userManager.getUser(messageToUse.getUser()));
				}	
				updateCaches(messageToUse);
			} catch (Exception e) {
				throw new BoardMessageNotFoundException(CommunityLogLocalizer.format("013007", messageId ));
			}
		}
		return messageToUse;
	}

	

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateThread(BoardThread thread) {		
		forumDao.updateForumThread(thread);
		evictCaches(thread);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateMessage(BoardMessage message) {
		
		forumDao.updateForumMessage(message);		
		try {
			BoardThread thread = getForumThread(message.getThreadId());
			forumDao.updateModifiedDate(thread, message.getModifiedDate() );
			
			evictCaches(message);
			evictCaches(thread);
			
		} catch (BoardThreadNotFoundException e) {
			logger.error(e.getMessage(), e );
		}		
	}	


	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void addMessage(BoardThread forumthread, BoardMessage parentMessage, BoardMessage newMessage) {
		
		DefaultBoardMessage newMessageToUse = (DefaultBoardMessage)newMessage;
		if(newMessageToUse.getCreationDate().getTime() < parentMessage.getCreationDate().getTime() ){
			logger.warn(CommunityLogLocalizer.getMessage("013008"));
			
			Date newDate = new Date(parentMessage.getCreationDate().getTime() + 1L);
			newMessageToUse.setCreationDate(newDate);
			newMessageToUse.setModifiedDate(newDate);
		}		
		if(forumthread.getThreadId() != -1L){
			newMessageToUse.setThreadId(forumthread.getThreadId());
		}		
		forumDao.createForumMessage(forumthread, newMessageToUse, parentMessage.getMessageId());
		updateThreadModifiedDate(forumthread, newMessageToUse);		
		evictCaches(forumthread);
		
	}
	
	protected void evictCaches(BoardThread thread){				
		if (threadCache != null && threadCache.get( thread.getThreadId() ) != null)
		{
			threadCache.remove(thread.getThreadId());
		}			
	}
	
	protected void evictCaches(BoardMessage message){				
		if (messageCache != null && messageCache.get( message.getMessageId() ) != null)
		{
			messageCache.remove(message.getMessageId());
		}			
	}
	
	protected void updateThreadModifiedDate(BoardThread thread, BoardMessage message){
		if( message.getModifiedDate() != null){			
			thread.setModifiedDate(message.getModifiedDate());
			if (threadCache != null && threadCache.get(thread.getThreadId()) != null){
				threadCache.put(new Element(thread.getThreadId(), thread ));
			}
		}
	}
	
	protected void updateCaches(BoardThread boardThread) {
		if (boardThread != null) {
			if (boardThread.getThreadId() > 0 ) {
				if (threadCache != null && threadCache.get(boardThread.getThreadId()) != null)
					threadCache.remove(boardThread.getThreadId());
				threadCache.put(new Element(boardThread.getThreadId(), boardThread ));
			}
		}
	}
	
	protected void updateCaches(BoardMessage boardMessage) {
		if (boardMessage != null) {
			if (boardMessage.getMessageId() > 0 ) {
				if (messageCache != null && messageCache.get(boardMessage.getMessageId()) != null)
					messageCache.remove(boardMessage.getMessageId());
				messageCache.put(new Element(boardMessage.getMessageId(), boardMessage ));
			}
		}
	}
	
	protected BoardThread getForumThreadInCache(Long threadId) {
		if( threadCache != null && threadCache.get(threadId) != null)
			return (BoardThread)threadCache.get(threadId).getObjectValue();
		else
			return null;
	}
	
	protected BoardMessage getForumMessageInCache(Long messageId) {
		if( messageCache != null && messageCache.get(messageId) != null)
			return (BoardMessage)messageCache.get(messageId).getObjectValue();
		else
			return null;
	}

	public int getFourmThreadCount(int objectType, long objectId) {
		return forumDao.getForumThreadCount(objectType, objectId);
	}

	public int getMessageCount(BoardThread thread) {		
		return forumDao.getMessageCount(thread);
	}

	public List<BoardMessage> getMessages(BoardThread thread) {		
		List<Long> messageIds = forumDao.getMessageIds(thread);
		List<BoardMessage> list = new ArrayList<BoardMessage>(messageIds.size());
		for(Long messageId : messageIds){
			try {
				list.add(getForumMessage(messageId));
			} catch (BoardMessageNotFoundException e) {
			}
		}
		return list;
	}

	public MessageTreeWalker getTreeWalker(BoardThread thread) {
		if( messageTreeWalkerCache != null && messageTreeWalkerCache.get(thread.getThreadId()) != null)
			return (MessageTreeWalker)messageTreeWalkerCache.get(thread.getThreadId()).getObjectValue();
		
		MessageTreeWalker treeWalker = forumDao.getTreeWalker(thread);
		messageTreeWalkerCache.put(new Element(thread.getThreadId(), treeWalker ));
		return treeWalker;
	}


}
