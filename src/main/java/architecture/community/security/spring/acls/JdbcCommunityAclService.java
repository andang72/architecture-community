package architecture.community.security.spring.acls;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.acls.domain.GrantedAuthoritySid;
import org.springframework.security.acls.domain.ObjectIdentityImpl;
import org.springframework.security.acls.domain.PrincipalSid;
import org.springframework.security.acls.domain.SidRetrievalStrategyImpl;
import org.springframework.security.acls.jdbc.JdbcMutableAclService;
import org.springframework.security.acls.jdbc.LookupStrategy;
import org.springframework.security.acls.model.AccessControlEntry;
import org.springframework.security.acls.model.AclCache;
import org.springframework.security.acls.model.MutableAcl;
import org.springframework.security.acls.model.NotFoundException;
import org.springframework.security.acls.model.ObjectIdentity;
import org.springframework.security.acls.model.Permission;
import org.springframework.security.acls.model.Sid;
import org.springframework.security.acls.model.SidRetrievalStrategy;
import org.springframework.security.acls.model.UnloadedSidException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import architecture.community.security.spring.userdetails.CommuintyUserDetails;
import architecture.community.user.Role;
import architecture.community.user.User;
import architecture.community.util.SecurityHelper;

public class JdbcCommunityAclService extends JdbcMutableAclService {

	private Logger log = LoggerFactory.getLogger(getClass());
	
	private SidRetrievalStrategy sidRetrievalStrategy = new SidRetrievalStrategyImpl();
	
	public JdbcCommunityAclService(DataSource dataSource, LookupStrategy lookupStrategy, AclCache aclCache) {
		super(dataSource, lookupStrategy, aclCache);
	}

	
	/**
	 * 
	 */
	public void initialzie() {

		this.setClassIdentityQuery("classIdentityQuery");
		this.setClassPrimaryKeyQuery("selectClassPrimaryKey");
		this.setDeleteEntryByObjectIdentityForeignKeySql("deleteEntryByObjectIdentityForeignKey");
		this.setDeleteObjectIdentityByPrimaryKeySql("deleteObjectIdentityByPrimaryKey");
		this.setFindChildrenQuery("findChildrenSql");
		this.setForeignKeysInDatabase(false);
		this.setInsertClassSql("insertClass");
		this.setInsertEntrySql("insertEntry");
		this.setInsertObjectIdentitySql("insertObjectIdentity");
		this.setInsertSidSql("insertSid");
		this.setObjectIdentityPrimaryKeyQuery("selectObjectIdentityPrimaryKey");
		this.setSidIdentityQuery("sidIdentityQuery");
		this.setSidPrimaryKeyQuery("selectSidPrimaryKey");
		this.setUpdateObjectIdentity("updateObjectIdentity");
		
	}
	
	public <T> void getFinalGrantedPermissions(  Authentication authentication, Class<T> clazz, Serializable identifier, PermissionsSetter setter ) {	
		ObjectIdentity identity = new ObjectIdentityImpl(clazz.getCanonicalName(), identifier);
		
		log.debug("final granted permission for {}({})" ,  clazz.getCanonicalName() ,  identifier );
		MutableAcl acl = (MutableAcl) readAclById(identity);
		log.debug("final granted permission entries: {}" , acl.getEntries() );
		
		List<Sid> sids = sidRetrievalStrategy.getSids(authentication);	
		
		// checking anonymous !!
		boolean isAnonymous = false;
		if (authentication.getPrincipal() instanceof CommuintyUserDetails ){
			isAnonymous = ((CommuintyUserDetails) authentication.getPrincipal()).getUser().isAnonymous() ;
		}
		
		if( ! isAnonymous ) {
			sids.add(new PrincipalSid(SecurityHelper.ANONYMOUS_USER_DETAILS.getUser().getUsername()));
		}
		
		setter.execute( sids, acl);	
	}
	
	/**
	 * 
	 * @param authentication
	 * @param identity
	 * @param permissions
	 * @return
	 */
	public <T> boolean isPermissionGrantedFinally(Authentication authentication, ObjectIdentity identity, List<Permission> permissions) {		
			
		boolean isGranted = false;			
		MutableAcl acl;
		
		try {
			acl = (MutableAcl) readAclById(identity);
		} catch (NotFoundException e1) {
			return isGranted ;
		}
		
		List<Sid> sids = sidRetrievalStrategy.getSids(authentication);
		boolean isAnonymous = false;
		List<Permission> permissionsToUse = permissions;
		// checking anonymous !!
		if (authentication.getPrincipal() instanceof CommuintyUserDetails ){
			isAnonymous = ((CommuintyUserDetails) authentication.getPrincipal()).getUser().isAnonymous() ;
		}
		if( !isAnonymous ) {
			sids.add(new PrincipalSid(SecurityHelper.ANONYMOUS_USER_DETAILS.getUser().getUsername()));
		}
					
		try {
			
			if (!permissions.contains(CommunityPermissions.ADMIN) ) {
				isGranted = acl.isGranted(Arrays.asList( (Permission)CommunityPermissions.ADMIN) , sids, false);				
			}
			
			log.debug( "Checking permissions {} for {}", permissionsToUse, sids );
			if( isGranted ) {
				isGranted = acl.isGranted(permissionsToUse, sids, false);
			}
			
		} catch (NotFoundException e) {
			log.warn("Unable to find an ACE for the given object", e);
		} catch (UnloadedSidException e) {
			log.error("Unloaded Sid", e);
		}

		return isGranted;
	}
	

	/**
	 * 지정된 객체에 대하여 부여된 모든 권한 정보를 리턴한다.
	 * 
	 * @param clazz
	 * @param identifier
	 * @return
	 */
	public <T> List<AccessControlEntry> getAsignedPermissions(Class<T> clazz, Serializable identifier) {
		try {
			ObjectIdentity identity = new ObjectIdentityImpl(clazz.getCanonicalName(), identifier);
			MutableAcl acl = (MutableAcl) readAclById(identity);		
			List<AccessControlEntry> entries = acl.getEntries();
			return entries;
		} catch (NotFoundException e) {
			return Collections.EMPTY_LIST;
		}
	}
	
	/**
	 * 지정된 객체에 대한 권한이 있는가를 리턴한다.
	 * 사용자에게 부여된 롤에 대한 권한 역시 동시에 검사하여 결과에 반영한다.
	 * 
	 * @param clazz
	 * @param identifier
	 * @param user
	 * @param permissions
	 * @return
	 */
	public <T> boolean isPermissionGranted(Class<T> clazz, Serializable identifier, UserDetails user, Permission... permissions) {		
		ObjectIdentity identity = new ObjectIdentityImpl(clazz.getCanonicalName(), identifier);
		boolean isGranted = false;			
		MutableAcl acl;
		try {
			acl = (MutableAcl) readAclById(identity);
		} catch (NotFoundException e1) {
			return isGranted ;
		}		

		List<Sid> list = new ArrayList<Sid>();
		list.add(new PrincipalSid(user.getUsername()));
		
		for( GrantedAuthority authority : user.getAuthorities() ) {
			list.add(new GrantedAuthoritySid(authority.getAuthority()));
		}		
				
		try {
			isGranted = acl.isGranted(Arrays.asList(permissions), list, false);
		} catch (NotFoundException e) {
			log.warn("Unable to find an ACE for the given object", e);
		} catch (UnloadedSidException e) {
			log.error("Unloaded Sid", e);
		}

		return isGranted;
	}
	
	public <T> boolean isPermissionGrantedToAnonymous(Class<T> clazz, Serializable identifier, Permission... permissions) {	
		return isPermissionGranted(clazz, identifier, SecurityHelper.ANONYMOUS_USER_DETAILS , permissions);
	}
	
	public <T> void addAnonymousPermission(Class<T> clazz, Serializable identifier, Permission permission) {	
		 addPermission(clazz, identifier, SecurityHelper.ANONYMOUS_USER_DETAILS.getUser() , permission);
	}

	public <T> void removeAnonymousPermission(Class<T> clazz, Serializable identifier, Permission permission) {	
		removePermission(clazz, identifier, SecurityHelper.ANONYMOUS_USER_DETAILS.getUser() , permission);
	}
	
	public <T> void addPermission(Class<T> clazz, Serializable identifier, User user, Permission permission) {
		ObjectIdentity identity = new ObjectIdentityImpl(clazz, identifier);
		MutableAcl acl = isNewAcl(identity);
		isPermissionGranted(permission, new PrincipalSid(user.getUsername()), acl);
		updateAcl(acl);
	}


	public <T> boolean isPermissionGranted(Class<T> clazz, Serializable identifier, User user, Permission... permissions) {
		Sid sid = new PrincipalSid(user.getUsername());
		ObjectIdentity identity = new ObjectIdentityImpl(clazz.getCanonicalName(), identifier);
		MutableAcl acl = (MutableAcl) readAclById(identity);		

		boolean isGranted = false;
		try {
			isGranted = acl.isGranted(Arrays.asList(permissions), Arrays.asList(sid), false);
		} catch (NotFoundException e) {
			log.info("Unable to find an ACE for the given object", e);
		} catch (UnloadedSidException e) {
			log.error("Unloaded Sid", e);
		}

		return isGranted;
	}

	public <T> void removePermission(Class<T> clazz, Serializable identifier, User user, Permission permission) {
		Sid sid = new PrincipalSid(user.getUsername());
		ObjectIdentity identity = new ObjectIdentityImpl(clazz.getCanonicalName(), identifier);
		MutableAcl acl = (MutableAcl) readAclById(identity);		
		AccessControlEntry[] entries = acl.getEntries().toArray(new AccessControlEntry[acl.getEntries().size()]);		
		for (int i = 0; i < acl.getEntries().size(); i++) {
			if (entries[i].getSid().equals(sid) && entries[i].getPermission().equals(permission)) {
				acl.deleteAce(i);
			}
		}		
		updateAcl(acl);
	}
	
	public <T> void addPermission(Class<T> clazz, Serializable identifier, Role role, Permission permission) {
		ObjectIdentity identity = new ObjectIdentityImpl(clazz, identifier);
		MutableAcl acl = isNewAcl(identity);
		isPermissionGranted(permission, new GrantedAuthoritySid(role.getName()), acl);
		updateAcl(acl);
	}


	public <T> boolean isPermissionGranted(Class<T> clazz, Serializable identifier, Role role, Permission... permissions) {
		Sid sid = new GrantedAuthoritySid(role.getName());
		ObjectIdentity identity = new ObjectIdentityImpl(clazz.getCanonicalName(), identifier);
		MutableAcl acl = (MutableAcl) readAclById(identity);		
		boolean isGranted = false;
		try {
			isGranted = acl.isGranted(Arrays.asList(permissions), Arrays.asList(sid), false);
		} catch (NotFoundException e) {
			log.info("Unable to find an ACE for the given object", e);
		} catch (UnloadedSidException e) {
			log.error("Unloaded Sid", e);
		}

		return isGranted;
	}

	public <T> void removePermission(Class<T> clazz, Serializable identifier, Role role, Permission permission) {
		Sid sid = new GrantedAuthoritySid(role.getName());
		ObjectIdentity identity = new ObjectIdentityImpl(clazz.getCanonicalName(), identifier);
		MutableAcl acl = (MutableAcl) readAclById(identity);		
		AccessControlEntry[] entries = acl.getEntries().toArray(new AccessControlEntry[acl.getEntries().size()]);		
		for (int i = 0; i < acl.getEntries().size(); i++) {
			if (entries[i].getSid().equals(sid) && entries[i].getPermission().equals(permission)) {
				acl.deleteAce(i);
			}
		}		
		updateAcl(acl);
	}
	
	
	private void isPermissionGranted(Permission permission, Sid sid, MutableAcl acl) {
		try {
			acl.isGranted(Arrays.asList(permission), Arrays.asList(sid), false);
		} catch (NotFoundException e) {
			acl.insertAce(acl.getEntries().size(), permission, sid, true);
		}
	}
	
	private MutableAcl isNewAcl(ObjectIdentity identity) {
		MutableAcl acl;
		try {
			acl = (MutableAcl) readAclById(identity);
		} catch (NotFoundException e) {
			acl = createAcl(identity);
		}
		return acl;
	}

}
