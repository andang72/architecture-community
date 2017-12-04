package architecture.community.web.spring.controller.data.v1;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.security.spring.userdetails.CommuintyUserDetails;
import architecture.community.user.User;
import architecture.community.util.SecurityHelper;

@Controller("community-data-v1-user-controller")
@RequestMapping("/data/v1/users")
public class UserDataController {
		
	@PreAuthorize("permitAll")
    @RequestMapping(value = "/me.json", method = { RequestMethod.POST, RequestMethod.GET })
    @ResponseBody
    public UserDetails getUserDetails(Authentication authentication, NativeWebRequest request) {		
		if( authentication != null ) {
			CommuintyUserDetails userDetails = (CommuintyUserDetails) authentication.getPrincipal();
			return new UserDetails(userDetails.getUser(), getRoles(userDetails.getAuthorities()));
		}else {
			return new UserDetails(SecurityHelper.ANONYMOUS, Collections.EMPTY_LIST);
		}
	}
	
	protected List<String> getRoles(Collection<GrantedAuthority> authorities) {
		List<String> list = new ArrayList<String>();
		for (GrantedAuthority auth : authorities) {
		    list.add(auth.getAuthority());
		}
		return list;
	}
		
	public static class UserDetails {
		private User user;		
		private List<String> roles;
		
		public UserDetails() {
		}
		
		public UserDetails(User user, List<String> roles) {
		    this.user = user;
		    this.roles = roles;
		}

		/**
		 * @return user
		 */
		public User getUser() {
		    return user;
		}

		/**
		 * @param user
		 *            설정할 user
		 */
		public void setUser(User user) {
		    this.user = user;
		}

		/**
		 * @return roles
		 */
		public List<String> getRoles() {
		    return roles;
		}

		/**
		 * @param roles
		 *            설정할 roles
		 */
		public void setRoles(List<String> roles) {
		    this.roles = roles;
		}
	}
	
}