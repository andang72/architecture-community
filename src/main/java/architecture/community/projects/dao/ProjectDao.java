package architecture.community.projects.dao;

import java.util.List;

import architecture.community.projects.Issue;
import architecture.community.projects.Project;
import architecture.community.web.model.json.DataSourceRequest;

public interface ProjectDao {
	
	public void saveOrUpdateProject(Project project);
	
	public Project getProjectById(long projectId);
	
	public List<Long> getAllProjectIds(); 
	
	
	public abstract void saveOrUpdateIssue(Issue issue);
	
	public abstract Issue getIssueById(long issueId);
	
	public abstract int getIssueCount( int objectType, long objectId ); 
	
	public abstract int getIssueCount(DataSourceRequest dataSourceRequest);
	
	public abstract List<Long> getIssueIds( int objectType, long objectId ); 
	
	public abstract List<Long> getIssueIds(DataSourceRequest dataSourceRequest);
	
	public abstract List<Long> getIssueIds(int objectType, long objectId, int startIndex, int numResults);
	
}
