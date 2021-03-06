package architecture.community.web.spring.controller.data.v1;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.SqlParameterValue;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import architecture.community.announce.Announce;
import architecture.community.announce.AnnounceNotFoundException;
import architecture.community.announce.AnnounceService;
import architecture.community.attachment.Attachment;
import architecture.community.attachment.AttachmentService;
import architecture.community.board.Board;
import architecture.community.board.BoardMessage;
import architecture.community.board.BoardMessageNotFoundException;
import architecture.community.board.BoardNotFoundException;
import architecture.community.board.BoardService;
import architecture.community.board.BoardThread;
import architecture.community.board.BoardThreadNotFoundException;
import architecture.community.board.BoardView;
import architecture.community.board.DefaultBoardMessage;
import architecture.community.board.DefaultBoardThread;
import architecture.community.board.MessageTreeWalker;
import architecture.community.codeset.CodeSet;
import architecture.community.codeset.CodeSetService;
import architecture.community.comment.Comment;
import architecture.community.comment.CommentService;
import architecture.community.exception.NotFoundException;
import architecture.community.exception.UnAuthorizedException;
import architecture.community.image.Image;
import architecture.community.image.ImageService;
import architecture.community.image.ThumbnailImage;
import architecture.community.model.ModelObjectTreeWalker;
import architecture.community.model.ModelObjectTreeWalker.ObjectLoader;
import architecture.community.model.Models;
import architecture.community.model.json.JsonDateSerializer;
import architecture.community.query.CustomQueryService;
import architecture.community.query.CustomQueryService.DaoCallback;
import architecture.community.query.dao.CustomQueryJdbcDao;
import architecture.community.security.spring.acls.CommunityAclService;
import architecture.community.user.User;
import architecture.community.util.SecurityHelper;
import architecture.community.viewcount.ViewCountService;
import architecture.community.web.model.ItemList;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.community.web.model.json.Result;
import architecture.ee.util.StringUtils;

/**
 * Board Data Controller
 * 
 * 
 * @author donghyuck
 *
 */

@Controller("data-api-v1-community-controller")
@RequestMapping("/data/api/v1")
public class CommunityDataController extends AbstractCommunityDateController {

	private Logger log = LoggerFactory.getLogger(getClass());	
	
	@Inject
	@Qualifier("boardService")
	private BoardService boardService;
	
	@Inject
	@Qualifier("commentService")
	private CommentService commentService;

	@Inject
	@Qualifier("imageService")
	private ImageService imageService;
	
	@Inject
	@Qualifier("attachmentService")
	private AttachmentService attachmentService;
		
	@Inject
	@Qualifier("viewCountService")
	private ViewCountService viewCountService
	;	
	
	@Inject
	@Qualifier("communityAclService")
	private CommunityAclService communityAclService;

	@Inject
	@Qualifier("codeSetService")
	private CodeSetService codeSetService;
	
	@Inject
	@Qualifier("announceService")
	private AnnounceService announceService;
	
	
	@Inject
	@Qualifier("customQueryService")
	private CustomQueryService customQueryService;
	
	
	protected BoardService getBoardService () {
		return boardService;
	}
 
	protected CommunityAclService getCommunityAclService() { 
		return communityAclService;
	}
	
	
	/**
	 * COMMON CODE API 
	******************************************/
	
	@RequestMapping(value = "/codeset/{group}/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<CodeSet> getCodeSetsByGroupAndCode(
			@PathVariable String group,
			@RequestParam(value = "objectType", defaultValue = "-1", required = false) Integer objectType,
			@RequestParam(value = "objectId", defaultValue = "-1", required = false) Long objectId ){
		
		List<CodeSet> codes = Collections.EMPTY_LIST ;
		
		if (!StringUtils.isNullOrEmpty(group)) {
			codes = codeSetService.getCodeSets(objectType, objectId, group);
			
		}
		return codes ;
	}

	@RequestMapping(value = "/objects/type/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Map<String, Object>> getObjectTypes(NativeWebRequest request){ 
		List<Map<String, Object>> list = customQueryService.list("COMMUNITY_CS.SELECT_OBJECT_TYPE_ID_AND_NAME");
		return list ;
	}
	
	/**
	 * ANNOUNCE API 
	******************************************/
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping(value = "/announces/save-or-update.json", method = RequestMethod.POST)
	@ResponseBody
	public Announce saveOrUpdateAnnounce(@RequestBody Announce announce, NativeWebRequest request)
			throws AnnounceNotFoundException, UnAuthorizedException {

		User user = SecurityHelper.getUser();
		if (announce.getUser() == null && announce.getAnnounceId() == 0)
			announce.setUser(user);

		if (user.isAnonymous() || ( !SecurityHelper.isUserInRole("ROLE_ADMINISTRATOR")  && user.getUserId() != announce.getUser().getUserId()) ) {
			throw new UnAuthorizedException();
		}

		Announce target;
		if (announce.getAnnounceId() > 0) {
			target = announceService.getAnnounce(announce.getAnnounceId());
		} else {
			target = announceService.createAnnounce(user, announce.getObjectType(), announce.getObjectId());
		}

		target.setSubject(announce.getSubject());
		target.setBody(announce.getBody());
		target.setStartDate(announce.getStartDate());
		target.setEndDate(announce.getEndDate());
		if (target.getAnnounceId() > 0) {
			announceService.updateAnnounce(target);
		} else {
			announceService.addAnnounce(target);
		}
		return target;
	}

	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping(value = "/announces/{announceId:[\\p{Digit}]+}/delete.json", method = RequestMethod.POST)
	@ResponseBody
	public Result destoryAnnounce( @PathVariable Long announceId, NativeWebRequest request) throws AnnounceNotFoundException {
		
		User user = SecurityHelper.getUser();

		Announce announce = announceService.getAnnounce(announceId);
		if( announce.getUser().getUserId() == user.getUserId())
			announceService.deleteAnnounce(announceId);
		return Result.newResult();
	}

	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping(value = "/announces/{announceId:[\\p{Digit}]+}/get.json", method = RequestMethod.POST)
	@ResponseBody
	public Announce getAnnounce( @PathVariable Long announceId, NativeWebRequest request) throws AnnounceNotFoundException {
		
		User user = SecurityHelper.getUser();

		Announce announce = announceService.getAnnounce(announceId);
		
		return announce;
	}
	
	@PreAuthorize("permitAll")
    @RequestMapping(value = "/announces/list.json", method = { RequestMethod.POST, RequestMethod.GET })
    @ResponseBody
	public ItemList getAnnounces(
		
		@RequestParam(value = "objectType", defaultValue = "0", required = false) Integer objectType,
		@RequestParam(value = "objectId", defaultValue = "0", required = false) Long objectId,			
		@RequestBody DataSourceRequest dataSourceRequest,
		NativeWebRequest request) throws NotFoundException {
		ItemList items = new ItemList();
		User user = SecurityHelper.getUser();

		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");		
		
		Date startDate = null;
		Date endDate = null;		
		try {
			
			if(dataSourceRequest.getDataAsString("startDate", null)!=null)
				startDate = simpleDateFormat.parse(dataSourceRequest.getDataAsString("startDate", null));
			if(dataSourceRequest.getDataAsString("endDate", null)!=null)
				endDate = simpleDateFormat.parse(dataSourceRequest.getDataAsString("endDate", null));
			
			if (startDate == null)
			    startDate = Calendar.getInstance().getTime();
			if (endDate == null)
			    endDate = Calendar.getInstance().getTime();
		} catch (ParseException e) {}
		
		items.setItems(announceService.getAnnounces(objectType, objectId, startDate, endDate));
		items.setTotalCount(getTotalAnnounceCount(objectType, objectId, startDate, endDate));
		
		return items;
	}

	private int getTotalAnnounceCount(int objectType, long objectId, Date startDate, Date endDate) {
		if (startDate != null) {
		    return announceService.getAnnounceCount(objectType, objectId, startDate,
			    endDate == null ? Calendar.getInstance().getTime() : endDate);
		}
		return announceService.getAnnounceCount(objectType, objectId,
			endDate == null ? Calendar.getInstance().getTime() : endDate);
	}
	
	/**
	 * BOARD API 
	******************************************/
	
	/**
	 * 게시판 목록 리턴 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/boards/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getBoardList (NativeWebRequest request) {			
		List<Board> list = boardService.getAllBoards();
		List<Board> list2 = new ArrayList<Board> ();		
		
		for( Board board : list)
		{	
			BoardView v = getBoardView(communityAclService, boardService, board);
			if(v.isReadable())
				list2.add(v);
		}
		return new ItemList(list2, list2.size());
	}
	
	
	/**
	 * 게시판 정보 리턴 
	 * @param request
	 * @return
	 * @throws BoardNotFoundException 
	 */
	@RequestMapping(value = { "/boards/{boardId:[\\p{Digit}]+}/info.json",  "/boards/{boardId:[\\p{Digit}]+}/get.json" }, method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public Board getBoard (@PathVariable Long boardId, NativeWebRequest request) throws BoardNotFoundException {	
		Board board = boardService.getBoardById(boardId);
		BoardView b = getBoardView(communityAclService, boardService, board);
		return b;
	}
	
	
	/**
	 * 특정 게시판 스레드(게시물) 목록
	 * /data/boards/{boardId}/threads/list.json
	 * 
	 * @param boardId
	 * @param request
	 * @return
	 * @throws BoardNotFoundException
	 */
	@RequestMapping(value = "/boards/{boardId:[\\p{Digit}]+}/threads/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getThreadList (@PathVariable Long boardId, 
			@RequestParam(value = "skip", defaultValue = "0", required = false) int skip,
			@RequestParam(value = "page", defaultValue = "0", required = false) int page,
			@RequestParam(value = "pageSize", defaultValue = "0", required = false) int pageSize,
			NativeWebRequest request) throws BoardNotFoundException {	
				
		Board board = boardService.getBoardById(boardId);	
		List<BoardThread> list;
		int totalSize = boardService.getBoardThreadCount(Models.BOARD.getObjectType(), board.getBoardId());
		
		if( pageSize == 0 && page == 0){
			list = boardService.getBoardThreads(Models.BOARD.getObjectType(), board.getBoardId());
		}else{
			list = boardService.getBoardThreads(Models.BOARD.getObjectType(), board.getBoardId(), skip, pageSize);
		}
		return new ItemList(list, totalSize);
	}
	
	@RequestMapping(value = "/boards/{boardId:[\\p{Digit}]+}/threads/list_v2.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getThreadList2 (@PathVariable Long boardId, 
			@RequestBody DataSourceRequest dataSourceRequest,
			NativeWebRequest request) throws BoardNotFoundException {	
				
		Board board = boardService.getBoardById(boardId);	
		dataSourceRequest.getData().put("boardId", board.getBoardId());
		dataSourceRequest.setStatement("COMMUNITY_CS.COUNT_THREAD_BY_REQUEST");
		int totalCount = customQueryService.queryForObject(dataSourceRequest, Integer.class);
		dataSourceRequest.setStatement("COMMUNITY_CS.SELECT_THREAD_IDS_BY_REQUEST");
		List<Long> items = customQueryService.list(dataSourceRequest, Long.class);
		
		List<BoardThread> threads = new ArrayList<BoardThread>(items.size());
		for( Long id : items ) {
			try {
				threads.add( new UnmutableMessageThread ( boardService.getBoardThread(id) ));
			} catch (NotFoundException e) {
			}
		}
		return new ItemList(threads, totalCount );
	}	
	

	public class UnmutableMessage implements BoardMessage{
		
		private BoardMessage message ;
		
		protected UnmutableMessage(architecture.community.board.BoardMessage message) {
			this.message = message;
		}

		
		public int getObjectType() {
			return message.getObjectType();
		}

		@Override
		public long getObjectId() {
			return message.getObjectId();
		}

		@Override
		public Map<String, String> getProperties() { 
			return message.getProperties();
		}

		@Override
		public void setProperties(Map<String, String> properties) {
			message.setProperties(properties);
		}

		@Override
		public User getUser() { 
			return message.getUser();
		}

		@Override
		public long getParentMessageId() {
			return message.getParentMessageId();
		}

		@Override
		public long getMessageId() {
			// TODO Auto-generated method stub
			return message.getMessageId();
		}

		@Override
		public long getThreadId() {
			return message.getThreadId();
		}

		@Override
		public String getSubject() {
			return message.getSubject();
		}

		@Override
		public String getBody() {
			return null;
		}

		@Override
		public void setSubject(String subject) {
			message.setSubject(subject);
		}

		@Override
		public void setBody(String body) {
			message.setBody(body);
		}

		@Override
		public void setKeywords(String keywords) {
			message.setKeywords(keywords);
		}

		@Override
		public String getKeywords() {
			return message.getKeywords();
		}

		@JsonSerialize(using = JsonDateSerializer.class)
		public Date getCreationDate() { 
			return message.getCreationDate();
		}

		@JsonSerialize(using = JsonDateSerializer.class)
		public Date getModifiedDate() { 
			return message.getModifiedDate();
		}
 
		public void setCreationDate(Date creationDate) { 
		}
 
		public void setModifiedDate(Date modifiedDate) { 
		} 
	}
	
	public class UnmutableMessageThread implements BoardThread { 
		
		private BoardThread thread ;
 

		public UnmutableMessageThread(BoardThread thread) {
			this.thread = thread;
		}

		@Override
		public int getObjectType() { 
			return thread.getObjectType();
		}

		@Override
		public long getObjectId() { 
			return thread.getObjectId();
		}

		@Override
		public Map<String, String> getProperties() { 
			return thread.getProperties();
		}

		@Override
		public void setProperties(Map<String, String> properties) {
			 
		}

		@Override
		public long getThreadId() { 
			return thread.getThreadId();
		}

		@JsonSerialize(using = JsonDateSerializer.class)
		public Date getCreationDate() { 
			return thread.getCreationDate();
		}

		@Override
		public void setCreationDate(Date creationDate) { 
			
		}

		@JsonSerialize(using = JsonDateSerializer.class)
		public Date getModifiedDate() { 
			return thread.getModifiedDate();
		}

		@Override
		public void setModifiedDate(Date modifiedDate) { 
			
		}

		@Override
		public BoardMessage getLatestMessage() { 
			return new UnmutableMessage( thread.getLatestMessage( ) );
		}

		@Override
		public void setLatestMessage(BoardMessage latestMessage) { 
			
		}

		@Override
		public BoardMessage getRootMessage() { 
			return new UnmutableMessage(thread.getRootMessage());
		}

		@Override
		public void setRootMessage(BoardMessage rootMessage) { 
			
		}
		

		public int getViewCount(){
			return ((DefaultBoardThread)thread).getViewCount();
		}
		
	    public int getMessageCount()
	    {
		     return ((DefaultBoardThread)thread).getMessageCount();
	    }

		
	}
	
	
	
	/**
	 * 특정 스레드에 해당하는 게시물 목록 
	 * 
	 * @param threadId
	 * @param request
	 * @return
	 * @throws BoardNotFoundException
	 */
	@RequestMapping(value = { "/threads/{threadId:[\\p{Digit}]+}/info.json", "/threads/{threadId:[\\p{Digit}]+}/get.json" }, method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public BoardThread getThread(@PathVariable Long threadId, NativeWebRequest request) throws BoardThreadNotFoundException { 
		
		BoardThread thread = boardService.getBoardThread(threadId);
		
		return thread ;
	}	
	 

	/**
	 * 특정 스레드에 해당하는 게시물 목록 
	 * 
	 * @param threadId
	 * @param request
	 * @return
	 * @throws BoardNotFoundException
	 */
	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getMessages(@PathVariable Long threadId,
			@RequestParam(value = "skip", defaultValue = "0", required = false) int skip,
			@RequestParam(value = "page", defaultValue = "0", required = false) int page,
			@RequestParam(value = "pageSize", defaultValue = "0", required = false) int pageSize,
			NativeWebRequest request) throws BoardThreadNotFoundException { 
		
		BoardThread thread = boardService.getBoardThread(threadId);
		
		MessageTreeWalker walker = boardService.getTreeWalker(thread);
		int totalSize = walker.getChildCount(thread.getRootMessage());
		List<BoardMessage> list = getProjectView(skip, page, pageSize, walker.getChildIds(thread.getRootMessage()));
		return new ItemList(list, totalSize);
	}	
	 
	
	@Secured({ "ROLE_USER" })
	@RequestMapping(value = "/messages/save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public BoardMessage saveOrUpdate(@RequestBody DefaultBoardMessage newMessage, NativeWebRequest request) throws BoardThreadNotFoundException, NotFoundException {

		User user = SecurityHelper.getUser();
		newMessage.setUser(user);
		log.debug("MESSAGE : " + newMessage.toString() );
		boolean bodyChanged = false;
		final BoardMessage messageToUse = newMessage;
		// NEW THREAD MESSAGE...	
		if ( newMessage.getThreadId() > 0) {
			BoardThread thread = boardService.getBoardThread(newMessage.getThreadId());
			if( newMessage.getMessageId() > 0 ) {
				// UPDATE MESSAGE...	
				BoardMessage message = boardService.getBoardMessage(newMessage.getMessageId());
				boardService.updateMessage(newMessage);
				if( !org.apache.commons.lang3.StringUtils.equals(message.getBody(), messageToUse.getBody())  ) {
					customQueryService.execute(new DaoCallback<Integer>() {
						public Integer process(CustomQueryJdbcDao dao) throws DataAccessException {
							Document doc = Jsoup.parse(messageToUse.getBody());
							Elements eles = doc.select("img");
							int count = 0;
							for( Element ele : eles ) {
								log.debug("found img tag in content : {} ", ele.toString());
								if( ele.hasAttr("data-external-id") ) {					
									String link = ele.attr("data-external-id");
									log.debug("it has external link : {}.", link);
									try {
										Image image = imageService.getImageByImageLink(link);
										if( image.getObjectType() <= 0 && image.getObjectId() <= 0 ) {									
											count = dao.getExtendedJdbcTemplate().update(dao.getBoundSql("COMMUNITY_CS.UPDATE_IMAGE_OBJECT_TYPE_AND_OBJECT_ID").getSql(), 
												new SqlParameterValue(Types.NUMERIC, Models.BOARD_MESSAGE.getObjectType()),
												new SqlParameterValue(Types.NUMERIC, messageToUse.getMessageId()),
												new SqlParameterValue(Types.NUMERIC, image.getImageId())
											);
											imageService.invalidate(image, false);
										}
									} catch (Exception e) {
									}
								}
							}
							return count;
						}
					});				
				}
			}else {
				// ADD NEW MESSAGE...							
				boardService.addMessage(thread, thread.getRootMessage(), newMessage);				
			}		
		}else {
			if( newMessage.getMessageId() < 1 ) {
				// NEW THREAD AND MESSAGE...
				BoardMessage rootMessage = boardService.createMessage(newMessage.getObjectType(), newMessage.getObjectId(), user);
				rootMessage.setSubject(newMessage.getSubject());
				rootMessage.setBody(newMessage.getBody());
				rootMessage.setKeywords(newMessage.getKeywords());
				BoardThread thread = boardService.createThread(rootMessage.getObjectType(), rootMessage.getObjectId(), rootMessage);
				boardService.addThread(rootMessage.getObjectType(), rootMessage.getObjectId(), thread);
				return boardService.getBoardMessage(thread.getRootMessage().getMessageId());		
			}
		}		
		return newMessage;
	}	
	
	
	
	@Secured({ "ROLE_USER" })
	@RequestMapping(value = "/messages/{messageId:[\\p{Digit}]+}/attachments/{attachmentId:[\\p{Digit}]+}/remove.json", method = { RequestMethod.POST, RequestMethod.GET })	
	@ResponseBody
	public Result removeMessageAttachment (
		@PathVariable Long messageId, 
		@PathVariable Long attachmentId, 
		@RequestBody DataSourceRequest dataSourceRequest, 
		NativeWebRequest request) throws NotFoundException {
		
		
		User user = SecurityHelper.getUser();
		BoardMessage message = boardService.getBoardMessage(messageId);
		if( message.getUser().getUserId() == user.getUserId() )
		{
			Attachment attachment = attachmentService.getAttachment(attachmentId);
			attachmentService.removeAttachment(attachment);
		}
		
		return Result.newResult();
	}	

	@Secured({ "ROLE_USER" })
	@RequestMapping(value = "/messages/add.json", method = { RequestMethod.POST })
	@ResponseBody
	public BoardMessage addThread(@RequestBody DefaultBoardMessage newMessage, NativeWebRequest request) {

		User user = SecurityHelper.getUser();
		if (newMessage.getThreadId() < 1 && newMessage.getMessageId() < 1) {
			BoardMessage rootMessage = boardService.createMessage(newMessage.getObjectType(), newMessage.getObjectId(), user);
			rootMessage.setSubject(newMessage.getSubject());
			rootMessage.setBody(newMessage.getBody());
			rootMessage.setKeywords(newMessage.getKeywords());
			BoardThread thread = boardService.createThread(rootMessage.getObjectType(), rootMessage.getObjectId(), rootMessage);
			boardService.addThread(rootMessage.getObjectType(), rootMessage.getObjectId(), thread);
			return thread.getRootMessage();
		}
		return newMessage;
	}
	
	@RequestMapping(value = "/messages/{messageId:[\\p{Digit}]+}/delete.json", method = RequestMethod.POST)
	@ResponseBody
	public Result deleteMessage(@PathVariable Long messageId, @RequestParam(value = "recursive", defaultValue = "false", required = false) boolean recursive, NativeWebRequest request) throws NotFoundException {
		if (messageId < 1) {
			throw new BoardMessageNotFoundException();
		}
		BoardMessage message = boardService.getBoardMessage(messageId);
		BoardThread thread = boardService.getBoardThread(message.getThreadId());

		if( thread.getRootMessage().getMessageId() == message.getMessageId() ) {
			// delete thread
			boardService.deleteThread(thread);
		}else {
			boardService.deleteMessage(thread, message, recursive);
		}
		
		return Result.newResult();
	}	

	@RequestMapping(value = "/messages/{messageId:[\\p{Digit}]+}/get.json", method = RequestMethod.POST)
	@ResponseBody
	public BoardMessage getMessageById(@PathVariable Long messageId, NativeWebRequest request) throws NotFoundException {
		if (messageId < 1) {
			throw new BoardMessageNotFoundException();
		}
		BoardMessage message = boardService.getBoardMessage(messageId);
		BoardThread thread = boardService.getBoardThread(message.getThreadId());

		return message;
	}

	@RequestMapping(value = "/messages/{messageId:[\\p{Digit}]+}/update.json", method = RequestMethod.POST)
	@ResponseBody
	public BoardMessage updateMessage(@RequestBody DefaultBoardMessage newMessage, NativeWebRequest request) throws NotFoundException {
		
		User user = SecurityHelper.getUser();
		BoardMessage message = boardService.getBoardMessage(newMessage.getMessageId());
		message.setSubject(newMessage.getSubject());
		message.setBody(newMessage.getBody());
		message.setKeywords(newMessage.getKeywords());
		boardService.updateMessage(message);
		
		return message;
	}	
	
	@RequestMapping(value = "/messages/{messageId:[\\p{Digit}]+}/attachments/list.json", method = RequestMethod.POST)
	@ResponseBody
	public ItemList getMessageAttachmentList(@PathVariable Long messageId, NativeWebRequest request) throws NotFoundException {

		ItemList list = new ItemList();
		if (messageId < 1) {
			return list;
		}

		BoardMessage message = boardService.getBoardMessage(messageId);
		BoardThread thread = boardService.getBoardThread(message.getThreadId());

		List<Attachment> attachments = attachmentService.getAttachments(Models.BOARD_MESSAGE.getObjectType(), message.getMessageId());
		list.setItems(attachments);
		list.setTotalCount(attachments.size());

		return list;

	}

	@RequestMapping(value = "/messages/{messageId:[\\p{Digit}]+}/attachments/{attachmentId:[\\p{Digit}]+}/{filename:.+}", method = { RequestMethod.GET, RequestMethod.POST })
	public void downloadMessageAttachement(
			@PathVariable Long messageId, 
			@PathVariable("attachmentId") Long attachmentId,
			@PathVariable("filename") String filename,
			@RequestParam(value = "thumbnail", defaultValue = "false", required = false) boolean thumbnail,
			@RequestParam(value = "width", defaultValue = "150", required = false) Integer width,
			@RequestParam(value = "height", defaultValue = "150", required = false) Integer height,
			HttpServletResponse response) throws NotFoundException, IOException {
		
		if (messageId > 0 && attachmentId > 0 && !StringUtils.isNullOrEmpty(filename)) {
			
			BoardMessage message = boardService.getBoardMessage(messageId);
			BoardThread thread = boardService.getBoardThread(message.getThreadId());
			Attachment attachment = attachmentService.getAttachment(attachmentId);
			
			if( thumbnail )
			{
				if( attachmentService.hasThumbnail(attachment) ){
					ThumbnailImage thumbnailImage = new ThumbnailImage();
					thumbnailImage.setWidth(width);
					thumbnailImage.setHeight(height);
					
					InputStream input = attachmentService.getAttachmentThumbnailInputStream(attachment, thumbnailImage );
					response.setContentType(thumbnailImage.getContentType());
				    response.setContentLength((int)thumbnailImage.getSize());
				    IOUtils.copy(input, response.getOutputStream());
				    response.flushBuffer();
				}else{
				    response.setStatus(301);
				    String url ="/images/no-image.jpg" ;
				    response.addHeader("Location", url);
				}
			} else {
				InputStream input = attachmentService.getAttachmentInputStream(attachment);
				response.setContentType(attachment.getContentType());
				response.setContentLength(attachment.getSize());
				IOUtils.copy(input, response.getOutputStream());
				response.setHeader("contentDisposition", "attachment;filename=" + getEncodedFileName(attachment));
				response.flushBuffer();					
			}
		}		
		throw new NotFoundException();
	}
	

	@Secured({ "ROLE_USER" })
	@RequestMapping(value = "/messages/{messageId:[\\p{Digit}]+}/attachments/upload.json", method = RequestMethod.POST)
	@ResponseBody
	public List<Attachment> uploadMessageAttachement(@PathVariable Long messageId, MultipartHttpServletRequest request)
			throws NotFoundException, UnAuthorizedException, IOException {

		User currentUser = SecurityHelper.getUser();
		BoardMessage message = boardService.getBoardMessage(messageId);

		if (currentUser.isAnonymous() || message.getUser().getUserId() != currentUser.getUserId()) {
			throw new UnAuthorizedException();
		}

		if (messageId < 1) {
			throw new IllegalArgumentException("Message Id can't be " + messageId);
		}

		List<Attachment> list = new ArrayList<Attachment>();
		Iterator<String> names = request.getFileNames();
		while (names.hasNext()) {
			String fileName = names.next();
			MultipartFile mpf = request.getFile(fileName);
			InputStream is = mpf.getInputStream();
			log.debug("upload - file:{}, size:{}, type:{} ", mpf.getOriginalFilename(), mpf.getSize(), mpf.getContentType());
			Attachment attachment = attachmentService.createAttachment(7, message.getMessageId(), mpf.getOriginalFilename(), mpf.getContentType(), is, (int) mpf.getSize());
			attachment.setUser(currentUser);
			attachmentService.saveAttachment(attachment);
			list.add(attachment);
		}
		return list;

	}


	/**
	 * /data/forums/{threadId}/messages/{messageId}/list.json
	 * 
	 * @param boardId
	 * @param threadId
	 * @param request
	 * @return
	 * @throws BoardMessageNotFoundException
	 * @throws BoardNotFoundException
	 */
	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/{parentId:[\\p{Digit}]+}/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getChildMessages(@PathVariable Long threadId, @PathVariable Long parentId, NativeWebRequest request)
			throws BoardThreadNotFoundException, BoardMessageNotFoundException {

		BoardThread thread = boardService.getBoardThread(threadId);
		BoardMessage parent = boardService.getBoardMessage(parentId);
		MessageTreeWalker walker = boardService.getTreeWalker(thread);
		int totalSize = walker.getChildCount(parent);
		List<BoardMessage> list = getMessages(walker.getChildIds(parent));
		return new ItemList(list, totalSize);
	}

	/**
	 * /data/forums/threads/{threadId}/messages/{messageId}/comments/add.json?
	 * text=
	 * 
	 * @return
	 * @throws BoardMessageNotFoundException
	 * @throws BoardNotFoundException
	 */
	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/{messageId:[\\p{Digit}]+}/comments/add_simple.json", method = {RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result addComment(@PathVariable Long threadId, @PathVariable Long messageId,
			@RequestParam(value = "name", defaultValue = "", required = false) String name,
			@RequestParam(value = "email", defaultValue = "", required = false) String email,
			@RequestParam(value = "text", defaultValue = "", required = true) String text, HttpServletRequest request,
			ModelMap model) {

		Result result = Result.newResult();
		try {
			User user = SecurityHelper.getUser();
			String address = request.getRemoteAddr();

			BoardMessage message = boardService.getBoardMessage(messageId);
			Comment newComment = commentService.createComment(Models.BOARD_MESSAGE.getObjectType(), message.getMessageId(), user, text);

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

	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/{messageId:[\\p{Digit}]+}/comments/add.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result addMessageComment(@PathVariable Long threadId, @PathVariable Long messageId,
			@RequestBody DataSourceRequest reqeustData, HttpServletRequest request, ModelMap model) {
		Result result = Result.newResult();
		try {
			User user = SecurityHelper.getUser();
			String address = request.getRemoteAddr();
			String name = reqeustData.getDataAsString("name", null);
			String email = reqeustData.getDataAsString("email", null);
			String text = reqeustData.getDataAsString("text", null);
			Long parentCommentId = reqeustData.getDataAsLong("parentCommentId", 0L);

			BoardMessage message = boardService.getBoardMessage(messageId);
			Comment newComment = commentService.createComment(Models.BOARD_MESSAGE.getObjectType(),
					message.getMessageId(), user, text);

			newComment.setIPAddress(address);
			if (!StringUtils.isNullOrEmpty(name))
				newComment.setName(name);
			if (!StringUtils.isNullOrEmpty(email))
				newComment.setEmail(email);

			if (parentCommentId > 0) {
				Comment parentComment = commentService.getComment(parentCommentId);
				commentService.addComment(parentComment, newComment);
			} else {
				commentService.addComment(newComment);
			}
			result.setCount(1);
		} catch (Exception e) {
			result.setError(e);
		}

		return result;
	}

	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/{messageId:[\\p{Digit}]+}/comments/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getComments(@PathVariable Long threadId, @PathVariable Long messageId, NativeWebRequest request)
			throws BoardMessageNotFoundException {
		BoardMessage message = boardService.getBoardMessage(messageId);
		ModelObjectTreeWalker walker = commentService.getCommentTreeWalker(Models.BOARD_MESSAGE.getObjectType(), message.getMessageId());
		long parentId = -1L;
		int totalSize = walker.getChildCount(parentId);
		
		
		List<Comment> list = walker.children(parentId, new ObjectLoader<Comment>() {
			public Comment load(long commentId) throws NotFoundException {
				return commentService.getComment(commentId);
			}

		});
		return new ItemList(list, totalSize);
	}

	@RequestMapping(value = "/threads/{threadId:[\\p{Digit}]+}/messages/{messageId:[\\p{Digit}]+}/comments/{commentId:[\\p{Digit}]+}/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getChildComments(@PathVariable Long threadId, @PathVariable Long messageId,
			@PathVariable Long commentId, NativeWebRequest request) throws BoardMessageNotFoundException {

		BoardMessage message = boardService.getBoardMessage(messageId);
		ModelObjectTreeWalker walker = commentService.getCommentTreeWalker(Models.BOARD_MESSAGE.getObjectType(), message.getMessageId());

		int totalSize = walker.getChildCount(commentId);
		
		List<Comment> list = walker.children(commentId, new ObjectLoader<Comment>() {
			public Comment load(long commentId) throws NotFoundException {
				return commentService.getComment(commentId);
			}
		});
		return new ItemList(list, totalSize);
	}



	/**
	 * 메시지 아이디에 해당하는 메시지 객체를 리턴.
	 * @param messageIds
	 * @return
	 */
	protected List<BoardMessage> getMessages(long[] messageIds) {
		List<BoardMessage> list = new ArrayList<BoardMessage>(messageIds.length);
		for (long messageId : messageIds) {
			try {
				list.add(boardService.getBoardMessage(messageId));
			} catch (BoardMessageNotFoundException e) {
				// ignore..
			}
		}
		return list;
	}
		
	protected List<BoardMessage> getProjectView(int skip, int page, int pageSize, long[] messageIds) {
		if (pageSize == 0 && page == 0) {
			return getMessages(messageIds);
		}
		List<BoardMessage> list = new ArrayList<BoardMessage>();
		for (int i = 0; i < pageSize * page; i++) {
			if (i >= messageIds.length)
				break;

			if (skip > 0 && i < skip) {
				continue;
			}
			try {
				list.add(boardService.getBoardMessage(messageIds[i]));
			} catch (BoardMessageNotFoundException e) {
			}
		}
		return list;
	} 
}
