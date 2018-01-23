package architecture.community.query;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.SqlParameterValue;

import architecture.community.util.CommunityContextHelper;
import architecture.ee.jdbc.sqlquery.factory.Configuration;
import architecture.ee.spring.jdbc.ExtendedJdbcDaoSupport;

public class CommunityCustomQueryService implements CustomQueryService {

	@Autowired
	@Qualifier("sqlConfiguration")
	private Configuration sqlConfiguration;

	public CommunityCustomQueryService() {

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

}
