package architecture.community.projects;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.community.board.BoardThread;
import architecture.community.board.BoardThreadNotFoundException;
import architecture.community.board.DefaultBoardMessage;
import architecture.community.board.dao.BoardDao;
import architecture.community.codeset.CodeSetNotFoundException;
import architecture.community.codeset.CodeSetService;
import architecture.community.projects.dao.ProjectDao;
import architecture.community.user.User;
import architecture.community.user.UserManager;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

public class DefaultProjectService implements ProjectService {

	private Logger logger = LoggerFactory.getLogger(getClass().getName());
	
	@Inject
	@Qualifier("projectDao")
	private ProjectDao projectDao;

	@Inject
	@Qualifier("projectCache")
	private Cache projectCache;	
	
	@Inject
	@Qualifier("projectIssueCache")
	private Cache projectIssueCache;	
	
	@Inject
	@Qualifier("userManager")
	private UserManager userManager;
	
	@Inject
	@Qualifier("codeSetService")
	private CodeSetService codeSetService;
	
	
	public DefaultProjectService() { 
	}
 
	public List<Project> getProjects() {
		
		List<Long> ids = projectDao.getAllProjectIds();
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
			project = projectDao.getProjectById(projectId);
			if( project != null && project.getProjectId() > 0 )
				projectCache.put(new Element(projectId, project ));
		}
		if( project == null )
			throw new ProjectNotFoundException(); 
		return project;
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void saveOrUpdateProject(Project project) {
		if( project.getProjectId() > 0 && projectCache.get(project.getProjectId()) != null  ) {
			projectCache.remove(project.getProjectId());
		} 
		projectDao.saveOrUpdateProject(project);
	}
	
	protected Project getProjectInCache(long projectId){
		if( projectCache.get(projectId) != null && projectId > 0L )
			return  (Project) projectCache.get( projectId ).getObjectValue();
		else 
			return null;
	}
 
	public Issue createIssue(int objectType, long objectId, User repoter) {
		Issue issue = new DefaultIssue(objectType, objectId, repoter);		
		return issue;
	}

 
	public int getIssueCount(int objectType, long objectId) {		
		return projectDao.getIssueCount(objectType, objectId);
	}
 
	public List<Issue> getIssues(int objectType, long objectId) {
		List<Long> threadIds = projectDao.getIssueIds(objectType, objectId);
		List<Issue> list = new ArrayList<Issue>(threadIds.size());
		for( Long threadId : threadIds )
		{
			try {
				list.add(getIssue(threadId));
			} catch (IssueNotFoundException e) {
				// ignore;
				logger.warn(e.getMessage(), e);
			}
		}
		return list;
	}
 
	public List<Issue> getIssues(int objectType, long objectId, int startIndex, int numResults) {
		List<Long> threadIds = projectDao.getIssueIds(objectType, objectId, startIndex, numResults);
		List<Issue> list = new ArrayList<Issue>(threadIds.size());
		for( Long threadId : threadIds )
		{
			try {
				list.add(getIssue(threadId));
			} catch (IssueNotFoundException e) {
				// ignore;
				logger.warn(e.getMessage(), e);
			}
		}
		return list;
	}
	 
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void saveOrUpdateIssue(Issue issue) {
		if( issue.getIssueId() > 0 && projectIssueCache.get(issue.getIssueId()) != null  ) {
			projectIssueCache.remove(issue.getIssueId());
		} 
		projectDao.saveOrUpdateIssue(issue);
	}
	
	protected Issue geIssueInCache(long issueId){
		if( projectIssueCache.get(issueId) != null && issueId > 0L )
			return  (Issue) projectIssueCache.get( issueId ).getObjectValue();
		else 
			return null;
	}
 
	public Issue getIssue(long issueId) throws IssueNotFoundException {
		Issue issue = geIssueInCache(issueId);		
		if( issue == null ) {
			issue = projectDao.getIssueById(issueId);
			if( issue != null && issue.getIssueId() > 0 ) {
				if( issue.getAssignee().getUserId() > 0)
					issue.setAssignee( userManager.getUser(issue.getAssignee()));
					
				if( issue.getRepoter().getUserId() > 0)
					issue.setRepoter( userManager.getUser(issue.getRepoter()));				
				((DefaultIssue)issue).setIssueTypeName(getCodeText( "ISSUE_TYPE", issue.getIssueType()));
				((DefaultIssue)issue).setPriorityName(getCodeText( "PRIORITY", issue.getPriority()));				
				projectIssueCache.put(new Element(issueId, issue ));
			}
		}
		if( issue == null )
			throw new IssueNotFoundException(); 
		return issue;
	}
	
	
	private String getCodeText( String group, String code ) {
		if( StringUtils.isEmpty(group) || StringUtils.isEmpty(code))
			return null;
		try {
			return codeSetService.getCodeSetByCode(group, code).getName();
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return null;
		}
	}

}
