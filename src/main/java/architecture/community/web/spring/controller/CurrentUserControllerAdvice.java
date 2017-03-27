package architecture.community.web.spring.controller;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import architecture.community.spring.security.userdetails.CommuintyUserDetails;
import architecture.community.user.User;
import architecture.community.util.SecurityHelper;

@ControllerAdvice
public class CurrentUserControllerAdvice {

	@ModelAttribute("currentUser")
    public User getCurrentUser(Authentication authentication) {
        return (authentication == null) ? SecurityHelper.ANONYMOUS : ((CommuintyUserDetails)authentication.getPrincipal()).getUser();
    }
	
}
