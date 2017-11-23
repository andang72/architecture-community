package architecture.community.web.spring.controller.data;

import java.util.Date;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.user.EmailAlreadyExistsException;
import architecture.community.user.User;
import architecture.community.user.UserAlreadyExistsException;
import architecture.community.user.UserManager;
import architecture.community.user.UserTemplate;
import architecture.community.util.SecurityHelper;
import architecture.community.web.model.json.RequestData;
import architecture.community.web.model.json.Result;

@Controller("accounts-data-controller")
@RequestMapping("/data/accounts")
public class AccountsDataController {

	private Logger logger = LoggerFactory.getLogger(getClass());	
	
	
	@Inject
	@Qualifier("userManager")
	private UserManager userManager;
	
	
	@RequestMapping(value = "/signup-with-data.json", method = { RequestMethod.POST})
	@ResponseBody
	public Object signupByJson(@RequestBody RequestData data, NativeWebRequest request) {		
		
		String nameToUse =  data.getDataAsString("name", null);
		String emailToUse =  data.getDataAsString("email", null);
		String usernameToUse = extractUsernameFromEmail(emailToUse);
		String passwordToUse =  data.getDataAsString("password", null);
		boolean mameVisible =  data.getDataAsBoolean("nameVisible", false);
		boolean emailVisible =  data.getDataAsBoolean("emailVisible", false);		
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
	
	@RequestMapping(value = "/signup-with-user.json", method = { RequestMethod.POST})
	@ResponseBody
	public Result signup(@RequestBody SignupForm user, NativeWebRequest request)  {		
		Result result = Result.newResult();	
		result.setAnonymous(true);	

		logger.debug(user.getName());
		logger.debug(user.getEmail());
		logger.debug(user.getPassword());
		try {
			
			User newUser = new UserTemplate(user.email, user.password, user.name, user.mameVisible, user.email, user.emailVisible);				
			User registeredUser = userManager.createUser(newUser);
			result.getData().put("user", registeredUser);
			result.setCount(1);
			
		} catch (Exception e) {			
			result.setError(e);
		}
		return result;	
	}
	
	private String extractUsernameFromEmail(String email){		
		int index = email.indexOf('@');
		return email.substring(0, index );
	}
	
	
	private static class SignupForm {
		
		private String name ;
		private String password;
		private String email;
		private Boolean mameVisible;
		private Boolean emailVisible;
		 
		
		public SignupForm() {
			mameVisible = false;
			emailVisible = false;
		}
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public String getPassword() {
			return password;
		}
		public void setPassword(String password) {
			this.password = password;
		}
		public String getEmail() {
			return email;
		}
		public void setEmail(String email) {
			this.email = email;
		}

		public Boolean getMameVisible() {
			return mameVisible;
		}
		public void setMameVisible(Boolean mameVisible) {
			this.mameVisible = mameVisible;
		}
		public Boolean getEmailVisible() {
			return emailVisible;
		}
		public void setEmailVisible(Boolean emailVisible) {
			this.emailVisible = emailVisible;
		}
		
		public String toString() {
			StringBuilder builder = new StringBuilder();
			builder.append("SignupForm [");
			if (name != null)
				builder.append("name=").append(name).append(", ");
			if (password != null)
				builder.append("password=").append(password).append(", ");
			if (email != null)
				builder.append("email=").append(email);
			builder.append("]");
			return builder.toString();
		}
		
	}
}
