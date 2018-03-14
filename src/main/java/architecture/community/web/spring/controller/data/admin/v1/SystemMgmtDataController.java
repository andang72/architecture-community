package architecture.community.web.spring.controller.data.admin.v1;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.exception.NotFoundException;
import architecture.community.model.Property;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.ee.service.ConfigService;

/**
 * 시스템 관리자 API
 * @author donghyuck
 *
 */

@Controller("community-data-v1-mgmt-system-controller")
@RequestMapping("/data/api/mgmt/v1")
public class SystemMgmtDataController {

	
	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	public SystemMgmtDataController() {
	}


	/**
	 * CONFIG API 
	******************************************/
	
	private List<Property> getApplicationProperties(){
		List<String> propertyKeys = configService.getApplicationPropertyNames();
		List<Property> list = new ArrayList<Property>(); 
		for( String key : propertyKeys ) {
			String value = configService.getApplicationProperty(key);
			list.add(new Property( key, value ));
		}
		return list ;
	}
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/properties/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Property> getConfig(@RequestBody DataSourceRequest dataSourceRequest, NativeWebRequest request){ 
		return getApplicationProperties() ;
	}
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/properties/update.json", method = RequestMethod.POST)
	@ResponseBody
	public List<Property> updatePageProperties( 
			@RequestBody List<Property> newProperties, 
			NativeWebRequest request) throws NotFoundException {
 
		// update or create
		for (Property property : newProperties) {
			configService.setApplicationProperty(property.getName(), property.getValue());
		}		
		return getApplicationProperties();
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/properties/delete.json", method = { RequestMethod.POST, RequestMethod.DELETE })
	@ResponseBody
	public List<Property> deletePageProperties(  
			@RequestBody List<Property> newProperties, NativeWebRequest request) throws NotFoundException {
		
		for (Property property : newProperties) {
			configService.deleteApplicationProperty(property.getName());
		}
		return getApplicationProperties();
	}
}
