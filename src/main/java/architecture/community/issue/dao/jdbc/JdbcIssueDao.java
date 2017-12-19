package architecture.community.issue.dao.jdbc;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameterValue;

import architecture.community.board.Board;
import architecture.community.board.DefaultBoard;
import architecture.community.issue.Project;
import architecture.community.issue.dao.IssueDao;
import architecture.community.model.Models;
import architecture.community.user.AvatarImage;
import architecture.community.user.AvatarImageNotFoundException;
import architecture.ee.jdbc.sequencer.SequencerFactory;
import architecture.ee.service.ConfigService;
import architecture.ee.spring.jdbc.ExtendedJdbcDaoSupport;

public class JdbcIssueDao extends ExtendedJdbcDaoSupport implements IssueDao {

	private final RowMapper<Project> projectMapper = new RowMapper<Project>() {		
		
		public Project mapRow(ResultSet rs, int rowNum) throws SQLException {			
			Project board = new Project(rs.getLong("PROJECT_ID"));			
			board.setName(rs.getString("NAME"));
			board.setSummary(rs.getString("SUMMARY"));
			board.setStartDate(rs.getDate("START_DATE"));
			board.setEndDate(rs.getDate("END_DATE"));
			board.setCreationDate(rs.getDate("CREATION_DATE"));
			board.setModifiedDate(rs.getDate("MODIFIED_DATE"));		
			return board;
		}
		
	};
	
	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	@Inject
	@Qualifier("sequencerFactory")
	private SequencerFactory sequencerFactory;
	
	public JdbcIssueDao() { 
	}

	public long getNextProjectId(){
		logger.debug("next id for {}, {}", Models.PROJECT.getObjectType(), Models.PROJECT.name() );
		return sequencerFactory.getNextValue(Models.PROJECT.getObjectType(), Models.PROJECT.name());
	}
	
	public long getNextIssueId(){
		logger.debug("next id for {}, {}", Models.ISSUE.getObjectType(), Models.ISSUE.name() );
		return sequencerFactory.getNextValue(Models.ISSUE.getObjectType(), Models.ISSUE.name());
	}

	@Override
	public void saveOrUpdateProject(Project project) {
		Project toUse = project;
		if (toUse.getProjectId() < 1L) {
			toUse.setProjectId(getNextProjectId());
		
			getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_ISSUE.INSERT_PROJECT").getSql(),
					new SqlParameterValue(Types.NUMERIC, toUse.getProjectId()),
					new SqlParameterValue(Types.VARCHAR, toUse.getName()),
					new SqlParameterValue(Types.VARCHAR, toUse.getSummary()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getStartDate()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getEndDate()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getCreationDate()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getModifiedDate()));		
			
		} else {
			Date now = Calendar.getInstance().getTime();
			toUse.setModifiedDate(now);		
			getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_ISSUE.UPDATE_PROJECT").getSql(),
					new SqlParameterValue(Types.VARCHAR, toUse.getName()),
					new SqlParameterValue(Types.VARCHAR, toUse.getSummary()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getStartDate()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getEndDate()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getModifiedDate()),
					new SqlParameterValue(Types.NUMERIC, toUse.getProjectId())
					);		
			
		}	
	}
 
	public Project getProjectById(long projectId) {
		try {
			return getExtendedJdbcTemplate().queryForObject(
				getBoundSql("COMMUNITY_ISSUE.SELECT_PROJECT_BY_ID").getSql(),
				projectMapper,
				new SqlParameterValue(Types.NUMERIC, projectId));
		} catch (DataAccessException e) {
			logger.warn(e.getMessage());
			return null;
		}
	}
 
	public List<Long> getAllProjectIds() {
		return getExtendedJdbcTemplate().queryForList(getBoundSql("COMMUNITY_ISSUE.SELECT_PROJECT_IDS").getSql(), Long.class);
	}
	
	
}
