package architecture.community.issue.dao;

import java.util.List;

import architecture.community.issue.Project;

public interface IssueDao {
	
	public void saveOrUpdateProject(Project project);
	
	public Project getProjectById(long projectId);
	
	public List<Long> getAllProjectIds(); 
	
}
