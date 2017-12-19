package architecture.community.issue;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Qualifier;

import architecture.community.issue.dao.IssueDao;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

public class DefaultIssueService implements IssueService {

	@Inject
	@Qualifier("issueDao")
	private IssueDao issueDao;

	@Inject
	@Qualifier("projectCache")
	private Cache projectCache;	
	
	@Inject
	@Qualifier("issueCache")
	private Cache issueCache;	
	
	public DefaultIssueService() { 
	}
 
	public List<Project> getProjects() {
		
		List<Long> ids = issueDao.getAllProjectIds();
		List<Project> list = new ArrayList<Project>(ids.size());
		for(Long projectId : ids ) {
			try {
				list.add(getProject(projectId));
			} catch (ProjectNotFoundException e) {
			}
		}
		return list;
	}
 
	public Project getProject(long projectId) throws ProjectNotFoundException {
		
		Project project = getProjectInCache(projectId);		
		if( project == null ) {
			project = issueDao.getProjectById(projectId);
			if( project != null && project.getProjectId() > 0 )
				projectCache.put(new Element(projectId, project ));
		}
		if( project == null )
			throw new ProjectNotFoundException(); 
		return project;
	}

	public void saveOrUpdateProject(Project project) {
		if( project.getProjectId() > 0 && projectCache.get(project.getProjectId()) != null  ) {
			projectCache.remove(project.getProjectId());
		} 
		issueDao.saveOrUpdateProject(project);
	}
	
	protected Project getProjectInCache(long projectId){
		if( projectCache.get(projectId) != null && projectId > 0L )
			return  (Project) projectCache.get( projectId ).getObjectValue();
		else 
			return null;
	}
}
