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
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.board.BoardNotFoundException;
import architecture.community.comment.Comment;
import architecture.community.comment.CommentService;
import architecture.community.exception.NotFoundException;
import architecture.community.forum.ForumMessage;
import architecture.community.forum.ForumMessageNotFoundException;
import architecture.community.forum.ForumService;
import architecture.community.forum.ForumThread;
import architecture.community.forum.ForumThreadNotFoundException;
import architecture.community.forum.MessageTreeWalker;
import architecture.community.model.ModelObject;
import architecture.community.model.ModelObjectTreeWalker;
import architecture.community.model.ModelObjectTreeWalker.ObjectLoader;
import architecture.community.user.User;
import architecture.community.util.SecurityHelper;
import architecture.community.web.model.ItemList;
import architecture.community.web.model.json.RequestData;
import architecture.community.web.model.json.Result;
import architecture.ee.util.StringUtils;

@Controller("forums-data-controller")
@RequestMapping("/data/forums")
public class ForumDataController {

	@Inject
	@Qualifier("forumService")
	private ForumService forumService;

	@Inject
	@Qualifier("commentService")
	private CommentService commentService;
	
	private Logger log = LoggerFactory.getLogger(ForumDataController.class);
	
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
	public ItemList getMessages (
			@PathVariable Long threadId, 
			@RequestParam(value = "skip", defaultValue = "0", required = false) int skip,
			@RequestParam(value = "page", defaultValue = "0", required = false) int page,
			@RequestParam(value = "pageSize", defaultValue = "0", required = false) int pageSize,
			NativeWebRequest request			
			) throws ForumThreadNotFoundException {	
		
		log.debug(" skip: {}, page: {}, pageSize: {}", skip, page, pageSize );
		
		ForumThread thread = forumService.getForumThread(threadId);
		MessageTreeWalker walker = forumService.getTreeWalker(thread);
	    
		int totalSize = walker.getChildCount(thread.getRootMessage());
				
		List<ForumMessage> list = getMessages(skip, page, pageSize, walker.getChildIds(thread.getRootMessage()));		
		
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
	
	
	
	/**
	 * /data/forums/threads/{threadId}/messages/{messageId}/comments/add.json?text=
	 * @return
	 * @throws ForumMessageNotFoundException 
	 * @throws BoardNotFoundException
	 */
	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/{messageId:[\\p{Digit}]+}/comments/add_simple.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public Result addComment (			
			@PathVariable Long threadId, 
			@PathVariable Long messageId, 
			@RequestParam(value = "name", defaultValue = "", required = false) String name,
		    @RequestParam(value = "email", defaultValue = "", required = false) String email,
			@RequestParam(value = "text", defaultValue = "", required = true) String text,
			HttpServletRequest request, 
			ModelMap model) {	
		
		Result result = Result.newResult();
		try {
			User user = SecurityHelper.getUser();	
			String address = request.getRemoteAddr();
			
			ForumMessage message = forumService.getForumMessage(messageId);		
			Comment newComment = commentService.createComment(ModelObject.FORUM_MESSAGE, message.getMessageId(), user, text);
			
			newComment.setIPAddress(address);
			if (!StringUtils.isNullOrEmpty(name))
				newComment.setName(name);
			if (!StringUtils.isNullOrEmpty(email))
				newComment.setEmail(email);
			
			commentService.addComment(newComment);			
			
			result.setCount(1);			
		} catch (Exception e) {
			result.setError(e);
		}
		
		return result;
	}

	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/{messageId:[\\p{Digit}]+}/comments/add.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public Result addMessageComment (			
			@PathVariable Long threadId, 
			@PathVariable Long messageId, 
			@RequestBody RequestData reqeustData,
			HttpServletRequest request, 
			ModelMap model) {			
		Result result = Result.newResult();
		try {
			User user = SecurityHelper.getUser();	
			String address = request.getRemoteAddr();
			String name = reqeustData.getDataAsString("name", null);
			String email = reqeustData.getDataAsString("email", null);
			String text = reqeustData.getDataAsString("text", null);
			Long parentCommentId = reqeustData.getDataAsLong("parentCommentId", 0L);
			
			ForumMessage message = forumService.getForumMessage(messageId);		
			Comment newComment = commentService.createComment(ModelObject.FORUM_MESSAGE, message.getMessageId(), user, text);	
			
			
			newComment.setIPAddress(address);
			if (!StringUtils.isNullOrEmpty(name))
				newComment.setName(name);
			if (!StringUtils.isNullOrEmpty(email))
				newComment.setEmail(email);
			
			if( parentCommentId > 0 ){
				Comment parentComment = commentService.getComment(parentCommentId);
				commentService.addComment(parentComment, newComment);			
			}else{
				commentService.addComment(newComment);			
			}			
			result.setCount(1);			
		} catch (Exception e) {
			result.setError(e);
		}
		
		return result;
	}
	
	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/{messageId:[\\p{Digit}]+}/comments/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getComments(@PathVariable Long threadId, @PathVariable Long messageId, NativeWebRequest request) throws ForumMessageNotFoundException{			
		ForumMessage message = forumService.getForumMessage(messageId);		
		ModelObjectTreeWalker walker = commentService.getCommentTreeWalker(ModelObject.FORUM_MESSAGE, message.getMessageId());
		long parentId = -1L;
		int totalSize = walker.getChildCount(parentId);
		List<Comment> list = walker.children(parentId, new ObjectLoader<Comment>(){
			public Comment load(long commentId) throws NotFoundException {
				return commentService.getComment(commentId);
			}
			
		});
		return new ItemList(list, totalSize);
	}
	
	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/{messageId:[\\p{Digit}]+}/comments/{commentId:[\\p{Digit}]+}/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getChildComments(
			@PathVariable Long threadId, 
			@PathVariable Long messageId, 
			@PathVariable Long commentId,
			NativeWebRequest request) throws ForumMessageNotFoundException{		
		
		ForumMessage message = forumService.getForumMessage(messageId);		
		ModelObjectTreeWalker walker = commentService.getCommentTreeWalker(ModelObject.FORUM_MESSAGE, message.getMessageId());
		
		int totalSize = walker.getChildCount(commentId);		
		List<Comment> list = walker.children(commentId, new ObjectLoader<Comment>(){
			public Comment load(long commentId) throws NotFoundException {
				return commentService.getComment(commentId);
			}			
		});
		return new ItemList(list, totalSize);
	}
	
	protected List<ForumMessage> getMessages(int skip, int page, int pageSize, long[] messageIds){	
		
		if( pageSize == 0 && page == 0){
			return getMessages(messageIds);
		}
		
		List<ForumMessage> list = new ArrayList<ForumMessage>();
		for( int i = 0 ; i < pageSize * page ; i++ )
		{
			if( skip > 0 && i < skip ){
				continue;
			}
			try {
				
				list.add(forumService.getForumMessage(messageIds[i]));
			} catch (ForumMessageNotFoundException e) {
			}			
		}
		return list;
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