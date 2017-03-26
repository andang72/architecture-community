package architecture.community.web.spring.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import architecture.community.web.util.ServletUtils;
import architecture.ee.util.StringUtils;

@Controller("accounts-page-controller")
@RequestMapping("/accounts")
public class AccountsPageController {
	
	private Logger logger = LoggerFactory.getLogger(getClass());
		
	@RequestMapping(value={"/signin","/login"}, method = { RequestMethod.POST, RequestMethod.GET } )
    public String displayLoginPage(
    		@RequestParam(value="redirect_after_login", defaultValue="/", required=false ) String returnUrl,
    		@RequestParam(value="error", defaultValue="false", required=false ) boolean hasError,
    		HttpServletRequest request, 
    		HttpServletResponse response, 
    		Model model) {		
		
		ServletUtils.setContentType(null, response);		
		model.addAttribute("error", hasError);
		model.addAttribute("returnUrl", returnUrl);				
		//login form for update page
        //if login error, get the targetUrl from session again.
		String targetUrl = getRememberMeTargetUrlFromSession(request);
		logger.debug("targetUrl : {0}", targetUrl);
		if(StringUtils.isNullOrEmpty(targetUrl)){
			model.addAttribute("targetUrl", targetUrl);
			model.addAttribute("loginUpdate", true);
		}		
        return "/accounts/login";        
    }

	@RequestMapping(value={"/join","/signup"}, method = { RequestMethod.POST, RequestMethod.GET } )
    public String displaySignupPage(@RequestParam(value="url", defaultValue="/", required=false ) String returnUrl,
    		HttpServletRequest request, 
    		HttpServletResponse response, 
    		Model model) {		
		
		ServletUtils.setContentType(null, response);		
		model.addAttribute("returnUrl", returnUrl);	
		
        return "/accounts/signup";        
    }
	
	private String getRememberMeTargetUrlFromSession(HttpServletRequest request){
		String targetUrl = "";
		HttpSession session = request.getSession(false);
		if(session!=null){
			targetUrl = session.getAttribute("targetUrl")==null?"":session.getAttribute("targetUrl").toString();
		}
		return targetUrl;
	}
}
