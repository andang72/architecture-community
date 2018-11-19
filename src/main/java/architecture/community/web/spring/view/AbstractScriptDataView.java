package architecture.community.web.spring.view;

import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.ui.Model;

import architecture.community.page.api.Api;
import architecture.community.security.spring.acls.CommunityAclService;
import architecture.community.security.spring.acls.JdbcCommunityAclService.PermissionsBundle;
import architecture.community.user.User;
import architecture.community.user.UserManager;
import architecture.community.user.UserNotFoundException;
import architecture.community.util.SecurityHelper;

public abstract class AbstractScriptDataView extends ScriptSupport implements DataView {

	protected Logger log = LoggerFactory.getLogger(getClass());
	
	private static final String DEFAULT_PREFIX = "api.";
	
	private String prefix = DEFAULT_PREFIX ;
	
	@Inject
	@Qualifier("userManager")
	private UserManager userManager;
	
	@Inject
	@Qualifier("communityAclService")
	private CommunityAclService communityAclService;
	
		
	public AbstractScriptDataView() { 
		
	} 
	
	public String getPrefix() {
		return prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}
	
	protected Api getApi(Model model){
		return (Api) model.asMap().get("__page");
	}
	
	protected Map<String, String> getVariables(Model model){
		return (Map<String, String>) model.asMap().get("__variables");
	} 
	
	protected PermissionsBundle getPermissionsBundle(Class objectType, Long objectId ) {		
		return communityAclService.getPermissionBundle( SecurityHelper.getAuthentication() , objectType , objectId );
	}
 	
	
	protected User getUserById(String userId) throws UserNotFoundException {
 		return userManager.getUser(Long.parseLong(userId)); 
	}
	
	protected User getUserById(long userId) throws UserNotFoundException {
 		return userManager.getUser(userId); 
	}
	

}
