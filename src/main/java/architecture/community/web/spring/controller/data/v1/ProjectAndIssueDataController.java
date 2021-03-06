package architecture.community.web.spring.controller.data.v1;

import java.io.IOException;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
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
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameterValue;
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

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

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
import architecture.community.image.Image;
import architecture.community.image.ImageService;
import architecture.community.image.ThumbnailImage;
import architecture.community.model.ModelObjectTreeWalker;
import architecture.community.model.ModelObjectTreeWalker.ObjectLoader;
import architecture.community.model.Models;
import architecture.community.model.json.JsonDateDeserializer;
import architecture.community.projects.DefaultIssue;
import architecture.community.projects.Issue;
import architecture.community.projects.IssueNotFoundException;
import architecture.community.projects.IssueSummary;
import architecture.community.projects.Project;
import architecture.community.projects.ProjectNotFoundException;
import architecture.community.projects.ProjectService;
import architecture.community.projects.ProjectView;
import architecture.community.projects.Scm;
import architecture.community.projects.ScmNotFoundException;
import architecture.community.projects.ScmService;
import architecture.community.projects.Stats;
import architecture.community.projects.Task;
import architecture.community.projects.TaskNotFoundException;
import architecture.community.projects.TaskService;
import architecture.community.query.CustomQueryService;
import architecture.community.query.CustomQueryService.DaoCallback;
import architecture.community.query.dao.CustomQueryJdbcDao;
import architecture.community.security.spring.acls.CommunityAclService;
import architecture.community.security.spring.acls.JdbcCommunityAclService.PermissionsBundle;
import architecture.community.user.User;
import architecture.community.user.UserTemplate;
import architecture.community.util.SecurityHelper;
import architecture.community.web.model.ItemList;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.community.web.model.json.Result;
import architecture.ee.util.NumberUtils;
import architecture.ee.util.StringUtils;

/**
 * Project & Issue Data Controller 
 * 
 * 
 * 
 * @author donghyuck
 *
 */
@Controller("community-data-v1-issues-controller")
@RequestMapping("/data/api/v1")
public class ProjectAndIssueDataController extends AbstractCommunityDateController  {

	@Inject
	@Qualifier("projectService")
	private ProjectService projectService;
	
	@Inject
	@Qualifier("scmService")
	private ScmService scmService;
	
	@Inject
	@Qualifier("taskService")
	private TaskService taskService;
		
	@Inject
	@Qualifier("commentService")
	private CommentService commentService;
	
	@Inject
	@Qualifier("communityAclService")
	private CommunityAclService communityAclService;

	@Inject
	@Qualifier("imageService")
	private ImageService imageService;
	
	@Inject
	@Qualifier("attachmentService")
	private AttachmentService attachmentService;
	
	@Inject
	@Qualifier("codeSetService")
	private CodeSetService codeSetService;
	
	@Inject
	@Qualifier("customQueryService")
	private CustomQueryService customQueryService;
	
	public ProjectAndIssueDataController() {
		
	}

	/**
	 * TASK API 
	******************************************/
	
	@Secured({ "ROLE_USER" })
	@RequestMapping(value = "/projects/{projectId:[\\p{Digit}]+}/scms/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getScms (		
			@PathVariable Long projectId, 
			@RequestBody DataSourceRequest dataSourceRequest, 
			NativeWebRequest request) {		
		
		dataSourceRequest.setData("objectType", Models.PROJECT.getObjectType());
		dataSourceRequest.setData("objectId", projectId);		
		dataSourceRequest.setStatement("SERVICE_DESK.SELECT_SCM_IDS");
		List<Long> ids = customQueryService.list(dataSourceRequest, Long.class);
		List<Scm> list = new ArrayList<Scm> ();
		for( Long scmId : ids)
		{	 
			try {
				Scm scm = scmService.getScmById(scmId);
				list.add(scm);
			} catch (ScmNotFoundException e) {
			} 
		}
		return new ItemList(list, list.size()); 
	}
	
	/**
	 * TASK API 
	******************************************/
	
	@Secured({ "ROLE_USER" })
	@RequestMapping(value = "/projects/{projectId:[\\p{Digit}]+}/tasks/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getTasks (		
			@PathVariable Long projectId, 
			@RequestBody DataSourceRequest dataSourceRequest, 
			NativeWebRequest request) {		
		
		dataSourceRequest.setData("objectType", Models.PROJECT.getObjectType());
		dataSourceRequest.setData("objectId", projectId);		
		//dataSourceRequest.setStatement("COMMUNITY_CS.COUNT_TASK_IDS");
		//int total = customQueryService.queryForObject(dataSourceRequest, Integer.class);
		dataSourceRequest.setStatement("COMMUNITY_WEB.SELECT_TASK_IDS");
		List<Long> ids = customQueryService.list(dataSourceRequest, Long.class);
		List<Task> list = new ArrayList<Task> ();
		for( Long taskId : ids)
		{	 
			try {
				Task task = taskService.getTask(taskId);
				list.add(task);
			} catch (TaskNotFoundException e) {
			} 
		}
		return new ItemList(list, list.size()); 
	}	
	
	
	/**
	 * PROJECT & ISSUE API 
	******************************************/
	@RequestMapping(value = "/projects/list_v2.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getProjecs (@RequestBody DataSourceRequest dataSourceRequest, NativeWebRequest request) {		
		
		dataSourceRequest.setStatement("COMMUNITY_CS.SELECT_PROJECT_IDS_BY_REQUEST");
		List<Long> ids = customQueryService.list(dataSourceRequest, Long.class);
		List<Project> list = new ArrayList<Project> ();
		for( Long projectId : ids)
		{	 
			try {
				PermissionsBundle bundle = communityAclService.getPermissionBundle(SecurityHelper.getAuthentication(), Project.class, projectId );	
				if( bundle.isAdmin() || bundle.isWrite() || bundle.isRead() || bundle.isCreate() )
				{
					Project project = projectService.getProject(projectId);
					list.add(project);
				}
			} catch (ProjectNotFoundException e) {
			} 
		}
		return new ItemList(list, list.size()); 
	}
	
	
	@RequestMapping(value = "/projects/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getProjects (@RequestBody DataSourceRequest dataSourceRequest, NativeWebRequest request) {			
		
		dataSourceRequest.setStatement("COMMUNITY_CS.SELECT_PROJECT_IDS_BY_REQUEST");
		List<Long> ids = customQueryService.list(dataSourceRequest, Long.class);
		List<ProjectView> list = new ArrayList<ProjectView> ();
		for( Long projectId : ids)
		{	
			Project project;
			try {
				project = projectService.getProject(projectId);
				ProjectView v = getProjectView(communityAclService, project);
				if( v.isReadable() )
				{
					v.setIssueTypeStats(projectService.getIssueTypeStats(project));
					v.setResolutionStats(projectService.getIssueResolutionStats(project));
					list.add(v);
				}
			} catch (ProjectNotFoundException e) {
			} 
		}
		return new ItemList(list, list.size());
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
		//v.setIssueTypeStats(projectService.getIssueTypeStats(project));
		//v.setResolutionStats(projectService.getIssueResolutionStats(project));
		return v;
	}
	 
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = { "/issues/{issueId:[\\p{Digit}]+}/delete.json" }, method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public Result removeIssue (@PathVariable Long issueId, NativeWebRequest request) throws NotFoundException {	
		User user = SecurityHelper.getUser(); 
		Issue issue = projectService.getIssue(issueId);
		projectService.deleteIssue(issue); 
		return Result.newResult();
	}
	
	
	@Secured({ "ROLE_USER" })
	@RequestMapping(value = "/issues/save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public Issue saveOrUpdateIssue(@RequestBody DefaultIssue newIssue, NativeWebRequest request) throws NotFoundException {

		User user = SecurityHelper.getUser();
		String statusCodeToUse = newIssue.getStatus() ;
		boolean isNew = true;
		boolean descriptionUpdate = false;
		final Issue issueToUse ;	
		if ( newIssue.getIssueId() > 0) {
			isNew = false;
			issueToUse = projectService.getIssue(newIssue.getIssueId());		
			if( !org.apache.commons.lang3.StringUtils.equals(newIssue.getDescription(), issueToUse.getDescription())  ) { 
				descriptionUpdate = true; 
			}
			if( newIssue.getTask() != null && newIssue.getTask().getTaskId() > 0 && newIssue.getTask().getTaskId() != issueToUse.getTask().getTaskId()) {
				issueToUse.setTask( newIssue.getTask() );
			} 
		}else {
			issueToUse = projectService.createIssue(newIssue.getObjectType(), newIssue.getObjectId(), user );
			if( StringUtils.isNullOrEmpty(newIssue.getStatus()))
				statusCodeToUse = "001";		
			if(newIssue.getTask() != null && newIssue.getTask().getTaskId() > 0) {
				issueToUse.setTask(newIssue.getTask());
			}
				
			descriptionUpdate = true;
		}
		if( !StringUtils.isNullOrEmpty(newIssue.getResolution()))
		{
			if( newIssue.getResolutionDate() == null ) {
				newIssue.setResolutionDate(new Date());
			}	
			if(!org.apache.commons.lang3.StringUtils.equals(issueToUse.getStatus(), "005")) {
				statusCodeToUse = "005";
			}
		}
		
		// REOPEN CLOSED ISSUE.
		if( !StringUtils.isNullOrEmpty(newIssue.getStatus()) && !org.apache.commons.lang3.StringUtils.equals(newIssue.getStatus(), "005") ) {
			if( org.apache.commons.lang3.StringUtils.equals(issueToUse.getStatus(), "005") && 
				!StringUtils.isNullOrEmpty( issueToUse.getResolution() )	) {
				newIssue.setResolution(null);
				issueToUse.setResolutionDate(null);
			}
		}
		
		if( newIssue.getResolutionDate() != null && newIssue.getResolutionDate() != issueToUse.getResolutionDate() ) {
			issueToUse.setResolutionDate(newIssue.getResolutionDate());
		}
		
		if( newIssue.getAssignee() != null && newIssue.getAssignee().getUserId() > 0	) {			
			if( issueToUse.getAssignee() != null && issueToUse.getAssignee().getUserId() != newIssue.getAssignee().getUserId() ) {
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

		if( newIssue.getStartDate() != null && newIssue.getStartDate() != issueToUse.getStartDate() ) {
			issueToUse.setStartDate(newIssue.getStartDate());
		} 
		
		if( newIssue.getDueDate() != null && newIssue.getDueDate() != issueToUse.getDueDate() ) {
			issueToUse.setDueDate(newIssue.getDueDate());
		} 
		
		
		issueToUse.setStatus(statusCodeToUse);
		issueToUse.setComponent(newIssue.getComponent());
		issueToUse.setSummary(newIssue.getSummary());
		issueToUse.setDescription(newIssue.getDescription());
		issueToUse.setIssueType(newIssue.getIssueType());
		issueToUse.setStatus(newIssue.getStatus());
		issueToUse.setResolution(newIssue.getResolution());		
		issueToUse.setPriority(newIssue.getPriority());	
		issueToUse.setOriginalEstimate(newIssue.getOriginalEstimate());
		issueToUse.setEstimate(newIssue.getEstimate());
		issueToUse.setTimeSpent(newIssue.getTimeSpent());
		issueToUse.setRequestorName(newIssue.getRequestorName());
		
		projectService.saveOrUpdateIssue(issueToUse);
		
		if(descriptionUpdate) {		
			customQueryService.execute(new DaoCallback<Integer>() {
				public Integer process(CustomQueryJdbcDao dao) throws DataAccessException {
					Document doc = Jsoup.parse(issueToUse.getDescription());
					Elements eles = doc.select("img");
					for( Element ele : eles ) {
						log.debug("found img tag in content : {} ", ele.toString());
						if( ele.hasAttr("data-external-id") ) {					
							String link = ele.attr("data-external-id");
							log.debug("it has external link : {}.", link);
							try {
								Image image = imageService.getImageByImageLink(link);
								if( image.getObjectType() <= 0 && image.getObjectId() <= 0 ) {									
									dao.getExtendedJdbcTemplate().update(dao.getBoundSql("COMMUNITY_CS.UPDATE_IMAGE_OBJECT_TYPE_AND_OBJECT_ID").getSql(), 
										new SqlParameterValue(Types.NUMERIC, Models.ISSUE.getObjectType()),
										new SqlParameterValue(Types.NUMERIC, issueToUse.getIssueId()),
										new SqlParameterValue(Types.NUMERIC, image.getImageId())
									);
									imageService.invalidate(image, false);
								}
							} catch (Exception e) {
							}
						}
					}
					return null;
				}
				
			}); 
		} 
		return issueToUse;
	}	 
	

	
	@Secured({ "ROLE_USER" })
	@RequestMapping(value = "/issues/batch-save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public Result saveOrUpdateIssue(@RequestBody BatchUpdateIssues batchUpdateIssues, NativeWebRequest request) throws NotFoundException {
		Result result = new Result();
		
		List<DefaultIssue> issues = batchUpdateIssues.issues;
		String status = batchUpdateIssues.status;
		String resolution = batchUpdateIssues.resolution;
		Date resolutionDate = batchUpdateIssues.resolutionDate;
		
		if(StringUtils.isNullOrEmpty(status))
			throw new IllegalArgumentException("status can not be null.");
		
		boolean hasResolutioin = false;
		if( !StringUtils.isNullOrEmpty(resolution)) {
			hasResolutioin = true; 
			if(resolutionDate == null )
				resolutionDate = new Date();
			if(!org.apache.commons.lang3.StringUtils.equals(status, "005")) {
				status = "005";
			}
		}
		
		List<Issue> updates = new ArrayList<Issue>(issues.size());
		for ( Issue issue : issues )
		{
			if( hasResolutioin ) {
				issue.setResolution(resolution);
				issue.setResolutionDate(resolutionDate);
			}
			issue.setStatus(status);
			updates.add(issue);
		}
		projectService.saveOrUpdateIssues( updates );
		return result;
	}	
	

	public static class BatchUpdateIssues {
		
		private List<DefaultIssue> issues;
		
		private String status ;
		
		private String resolution ;
		
		private Date resolutionDate ;

		public List<DefaultIssue> getIssues() {
			return issues;
		}

		public void setIssues(List<DefaultIssue> issues) {
			this.issues = issues;
		}

		public String getStatus() {
			return status;
		}

		public void setStatus(String status) {
			this.status = status;
		}

		public String getResolution() {
			return resolution;
		}

		public void setResolution(String resolution) {
			this.resolution = resolution;
		}

		public Date getResolutionDate() {
			return resolutionDate;
		}

		@JsonDeserialize(using = JsonDateDeserializer.class)
		public void setResolutionDate(Date resolutionDate) {
			this.resolutionDate = resolutionDate;
		}
		
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
	@RequestMapping(value = "/issues/overviewstats/monthly/stats/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getYearIssueOverviewstats(
		@RequestBody DataSourceRequest dataSourceRequest,
		NativeWebRequest request) {
		ItemList items = new ItemList();
		
		final List<CodeSet> issueTypes = codeSetService.getCodeSets(-1, -1L, "ISSUE_TYPE");
		final Map<String , MonthIssueCount> monthlyIssueCounts = new HashMap<String , MonthIssueCount>();
		for ( int month = 0 ; month < Calendar.getInstance().get(Calendar.MONTH) + 1 ; month ++ )
		{
			MonthIssueCount m = createMonthIssueCount(String.format("%02d", month + 1 ), issueTypes);
			monthlyIssueCounts.put(m.month, m);
		}
		
		log.debug("monthly index : {}", monthlyIssueCounts.keySet());
	
		dataSourceRequest.setStatement("COMMUNITY_CUSTOM.SELECT_ISSUE_STATS_BY_YEAR");
		customQueryService.query(dataSourceRequest, new RowCallbackHandler() {
			public void processRow(ResultSet rs) throws SQLException {
				log.debug("extract database row {} ...." , rs.getRow() ); 
					String type = rs.getString(1);   // ISSUE TYPE
					String status = rs.getString(2); // ISSUE STATUS
					String month1 = rs.getString(3); // DEU DATE
					String month2 = rs.getString(4); // CREATION DATE
					String month3 = rs.getString(5); // RESOLUTION DATE 
					String monthToUse = month2 ;
					if( !StringUtils.isEmpty( month1 ) ) {
						monthToUse = month1;
					} 
					log.debug("holder {} , exist: {}, type:{}, DEU:{}, CREATION:{}, RESOLUTION:{}", monthToUse , monthlyIssueCounts.containsKey(monthToUse), type, month1, month2, month3 ); 
					MonthIssueCount issueCountToUse = monthlyIssueCounts.get(monthToUse);
					if( issueCountToUse == null ) {
						issueCountToUse = createMonthIssueCount(monthToUse, issueTypes);
					} 
					issueCountToUse.aggregate.put(type, issueCountToUse.aggregate.get(type) + 1);					
					if( !StringUtils.isEmpty(month3)) {
						int closedCount = issueCountToUse.aggregate.get("000");
						issueCountToUse.aggregate.put("000", closedCount + 1);
					}
					monthlyIssueCounts.put(monthToUse, issueCountToUse);
			}});
		
		List<MonthIssueCount> list = new ArrayList<MonthIssueCount>(monthlyIssueCounts.values());
		Collections.sort(list, new Comparator<MonthIssueCount>() { 
			public int compare(MonthIssueCount o1, MonthIssueCount o2) { 
				int o1n = NumberUtils.toInt(o1.month, 0);
				int o2n = NumberUtils.toInt(o2.month, 0);
				if( o1n > o2n )
					return 1 ;
				else if ( o1n < o2n )
					return -1 ;
				return 0;
			}});
		items.setTotalCount(list.size());
		items.setItems(list);
		return items;
	}
	
	private MonthIssueCount createMonthIssueCount(String month , List<CodeSet> issueTypes ) {
		MonthIssueCount m = new MonthIssueCount(month);
		for( CodeSet code : issueTypes ) {
			
			m.aggregate.put(code.getCode(), 0);
		}	
		m.aggregate.put("000", 0);
		return m;
	}
	
	public static class MonthIssueCount {
		
		String month ;
		
		Map<String , Integer > aggregate ;
		
		public MonthIssueCount(String month) {
			this.month = month;
			aggregate = new HashMap<String , Integer >();
		}
		
		public String getMonth() {
			return month;
		}

		public void setMonth(String month) {
			this.month = month;
		}

		public Map<String, Integer> getAggregate() {
			return aggregate;
		}

		public void setAggregate(Map<String, Integer> aggregate) {
			this.aggregate = aggregate;
		}

	}
	
	
	/**
	 * 기간별 이슈 통계
	 *  
	 * @param dataSourceRequest
	 * @param request
	 * @return
	 */
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
		
		log.debug("data : {}", dataSourceRequest.getData());
 
		
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
		for( IssueSummary summary : summaries ) {
			Project project = summary.getProject();
			log.debug("summary for projcect : {} , issue : {}", summary.getProject().getProjectId(), summary.getIssueId());
			if( overviewStats.get( project.getProjectId() ) == null ) {
				OverviewStats overview = new OverviewStats( project );
				for( CodeSet code : issueTypes ) {
					overview.stats.add(code.getCode(), 0);
				}
				overviewStats.put( project.getProjectId(), overview );
				log.debug("create new stats overview for project : {}", project.getProjectId() );
			}
		}
		
		log.debug("overviews : {}", overviewStats.values());
		
		
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
 
		public String toString() {
			StringBuilder builder = new StringBuilder();
			builder.append("OverviewStats [");
			if (project != null)
				builder.append("project=").append(project.getProjectId());
			builder.append("]");
			return builder.toString();
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
