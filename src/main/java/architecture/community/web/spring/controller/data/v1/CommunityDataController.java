package architecture.community.web.spring.controller.data.v1;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.access.annotation.Secured;
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
import architecture.community.board.MessageTreeWalker;
import architecture.community.codeset.CodeSet;
import architecture.community.codeset.CodeSetService;
import architecture.community.comment.Comment;
import architecture.community.comment.CommentService;
import architecture.community.exception.NotFoundException;
import architecture.community.exception.UnAuthorizedException;
import architecture.community.image.ThumbnailImage;
import architecture.community.model.ModelObjectTreeWalker;
import architecture.community.model.ModelObjectTreeWalker.ObjectLoader;
import architecture.community.model.Models;
import architecture.community.projects.DefaultIssue;
import architecture.community.projects.Issue;
import architecture.community.projects.IssueNotFoundException;
import architecture.community.projects.IssueSummary;
import architecture.community.projects.Project;
import architecture.community.projects.ProjectService;
import architecture.community.projects.ProjectView;
import architecture.community.security.spring.acls.JdbcCommunityAclService;
import architecture.community.user.User;
import architecture.community.util.SecurityHelper;
import architecture.community.viewcount.ViewCountService;
import architecture.community.web.model.ItemList;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.community.web.model.json.Result;
import architecture.ee.util.StringUtils;

@Controller("community-data-v1-core-controller")
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
	@Qualifier("attachmentService")
	private AttachmentService attachmentService;
	
	@Inject
	@Qualifier("viewCountService")
	private ViewCountService viewCountService
	;	
	
	@Inject
	@Qualifier("communityAclService")
	private JdbcCommunityAclService communityAclService;
	
	@Inject
	@Qualifier("projectService")
	private ProjectService projectService;
		
	@Inject
	@Qualifier("codeSetService")
	private CodeSetService codeSetService;
	
	protected BoardService getBoardService () {
		return boardService;
	}
 
	protected JdbcCommunityAclService getCommunityAclService() { 
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
	
	/**
	 * PROJECT & ISSUE API 
	******************************************/
	@RequestMapping(value = "/projects/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getProjects (@RequestBody DataSourceRequest dataSourceRequest, NativeWebRequest request) {			
		
		List<Project> list = projectService.getProjects();
		List<ProjectView> list2 = new ArrayList<ProjectView> ();		
		
		for( Project project : list)
		{	
			ProjectView v = getProjectView(communityAclService, project);
			v.setIssueTypeStats(projectService.getIssueTypeStats(project));
			v.setResolutionStats(projectService.getIssueResolutionStats(project));
			if(v.isReadable())
				list2.add(v);
		}
		return new ItemList(list2, list2.size());
	}
	
	/**
	 * 프로젝트 정보 리턴 
	 * @param request
	 * @return
	 * @throws BoardNotFoundException 
	 */
	@RequestMapping(value = { "/projects/{projectId:[\\p{Digit}]+}/info.json",  "/projects/{projectId:[\\p{Digit}]+}/get.json" }, method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ProjectView getProject (@PathVariable Long projectId, NativeWebRequest request) throws NotFoundException {	
		Project project = projectService.getProject(projectId);
		ProjectView v = getProjectView(communityAclService, project);
		v.setIssueTypeStats(projectService.getIssueTypeStats(project));
		v.setResolutionStats(projectService.getIssueResolutionStats(project));
		return v;
	}
	 
	@Secured({ "ROLE_USER" })
	@RequestMapping(value = "/issues/save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public Issue saveOrUpdateIssue(@RequestBody DefaultIssue newIssue, NativeWebRequest request) throws NotFoundException {

		User user = SecurityHelper.getUser();
		
		log.debug("ISSUE : " + newIssue.toString() );
		Issue issueToUse ;
		if ( newIssue.getIssueId() > 0) {
			issueToUse = projectService.getIssue(newIssue.getIssueId());
		}else {
			issueToUse = projectService.createIssue(newIssue.getObjectType(), newIssue.getObjectId(), user );
		}		
		if( newIssue.getAssignee() != null && newIssue.getAssignee().getUserId() > 0	) {			
			if( issueToUse.getAssignee() != null && issueToUse.getAssignee().getUserId()  > 0 && issueToUse.getAssignee().getUserId() != newIssue.getAssignee().getUserId() ) {
				issueToUse.setAssignee(newIssue.getAssignee());
			}
			if( issueToUse.getAssignee() == null ) {
				issueToUse.setAssignee(newIssue.getAssignee());
			}
		}	
		if( newIssue.getRepoter() != null && newIssue.getRepoter().getUserId() > 0	) {			
			if( issueToUse.getRepoter() != null && issueToUse.getRepoter().getUserId()  > 0 && issueToUse.getRepoter().getUserId() != newIssue.getRepoter().getUserId() ) {
				issueToUse.setRepoter(newIssue.getAssignee());
			}
			if( issueToUse.getRepoter() == null ) {
				issueToUse.setRepoter(newIssue.getRepoter());
			}
		}

		if( newIssue.getDueDate() != null && newIssue.getDueDate() != issueToUse.getDueDate() ) {
			issueToUse.setDueDate(newIssue.getDueDate());
		}
		if( newIssue.getResolutionDate() != null && newIssue.getResolutionDate() != issueToUse.getResolutionDate() ) {
			issueToUse.setResolutionDate(newIssue.getResolutionDate());
		}
		log.debug("{} compare with saved : {}", newIssue.getResolutionDate(), newIssue.getResolutionDate() != issueToUse.getResolutionDate());
		issueToUse.setComponent(newIssue.getComponent());
		issueToUse.setSummary(newIssue.getSummary());
		issueToUse.setDescription(newIssue.getDescription());
		issueToUse.setIssueType(newIssue.getIssueType());
		issueToUse.setStatus(newIssue.getStatus());
		issueToUse.setResolution(newIssue.getResolution());
		issueToUse.setPriority(newIssue.getPriority());
		
		projectService.saveOrUpdateIssue(newIssue);
		
		return issueToUse;
	}	 
	
	
	/**
	 * STATUS_ISNULL, TILL_THIS_WEEK 
	 * @param dataSourceRequest
	 * @param request
	 * @return
	 */
	@Secured({ "ROLE_USER" })
	@RequestMapping(value = "/issues/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getIssueSummaries(
			@RequestBody DataSourceRequest dataSourceRequest,
			NativeWebRequest request) {
		ItemList items = new ItemList();
		User currentUser = SecurityHelper.getUser();
		if( dataSourceRequest.getDataAsBoolean("TILL_THIS_WEEK", false) ) {
			dataSourceRequest.getData().put("TILL_THIS_WEEK", getThisSaturday());
		}{
			dataSourceRequest.getData().put("TILL_THIS_WEEK", null);
		}
		dataSourceRequest.setUser(currentUser);		
		int totalSize = projectService.getIssueSummaryCount(dataSourceRequest);
		if( totalSize > 0) {
			List<IssueSummary> list = projectService.getIssueSummary(dataSourceRequest);
			items.setTotalCount(totalSize);
			items.setItems(list);
		}		
		return items;
	}
	
	private String getThisSaturday() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY );
		Date sat = c.getTime();	
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		return formatter.format(sat);
	}
	
	@Secured({ "ROLE_USER" })
	@RequestMapping(value = "/issues/me/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getMyIssueSummaries(
			@RequestBody DataSourceRequest dataSourceRequest,
			NativeWebRequest request) {
		ItemList items = new ItemList();
		User currentUser = SecurityHelper.getUser();
		dataSourceRequest.setUser(currentUser);
		int totalSize = projectService.getIssueSummaryCount(dataSourceRequest);
		if( totalSize > 0) {
			List<IssueSummary> list = projectService.getIssueSummary(dataSourceRequest);
			items.setTotalCount(totalSize);
			items.setItems(list);
		}		
		return items;
	}
	
	/**
	 * 프로젝트 이슈 목록
	 * /data/boards/{boardId}/threads/list.json
	 * 
	 * @param boardId
	 * @param request
	 * @return
	 * @throws BoardNotFoundException
	 */
	@RequestMapping(value = "/projects/{projectId:[\\p{Digit}]+}/issues/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getProjectIssues (@PathVariable Long projectId, 
			@RequestBody DataSourceRequest dataSourceRequest,
			NativeWebRequest request) throws NotFoundException {	
				
		Project project = projectService.getProject(projectId);
		List<Issue> list ;
		log.debug("DataSourceRequest: {}", dataSourceRequest );
		
		dataSourceRequest.getData().put("objectType", Models.PROJECT.getObjectType());
		dataSourceRequest.getData().put("objectId", project.getProjectId());
		
		int totalSize = projectService.getIssueCount(dataSourceRequest);
		if( totalSize > 0) {
			list = projectService.getIssues(dataSourceRequest);
		}else {
			list = Collections.EMPTY_LIST;
		}
		return new ItemList(list, totalSize);
	}
	
	@RequestMapping(value = "/issues/{issueId:[\\p{Digit}]+}/get-with-project.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public IssueWithProject getIssueWithProject(@PathVariable Long issueId, NativeWebRequest request) throws NotFoundException{
		if( issueId <= 0)
			throw new IssueNotFoundException();
		
		Issue issueToUse = projectService.getIssue(issueId);
		Project projectToUse = projectService.getProject(issueToUse.getObjectId());
		return new IssueWithProject(projectToUse, issueToUse);
		
	}

	public static class IssueWithProject {
		private Issue issue ;
		private Project project;
		
		public IssueWithProject(Project project, Issue issue) {
			this.project = project;
			this.issue = issue;
		}
		public Issue getIssue() {
			return issue;
		}
		public void setIssue(Issue issue) {
			this.issue = issue;
		}
		public Project getProject() {
			return project;
		}
		public void setProject(Project project) {
			this.project = project;
		}
		
	}

	@RequestMapping(value = "/issues/{issueId:[\\p{Digit}]+}/attachments/list.json", method = RequestMethod.POST)
	@ResponseBody
	public ItemList getIssueAttachmentList(@PathVariable Long issueId, NativeWebRequest request) throws NotFoundException {
		ItemList list = new ItemList();
		if (issueId < 1) {
			return list;
		}
		Issue issueToUse = projectService.getIssue(issueId);
		List<Attachment> attachments = attachmentService.getAttachments(Models.ISSUE.getObjectType(), issueToUse.getIssueId());
		list.setItems(attachments);
		list.setTotalCount(attachments.size());
		return list;

	}

	@RequestMapping(value = "/issues/{issueId:[\\p{Digit}]+}/attachments/{attachmentId:[\\p{Digit}]+}/{filename:.+}", method = { RequestMethod.GET, RequestMethod.POST })
	public void downloadIssueAttachement(
			@PathVariable Long issueId, 
			@PathVariable("attachmentId") Long attachmentId,
			@PathVariable("filename") String filename,
			@RequestParam(value = "thumbnail", defaultValue = "false", required = false) boolean thumbnail,
			@RequestParam(value = "width", defaultValue = "150", required = false) Integer width,
			@RequestParam(value = "height", defaultValue = "150", required = false) Integer height,
			HttpServletResponse response) throws NotFoundException, IOException {
		
		if (issueId > 0 && attachmentId > 0 && !StringUtils.isNullOrEmpty(filename)) {
			
			Issue issueToUse = projectService.getIssue(issueId);
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
	@RequestMapping(value = "/issues/{issueId:[\\p{Digit}]+}/attachments/upload.json", method = RequestMethod.POST)
	@ResponseBody
	public List<Attachment> uploadIssueAttachement(@PathVariable Long issueId, MultipartHttpServletRequest request)
			throws NotFoundException, UnAuthorizedException, IOException {

		User currentUser = SecurityHelper.getUser();
		Issue issueToUse = projectService.getIssue(issueId);
		
		if (currentUser.isAnonymous() || issueToUse.getRepoter().getUserId() != currentUser.getUserId()) {
			throw new UnAuthorizedException();
		}

		if (issueId < 1) {
			throw new IllegalArgumentException("IssueId Id can't be " + issueId);
		}

		List<Attachment> list = new ArrayList<Attachment>();
		Iterator<String> names = request.getFileNames();
		while (names.hasNext()) {
			String fileName = names.next();
			MultipartFile mpf = request.getFile(fileName);
			InputStream is = mpf.getInputStream();
			log.debug("upload - file:{}, size:{}, type:{} ", mpf.getOriginalFilename(), mpf.getSize(), mpf.getContentType());
			Attachment attachment = attachmentService.createAttachment(Models.ISSUE.getObjectType(), issueToUse.getIssueId(), mpf.getOriginalFilename(), mpf.getContentType(), is, (int) mpf.getSize());
			attachment.setUser(currentUser);
			attachmentService.saveAttachment(attachment);
			list.add(attachment);
		}
		return list;
	}
	

	/**
	 * 
	 * @return
	 * @throws BoardMessageNotFoundException
	 * @throws BoardNotFoundException
	 */
	@RequestMapping(value = "/issues/{issueId:[\\p{Digit}]+}/comments/add_simple.json", method = {RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result addCommentToIssueSimple(@PathVariable Long threadId, @PathVariable Long issueId,
			@RequestParam(value = "name", defaultValue = "", required = false) String name,
			@RequestParam(value = "email", defaultValue = "", required = false) String email,
			@RequestParam(value = "text", defaultValue = "", required = true) String text, HttpServletRequest request,
			ModelMap model) {

		Result result = Result.newResult();
		try {
			User user = SecurityHelper.getUser();
			String address = request.getRemoteAddr();

			Issue issueToUse = projectService.getIssue(issueId);
			Comment newComment = commentService.createComment(Models.ISSUE.getObjectType(), issueToUse.getIssueId(), user, text);

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

	@RequestMapping(value = "/issues/{issueId:[\\p{Digit}]+}/comments/add.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result addCommentToIssue(@PathVariable Long issueId,  @RequestBody DataSourceRequest reqeustData, HttpServletRequest request, ModelMap model) {
		Result result = Result.newResult();
		try {
			User user = SecurityHelper.getUser();
			String address = request.getRemoteAddr();
			String name = reqeustData.getDataAsString("name", null);
			String email = reqeustData.getDataAsString("email", null);
			String text = reqeustData.getDataAsString("text", null);
			Long parentCommentId = reqeustData.getDataAsLong("parentCommentId", 0L);

			Issue issueToUse = projectService.getIssue(issueId);
			Comment newComment = commentService.createComment(Models.ISSUE.getObjectType(), issueToUse.getIssueId(), user, text);

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

	@RequestMapping(value = "/issues/{issueId:[\\p{Digit}]+}/comments/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getIssueComments(@PathVariable Long issueId, NativeWebRequest request)
			throws IssueNotFoundException {
		ItemList items = new ItemList();
		if( issueId > 0 ) {		
			Issue issueToUse = projectService.getIssue(issueId);
			ModelObjectTreeWalker walker = commentService.getCommentTreeWalker(Models.ISSUE.getObjectType(), issueToUse.getIssueId());
			long parentId = -1L;
			int totalSize = walker.getChildCount(parentId);
			List<Comment> list = walker.children(parentId, new ObjectLoader<Comment>() {
				public Comment load(long commentId) throws NotFoundException {
					return commentService.getComment(commentId);
				}
	
			});
			items.setItems(list);
			items.setTotalCount(totalSize);
		}	
		return items;
	}

	@RequestMapping(value = "/issues/{issueId:[\\p{Digit}]+}/comments/{commentId:[\\p{Digit}]+}/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getIssueChildComments(@PathVariable Long issueId,
			@PathVariable Long commentId, NativeWebRequest request) throws IssueNotFoundException {

		Issue issueToUse = projectService.getIssue(issueId);
		
		ModelObjectTreeWalker walker = commentService.getCommentTreeWalker(Models.ISSUE.getObjectType(), issueToUse.getIssueId());

		int totalSize = walker.getChildCount(commentId);
		
		List<Comment> list = walker.children(commentId, new ObjectLoader<Comment>() {
			public Comment load(long commentId) throws NotFoundException {
				return commentService.getComment(commentId);
			}
		});
		return new ItemList(list, totalSize);
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
			BoardView v = getBoardView(board);
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
		BoardView b = getBoardView(board);
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
	public BoardMessage saveOrUpdate(@RequestBody DefaultBoardMessage newMessage, NativeWebRequest request) throws BoardThreadNotFoundException {

		User user = SecurityHelper.getUser();
		newMessage.setUser(user);
		log.debug("MESSAGE : " + newMessage.toString() );
		// NEW THREAD MESSAGE...	
		if ( newMessage.getThreadId() > 0) {
			BoardThread thread = boardService.getBoardThread(newMessage.getThreadId());
			if( newMessage.getMessageId() > 0 ) {
				// UPDATE MESSAGE...	
				boardService.updateMessage(newMessage);
			}else {
				// NEW MESSAGE...							
				boardService.addMessage(thread, thread.getRootMessage(), newMessage);				
			}		
		}else {
			if( newMessage.getMessageId() < 1 ) {
				// NEW MESSAGE...
				BoardMessage rootMessage = boardService.createMessage(newMessage.getObjectType(), newMessage.getObjectId(), user);
				rootMessage.setSubject(newMessage.getSubject());
				rootMessage.setBody(newMessage.getBody());
				BoardThread thread = boardService.createThread(rootMessage.getObjectType(), rootMessage.getObjectId(), rootMessage);
				boardService.addThread(rootMessage.getObjectType(), rootMessage.getObjectId(), thread);
				return thread.getRootMessage();				
			}
		}		
		return newMessage;
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
			BoardThread thread = boardService.createThread(rootMessage.getObjectType(), rootMessage.getObjectId(), rootMessage);
			boardService.addThread(rootMessage.getObjectType(), rootMessage.getObjectId(), thread);
			return thread.getRootMessage();
		}
		return newMessage;
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
