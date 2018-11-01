package services.script
 
 /** common package import here! */
import java.util.Map;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Qualifier;


/** custom package import here! */

import architecture.community.page.Page;
import architecture.community.projects.Scm;
import architecture.community.projects.ScmService;
import architecture.community.projects.ScmNotFoundException

public class ScmView extends architecture.community.web.spring.view.AbstractScriptView  {

	
	@Inject
	@Qualifier("scmService")
	private ScmService scmService;
	
	
	public ScmView() { 
		
	} 

	protected void renderMergedOutputModel(
		Map<String, Object> model, 
		HttpServletRequest request, 
		HttpServletResponse response) throws Exception { 
		Page page = model.get("__page");
		Map<String, String> variables = model.get("__variables");

		String name = "scm"; 		
		boolean required =  getBooleanProperty( page.getProperties(), new StringBuilder(getPrefix()).append("parameters.").append(name).append(".required").toString(), false );
		Long scmId = getLongProperty( variables, getProperty( page.getProperties(), new StringBuilder(getPrefix()).append("parameters.").append(name).append(".key").toString(), name.toLowerCase() + "Id"), -1L ); 
		if( scmId > 0L) {
			try {
				Scm scm = scmService.getScmById(scmId);
				String attributeName = getProperty(page.getProperties(), new StringBuilder(getPrefix()).append("attributes.").append(name).append(".key").toString() , "__"+name.toLowerCase());
				model.addAttribute(attributeName, scm);
			} catch (ScmNotFoundException e) {
				if( required )
					throw e;
			}
		} 
	}
 

}