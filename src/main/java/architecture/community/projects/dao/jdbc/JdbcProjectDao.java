package architecture.community.projects.dao.jdbc;

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

import architecture.community.board.BoardThread;
import architecture.community.i18n.CommunityLogLocalizer;
import architecture.community.model.Models;
import architecture.community.projects.DefaultIssue;
import architecture.community.projects.Issue;
import architecture.community.projects.Project;
import architecture.community.projects.dao.ProjectDao;
import architecture.community.user.UserTemplate;
import architecture.ee.jdbc.sequencer.SequencerFactory;
import architecture.ee.service.ConfigService;
import architecture.ee.spring.jdbc.ExtendedJdbcDaoSupport;

public class JdbcProjectDao extends ExtendedJdbcDaoSupport implements ProjectDao {

	private final RowMapper<Project> projectMapper = new RowMapper<Project>() {				
		public Project mapRow(ResultSet rs, int rowNum) throws SQLException {			
			Project board = new Project(rs.getLong("PROJECT_ID"));			
			board.setName(rs.getString("NAME"));
			board.setSummary(rs.getString("SUMMARY"));
			board.setContractState(rs.getString("CONTRACT_STATE"));
			board.setMaintenanceCost(rs.getDouble("MAINTENANCE_COST"));
			board.setStartDate(rs.getDate("START_DATE"));
			board.setEndDate(rs.getDate("END_DATE"));
			board.setCreationDate(rs.getDate("CREATION_DATE"));
			board.setModifiedDate(rs.getDate("MODIFIED_DATE"));		
			return board;
		}		
	};
	
	private final RowMapper<Issue> issueMapper = new RowMapper<Issue>() {				
		public Issue mapRow(ResultSet rs, int rowNum) throws SQLException {			
			
			DefaultIssue issue = new DefaultIssue(rs.getLong("ISSUE_ID"));			
			issue.setObjectType(rs.getInt("OBJECT_TYPE"));
			issue.setObjectId(rs.getLong("OBJECT_ID"));
			issue.setIssueType(rs.getString("ISSUE_TYPE"));
			issue.setStatus(rs.getString("ISSUE_STATUS"));
			issue.setResolution(rs.getString("RESOLUTION"));
			
			issue.setSummary(rs.getString("SUMMARY"));
			issue.setDescription(rs.getString("DESCRIPTION"));
			issue.setPriority(rs.getString("PRIORITY"));
			issue.setComponent(rs.getString("COMPONENT"));
			
			issue.setAssignee(new UserTemplate(rs.getLong("ASSIGNEE")));
			issue.setRepoter(new UserTemplate(rs.getLong("REPOTER")));
			
			issue.setDueDate(rs.getDate("DUE_DATE"));
			
			issue.setCreationDate(rs.getDate("CREATION_DATE"));
			issue.setModifiedDate(rs.getDate("MODIFIED_DATE"));		
			return issue;
		}		
	};
	
	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	@Inject
	@Qualifier("sequencerFactory")
	private SequencerFactory sequencerFactory;
	
	public JdbcProjectDao() { 
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
		
			getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_WEB.INSERT_PROJECT").getSql(),
					new SqlParameterValue(Types.NUMERIC, toUse.getProjectId()),
					new SqlParameterValue(Types.VARCHAR, toUse.getName()),
					new SqlParameterValue(Types.VARCHAR, toUse.getSummary()),
					new SqlParameterValue(Types.VARCHAR, toUse.getContractState()),
					new SqlParameterValue(Types.NUMERIC, toUse.getMaintenanceCost()),					
					new SqlParameterValue(Types.TIMESTAMP, toUse.getStartDate()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getEndDate()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getCreationDate()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getModifiedDate()));		
			
		} else {
			Date now = Calendar.getInstance().getTime();
			toUse.setModifiedDate(now);		
			getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_WEB.UPDATE_PROJECT").getSql(),
					new SqlParameterValue(Types.VARCHAR, toUse.getName()),
					new SqlParameterValue(Types.VARCHAR, toUse.getSummary()),
					new SqlParameterValue(Types.VARCHAR, toUse.getContractState()),
					new SqlParameterValue(Types.NUMERIC, toUse.getMaintenanceCost()),	
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
				getBoundSql("COMMUNITY_WEB.SELECT_PROJECT_BY_ID").getSql(),
				projectMapper,
				new SqlParameterValue(Types.NUMERIC, projectId));
		} catch (DataAccessException e) {
			logger.warn(e.getMessage());
			return null;
		}
	}
 
	public List<Long> getAllProjectIds() {
		return getExtendedJdbcTemplate().queryForList(getBoundSql("COMMUNITY_WEB.SELECT_PROJECT_IDS").getSql(), Long.class);
	}

	@Override
	public void saveOrUpdateIssue(Issue issue) {
 
		Issue toUse = issue;
		if (toUse.getIssueId() < 1L) {
			toUse.setIssueId(getNextIssueId());
		
			getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_WEB.INSERT_ISSUE").getSql(),
					new SqlParameterValue(Types.NUMERIC, toUse.getIssueId()),
					new SqlParameterValue(Types.NUMERIC, toUse.getObjectType()),
					new SqlParameterValue(Types.NUMERIC, toUse.getObjectId()),
					new SqlParameterValue(Types.VARCHAR, toUse.getIssueType()),
					new SqlParameterValue(Types.VARCHAR, toUse.getStatus()),
					
					new SqlParameterValue(Types.VARCHAR, toUse.getComponent()),
					new SqlParameterValue(Types.VARCHAR, toUse.getSummary()),
					new SqlParameterValue(Types.VARCHAR, toUse.getDescription()),
					new SqlParameterValue(Types.VARCHAR, toUse.getPriority()),	
					
					new SqlParameterValue(Types.VARCHAR, toUse.getAssignee().getUserId()),	
					new SqlParameterValue(Types.VARCHAR, toUse.getRepoter().getUserId()),	
					 
					new SqlParameterValue(Types.TIMESTAMP, toUse.getDueDate()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getCreationDate()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getModifiedDate()));		
			
		} else {
			Date now = Calendar.getInstance().getTime();
			toUse.setModifiedDate(now);		
			getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_WEB.UPDATE_ISSUE").getSql(), 
					new SqlParameterValue(Types.VARCHAR, toUse.getIssueType()),
					new SqlParameterValue(Types.VARCHAR, toUse.getStatus()),
					new SqlParameterValue(Types.VARCHAR, toUse.getResolution()),
					new SqlParameterValue(Types.VARCHAR, toUse.getComponent()),
					new SqlParameterValue(Types.VARCHAR, toUse.getSummary()),
					new SqlParameterValue(Types.VARCHAR, toUse.getDescription()),
					new SqlParameterValue(Types.VARCHAR, toUse.getPriority()),	
					new SqlParameterValue(Types.VARCHAR, toUse.getAssignee().getUserId()),	
					new SqlParameterValue(Types.VARCHAR, toUse.getRepoter().getUserId()),	
					new SqlParameterValue(Types.TIMESTAMP, toUse.getDueDate()),
					new SqlParameterValue(Types.TIMESTAMP, toUse.getModifiedDate()),
					new SqlParameterValue(Types.NUMERIC, toUse.getIssueId())
			);		
			
		}	
		
	}
 
	public Issue getIssueById(long issueId) {
		Issue thread = null;
		if (issueId <= 0L) {
			return thread;
		}		
		try {
			thread = getExtendedJdbcTemplate().queryForObject(getBoundSql("COMMUNITY_WEB.SELECT_ISSUE_BY_ID").getSql(), 
					issueMapper, 
					new SqlParameterValue(Types.NUMERIC, issueId ));
		} catch (DataAccessException e) {
			logger.error(CommunityLogLocalizer.format("013005", issueId), e);
		}
		return thread;
	}
 
	public int getIssueCount(int objectType, long objectId) {
		return getExtendedJdbcTemplate().queryForObject(
				getBoundSql("COMMUNITY_WEB.COUNT_ISSUE_IDS_BY_OBJECT_TYPE_AND_OBJECT_ID").getSql(), 
				Integer.class,
				new SqlParameterValue(Types.NUMERIC, objectType ),
				new SqlParameterValue(Types.NUMERIC, objectId )
			);
	}
 
	public List<Long> getIssueIds(int objectType, long objectId) {
		return getExtendedJdbcTemplate().queryForList(
				getBoundSql("COMMUNITY_WEB.SELECT_ISSUE_IDS_BY_OBJECT_TYPE_AND_OBJECT_ID").getSql(), 
				Long.class,
				new SqlParameterValue(Types.NUMERIC, objectType ),
				new SqlParameterValue(Types.NUMERIC, objectId )
			);
	}
 
	public List<Long> getIssueIds(int objectType, long objectId, int startIndex, int numResults) {
		return getExtendedJdbcTemplate().query(
				getBoundSql("COMMUNITY_WEB.SELECT_ISSUE_IDS_BY_OBJECT_TYPE_AND_OBJECT_ID").getSql(), 
				startIndex, 
				numResults, 
				Long.class, 
				new SqlParameterValue(Types.NUMERIC, objectType ),
				new SqlParameterValue(Types.NUMERIC, objectId )
		);
	}
	
	
}
