package tests;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
/** common package import here! */
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.ui.Model;

import architecture.community.codeset.CodeSetService;
/** custom package import here! */
import architecture.community.page.api.Api;
import architecture.community.projects.Project;
import architecture.community.projects.ProjectNotFoundException;
import architecture.community.projects.ProjectService;
import architecture.community.query.CustomQueryService;
import architecture.community.query.ParameterValue;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.community.wiki.WikiService;

public class GetWikiByProject extends architecture.community.web.spring.view.AbstractScriptDataView  {
	
	@Inject
	@Qualifier("codeSetService")
	private CodeSetService codeSetService;
		
	@Inject
	@Qualifier("customQueryService")
	private CustomQueryService customQueryService;

		
	@Inject
	@Qualifier("wikiService")
	private WikiService wikiService;
	
	@Inject
	@Qualifier("projectService")
	private ProjectService projectService;
	 
	 
	private Project getProject(Long projectId) throws ProjectNotFoundException{
		Project project = projectService.getProject(projectId);
		return project;
	}

	public Object handle(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{ 

		Api page = getApi(model);
		Map<String, String> variables = getVariables(model);
		
		Long projectId = getLongProperty( variables, "projectId", -1L );
		Project project = 	 projectService.getProject(projectId);
		log.debug( "get wiki by project {}", project );

		DataSourceRequest dataSourceRequest = getDataSourceRequest(request);
		dataSourceRequest.setStatement("COMMUNITY_UI_WIKI.SELECT_WIKI_BY_OBJECT_TYPE_AND_OBJECT_ID");	
		
		List<ParameterValue> params = new java.util.ArrayList<ParameterValue>();
		params.add( new ParameterValue( 1, "OBJECT_TYPE", java.sql.Types.NUMERIC, 19));
		params.add( new ParameterValue( 2, "OBJECT_ID", java.sql.Types.NUMERIC, projectId));
		dataSourceRequest.setParameters( params ); 
		
		customQueryService.query(dataSourceRequest, new org.springframework.jdbc.core.RowCallbackHandler() { 
			public void processRow(ResultSet rs) throws SQLException {
				rs.getLong("");
				
				
		}});
		
		return project ;
		
	} 

}