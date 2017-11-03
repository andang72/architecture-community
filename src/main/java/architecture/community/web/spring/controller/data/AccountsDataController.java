package architecture.community.web.spring.controller.data;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.user.User;
import architecture.community.user.UserManager;
import architecture.community.user.UserTemplate;
import architecture.community.web.model.json.RequestData;
import architecture.community.web.model.json.Result;

@Controller("accounts-data-controller")
@RequestMapping("/data/accounts")
public class AccountsDataController {

	private Logger logger = LoggerFactory.getLogger(getClass());	
	
	
	@Inject
	@Qualifier("userManager")
	private UserManager userManager;
	
	
	@RequestMapping(value = "/signup.json", method = { RequestMethod.POST})
	@ResponseBody
	public Object signupByJson(@RequestBody RequestData data, NativeWebRequest request) {		
		String nameToUse = (String)data.getData().getOrDefault("name", null);
		String emailToUse = (String)data.getData().getOrDefault("email", null);
		String usernameToUse = extractUsernameFromEmail(emailToUse);
		String passwordToUse = (String)data.getData().getOrDefault("password", null);
		boolean mameVisible = (Boolean)data.getData().getOrDefault("nameVisible", false);
		boolean emailVisible = (Boolean) data.getData().getOrDefault("emailVisible", false);		
		String ipAddress = request.getNativeRequest(HttpServletRequest.class).getRemoteAddr();		
		User newUser = new UserTemplate(usernameToUse, passwordToUse, nameToUse, mameVisible, emailToUse, emailVisible);		
		
		Result result = Result.newResult();	
		result.setAnonymous(true);		
		try {
			User user = userManager.createUser(newUser);			
			result.setCount(1);
			result.setSuccess(true);
			result.getData().put("user", user);
		} catch (Exception e) {			
			result.setError(e);
		}
		return result;	
	}
	
	private String extractUsernameFromEmail(String email){		
		int index = email.indexOf('@');
		return email.substring(0, index );
	}
	
}
