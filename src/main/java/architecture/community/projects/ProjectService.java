package architecture.community.projects;

import java.util.List;

public interface ProjectService {
	
	public abstract List<Project> getProjects();
	
	public abstract Project getProject(long projectId) throws ProjectNotFoundException ;
	
	public void saveOrUpdateProject(Project project);
 
}
