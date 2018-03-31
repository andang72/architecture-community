package architecture.community.web.spring.controller.data;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import architecture.community.web.spring.controller.data.v1.AbstractCommunityDateController;

@Controller("data-api-v2-community-controller")
@RequestMapping("/data/api/v2")
public class V2CommunityDataController extends AbstractCommunityDateController  {

	public V2CommunityDataController() {
		
	}

}
