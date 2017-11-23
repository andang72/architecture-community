package architecture.community.web.spring.controller.data.v1;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import architecture.community.exception.NotFoundException;
import architecture.community.exception.UnAuthorizedException;
import architecture.community.image.DefaultImage;
import architecture.community.image.Image;
import architecture.community.link.ExternalLink;
import architecture.community.model.ModelObjectAwareSupport;
import architecture.community.model.Models;
import architecture.community.security.spring.userdetails.CommuintyUserDetails;
import architecture.community.user.AvatarImage;
import architecture.community.user.User;
import architecture.community.user.UserAvatarService;
import architecture.community.util.SecurityHelper;
import architecture.community.web.model.json.Result;
import architecture.community.web.spring.controller.data.ImageDataController;

@Controller("community-data-v1-user-controller")
@RequestMapping("/data/v1/users")
public class UserDateController {

	private Logger log = LoggerFactory.getLogger(ImageDataController.class);
	 
	@Inject
	@Qualifier("userAvatarService")
	private UserAvatarService userAvatarService;

	
	@Secured({ "ROLE_USER" })
    @RequestMapping(value = "/upload_avatar_image.json", method = RequestMethod.POST)
    @ResponseBody
    public Result uploadUserAvatarImage(
    		MultipartHttpServletRequest request) throws NotFoundException, IOException, UnAuthorizedException {
		
		Result result = Result.newResult();
		result.setAnonymous(false);		
		
		User user = SecurityHelper.getUser();				
		if( user.isAnonymous() )			
		    throw new UnAuthorizedException();			
		
		AvatarImage imageToUse = new AvatarImage(user);		
		Iterator<String> names = request.getFileNames();		
		while (names.hasNext()) {
		    String fileName = names.next();
		    MultipartFile mpf = request.getFile(fileName);
		    InputStream is = mpf.getInputStream();
		    log.debug("upload  file:{}, size:{}, type:{} ", mpf.getOriginalFilename(), mpf.getSize() , mpf.getContentType() );		    
		    imageToUse.setFilename(mpf.getOriginalFilename());
		    imageToUse.setImageContentType(mpf.getContentType());
		    imageToUse.setImageSize((int) mpf.getSize());		    
		    userAvatarService.addAvatarImage(imageToUse, is, user);
		    result.setCount( result.getCount() + 1);
		}
		return result;
    }
		
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