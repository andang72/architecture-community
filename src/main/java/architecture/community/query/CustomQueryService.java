package architecture.community.query;

import java.util.List;
import java.util.Map;

import org.apache.poi.ss.formula.functions.T;
import org.springframework.jdbc.core.RowMapper;

import architecture.community.web.model.json.DataSourceRequest;

public interface CustomQueryService {
	
	public <T> List<T> list( DataSourceRequest dataSourceRequest, String statement, RowMapper<T> rowmapper);
	
	public <T> List<T> list( String statement, List<ParameterValue> values, RowMapper<T> rowmapper);
	
	public List<Map<String, Object>> list(String statement, List<ParameterValue> values) ;

	public List<Map<String, Object>> list(String source, String statement, List<ParameterValue> values) ;

}
