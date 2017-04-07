package architecture.community.forum;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.community.forum.dao.ForumDao;
import architecture.community.forum.event.ForumThreadEvent;
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
	
		
	public ForumThread createThread(int objectType, long objectId, ForumMessage rootMessage) {		
		DefaultForumThread newThread = new DefaultForumThread(objectType, objectId, rootMessage);
		return newThread;
	}
 
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void addThread(int objectType, long objectId, ForumThread thread) {		
		DefaultForumThread threadToUse = (DefaultForumThread)thread; 
		DefaultForumMessage rootMessage = (DefaultForumMessage)threadToUse.getRootMessage();		
		boolean isNew = rootMessage.getThreadId() < 1L ;
		if( !isNew ){
			// get exist old value..			
		}				
		// insert thread ..
		forumDao.createForumThread(threadToUse);
		// insert message ..
		forumDao.createForumMessage(threadToUse, rootMessage, -1L );				
		fireEvent(new ForumThreadEvent(threadToUse, ForumThreadEvent.Type.CREATED));		
	}

	public ForumMessage createMessage(int objectType, long objectId) {
		DefaultForumMessage newMessage = new DefaultForumMessage(objectType, objectId, SecurityHelper.ANONYMOUS);
		return newMessage;
	}

	public ForumMessage createMessage(int objectType, long objectId, User user) {
		DefaultForumMessage newMessage = new DefaultForumMessage(objectType, objectId, SecurityHelper.ANONYMOUS);
		return newMessage;
	}

	public List<ForumThread> getForumThreads(int objectType, long objectId) {		
		List<Long> threadIds = forumDao.getForumThreadIds(objectType, objectId);
		List<ForumThread> list = new ArrayList<ForumThread>(threadIds.size());
		for( Long threadId : threadIds )
		{
			try {
				list.add(getForumThread(threadId));
			} catch (ForumThreadNotFoundException e) {
				// ignore;
				logger.warn(e.getMessage(), e);
			}
		}
		return list;
	}

	
	public List<ForumMessage> getForumMessages(int objectType, long objectId) {
		return null;
	}

	public ForumThread getForumThread(long threadId) throws ForumThreadNotFoundException {		
		if(threadId < 0L)
            throw new ForumThreadNotFoundException(CommunityLogLocalizer.format("013004", threadId ));
		
		ForumThread threadToUse = getForumThreadInCache(threadId);
		if( threadToUse == null){
			
			try {
				threadToUse = forumDao.getForumThreadById(threadId);
				threadToUse.setLatestMessage(new DefaultForumMessage(forumDao.getLatestMessageId(threadToUse)));	
				((DefaultForumThread)threadToUse).setMessageCount(forumDao.getAllMessageIdsInThread(threadToUse).size());
			} catch (Exception e) {
				throw new ForumThreadNotFoundException(CommunityLogLocalizer.format("013005", threadId ));
			}			
			try {
				ForumMessage rootMessage = threadToUse.getRootMessage();		
				ForumMessage latestMessage = threadToUse.getLatestMessage();					
				threadToUse.setRootMessage(getForumMessage(rootMessage.getMessageId()));					
				if(latestMessage != null && latestMessage.getMessageId() > 0){
					threadToUse.setLatestMessage(getForumMessage(latestMessage.getMessageId()));	
					threadToUse.setModifiedDate(threadToUse.getLatestMessage().getModifiedDate());
				}						
			} catch (Exception e) {
				throw new ForumThreadNotFoundException(CommunityLogLocalizer.format("013005", threadId ), e);
			}
			updateCaches(threadToUse);	
		}
		return threadToUse;
	}


	public ForumMessage getForumMessage(long messageId) throws ForumMessageNotFoundException {
		if(messageId < 0L)
            throw new ForumMessageNotFoundException(CommunityLogLocalizer.format("013006", messageId ));
		
		ForumMessage messageToUse = getForumMessageInCache(messageId);
		if( messageToUse == null){
			try {
				messageToUse = forumDao.getForumMessageById(messageId);			
				if( messageToUse.getUser().getUserId() > 0){
					((DefaultForumMessage)messageToUse).setUser(userManager.getUser(messageToUse.getUser()));
				}	
				updateCaches(messageToUse);
			} catch (Exception e) {
				throw new ForumMessageNotFoundException(CommunityLogLocalizer.format("013007", messageId ));
			}
		}
		return messageToUse;
	}

	

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateThread(ForumThread thread) {		
		forumDao.updateForumThread(thread);
		evictCaches(thread);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateMessage(ForumMessage message) {
		
		forumDao.updateForumMessage(message);		
		try {
			ForumThread thread = getForumThread(message.getThreadId());
			forumDao.updateModifiedDate(thread, message.getModifiedDate() );
			
			evictCaches(message);
			evictCaches(thread);
			
		} catch (ForumThreadNotFoundException e) {
			logger.error(e.getMessage(), e );
		}		
	}	


	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void addMessage(ForumThread forumthread, ForumMessage parentMessage, ForumMessage newMessage) {
		
		DefaultForumMessage newMessageToUse = (DefaultForumMessage)newMessage;
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
	
	protected void evictCaches(ForumThread thread){				
		if (threadCache != null && threadCache.get( thread.getThreadId() ) != null)
		{
			threadCache.remove(thread.getThreadId());
		}			
	}
	
	protected void evictCaches(ForumMessage message){				
		if (messageCache != null && messageCache.get( message.getMessageId() ) != null)
		{
			messageCache.remove(message.getMessageId());
		}			
	}
	
	protected void updateThreadModifiedDate(ForumThread thread, ForumMessage message){
		if( message.getModifiedDate() != null){			
			thread.setModifiedDate(message.getModifiedDate());
			if (threadCache != null && threadCache.get(thread.getThreadId()) != null){
				threadCache.put(new Element(thread.getThreadId(), thread ));
			}
		}
	}
	
	protected void updateCaches(ForumThread forumThread) {
		if (forumThread != null) {
			if (forumThread.getThreadId() > 0 ) {
				if (threadCache != null && threadCache.get(forumThread.getThreadId()) != null)
					threadCache.remove(forumThread.getThreadId());
				threadCache.put(new Element(forumThread.getThreadId(), forumThread ));
			}
		}
	}
	
	protected void updateCaches(ForumMessage forumMessage) {
		if (forumMessage != null) {
			if (forumMessage.getMessageId() > 0 ) {
				if (messageCache != null && messageCache.get(forumMessage.getMessageId()) != null)
					messageCache.remove(forumMessage.getMessageId());
				messageCache.put(new Element(forumMessage.getMessageId(), forumMessage ));
			}
		}
	}
	
	protected ForumThread getForumThreadInCache(Long threadId) {
		if( threadCache != null && threadCache.get(threadId) != null)
			return (ForumThread)threadCache.get(threadId).getObjectValue();
		else
			return null;
	}
	
	protected ForumMessage getForumMessageInCache(Long messageId) {
		if( messageCache != null && messageCache.get(messageId) != null)
			return (ForumMessage)messageCache.get(messageId).getObjectValue();
		else
			return null;
	}

	public int getFourmThreadCount(int objectType, long objectId) {
		return forumDao.getForumThreadCount(objectType, objectId);
	}

	public int getMessageCount(ForumThread thread) {		
		return forumDao.getMessageCount(thread);
	}

	public List<ForumMessage> getMessages(ForumThread thread) {		
		List<Long> messageIds = forumDao.getMessageIds(thread);
		List<ForumMessage> list = new ArrayList<ForumMessage>(messageIds.size());
		for(Long messageId : messageIds){
			try {
				list.add(getForumMessage(messageId));
			} catch (ForumMessageNotFoundException e) {
			}
		}
		return list;
	}

	public MessageTreeWalker getTreeWalker(ForumThread thread) {
		if( messageTreeWalkerCache != null && messageTreeWalkerCache.get(thread.getThreadId()) != null)
			return (MessageTreeWalker)messageTreeWalkerCache.get(thread.getThreadId()).getObjectValue();
		
		MessageTreeWalker treeWalker = forumDao.getTreeWalker(thread);
		messageTreeWalkerCache.put(new Element(thread.getThreadId(), treeWalker ));
		return treeWalker;
	}


}
