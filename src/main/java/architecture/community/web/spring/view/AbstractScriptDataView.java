package architecture.community.web.spring.view;

import java.io.IOException;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpInputMessage;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.security.core.Authentication;
import org.springframework.ui.Model;

import architecture.community.page.api.Api;
import architecture.community.projects.Project;
import architecture.community.projects.ProjectView;
import architecture.community.security.spring.acls.CommunityAclService;
import architecture.community.security.spring.acls.JdbcCommunityAclService.PermissionsBundle;
import architecture.community.security.spring.userdetails.CommuintyUserDetails;
import architecture.community.user.User;
import architecture.community.user.UserManager;
import architecture.community.user.UserNotFoundException;
import architecture.community.util.SecurityHelper;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.ee.util.StringUtils;

public abstract class AbstractScriptDataView implements DataView {

	protected Logger log = LoggerFactory.getLogger(getClass());
		
	@Inject
	@Qualifier("userManager")
	private UserManager userManager;
	
	@Inject
	@Qualifier("communityAclService")
	private CommunityAclService communityAclService;
	
		
	public AbstractScriptDataView() { 
		
	} 
	
	protected Api getApi(Model model){
		return (Api) model.asMap().get("__page");
	}
	
	
	protected PermissionsBundle getPermissionsBundle(Class objectType, Long objectId ) {		
		return communityAclService.getPermissionBundle( SecurityHelper.getAuthentication() , objectType , objectId );
	}
	
	protected DataSourceRequest getDataSourceRequest(HttpServletRequest request) {
		return getRequestBodyObject (DataSourceRequest.class, request );
	}
	
	protected <T> T getRequestBodyObject(Class<T> requiredType, HttpServletRequest request) {
		HttpInputMessage inputMessage = new ServletServerHttpRequest(request);
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        try {
			return  (T) converter.read(requiredType, inputMessage );
		
        } catch (IOException e) {
			log.warn("error : {}", e);
			return null;
		}
	}
	
	
	protected User getUserById(String userId) throws UserNotFoundException {
 		return userManager.getUser(Long.parseLong(userId)); 
	}
	
	protected User getUserById(long userId) throws UserNotFoundException {
 		return userManager.getUser(userId); 
	}
	
	public String getProperty( Map<String, String> properties, String name, String defaultValue) {
		return StringUtils.defaultString( properties.get( name ), defaultValue );
	}
	
	public Boolean getBooleanProperty( Map<String, String> properties , String key, Boolean defaultValue ) {
		String value = properties.get(key);
		try {
			return Boolean.parseBoolean(value);
		} catch (Exception e) { } 
		return defaultValue;
	}
	
	public Long getLongProperty( Map<String, String> properties , String key, Long defaultValue ) {
		String value = properties.get(key);
		try {
			return Long.parseLong(value);
		} catch (Exception e) { } 
		return defaultValue;
	}	
}
