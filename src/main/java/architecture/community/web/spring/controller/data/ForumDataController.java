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

package architecture.community.web.spring.controller.data;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.board.BoardNotFoundException;
import architecture.community.forum.ForumMessage;
import architecture.community.forum.ForumMessageNotFoundException;
import architecture.community.forum.ForumService;
import architecture.community.forum.ForumThread;
import architecture.community.forum.ForumThreadNotFoundException;
import architecture.community.forum.MessageTreeWalker;
import architecture.community.web.model.ItemList;

@Controller("forums-data-controller")
@RequestMapping("/data/boards")
public class ForumDataController {

	@Inject
	@Qualifier("forumService")
	private ForumService forumService;
	
	public ForumDataController() {
	}

	/**
	 * /data/forums/threads/{threadId}/messages/list.json
	 * @param boardId
	 * @param threadId
	 * @param request
	 * @return
	 * @throws BoardNotFoundException
	 */
	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getMessages (@PathVariable Long threadId, NativeWebRequest request) throws ForumThreadNotFoundException {	
		
		ForumThread thread = forumService.getForumThread(threadId);
		MessageTreeWalker walker = forumService.getTreeWalker(thread);
		int totalSize = walker.getChildCount(thread.getRootMessage());
		List<ForumMessage> list = getMessages(walker.getChildIds(thread.getRootMessage()));		
		
		return new ItemList(list, totalSize);
	}
	
	/**
	 * /data/forums/{threadId}/messages/{messageId}/list.json
	 * @param boardId
	 * @param threadId
	 * @param request
	 * @return
	 * @throws ForumMessageNotFoundException 
	 * @throws BoardNotFoundException
	 */
	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/{parentId:[\\p{Digit}]+}/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getChildMessages (@PathVariable Long threadId, @PathVariable Long parentId, NativeWebRequest request) throws ForumThreadNotFoundException, ForumMessageNotFoundException {	
		
		ForumThread thread = forumService.getForumThread(threadId);
		ForumMessage parent = forumService.getForumMessage(parentId);
		MessageTreeWalker walker = forumService.getTreeWalker(thread);
		int totalSize = walker.getChildCount(parent);
		List<ForumMessage> list = getMessages(walker.getChildIds(parent));	
		return new ItemList(list, totalSize);
	}
	
	protected List<ForumMessage> getMessages(long[] messageIds){
		
		List<ForumMessage> list = new ArrayList<ForumMessage>(messageIds.length);
		for( long messageId : messageIds )
		{
			try {
				list.add(forumService.getForumMessage(messageId));
			} catch (ForumMessageNotFoundException e) {
				//ignore..
			}
		}
		return list;
	}
}
