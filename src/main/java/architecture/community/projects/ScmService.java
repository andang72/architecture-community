package architecture.community.projects;

public interface ScmService {
	
	/*
	 * Scm API
	 * */
	public abstract Scm getScmById( long scmId ) throws  ScmNotFoundException ;
	
	public abstract void deleteScm(Scm scm);
	
	public abstract void saveOrUpdateScm(Scm scm);	
}
