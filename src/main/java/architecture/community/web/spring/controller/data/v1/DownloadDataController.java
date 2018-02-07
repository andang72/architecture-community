package architecture.community.web.spring.controller.data.v1;

import java.io.IOException;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import architecture.community.export.CommunityExportService;
import architecture.community.web.model.json.DataSourceRequest;

@Controller("download-data-controller")
@RequestMapping("/data/api/v1/export")
public class DownloadDataController {

	private Logger log = LoggerFactory.getLogger(DownloadDataController.class);

	
	@Inject
	@Qualifier("exportService")
	private CommunityExportService exportService;
	
	public DownloadDataController() {
	}
	
	@Secured({ "ROLE_DEVELOPER" })
	@RequestMapping(value = "/excel/{name:.+}", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public void exportAsExcel (
			@PathVariable("name") String name, 
			@RequestBody DataSourceRequest dataSourceRequest,
		    HttpServletResponse response) throws IOException {		
		exportService.export(name, dataSourceRequest.getData(), response);
	}
}
