/**
 *    Copyright 2015-2017 donghyuck
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package architecture.community.viewcount;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.eventbus.Subscribe;

import architecture.community.forum.ForumThread;
import architecture.community.forum.event.ForumThreadEvent;
import architecture.community.model.ModelObject;
import architecture.community.viewcount.dao.ViewCountDao;
import architecture.ee.service.ConfigService;
import architecture.ee.spring.event.EventSupport;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;


public class DefaultViewCountService extends EventSupport implements ViewCountService {

	private Logger logger = LoggerFactory.getLogger(getClass().getName());

	private Map<String, ViewCountInfo> queue;

	private Lock lock = new ReentrantLock();
	
	private boolean viewCountsEnabled; 
	
	@Inject
	@Qualifier("configService")
	protected ConfigService configService;

	@Inject
	@Qualifier("viewCountDao")
	protected ViewCountDao viewCountDao;

	@Inject
	@Qualifier("viewCountCache")
	private Cache viewCountCache;
	
	
	public DefaultViewCountService() {
		this.viewCountsEnabled = true;
	}

	@PostConstruct
	public void initialize() throws Exception {
		logger.debug("initialize queue");
		this.queue = Collections.synchronizedMap(new HashMap<String, ViewCountInfo>());
		
		logger.debug("register event listener");
		registerEventListener(this);
	}
	
	@PreDestroy
	public void destory(){
		logger.debug("unregister event listener");
		unregisterEventListener(this);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void addViewCount(ForumThread thread) {
		if (viewCountsEnabled) {
			addCount(ModelObject.FORUM_THREAD, thread.getThreadId(), viewCountCache, 1);
		}
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public int getViewCount(ForumThread thread) {
		if (viewCountsEnabled) {
			return getCachedCount(ModelObject.FORUM_THREAD, thread.getThreadId());
		} else {
			return -1;
		}
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void clearCount(ForumThread thread){
		if (viewCountsEnabled) {
			String key = getCacheKey(ModelObject.FORUM_THREAD, thread.getThreadId());
			queue.remove(key);
			clearCount(ModelObject.FORUM_THREAD, thread.getThreadId());
		}
	}
	

	@Subscribe 
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void onForumThreadEvent(ForumThreadEvent e) {		
		logger.debug("forum thread event : " + e.getType().name());
		ForumThread thread = (ForumThread) e.getSource();
		
		int entityType = ModelObject.FORUM_THREAD;
		long entityId = thread.getThreadId();	
		String key = getCacheKey(entityType, entityId);
		if(e.getType() == ForumThreadEvent.Type.CREATED )
		{
			if (viewCountCache.get(key) == null) {
				viewCountDao.insertInitialViewCount(entityType, entityId,  0);
				viewCountCache.put(new Element(key, Integer.valueOf(0)));
			}			
		}else if (e.getType() == ForumThreadEvent.Type.DELETED ){
			queue.remove(key);
			viewCountDao.deleteViewCount(entityType, entityId);
			viewCountCache.remove(key);
		}
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateViewCounts() {		
		Map<String, ViewCountInfo> localQueue = queue;
		queue = Collections.synchronizedMap(new HashMap<String, ViewCountInfo>());
		logger.debug("update view counts {}", localQueue.size() );
		if (localQueue.size() > 0) {
			List<ViewCountInfo> list = new ArrayList<ViewCountInfo>(localQueue.values());
			viewCountDao.updateViewCounts(list);
		}		
	}


	
	private synchronized void clearCount(int entityType, long entityId) {
		viewCountDao.deleteViewCount(entityType, entityId);
	}

	private void addCount(int entityType, long entityId, Cache cache, int amount) {
		int count = -1;
		String cacheKey = getCacheKey(entityType, entityId);
		if (cache.get(cacheKey) != null)
			count = (Integer) cache.get(cacheKey).getObjectValue();
		else
			count = viewCountDao.getViewCount(entityType, entityId);
		count += amount;
		cache.put(new Element(cacheKey, Integer.valueOf(count)));
		
		Map<String, ViewCountInfo> queueRef = queue;
		synchronized (queueRef) {
			queueRef.put(cacheKey, new ViewCountInfo(entityType, entityId, count));
		}
	}

	private int getCachedCount(Integer entityType, Long entityId) {		
		Integer cachedCount;
		String cacheKey = getCacheKey(entityType, entityId);
		if (viewCountCache.get(cacheKey) != null) {
			cachedCount = (Integer) viewCountCache.get(cacheKey).getObjectValue();			
		}else{
			try{
				lock.lock();
				cachedCount = viewCountDao.getViewCount(entityType, entityId);
				viewCountCache.put(new Element(cacheKey, cachedCount));				
			}finally{
				lock.unlock();
			}
		}
		return cachedCount;
	}

	private static String getCacheKey(int entityType, long entityId) {
		StringBuffer buf = new StringBuffer();
		buf.append(entityType).append("-").append(entityId);
		return buf.toString();
	}
	
}