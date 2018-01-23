package architecture.community.web.spring.controller.data.v1;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.exception.NotFoundException;
import architecture.community.query.CustomQueryService;
import architecture.community.query.ParameterValue;
import architecture.community.web.model.ItemList;

@Controller("community-data-v1-aggregate-controller")
@RequestMapping("/data/api/v1/aggregate")
public class AggregateDataController {

	private Logger log = LoggerFactory.getLogger(getClass());	
	
	public AggregateDataController() { 
		
	}
	
	@Inject
	@Qualifier("customQueryService")
	private CustomQueryService customQueryService;
	
	@RequestMapping(value = "/{statement}/list.json", method = {RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList listByStatement(
			@PathVariable String source, 
			@PathVariable String statement, 
			@RequestBody List<ParameterValue> params,
			NativeWebRequest request)
			throws NotFoundException {
		List list = customQueryService.list( statement, params );		
		return new ItemList(list, list.size());		
	}
	
	@RequestMapping(value = "/{source}/{statement}/list.json", method = {RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList listBySourceAndStatement(
			@PathVariable String source, 
			@PathVariable String statement, 
			@RequestBody List<ParameterValue> params,
			NativeWebRequest request)
			throws NotFoundException {
		List list = customQueryService.list(source, statement, params );		
		return new ItemList(list, list.size());		
	}
}
