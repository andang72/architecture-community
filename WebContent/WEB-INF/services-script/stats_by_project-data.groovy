package services.script
 
 /** common package import here! */
import java.util.Map;
import java.util.List;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Qualifier; 
import org.springframework.ui.Model;

/** custom package import here! */
import architecture.community.user.*;
import architecture.community.codeset.*;
import architecture.community.projects.*;
import architecture.community.query.CustomQueryService;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.community.projects.stats.IssueCount;
import architecture.community.projects.stats.IssueStateByProject;
import architecture.ee.util.NumberUtils

public class StatsByProject extends architecture.community.web.spring.view.AbstractScriptDataView  {
	
	@Inject
	@Qualifier("codeSetService")
	private CodeSetService codeSetService;
		
	@Inject
	@Qualifier("customQueryService")
	private CustomQueryService customQueryService;

	@Inject
	@Qualifier("projectService")
	private ProjectService projectService;
	 
	private Project getProject(Long projectId){
		Project project = projectService.getProject(projectId);
		return project;
	}

	Object handle(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{ 
		DataSourceRequest dataSourceRequest = getDataSourceRequest(request);
		dataSourceRequest.setStatement("COMMUNITY_CUSTOM.SELECT_ISSUE_STATS_BY_PROJECT");	
		dataSourceRequest.getData().put("complete", false );
		
		List<Map<String, Object> > list = customQueryService.list( dataSourceRequest );
		List<CodeSet> issueTypes = codeSetService.getCodeSets(-1, -1L, "ISSUE_TYPE");
		Map<Long, IssueStateByProject > holder = new java.util.HashMap<Long , IssueStateByProject>();
		 
		for( Map<String, Object> row : list ){	
			String objectName = row.get("NAME").toString();
			Long projectId = NumberUtils.toLong( row.get("PROJECT_ID").toString(), -1L ); 
			String type = row.get("ISSUE_TYPE").toString();
			Integer cnt = NumberUtils.toInt( row.get("CNT").toString(), 0 );
			
			IssueStateByProject stats = holder.get(projectId);
			if( stats == null ){
				stats = new IssueStateByProject(getProject(projectId));
				for( CodeSet code : issueTypes ) {
					stats.aggregate.put(code.getCode(), new IssueCount(code) );
					stats.closedAggregate.put(code.getCode(), new IssueCount(code) );
				}
			}
			IssueCount ic = stats.aggregate.get( type ) ;
			ic.value = ic.value + cnt ;
			stats.aggregate.put( type, ic );
			stats.totalCount = stats.totalCount + cnt ;			
			holder.put( projectId, stats );
		}	
		
		dataSourceRequest.getData().put("complete", true );
		list = customQueryService.list( dataSourceRequest );
		
		for( Map<String, Object> row : list ){	
			Long projectId = NumberUtils.toLong( row.get("PROJECT_ID").toString(), -1L );
			
			String type = row.get("ISSUE_TYPE").toString();
			Integer cnt = NumberUtils.toInt( row.get("CNT").toString(), 0 );
			
			IssueStateByProject stats = holder.get(projectId);
			IssueCount ic = stats.closedAggregate.get( type ) ;
			ic.value = ic.value + cnt ;
			stats.closedAggregate.put( type, ic );
			stats.closedCount = stats.closedCount + cnt ;			
			holder.put( projectId, stats );
		}	
			
		List<IssueStateByProject> list2 = new java.util.ArrayList<IssueStateByProject>(holder.values()); 
		return new architecture.community.web.model.ItemList(list2, list2.size());
	} 

}