package architecture.community.query;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameterValue;

import architecture.community.util.CommunityContextHelper;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.ee.jdbc.sqlquery.factory.Configuration;
import architecture.ee.jdbc.sqlquery.mapping.BoundSql;
import architecture.ee.spring.jdbc.ExtendedJdbcDaoSupport;

public class CommunityCustomQueryService implements CustomQueryService {

	@Autowired
	@Qualifier("sqlConfiguration")
	private Configuration sqlConfiguration;

	@Autowired
	@Qualifier("dataSource")
	private DataSource dataSource;
	
	public CommunityCustomQueryService() {

	}
	
	
	public List<Map<String, Object>> list( String statement, List<ParameterValue> values) {
		ExtendedJdbcDaoSupport dao = new ExtendedJdbcDaoSupport(sqlConfiguration);
		dao.setDataSource(dataSource);
		if (values.size() > 0)
			return dao.getExtendedJdbcTemplate().queryForList(dao.getBoundSql(statement).getSql(), getSqlParameterValues(values).toArray());
		else
			return dao.getExtendedJdbcTemplate().queryForList(dao.getBoundSql(statement).getSql());
	}
	
	public List<Map<String, Object>> list(String source, String statement, List<ParameterValue> values) {
		DataSource dataSource = CommunityContextHelper.getComponent(source, DataSource.class);
		ExtendedJdbcDaoSupport dao = new ExtendedJdbcDaoSupport(sqlConfiguration);
		dao.setDataSource(dataSource);
		if (values.size() > 0)
			return dao.getExtendedJdbcTemplate().queryForList(dao.getBoundSql(statement).getSql(), getSqlParameterValues(values).toArray());
		else
			return dao.getExtendedJdbcTemplate().queryForList(dao.getBoundSql(statement).getSql());

	}

	public <T> List<T> list( String statement, List<ParameterValue> values, RowMapper<T> rowmapper) {
		ExtendedJdbcDaoSupport dao = new ExtendedJdbcDaoSupport(sqlConfiguration);
		dao.setDataSource(dataSource);
		if (values.size() > 0)
			return dao.getExtendedJdbcTemplate().query(dao.getBoundSql(statement).getSql(), rowmapper, getSqlParameterValues(values).toArray());
		else
			return dao.getExtendedJdbcTemplate().query(dao.getBoundSql(statement).getSql(), rowmapper);
	}
	
	public <T> List<T> list(DataSourceRequest dataSourceRequest, RowMapper<T> rowmapper) {		
		ExtendedJdbcDaoSupport dao = new ExtendedJdbcDaoSupport(sqlConfiguration);
		dao.setDataSource(dataSource);				
		BoundSql sqlSource = dao.getBoundSqlWithAdditionalParameter(dataSourceRequest.getStatement(), getAdditionalParameter(dataSourceRequest));
		if( dataSourceRequest.getPageSize() > 0 ){	
			if( dataSourceRequest.getParameters().size() > 0 )
				return dao.getExtendedJdbcTemplate().query( sqlSource.getSql(), dataSourceRequest.getSkip(),  dataSourceRequest.getPageSize(), rowmapper , getSqlParameterValues( dataSourceRequest.getParameters() ) );		
			else
				return dao.getExtendedJdbcTemplate().query( sqlSource.getSql(), dataSourceRequest.getSkip(),  dataSourceRequest.getPageSize(), rowmapper );					
		}else {
			if( dataSourceRequest.getParameters().size() > 0 )
				return dao.getExtendedJdbcTemplate().query(sqlSource.getSql(), rowmapper, getSqlParameterValues( dataSourceRequest.getParameters() ) );
			else	
				return dao.getExtendedJdbcTemplate().query(sqlSource.getSql(), rowmapper );
		}
	}
	
	/**
	 * 외부에서 전달된 인자들을 스프링이 인식하는 형식의 값을 변경하여 처리한다.
	 * @param values
	 * @return
	 */
	private List<SqlParameterValue> getSqlParameterValues (List<ParameterValue> values ){
		ArrayList<SqlParameterValue> al = new ArrayList<SqlParameterValue>();	
		for( ParameterValue v : values)
		{
			al.add(new SqlParameterValue(v.getJdbcType(), v.getValueText()) );
		}
		return al;
	}
	
	/**
	 * 다이나믹 쿼리 처리를 위하여 필요한 파라메터들을 Map 형식의 데이터로 생성한다. 
	 * @param dataSourceRequest
	 * @return
	 */
	private Map<String, Object> getAdditionalParameter( DataSourceRequest dataSourceRequest ){
		Map<String, Object> additionalParameter = new HashMap<String, Object>();
		additionalParameter.put("filter", dataSourceRequest.getFilter());
		additionalParameter.put("sort", dataSourceRequest.getSort());		
		additionalParameter.put("data", dataSourceRequest.getData());		
		additionalParameter.put("user", dataSourceRequest.getUser());		
		return additionalParameter;
	}
}
