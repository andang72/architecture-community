package architecture.community.web.spring.controller.data.v1;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.board.Board;
import architecture.community.board.BoardNotFoundException;
import architecture.community.board.BoardService;
import architecture.community.board.DefaultBoard;
import architecture.community.codeset.CodeSet;
import architecture.community.codeset.CodeSetNotFoundException;
import architecture.community.codeset.CodeSetService;
import architecture.community.exception.NotFoundException;
import architecture.community.model.Property;
import architecture.community.projects.Project;
import architecture.community.projects.ProjectService;
import architecture.community.security.spring.acls.JdbcCommunityAclService;
import architecture.community.web.model.ItemList;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.ee.service.ConfigService;
import architecture.ee.util.StringUtils;

@Controller("community-data-v1-mgmt-core-controller")
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
	@Qualifier("communityAclService")
	private JdbcCommunityAclService communityAclService;
	
	@Inject
	@Qualifier("codeSetService")
	private CodeSetService codeSetService;
	
	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	

	protected BoardService getBoardService() {
		return boardService;
	}

	protected JdbcCommunityAclService getCommunityAclService() {
		return communityAclService;
	}

	/**
	 * CONFIG API 
	******************************************/
	
	private List<Property> getApplicationProperties(){
		List<String> propertyKeys = configService.getApplicationPropertyNames();
		List<Property> list = new ArrayList<Property>(); 
		for( String key : propertyKeys ) {
			String value = configService.getApplicationProperty(key);
			list.add(new Property( key, value ));
		}
		return list ;
	}
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/properties/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Property> getConfig(@RequestBody DataSourceRequest dataSourceRequest, NativeWebRequest request){ 
		return getApplicationProperties() ;
	}
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/properties/update.json", method = RequestMethod.POST)
	@ResponseBody
	public List<Property> updatePageProperties( 
			@RequestBody List<Property> newProperties, 
			NativeWebRequest request) throws NotFoundException {
 
		// update or create
		for (Property property : newProperties) {
			configService.setApplicationProperty(property.getName(), property.getValue());
		}		
		return getApplicationProperties();
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/properties/delete.json", method = { RequestMethod.POST, RequestMethod.DELETE })
	@ResponseBody
	public List<Property> deletePageProperties(  
			@RequestBody List<Property> newProperties, NativeWebRequest request) throws NotFoundException {
		
		for (Property property : newProperties) {
			configService.deleteApplicationProperty(property.getName());
		}
		return getApplicationProperties();
	}
	/**
	 * CODESET API 
	******************************************/
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/codeset/{group}/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<CodeSet> getCodeSetsByGroup(
			@PathVariable String group,
			@RequestParam(value = "objectType", defaultValue = "-1", required = false) Integer objectType,
			@RequestParam(value = "objectId", defaultValue = "-1", required = false) Long objectId ){

		if (!StringUtils.isNullOrEmpty(group)) {
			return codeSetService.getCodeSets(objectType, objectId, group);
		}
		return Collections.EMPTY_LIST;
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/codeset/{group}/code/{code}/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<CodeSet> getCodeSetsByGroupAndCode(
			@PathVariable String group,
			@PathVariable String code,
			@RequestParam(value = "objectType", defaultValue = "-1", required = false) Integer objectType,
			@RequestParam(value = "objectId", defaultValue = "-1", required = false) Long objectId ){
		
		List<CodeSet> codes = Collections.EMPTY_LIST ;
		if (!StringUtils.isNullOrEmpty(group) && !StringUtils.isNullOrEmpty(code)) {
			codes = codeSetService.getCodeSets(objectType, objectId, group, code);
		}
		return codes ;
	}
	
	/**
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/codeset/group/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<CodeSet> getCodeSets(
			@RequestParam(value = "objectType", defaultValue = "0", required = false) Integer objectType,
			@RequestParam(value = "objectId", defaultValue = "0", required = false) Long objectId,
			@RequestParam(value = "name", defaultValue = "0", required = false) String name) {

		if (!StringUtils.isNullOrEmpty(name)) {
			return codeSetService.getCodeSets(objectType, objectId, name);
		}
		return Collections.EMPTY_LIST;
	}
	*/
	
	@RequestMapping(value = "/codeset/list.json", method = { RequestMethod.POST, RequestMethod.GET })
    @ResponseBody
    public List<CodeSet> getCodeSets(
	    @RequestParam(value = "objectType", defaultValue = "0", required = false) Integer objectType,
	    @RequestParam(value = "objectId", defaultValue = "0", required = false) Long objectId,
	    @RequestParam(value = "codeSetId", defaultValue = "0", required = false) Integer codeSetId) { 
		if (codeSetId > 0) {
		    try {
		    		CodeSet codeset = codeSetService.getCodeSet(codeSetId);
				return codeSetService.getCodeSets(codeset);
		    } catch (CodeSetNotFoundException e) {
		    }
		}
		if (objectType == 1 && objectId > 0L) {
		    return codeSetService.getCodeSets(null);
		}
		return Collections.EMPTY_LIST;
    }
	
	@RequestMapping(value = "/codeset/save-or-update.json", method = RequestMethod.POST)
    @ResponseBody
    public CodeSet updateCodeSet(@RequestBody CodeSet codeset) {		
		if (codeset.getParentCodeSetId() == null)
		    codeset.setParentCodeSetId(-1L);			
		codeSetService.saveOrUpdate(codeset);		
		return codeset;
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
			list2.add(getBoardView(board));
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
	 * PROJECT API 
	******************************************/
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/projects/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getProjects(NativeWebRequest request) {
		List<Project> list = projectService.getProjects();
		return new ItemList(list, list.size());
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
			boardToUse.setMaintenanceCost(project.getMaintenanceCost());
			
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
			if (!StringUtils.isNullOrEmpty(project.getContractState()))			
				boardToUse.setContractState(project.getContractState());
			if( project.getStartDate()!= null)
				boardToUse.setStartDate(project.getStartDate());
			if( project.getEndDate()!= null)
				boardToUse.setEndDate(project.getEndDate());
			boardToUse.setMaintenanceCost(project.getMaintenanceCost());
			projectService.saveOrUpdateProject(boardToUse);
		}		
		return boardToUse;
		
	}
}
