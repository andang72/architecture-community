package architecture.community.query;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;

import architecture.community.query.dao.CustomQueryJdbcDao;
import architecture.community.web.model.json.DataSourceRequest;

public interface CustomQueryService {
	
	
	/**
	 *  
	 * API using DataSourceRequest 
	 *
	 */
	
	/**
	 * 
	 * @param dataSourceRequest
	 * @param rowmapper Row 단위 결과 데이터 처리자 
	 * @return
	 */
	public <T> List<T> list( DataSourceRequest dataSourceRequest, RowMapper<T> rowmapper);
	
	
	/**
	 * 
	 * @param dataSourceRequest
	 * @param extractor 결과 데이터 처리자 
	 * @return
	 */
	public <T> T list(DataSourceRequest dataSourceRequest, ResultSetExtractor<T> extractor) ;
	 
	
	
	/**
	 *  
	 * Old style API
	 *
	 */
	
	/**
	 * 
	 * @param statement 쿼리 키 
	 * @param values 파라메터 값 
	 * @param rowmapper 결과 데이터처 처리자 
	 * @return
	 */
	public <T> List<T> list( String statement, List<ParameterValue> values, RowMapper<T> rowmapper);
	
	
	/**
	 * 
	 * @param statement 쿼리 키
	 * @param values 파라메터 값 
	 * @return 
	 */
	public List<Map<String, Object>> list(String statement, List<ParameterValue> values) ;

	/**
	 * 
	 * @param source 데이터소스 이름 
	 * @param statement 쿼리 키
	 * @param values 파라메터 값
	 * @return
	 */
	public List<Map<String, Object>> list(String source, String statement, List<ParameterValue> values) ;
	

	
	public abstract <T> T execute(DaoCallback<T> action) throws DataAccessException;	
	
	public interface DaoCallback<T> {
		T process(CustomQueryJdbcDao dao) throws DataAccessException;
	}
	

}
