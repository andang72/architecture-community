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
import architecture.community.projects.stats.IssueStateByMonth;
import architecture.ee.util.NumberUtils


public class StatsIssueByMonthly extends architecture.community.web.spring.view.AbstractScriptDataView  {
	
	@Inject
	@Qualifier("codeSetService")
	private CodeSetService codeSetService;
		
	@Inject
	@Qualifier("customQueryService")
	private CustomQueryService customQueryService;

	Object handle(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{ 
		DataSourceRequest dataSourceRequest = getDataSourceRequest(request);
		dataSourceRequest.setStatement("COMMUNITY_CUSTOM.SELECT_ISSUE_STATS_BY_MONTHLY");	
		dataSourceRequest.getData().put("complete", false );
		
		List<Map<String, Object> > list = customQueryService.list( dataSourceRequest );
		List<CodeSet> issueTypes = codeSetService.getCodeSets(-1, -1L, "ISSUE_TYPE");
		Map<String , IssueStateByMonth > holder = new java.util.HashMap<String , IssueStateByMonth>();
		 
		for( Map<String, Object> row : list ){	
			String month = row.get("MONTH").toString();
			String type = row.get("ISSUE_TYPE").toString();
			Integer cnt = NumberUtils.toInt( row.get("CNT").toString(), 0 );
			
			IssueStateByMonth stats = holder.get(month);
			if( stats == null ){
				stats = new IssueStateByMonth(month);
				for( CodeSet code : issueTypes ) {
					stats.aggregate.put(code.getCode(), new IssueCount(code) );
					stats.closedAggregate.put(code.getCode(), new IssueCount(code) );
				}
			}
			IssueCount ic = stats.aggregate.get( type ) ;
			ic.value = ic.value + cnt ;
			stats.aggregate.put( type, ic );
			stats.totalCount = stats.totalCount + cnt ;			
			holder.put( stats.month, stats );
		}	
		
		dataSourceRequest.getData().put("complete", true );
		list = customQueryService.list( dataSourceRequest );
		
		for( Map<String, Object> row : list ){	
			String month = row.get("MONTH").toString();
			String type = row.get("ISSUE_TYPE").toString();
			Integer cnt = NumberUtils.toInt( row.get("CNT").toString(), 0 );
			
			IssueStateByMonth stats = holder.get(month);
			IssueCount ic = stats.closedAggregate.get( type ) ;
			ic.value = ic.value + cnt ;
			stats.closedAggregate.put( type, ic );
			stats.closedCount = stats.closedCount + cnt ;			
			holder.put( stats.month, stats );
		}	
		
		List<IssueStateByMonth> list2 = new java.util.ArrayList<IssueStateByMonth>(holder.values()); 
		// Sorting by month.
		Collections.sort(list2, new Comparator<IssueStateByMonth>() { 
			public int compare(IssueStateByMonth o1, IssueStateByMonth o2) { 
				int o1n = NumberUtils.toInt(org.apache.commons.lang3.StringUtils.remove(o1.month, "."), 0);
				int o2n = NumberUtils.toInt(org.apache.commons.lang3.StringUtils.remove(o2.month, "."), 0);
				if( o1n > o2n )
					return 1 ;
				else if ( o1n < o2n )
					return -1 ;
				return 0;
		}});
			
		return new architecture.community.web.model.ItemList(list2, list2.size());
	} 

}