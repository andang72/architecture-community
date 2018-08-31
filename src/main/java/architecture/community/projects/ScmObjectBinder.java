package architecture.community.projects;

import java.util.Map;

import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.ui.Model;

import architecture.community.web.spring.controller.view.binding.ObjectBinder;
import architecture.ee.util.StringUtils;

/**
 * 
 * 
 * "binding.?.parameters.id"
 * "binding.?.attribute.name"
 * "binding.?.required"
 * 
 * @author donghyuck
 *
 */
public class ScmObjectBinder implements ObjectBinder {

	private static final String PREFIX = "binding.";
	
	public ScmObjectBinder() {
		
	}

	/**
	 * 
	 */
	public void bind(Model model, String name, Map<String, String> properties, Map<String, String> vairables, ConfigurableBeanFactory beanFactory) throws Exception {  
		
		ScmService service = beanFactory.getBean(ScmService.class);
		
		boolean required = getBooleanProperty( properties, new StringBuilder(PREFIX).append(name).append(".required").toString(), false ); 
		
		Long scmId = getLongProperty( vairables, getProperty(properties, name, ".parameters.id", name.toLowerCase() + "Id"), -1L ); 
		
		if( scmId > 0L) {
			try {
				Scm scm = service.getScmById(scmId);
				String attributeName = getProperty(properties, name, ".attribute.name", "__"+name.toLowerCase());
				model.addAttribute(attributeName, scm);
			} catch (ScmNotFoundException e) {
				if( required )
					throw e;
			}
		}
	}
	
	private String getProperty( Map<String, String> properties, String name, String key, String defaultValue) {
		return StringUtils.defaultString(properties.get( new StringBuilder(PREFIX).append(name).append(key).toString() ), defaultValue );
	}
	
	
	private String getStringProperty( Map<String, String> properties , String name, String key, String defaultKey, String defaultValue) {
		String keyToUse = StringUtils.defaultString(properties.get( new StringBuilder(PREFIX).append(name).append(key).toString() ), "");
		return null;
	}

	private Boolean getBooleanProperty( Map<String, String> properties , String key, Boolean defaultValue ) {
		String value = properties.get(key);
		try {
			return Boolean.parseBoolean(value);
		} catch (Exception e) { } 
		return defaultValue;
	}
	
	private Long getLongProperty( Map<String, String> properties , String key, Long defaultValue ) {
		String value = properties.get(key);
		try {
			return Long.parseLong(value);
		} catch (Exception e) { } 
		return defaultValue;
	}
}
