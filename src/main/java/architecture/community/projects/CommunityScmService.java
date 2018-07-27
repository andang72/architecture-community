package architecture.community.projects;

import java.util.concurrent.TimeUnit;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;

import architecture.community.projects.dao.ProjectDao;

public class CommunityScmService implements ScmService {

	private Logger logger = LoggerFactory.getLogger(getClass().getName());
	
	@Inject
	@Qualifier("projectDao")
	private ProjectDao projectDao;
	
 
	private com.google.common.cache.LoadingCache<Long, Scm> projectScmCache = null;
	
	public CommunityScmService() { 
	}
	

	public void initialize(){		
		logger.debug("creating cache ...");		
		 
		projectScmCache = CacheBuilder.newBuilder().maximumSize(50).expireAfterAccess(60 * 100, TimeUnit.MINUTES).build(		
				new CacheLoader<Long, Scm>(){			
					public Scm load(Long scmId) throws Exception {
						logger.debug("loading scm by {}", scmId);
						return projectDao.getScmById(scmId);
				}}
			);
	} 
	
	public Scm getScmById(long scmId) throws ScmNotFoundException {
		
		Scm scm = null;
		try {
			if( projectScmCache != null)
				scm = projectScmCache.get(scmId);
			else
				scm = projectDao.getScmById(scmId);
		} catch (Exception e) {
			throw new ScmNotFoundException(e);
		}
		return scm;
	
	}
	
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void deleteScm(Scm scm) {
		
		projectDao.deleteScm(scm);
		if( projectScmCache != null)
			projectScmCache.invalidate(scm.getScmId());
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void saveOrUpdateScm(Scm scm) {
		
		projectDao.saveOrUpdateScm(scm);
		
		if( projectScmCache != null)
			projectScmCache.refresh(scm.getScmId());
	} 
	
	
}
