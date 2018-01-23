package architecture.community.stats;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.SqlParameterValue;

import architecture.community.query.ParameterValue;
import architecture.community.util.CommunityContextHelper;
import architecture.ee.jdbc.sqlquery.factory.Configuration;
import architecture.ee.spring.jdbc.ExtendedJdbcDaoSupport;

public class DefaultStatisticsService implements StatisticsService {

	@Autowired
	@Qualifier("sqlConfiguration")
	private Configuration sqlConfiguration; 
	
	public List<Map<String, Object>> stat(String target , String statName, List<ParameterValue> values) {	
		
		DataSource dataSource = CommunityContextHelper.getComponent(target, DataSource.class);
		ExtendedJdbcDaoSupport dao = new ExtendedJdbcDaoSupport(sqlConfiguration);
		dao.setDataSource(dataSource);		
		
		ArrayList<SqlParameterValue> al = new ArrayList<SqlParameterValue>();	
		for( ParameterValue v : values)
		{
			al.add(new SqlParameterValue(v.getJdbcType(), v.getValueText()) );
		}
		if( values.size() > 0)
			return dao.getExtendedJdbcTemplate().queryForList(dao.getBoundSql(statName).getSql(), al.toArray() );
		else
			return dao.getExtendedJdbcTemplate().queryForList(dao.getBoundSql(statName).getSql())	;
	}

}
