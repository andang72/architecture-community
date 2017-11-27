package architecture.community.security.spring.acls;

import java.io.Serializable;
import java.util.Arrays;

import javax.sql.DataSource;

import org.springframework.security.acls.domain.ObjectIdentityImpl;
import org.springframework.security.acls.domain.PrincipalSid;
import org.springframework.security.acls.jdbc.JdbcMutableAclService;
import org.springframework.security.acls.jdbc.LookupStrategy;
import org.springframework.security.acls.model.AccessControlEntry;
import org.springframework.security.acls.model.AclCache;
import org.springframework.security.acls.model.MutableAcl;
import org.springframework.security.acls.model.NotFoundException;
import org.springframework.security.acls.model.ObjectIdentity;
import org.springframework.security.acls.model.Permission;
import org.springframework.security.acls.model.Sid;
import org.springframework.security.acls.model.UnloadedSidException;

import architecture.community.user.User;

public class JdbcCommunityAclService extends JdbcMutableAclService {

	public JdbcCommunityAclService(DataSource dataSource, LookupStrategy lookupStrategy, AclCache aclCache) {
		super(dataSource, lookupStrategy, aclCache);
	}

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

	
	public <T> void addPermission(Class<T> clazz, Serializable identifier, User user, Permission permission) {
		ObjectIdentity identity = new ObjectIdentityImpl(clazz, identifier);
		MutableAcl acl = isNewAcl(identity);
		isPermissionGranted(permission, new PrincipalSid(user.getUsername()), acl);
		updateAcl(acl);
	}


	public <T> boolean isPermissionGranted(Class<T> clazz, Serializable identifier, User user, Permission permission) {
		Sid sid = new PrincipalSid(user.getUsername());
		ObjectIdentity identity = new ObjectIdentityImpl(clazz.getCanonicalName(), identifier);
		MutableAcl acl = (MutableAcl) readAclById(identity);		
		boolean isGranted = false;
		try {
			isGranted = acl.isGranted(Arrays.asList(permission), Arrays.asList(sid), false);
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
