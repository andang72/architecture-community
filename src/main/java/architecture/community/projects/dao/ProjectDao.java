package architecture.community.projects.dao;

import java.util.List;

import architecture.community.projects.Project;

public interface ProjectDao {
	
	public void saveOrUpdateProject(Project project);
	
	public Project getProjectById(long projectId);
	
	public List<Long> getAllProjectIds(); 
	
}
