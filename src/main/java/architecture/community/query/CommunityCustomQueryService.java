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

	public <T> List<T> list( String statement, List<ParameterValue> values, RowMapper<T> rowmapper) {
		ExtendedJdbcDaoSupport dao = new ExtendedJdbcDaoSupport(sqlConfiguration);
		dao.setDataSource(dataSource);
		ArrayList<SqlParameterValue> list = new ArrayList<SqlParameterValue>();
		for (ParameterValue v : values) {
			list.add(new SqlParameterValue(v.getJdbcType(), v.getValueText()));
		}
		
		if (values.size() > 0)
			return dao.getExtendedJdbcTemplate().query(dao.getBoundSql(statement).getSql(), rowmapper, values);
		else
			return dao.getExtendedJdbcTemplate().query(dao.getBoundSql(statement).getSql(), rowmapper);
	}
	
	
	public List<Map<String, Object>> list( String statement, List<ParameterValue> values) {
		ExtendedJdbcDaoSupport dao = new ExtendedJdbcDaoSupport(sqlConfiguration);
		dao.setDataSource(dataSource);
		ArrayList<SqlParameterValue> list = new ArrayList<SqlParameterValue>();
		for (ParameterValue v : values) {
			list.add(new SqlParameterValue(v.getJdbcType(), v.getValueText()));
		}
		if (values.size() > 0)
			return dao.getExtendedJdbcTemplate().queryForList(dao.getBoundSql(statement).getSql(), list.toArray());
		else
			return dao.getExtendedJdbcTemplate().queryForList(dao.getBoundSql(statement).getSql());
	}
	
	public List<Map<String, Object>> list(String source, String statement, List<ParameterValue> values) {
		DataSource dataSource = CommunityContextHelper.getComponent(source, DataSource.class);

		ExtendedJdbcDaoSupport dao = new ExtendedJdbcDaoSupport(sqlConfiguration);
		dao.setDataSource(dataSource);

		ArrayList<SqlParameterValue> list = new ArrayList<SqlParameterValue>();
		for (ParameterValue v : values) {
			list.add(new SqlParameterValue(v.getJdbcType(), v.getValueText()));
		}
		if (values.size() > 0)
			return dao.getExtendedJdbcTemplate().queryForList(dao.getBoundSql(statement).getSql(), list.toArray());
		else
			return dao.getExtendedJdbcTemplate().queryForList(dao.getBoundSql(statement).getSql());

	}
 
	public <T> List<T> list(DataSourceRequest dataSourceRequest, String statement, RowMapper<T> rowmapper) {
		ExtendedJdbcDaoSupport dao = new ExtendedJdbcDaoSupport(sqlConfiguration);
		dao.setDataSource(dataSource);		
		BoundSql sqlSource = dao.getBoundSqlWithAdditionalParameter("COMMUNITY_WEB.SELECT_ISSUE_SUMMARY_BY_REQUEST", getAdditionalParameter(dataSourceRequest));
		if( dataSourceRequest.getPageSize() > 0 ){	
			return dao.getExtendedJdbcTemplate().query( sqlSource.getSql(), dataSourceRequest.getSkip(),  dataSourceRequest.getPageSize(), rowmapper );			
		}else {
			return dao.getExtendedJdbcTemplate().query(sqlSource.getSql(), rowmapper );
		}
	}

	private Map<String, Object> getAdditionalParameter( DataSourceRequest dataSourceRequest ){
		Map<String, Object> additionalParameter = new HashMap<String, Object>();
		additionalParameter.put("filter", dataSourceRequest.getFilter());
		additionalParameter.put("sort", dataSourceRequest.getSort());		
		additionalParameter.put("data", dataSourceRequest.getData());		
		additionalParameter.put("user", dataSourceRequest.getUser());		
		return additionalParameter;
	}
}
