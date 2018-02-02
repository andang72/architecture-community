package architecture.community.web.spring.controller.data.v1;

import java.io.IOException;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.RowMapper;
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
import architecture.community.board.BoardMessageNotFoundException;
import architecture.community.board.BoardNotFoundException;
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
import architecture.community.projects.Stats;
import architecture.community.query.CustomQueryService;
import architecture.community.security.spring.acls.JdbcCommunityAclService;
import architecture.community.user.User;
import architecture.community.user.UserTemplate;
import architecture.community.util.SecurityHelper;
import architecture.community.web.model.ItemList;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.community.web.model.json.Result;
import architecture.ee.util.StringUtils;

@Controller("community-data-v1-issue-controller")
@RequestMapping("/data/api/v1")
public class IssueDataController extends AbstractCommunityDateController  {

	@Inject
	@Qualifier("projectService")
	private ProjectService projectService;
		
	@Inject
	@Qualifier("commentService")
	private CommentService commentService;
	
	@Inject
	@Qualifier("communityAclService")
	private JdbcCommunityAclService communityAclService;


	@Inject
	@Qualifier("attachmentService")
	private AttachmentService attachmentService;
	
	@Inject
	@Qualifier("codeSetService")
	private CodeSetService codeSetService;
	
	@Inject
	@Qualifier("customQueryService")
	private CustomQueryService customQueryService;
	
	public IssueDataController() {
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
		
		log.debug( "1.TILL_THIS_WEEK : {} > {}" , dataSourceRequest.getDataAsBoolean("TILL_THIS_WEEK", false), getThisSaturday());
		
		if( dataSourceRequest.getDataAsBoolean("TILL_THIS_WEEK", false) ) {
			dataSourceRequest.setData("TILL_THIS_WEEK", getThisSaturday());
		}else{
			dataSourceRequest.setData("TILL_THIS_WEEK", null);
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
	
	@Secured({ "ROLE_DEVELOPER" })
	@RequestMapping(value = "/issues/overviewstats/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getOverviewstats(
		@RequestBody DataSourceRequest dataSourceRequest,
		NativeWebRequest request) {
		ItemList items = new ItemList();
		List<CodeSet> issueTypes = codeSetService.getCodeSets(-1, -1L, "ISSUE_TYPE");		
		dataSourceRequest.setStatement("COMMUNITY_CUSTOM.SELECT_ISSUE_SUMMARY_BY_PERIOD");
		
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");		
		Date startDate = null;
		Date endDate = null;		
		try {
			startDate = simpleDateFormat.parse(dataSourceRequest.getDataAsString("startDate", null));
			endDate = simpleDateFormat.parse(dataSourceRequest.getDataAsString("endDate", null));
		} catch (ParseException e) {}
		
		List<IssueSummary> summaries = customQueryService.list (dataSourceRequest, new RowMapper<IssueSummary>() {
			public IssueSummary mapRow(ResultSet rs, int rowNum) throws SQLException {
				IssueSummary issue = new IssueSummary(rs.getLong("ISSUE_ID"));			
				issue.setProject( new Project( rs.getLong("PROJECT_ID") ) );
				issue.getProject().setName(rs.getString("PROJECT_NAME"));
				issue.setIssueType(rs.getString("ISSUE_TYPE"));
				issue.setStatus(rs.getString("ISSUE_STATUS"));
				issue.setResolution(rs.getString("ISSUE_RESOLUTION"));
				issue.setResolutionDate(rs.getDate("RESOLUTION_DATE"));
				issue.setSummary(rs.getString("ISSUE_SUMMARY"));
				issue.setPriority(rs.getString("ISSUE_PRIORITY"));			
				issue.setAssignee(new UserTemplate(rs.getLong("ASSIGNEE")));
				issue.setRepoter(new UserTemplate(rs.getLong("REPOTER")));			
				issue.setDueDate(rs.getDate("DUE_DATE"));			
				issue.setCreationDate(rs.getDate("CREATION_DATE"));
				issue.setModifiedDate(rs.getDate("MODIFIED_DATE"));		
				return issue;
		}});		
		Map<Long, OverviewStats > overviewStats = new HashMap<Long, OverviewStats>();
		dataSourceRequest.setStatement("COMMUNITY_CUSTOM.SELECT_ISSUE_REMAILS_BY_DATE");
		List<OverviewStats> map = customQueryService.list(dataSourceRequest, new RowMapper<OverviewStats>() { 
			public OverviewStats mapRow(ResultSet rs, int rowNum) throws SQLException {
				OverviewStats os = new OverviewStats( new Project( rs.getLong("PROJECT_ID") ) );
				os.getProject().setName(rs.getString("PROJECT_NAME"));
				os.setUnclosedTotalCount(rs.getInt("CNT"));
				return os;
		}});			
		for( OverviewStats overview : map ) {			
			for( CodeSet code : issueTypes ) {
				overview.stats.add(code.getCode(), 0);
			}
			overviewStats.put(overview.project.getProjectId(), overview);
		}			
		for( IssueSummary summary : summaries )
		{
			OverviewStats overview = overviewStats.get(summary.getProject().getProjectId());
			if( overview == null ) {
				overview = new OverviewStats ( summary.getProject() );
				for( CodeSet code : issueTypes ) {
					overview.stats.add(code.getCode(), 0);
				}
				overviewStats.put(overview.project.getProjectId(), overview);
			}			
			// issue count
			overview.issueCount = overview.issueCount + 1;						
			boolean isWithin = isWithinPeriod(summary, startDate, endDate);			
			if( isWithin )
				overview.withinPeriodIssueCount ++;			
			// issue type 
			if( org.apache.commons.lang3.StringUtils.isNotEmpty( summary.getIssueType() ) )
			{
				overview.stats.add(summary.getIssueType(), 1 );
			}			
			// issue resolution..
			if( org.apache.commons.lang3.StringUtils.equals( summary.getStatus() , "005" ) )
			{
				overview.resolutionCount = overview.resolutionCount + 1 ;
				// issue within period 				
				if( isWithin )
					overview.withinPeriodResolutionCount ++;
			}
		} 
		List<OverviewStats> list = new ArrayList<OverviewStats>(overviewStats.values());
		for( OverviewStats overview : list ){			
			for(Stats.Item item : overview.stats.getItems()) {
				overview.aggregate.put(item.getName(), item.getValue());
			}
		} 		
		items.setItems(list);
		items.setTotalCount(list.size());
		return items;
	}
	
	
	private boolean isWithinPeriod(IssueSummary summary, Date start, Date end ) {
		if( start == null || end == null )
			return false;
		
		Date dateToUse ;
		if( summary.getDueDate() == null ) {
			dateToUse = summary.getCreationDate();
		}else {
			dateToUse = summary.getDueDate();
		}
		if( dateToUse.compareTo(start) < 0 ) {
			return false;
		}else {
			return true;
		}
	}
	
	public static class OverviewStats {
		
		private Project project;
		
		int issueCount ;
		
		int resolutionCount ;
		
		int unclosedTotalCount;
		
		int withinPeriodIssueCount ;
		
		int withinPeriodResolutionCount;
		
		Map<String , Integer > aggregate ;
		
		Stats stats ;
		
		public OverviewStats(Project project) {
			this.project = project;
			aggregate = new HashMap<String , Integer >();
			stats = new Stats();
			unclosedTotalCount = 0 ;
			issueCount = 0 ;
			resolutionCount = 0;
		}

		public Project getProject() {
			return project;
		}

		public void setProject(Project project) {
			this.project = project;
		}

		public int getIssueCount() {
			return issueCount;
		}

		public void setIssueCount(int issueCount) {
			this.issueCount = issueCount;
		}

		public int getResolutionCount() {
			return resolutionCount;
		}

		public void setResolutionCount(int resolutionCount) {
			this.resolutionCount = resolutionCount;
		}

		public Map<String, Integer> getAggregate() {
			return aggregate;
		}

		public int getUnclosedTotalCount() {
			return unclosedTotalCount;
		}

		public void setUnclosedTotalCount(int unclosedTotalCount) {
			this.unclosedTotalCount = unclosedTotalCount;
		}

		public void setAggregate(Map<String, Integer> aggregate) {
			this.aggregate = aggregate;
		}

		public int getWithinPeriodIssueCount() {
			return withinPeriodIssueCount;
		}

		public void setWithinPeriodIssueCount(int withinPeriodIssueCount) {
			this.withinPeriodIssueCount = withinPeriodIssueCount;
		}

		public int getWithinPeriodResolutionCount() {
			return withinPeriodResolutionCount;
		}

		public void setWithinPeriodResolutionCount(int withinPeriodResolutionCount) {
			this.withinPeriodResolutionCount = withinPeriodResolutionCount;
		}
		
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
		
}
