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
import architecture.community.query.CustomQueryService;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.community.projects.stats.IssueCount;
import architecture.community.projects.stats.IssueStatsByUser;
import architecture.ee.util.NumberUtils
public class StatsByAssinee extends architecture.community.web.spring.view.AbstractScriptDataView  {
	
	@Inject
	@Qualifier("codeSetService")
	private CodeSetService codeSetService;
		
	@Inject
	@Qualifier("customQueryService")
	private CustomQueryService customQueryService;

	public StatsByAssinee() { 
		
	}

	Object handle(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{ 
		DataSourceRequest dataSourceRequest = getDataSourceRequest(request);
		dataSourceRequest.setStatement("COMMUNITY_CUSTOM.SELECT_ISSUE_STATS_BY_ASSIGNEE");	
		List<Map<String, Object> > list = customQueryService.list( dataSourceRequest );
		List<CodeSet> issueTypes = codeSetService.getCodeSets(-1, -1L, "ISSUE_TYPE");
		Map<Long , IssueStatsByUser > holder = new java.util.HashMap<Long , IssueStatsByUser>();
		
		log.debug("hello");
		for( Map<String, Object> row : list ){	
			Long userId = Long.parseLong(row.get("USER_ID").toString());
			String type = row.get("ISSUE_TYPE").toString();
			String status = row.get("ISSUE_STATUS").toString();
			Integer cnt = NumberUtils.toInt( row.get("CNT").toString(), 0 );
			
			// create stats if not exist.
			IssueStatsByUser stats = holder.get(userId);
			if( stats == null ){
				stats = new IssueStatsByUser(getUserById(userId));
				for( CodeSet code : issueTypes ) {
					stats.aggregate.put(code.getCode(), new IssueCount(code) );
				}
			}

			IssueCount ic = stats.aggregate.get( type ) ;
			ic.value = ic.value + cnt ;
			stats.aggregate.put( type, ic );
			stats.totalCount = stats.totalCount + cnt ;			
			if( org.apache.commons.lang3.StringUtils.equals ( status , "005") ){
				stats.closedCount = stats.closedCount + cnt;
			}	
			
			holder.put( stats.getUser().getUserId() , stats );
			log.debug( "user {}", row );
		}		
		List<IssueStatsByUser> list2 = new java.util.ArrayList<IssueStatsByUser>(holder.values());
		
		return new architecture.community.web.model.ItemList(list2, list2.size());
	} 

}