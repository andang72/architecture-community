package architecture.community.web.spring.controller.data.admin.v1;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.announce.Announce;
import architecture.community.announce.AnnounceService;
import architecture.community.board.Board;
import architecture.community.board.BoardNotFoundException;
import architecture.community.board.BoardService;
import architecture.community.board.DefaultBoard;
import architecture.community.category.Category;
import architecture.community.category.CategoryNotFoundException;
import architecture.community.category.CategoryService;
import architecture.community.exception.NotFoundException;
import architecture.community.image.DefaultImage;
import architecture.community.image.Image;
import architecture.community.image.ImageLink;
import architecture.community.image.ImageService;
import architecture.community.model.Property;
import architecture.community.projects.Project;
import architecture.community.projects.ProjectService;
import architecture.community.projects.Scm;
import architecture.community.projects.ScmNotFoundException;
import architecture.community.projects.ScmService;
import architecture.community.projects.Task;
import architecture.community.projects.TaskNotFoundException;
import architecture.community.projects.TaskService;
import architecture.community.query.CustomQueryService;
import architecture.community.security.spring.acls.CommunityAclService;
import architecture.community.tag.ContentTag;
import architecture.community.tag.DefaultContentTag;
import architecture.community.tag.TagService;
import architecture.community.util.SecurityHelper;
import architecture.community.web.model.ItemList;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.community.web.model.json.Result;
import architecture.community.web.spring.controller.data.v1.AbstractCommunityDateController;
import architecture.ee.service.ConfigService;
import architecture.ee.util.StringUtils;

@Controller("data-api-v1-mgmt-community-controller")
@RequestMapping("/data/api/mgmt/v1")
public class CommunityMgmtDataController extends AbstractCommunityDateController {

	private Logger log = LoggerFactory.getLogger(getClass());

	@Inject
	@Qualifier("boardService")
	private BoardService boardService;

	@Inject
	@Qualifier("projectService")
	private ProjectService projectService;
	
	@Inject
	@Qualifier("taskService")
	private TaskService taskService;
	
	@Inject
	@Qualifier("scmService")
	private ScmService scmService;
	
	@Inject
	@Qualifier("communityAclService")
	private CommunityAclService communityAclService;

	
	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	@Inject
	@Qualifier("tagService")
	private TagService tagService;
	

	protected BoardService getBoardService() {
		return boardService;
	}

	@Inject
	@Qualifier("imageService")
	private ImageService imageService;
	
	@Inject
	@Qualifier("customQueryService")
	private CustomQueryService customQueryService;
	
	@Inject
	@Qualifier("announceService")
	private AnnounceService announceService;
	
	@Inject
	@Qualifier("categoryService")
	private CategoryService categoryService;
	
	protected CommunityAclService getCommunityAclService() {
		return communityAclService;
	}


	/**
	 * CATEGORY API 
	******************************************/
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/categories/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getCategories (@RequestBody DataSourceRequest dataSourceRequest, NativeWebRequest request) {

		dataSourceRequest.setStatement("COMMUNITY_CS.SELECT_CATEGORY_IDS_BY_REQUEST");
		List<Long> ids = customQueryService.list(dataSourceRequest, Long.class);
		List<Category> categories = new ArrayList<Category>(ids.size());
		for( Long categoryId : ids ) {
			try {
				categories.add(categoryService.getCategory(categoryId));
			} catch (CategoryNotFoundException e) {
				log.error(e.getMessage(), e);
			}
		}		
		return new ItemList(categories, categories.size());	
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/categories/save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public Category saveOrUpdate(@RequestBody Category category, NativeWebRequest request) throws CategoryNotFoundException {

		Category categoryToUse = category;

		if (category.getCategoryId() > 0) {
			
			categoryToUse = categoryService.getCategory(category.getCategoryId());
			
			if (!StringUtils.isNullOrEmpty(category.getName()))
				categoryToUse.setName(category.getName()); 
			if (!StringUtils.isNullOrEmpty(category.getDisplayName()))
				categoryToUse.setDisplayName(category.getDisplayName()); 
			if (!StringUtils.isNullOrEmpty(category.getDescription()))
				categoryToUse.setDescription(category.getDescription()); 
			Date modifiedDate = new Date();
			categoryToUse.setModifiedDate(modifiedDate);
			categoryService.saveOrUpdate(categoryToUse);
		} else {
			categoryService.saveOrUpdate(categoryToUse);
		}
		return categoryService.getCategory( categoryToUse.getCategoryId() );
	}	

	/**
	 * BOARD API 
	******************************************/
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/boards/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getBoardList(NativeWebRequest request) {

		List<Board> list = boardService.getAllBoards();
		List<Board> list2 = new ArrayList<Board>(list.size());
		for (Board board : list) {
			list2.add(getBoardView(communityAclService, boardService, board));
		}
		return new ItemList(list2, list2.size());
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/boards/save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public Board saveOrUpdate(@RequestBody DefaultBoard board, NativeWebRequest request) throws BoardNotFoundException {

		DefaultBoard boardToUse = board;

		if (board.getBoardId() > 0) {
			boardToUse = (DefaultBoard) boardService.getBoardById(board.getBoardId());
			if (!StringUtils.isNullOrEmpty(board.getName()))
				boardToUse.setName(board.getName());
			if (!StringUtils.isNullOrEmpty(board.getDisplayName()))
				boardToUse.setDisplayName(board.getDisplayName());
			if (!StringUtils.isNullOrEmpty(board.getDescription()))
				boardToUse.setDescription(board.getDescription());
			Date modifiedDate = new Date();
			boardToUse.setModifiedDate(modifiedDate);
			boardService.updateBoard(boardToUse);
		} else {
			// create...
			boardToUse = (DefaultBoard) boardService.createBoard(board.getName(), board.getDisplayName(),
					board.getDescription());
		}
		return boardService.getBoardById(boardToUse.getBoardId());
	}
	
	/**
	 * ANNOUNCE API 
	******************************************/	
	@Secured({ "ROLE_ADMINISTRATOR" , "ROLE_DEVELOPER"})
    @RequestMapping(value = "/announces/list.json", method = { RequestMethod.POST, RequestMethod.GET })
    @ResponseBody
	public ItemList getAnnounces(	
		@RequestBody DataSourceRequest dataSourceRequest,
		NativeWebRequest request) throws NotFoundException {
		
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
		
		dataSourceRequest.setStatement("COMMUNITY_CS.COUNT_ANNOUNCE_BY_REQUEST");
		int totalCount = customQueryService.queryForObject(dataSourceRequest, Integer.class);
		
		dataSourceRequest.setStatement("COMMUNITY_CS.SELECT_ANNOUNCE_IDS_BY_REQUEST");
		List<Long> items = customQueryService.list(dataSourceRequest, Long.class);
		
		List<Announce> announces = new ArrayList<Announce>(items.size());
		for( Long id : items ) {
			try {
				announces.add(announceService.getAnnounce(id));
			} catch (NotFoundException e) {
			}
		}
		
		return new ItemList(announces, totalCount );
	}	
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/announces/{announceId:[\\p{Digit}]+}/get.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Announce getAnnounce(
		@PathVariable Long announceId, 
		NativeWebRequest request) throws NotFoundException {
		
		return announceService.getAnnounce(announceId);
	}

	/**
	 * TASK API 
	******************************************/
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/tasks/list.json", method = { RequestMethod.POST })
	@ResponseBody
	public ItemList getTasks(
			@RequestBody DataSourceRequest dataSourceRequest,
			NativeWebRequest request) throws NotFoundException { 

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
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/tasks/save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public Task saveOrUpdate(@RequestBody Task task, NativeWebRequest request) throws NotFoundException { 
		
		Task taskToUse ;
		if (task.getTaskId() > 0) {
			taskToUse = taskService.getTask(task.getTaskId());
			if (!StringUtils.isNullOrEmpty(task.getTaskName()))
				taskToUse.setTaskName(task.getTaskName()); 
			if (!StringUtils.isNullOrEmpty(task.getDescription()))
				taskToUse.setDescription(task.getDescription()); 
			if (!StringUtils.isNullOrEmpty(task.getProgress()))			
				taskToUse.setProgress(task.getProgress()); 
			if (!StringUtils.isNullOrEmpty(task.getVersion()))			
				taskToUse.setVersion(task.getVersion()); 
			
			if ( task.getStartDate() != null )			
				taskToUse.setStartDate(task.getStartDate()); 
			if ( task.getEndDate() != null )			
				taskToUse.setEndDate(task.getEndDate()); 
			taskToUse.setPrice(task.getPrice()); 
			
			if( task.getUser() == null || task.getUser().isAnonymous() ) {
				taskToUse.setUser(SecurityHelper.getUser());
			}
			
			Date modifiedDate = new Date();
			taskToUse.setModifiedDate(modifiedDate);
			taskService.saveOrUpdateTask(taskToUse);
			
		} else {
			// create...
			taskToUse = new Task( task.getObjectType(), task.getObjectId());
			taskToUse.setTaskName(task.getTaskName());
			if (!StringUtils.isNullOrEmpty(task.getDescription()))
				taskToUse.setDescription(task.getDescription()); 
			if (!StringUtils.isNullOrEmpty(task.getProgress()))			
				taskToUse.setProgress(task.getProgress()); 
			if (!StringUtils.isNullOrEmpty(task.getVersion()))			
				taskToUse.setVersion(task.getVersion()); 
			
			if ( task.getStartDate() != null )			
				taskToUse.setStartDate(task.getStartDate()); 
			if ( task.getEndDate() != null )			
				taskToUse.setEndDate(task.getEndDate()); 
			taskToUse.setPrice(task.getPrice()); 
			
			taskService.saveOrUpdateTask(taskToUse);
		}		
		return taskToUse;
		
	}

	/**
	 * TAG API 
	******************************************/	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/tags/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getTags(@RequestBody DataSourceRequest dataSourceRequest, NativeWebRequest request) {
		dataSourceRequest.setStatement("COMMUNITY_UI.SELECT_CONTENT_TAGS");
		dataSourceRequest.setUser(SecurityHelper.getUser()); 
		List<DefaultContentTag> list = customQueryService.list(dataSourceRequest, new RowMapper<DefaultContentTag>() {
			public DefaultContentTag mapRow(ResultSet rs, int rowNum) throws SQLException {
				return new DefaultContentTag(rs.getLong(1), rs.getString(2), rs.getTimestamp(3));
			}
		}); 
		return new ItemList(list, list.size()); 
	}
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/tags/create.json", method = { RequestMethod.POST })
	@ResponseBody
	public ContentTag saveOrUpdate(@RequestBody DefaultContentTag tag, NativeWebRequest request) throws NotFoundException { 
		 
		if (tag.getTagId() > 0) { 
			return tag;
			
		} else {
			return tagService.createTag(tag.getName()); 
		} 
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/tags/object-list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getTagObjects(@RequestBody DataSourceRequest dataSourceRequest, NativeWebRequest request) {
		dataSourceRequest.setStatement("COMMUNITY_UI.SELECT_TAG_OBJECTS");
		dataSourceRequest.setUser(SecurityHelper.getUser());  
		List<TagObject> list = customQueryService.list(dataSourceRequest, new RowMapper<TagObject>() {
			public TagObject mapRow(ResultSet rs, int rowNum) throws SQLException {
				return new TagObject(rs.getInt(1), rs.getLong(2), rs.getLong(3));
			}
		}); 
		return new ItemList(list, list.size()); 
	}	
	
	
	public static class TagObject {
		
		private int objectType;
		
		private long objectId;
		
		private long tagId;
		
		private String key ;

		public TagObject(int objectType, long objectId, long tagId) {

			this.objectType = objectType;
			this.objectId = objectId;
			this.tagId = tagId;
		}

		public int getObjectType() {
			return objectType;
		}

		public void setObjectType(int objectType) {
			this.objectType = objectType;
		}

		public long getObjectId() {
			return objectId;
		}

		public void setObjectId(long objectId) {
			this.objectId = objectId;
		}

		public long getTagId() {
			return tagId;
		}

		public void setTagId(long tagId) {
			this.tagId = tagId;
		}

		public String getKey() {
			return tagId + "_" + objectType + "_" + objectId ;
		}

		public void setKey(String key) {
			
		} 
		
	}
	
	/**
	 * SCM API 
	******************************************/
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/scm/list.json", method = { RequestMethod.POST })
	@ResponseBody
	public ItemList getScms(
			@RequestBody DataSourceRequest dataSourceRequest,
			NativeWebRequest request) throws NotFoundException { 

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
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/scm/save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public Scm saveOrUpdate(@RequestBody Scm scm, NativeWebRequest request) throws NotFoundException { 
		
		Scm scmToUse ;
		if (scm.getScmId() > 0) {
			scmToUse = scmService.getScmById(scm.getScmId());
			if (!StringUtils.isNullOrEmpty(scm.getName()))
				scmToUse.setName(scm.getName()); 
			if (!StringUtils.isNullOrEmpty(scm.getDescription()))
				scmToUse.setDescription(scm.getDescription()); 
			if (!StringUtils.isNullOrEmpty(scm.getUrl()))			
				scmToUse.setUrl(scm.getUrl()); 
			if (!StringUtils.isNullOrEmpty(scm.getUsername()))			
				scmToUse.setUsername(scm.getUsername()); 
			if (!StringUtils.isNullOrEmpty(scm.getPassword()))			
				scmToUse.setPassword(scm.getPassword()); 
			Date modifiedDate = new Date();
			scmToUse.setModifiedDate(modifiedDate); 
			scmToUse.setProperties(scm.getProperties());
			scmService.saveOrUpdateScm(scmToUse); 
		} else {
			// create...
			scmToUse = new Scm( scm.getObjectType(), scm.getObjectId());
			scmToUse.setName(scm.getName());
			if (!StringUtils.isNullOrEmpty(scm.getDescription()))
				scmToUse.setDescription(scm.getDescription()); 
			if (!StringUtils.isNullOrEmpty(scm.getUrl()))			
				scmToUse.setUrl(scm.getUrl()); 
			if (!StringUtils.isNullOrEmpty(scm.getUsername()))			
				scmToUse.setUsername(scm.getUsername()); 
			if (!StringUtils.isNullOrEmpty(scm.getPassword()))			
				scmToUse.setPassword(scm.getPassword()); 
			scmToUse.setProperties(scm.getProperties());
			scmService.saveOrUpdateScm(scmToUse);
		}		
		return scmToUse; 
	}
	
	
	/**
	 * PROJECT API 
	******************************************/ 
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/projects/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getProjects(@RequestBody DataSourceRequest dataSourceRequest, NativeWebRequest request) {

		dataSourceRequest.setStatement("COMMUNITY_WEB.COUNT_PROJECT_IDS");
		int totalCount = customQueryService.queryForObject(dataSourceRequest, Integer.class);
		
		dataSourceRequest.setStatement("COMMUNITY_WEB.SELECT_PROJECT_IDS");
		List<Long> items = customQueryService.list(dataSourceRequest, Long.class);
		
		List<Project> projects = new ArrayList<Project>(items.size());
		for( Long projectId : items ) {
			try {
				projects.add(projectService.getProject(projectId));
			} catch (NotFoundException e) {
			}
		}
		return new ItemList(projects, totalCount); 
	}
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/projects/{projectId:[\\p{Digit}]+}/get.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Project getProject(
		@PathVariable Long projectId, 
		NativeWebRequest request) throws NotFoundException {
		
		return projectService.getProject(projectId);
	}
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/projects/save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public Project saveOrUpdate(@RequestBody Project project, NativeWebRequest request) throws NotFoundException {

		Project boardToUse = new Project();
		if (project.getProjectId() > 0) {
			boardToUse = projectService.getProject(project.getProjectId());
			if (!StringUtils.isNullOrEmpty(project.getName()))
				boardToUse.setName(project.getName());
			if (!StringUtils.isNullOrEmpty(project.getSummary()))
				boardToUse.setSummary(project.getSummary());
			if (!StringUtils.isNullOrEmpty(project.getContractState()))			
				boardToUse.setContractState(project.getContractState());
			
			if (!StringUtils.isNullOrEmpty(project.getContractor()))			
				boardToUse.setContractor(project.getContractor());
			
			boardToUse.setMaintenanceCost(project.getMaintenanceCost());
			boardToUse.setEnabled( project.isEnabled());
			
			if( project.getStartDate()!= null)
				boardToUse.setStartDate(project.getStartDate());
			if( project.getEndDate()!= null)
				boardToUse.setEndDate(project.getEndDate());
			Date modifiedDate = new Date();
			boardToUse.setModifiedDate(modifiedDate);
			projectService.saveOrUpdateProject(boardToUse);
			
		} else {
			// create...
			boardToUse = new Project();
			boardToUse.setName(project.getName());
			boardToUse.setSummary(project.getSummary());
			if (!StringUtils.isNullOrEmpty(project.getContractor()))			
				boardToUse.setContractor(project.getContractor());
			
			if (!StringUtils.isNullOrEmpty(project.getContractState()))			
				boardToUse.setContractState(project.getContractState());
			if( project.getStartDate()!= null)
				boardToUse.setStartDate(project.getStartDate());
			if( project.getEndDate()!= null)
				boardToUse.setEndDate(project.getEndDate());
			boardToUse.setMaintenanceCost(project.getMaintenanceCost());
			boardToUse.setEnabled( project.isEnabled());
			projectService.saveOrUpdateProject(boardToUse);
		}		
		return boardToUse;
		
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/projects/{projectId:[\\p{Digit}]+}/properties/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Property> getProjectProperties (
		@PathVariable Long projectId, 
		NativeWebRequest request) throws NotFoundException {
		Project project = 	projectService.getProject(projectId);
		Map<String, String> properties = project.getProperties(); 
		return toList(properties);
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/projects/{projectId:[\\p{Digit}]+}/properties/update.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Property> updateProjectProperties (
		@PathVariable Long projectId, 
		@RequestBody List<Property> newProperties,
		NativeWebRequest request) throws NotFoundException {
		Project project = 	projectService.getProject(projectId);
		Map<String, String> properties = project.getProperties();   
		// update or create
		for (Property property : newProperties) {
		    properties.put(property.getName(), property.getValue().toString());
		} 
		projectService.saveOrUpdateProject(project, properties); 
		return toList(project.getProperties());
	}
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/projects/{projectId:[\\p{Digit}]+}/properties/delete.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Property> deleteProjectProperties (
		@PathVariable Long projectId, 
		@RequestBody List<Property> newProperties,
		NativeWebRequest request) throws NotFoundException {
		Project project = 	projectService.getProject(projectId);
		Map<String, String> properties = project.getProperties();  
		for (Property property : newProperties) {
		    properties.remove(property.getName());
		}
		projectService.saveOrUpdateProject(project, properties); 
		return toList(project.getProperties());
	}
		
	/**
	 * IMAGES API 
	******************************************/
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/images/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getImages(
		@RequestBody DataSourceRequest dataSourceRequest, 
		NativeWebRequest request) {
		
		if( !dataSourceRequest.getData().containsKey("objectType")) {
			dataSourceRequest.getData().put("objectType", -1);
		}	
		if( !dataSourceRequest.getData().containsKey("objectId") ) {
			dataSourceRequest.getData().put("objectId", -1);
		}
		
		dataSourceRequest.setStatement("COMMUNITY_CS.COUNT_IMAGE_BY_REQUEST");
		int totalCount = customQueryService.queryForObject(dataSourceRequest, Integer.class);
		dataSourceRequest.setStatement("COMMUNITY_CS.SELECT_IMAGE_IDS_BY_REQUEST");
		List<Long> items = customQueryService.list(dataSourceRequest, Long.class);
		List<Image> images = new ArrayList<Image>(totalCount);
		for( Long id : items ) {
			try {
				images.add(imageService.getImage(id));
			} catch (NotFoundException e) {
			}
		}
		return new ItemList(images, totalCount );
	}	
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/images/save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public Image saveOrUpdate(@RequestBody DefaultImage image, NativeWebRequest request) throws NotFoundException {
		
		DefaultImage imageToUse = 	(DefaultImage)imageService.getImage(image.getImageId());
		if( !StringUtils.isNullOrEmpty(image.getName()) )
		{
			imageToUse.setName(image.getName());
		}
		if( imageToUse.getObjectType() != image.getObjectType())
		{
			imageToUse.setObjectType(image.getObjectType());
		}
		if( imageToUse.getObjectId() != image.getObjectId())
		{
			imageToUse.setObjectId(image.getObjectId());
		}
		imageService.saveOrUpdate(imageToUse); 
		return imageToUse;
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/imagebrowser/{objectType:[\\p{Digit}]+}/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getImagesByObjectType(
		@RequestBody DataSourceRequest dataSourceRequest, 	
		@PathVariable Integer objectType,
		NativeWebRequest request) {
		dataSourceRequest.setData("objectType", objectType);
		
		dataSourceRequest.setStatement("COMMUNITY_CS.SELECT_IMAGE_IDS_BY_OBJECT_TYPE_AND_OBJECT_ID");
		List<Long> items = customQueryService.list(dataSourceRequest, Long.class);
		List<Image> images = new ArrayList<Image>(items.size());
		for( Long id : items ) {
			try {
				images.add(imageService.getImage(id));
			} catch (NotFoundException e) {
			}
		}
		return new ItemList(images, images.size() );
	}
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/imagebrowser/{objectType:[\\p{Digit}]+}/{objectId:[\\p{Digit}]+}/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getImagesByObjectTypeAndObjectId(
		@PathVariable Integer objectType,
		@PathVariable Long objectId,
		@RequestBody DataSourceRequest dataSourceRequest,
		NativeWebRequest request) {
		
		dataSourceRequest.setData("objectType", objectType);
		dataSourceRequest.setData("objectId", objectId);
		
		dataSourceRequest.setStatement("COMMUNITY_CS.SELECT_IMAGE_IDS_BY_OBJECT_TYPE_AND_OBJECT_ID");
		List<Long> items = customQueryService.list(dataSourceRequest, Long.class);
		List<Image> images = new ArrayList<Image>(items.size());
		for( Long id : items ) {
			try {
				images.add(imageService.getImage(id));
			} catch (NotFoundException e) {
			}
		}
		return new ItemList(images, images.size() );
		
	}	
	
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/images/{imageId:[\\p{Digit}]+}/delete.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result removeImageAndLink (
		@PathVariable Long imageId,
		@RequestBody DataSourceRequest dataSourceRequest, 
		NativeWebRequest request) throws NotFoundException {
		
		Image image = 	imageService.getImage(imageId);
		imageService.deleteImage(image);
		
		return Result.newResult();
	}	
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/images/{imageId:[\\p{Digit}]+}/get.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Image getImage (
		@PathVariable Long imageId, 
		NativeWebRequest request) throws NotFoundException {
		Image image = 	imageService.getImage(imageId);
		return image;
	}
	
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/images/{imageId:[\\p{Digit}]+}/link.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ImageLink getImageLinkAndCreateIfNotExist (
		@PathVariable Long imageId,
		@RequestParam(value = "create", defaultValue = "false", required = false) Boolean createIfNotExist,
		NativeWebRequest request) throws NotFoundException {
		
		Image image = 	imageService.getImage(imageId);
		return imageService.getImageLink(image, createIfNotExist);
	}	
	
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/images/{imageId:[\\p{Digit}]+}/properties/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Property> getImageProperties (
		@PathVariable Long imageId, 
		NativeWebRequest request) throws NotFoundException {
		Image image = 	imageService.getImage(imageId);
		Map<String, String> properties = image.getProperties(); 
		return toList(properties);
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/images/{imageId:[\\p{Digit}]+}/properties/update.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Property> updateImageProperties (
		@PathVariable Long imageId, 
		@RequestBody List<Property> newProperties,
		NativeWebRequest request) throws NotFoundException {
		Image image = 	imageService.getImage(imageId);
		Map<String, String> properties = image.getProperties();   
		// update or create
		for (Property property : newProperties) {
		    properties.put(property.getName(), property.getValue().toString());
		} 
		imageService.saveOrUpdate(image); 
		return toList(image.getProperties());
	}
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/images/{imageId:[\\p{Digit}]+}/properties/delete.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Property> deleteImageProperties (
		@PathVariable Long imageId, 
		@RequestBody List<Property> newProperties,
		NativeWebRequest request) throws NotFoundException {
		Image image = 	imageService.getImage(imageId);
		Map<String, String> properties = image.getProperties();  
		for (Property property : newProperties) {
		    properties.remove(property.getName());
		}
		imageService.saveOrUpdate(image);
		return toList(image.getProperties());
	}
	
	protected List<Property> toList(Map<String, String> properties) {
		List<Property> list = new ArrayList<Property>();
		for (String key : properties.keySet()) {
		    String value = properties.get(key);
		    list.add(new Property(key, value));
		}
		return list;
	} 
}
