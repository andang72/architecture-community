package architecture.community.web.spring.view;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.View;

import architecture.community.web.util.ServletUtils;

public abstract class AbstractScriptView extends ScriptSupport implements View {

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
	
}
