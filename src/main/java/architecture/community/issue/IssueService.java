package architecture.community.issue;

import java.util.List;

public interface IssueService {
	
	public abstract List<Project> getProjects();
	
	public abstract Project getProject(long projectId) throws ProjectNotFoundException ;
	
	public void saveOrUpdateProject(Project project);
 
}
