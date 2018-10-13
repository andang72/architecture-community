package architecture.community.web.spring.view;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.web.servlet.View;

import architecture.community.web.util.ServletUtils;
import architecture.ee.util.StringUtils;

public abstract class AbstractScriptView implements View {

	private static final String DEFAULT_PREFIX = "view.";
	
	private String prefix = DEFAULT_PREFIX ;
	
	protected Logger log = LoggerFactory.getLogger(getClass());
	
	public AbstractScriptView() {
		
	}

	public String getPrefix() {
		return prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}

	public String getContentType() { 
		return ServletUtils.DEFAULT_HTML_CONTENT_TYPE;
	}
	
	public void render(Map<String, ?> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		if (log.isTraceEnabled()) {
			log.trace("Rendering view {} with model '{}'", getClass().getName(), model );
		}
		prepareResponse(request, response);
		renderMergedOutputModel((Map<String, Object>) model, request, response); 
	}
	
	protected abstract void renderMergedOutputModel( Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	protected void prepareResponse(HttpServletRequest request, HttpServletResponse response) {
		
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
