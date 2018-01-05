package architecture.community.projects;

import java.util.List;

import architecture.community.user.User;
import architecture.community.web.model.json.DataSourceRequest;

public interface ProjectService {
	
	public abstract List<Project> getProjects();
	
	public abstract Project getProject(long projectId) throws ProjectNotFoundException ;
	
	public abstract void saveOrUpdateProject(Project project);
	 
	public abstract Issue createIssue(int objectType, long objectId, User repoter);
	
	public abstract void saveOrUpdateIssue(Issue issue);
	
	public abstract int getIssueCount(int objectType, long objectId);
	
	public abstract int getIssueCount(DataSourceRequest dataSourceRequest);
	
	public abstract Issue getIssue( long issueId ) throws  IssueNotFoundException ;
	
	public abstract List<Issue> getIssues(int objectType, long objectId);
	
	public abstract List<Issue> getIssues(DataSourceRequest dataSourceRequest);
	
	public abstract List<Issue> getIssues(int objectType, long objectId, int startIndex, int numResults);
	
 
}
