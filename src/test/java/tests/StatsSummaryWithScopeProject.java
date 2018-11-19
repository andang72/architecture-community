package tests;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.ui.Model;

import architecture.community.page.api.Api;
import architecture.community.projects.Project;
import architecture.community.projects.ProjectNotFoundException;
import architecture.community.projects.ProjectService;
import architecture.community.projects.Stats; 

public class StatsSummaryWithScopeProject extends architecture.community.web.spring.view.AbstractScriptDataView  {

	@Inject
	@Qualifier("projectService")
	private ProjectService projectService;
	
	public Object handle(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Api page = getApi(model);  
		//Map<String, String> variables = model.get("__variables"); 
		//Long projectId = getLongProperty( variables, "projectId", -1L ); 
		Long projectId = 1L;
		Project project = getProject(projectId);
		
		Map<String, Stats> map = new HashMap<String, Stats>(); 
		map.put("issueTypeStats", projectService.getIssueTypeStats(project));
		map.put("issueResolutionStats", projectService.getIssueResolutionStats(project));
		return map;
	}

	private Project getProject(Long projectId) throws ProjectNotFoundException{
		Project project = projectService.getProject(projectId);
		return project;
	}

}
