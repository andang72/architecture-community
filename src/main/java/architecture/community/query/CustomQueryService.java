package architecture.community.query;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.RowMapper;

import architecture.community.web.model.json.DataSourceRequest;

public interface CustomQueryService {
	
	/**
	 * 
	 * @param dataSourceRequest
	 * @param rowmapper 결과 데이터처 처리자 
	 * @return
	 */
	public <T> List<T> list( DataSourceRequest dataSourceRequest, RowMapper<T> rowmapper);
	
	/**
	 * 
	 * @param statement 쿼리 키 
	 * @param values 파라메터 값 
	 * @param rowmapper 결과 데이터처 처리자 
	 * @return
	 */
	public <T> List<T> list( String statement, List<ParameterValue> values, RowMapper<T> rowmapper);
	
	
	
	public List<Map<String, Object>> list(String statement, List<ParameterValue> values) ;

	/**
	 * 
	 * @param source
	 * @param statement
	 * @param values
	 * @return
	 */
	public List<Map<String, Object>> list(String source, String statement, List<ParameterValue> values) ;

}
