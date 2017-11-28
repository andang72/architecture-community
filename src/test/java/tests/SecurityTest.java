package tests;


import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.acls.domain.BasePermission;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import architecture.community.board.Board;
import architecture.community.security.spring.acls.JdbcCommunityAclService;
import architecture.community.security.spring.userdetails.CommuintyUserDetails;
import architecture.community.security.spring.userdetails.CommunityUserDetailsService;
import architecture.community.user.Role;
import architecture.community.user.RoleManager;
import architecture.community.user.RoleNotFoundException;
import architecture.community.user.User;
import architecture.community.user.UserManager;
import architecture.community.user.UserNotFoundException;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration("WebContent/")
@ContextConfiguration(locations = { "classpath:application-community-context.xml", "classpath:context/community-security-acls-context.xml" })
public class SecurityTest {

	
	@Autowired private UserManager userManager;
	
	@Autowired private RoleManager roleManager;
	
	@Autowired private CommunityUserDetailsService userDetailsManager;
	
	@Autowired private JdbcCommunityAclService aclService;
	
	@Rule public ExpectedException exception = ExpectedException.none();
	
	private static final Logger log = LoggerFactory.getLogger(SecurityTest.class);
	
	@Before
	public void setup() {
		
	}
	
	@Test
	public void testRolePermission() throws UserNotFoundException, RoleNotFoundException {
		
		
		setAuthentication("king");
		Role role = roleManager.getRole("ROLE_ADMINISTRATOR");
		
		CommuintyUserDetails details = (CommuintyUserDetails)userDetailsManager.loadUserByUsername("king");
		
		
		aclService.addPermission(Board.class, 1, role, BasePermission.READ);
		
		boolean isGranted = aclService.isPermissionGranted(Board.class, 1, details.getUser(), BasePermission.READ);
		
		log.debug("============== {} isGranted:{}", details.getUsername(),  isGranted);
		
		aclService.removePermission(Board.class, 1, role, BasePermission.READ);
	}
	

	@Test
	public void testGrantedPermission() throws UserNotFoundException {
		
		setAuthentication("dhson@podosw.com");
		User user = userManager.getUser("dhson@podosw.com");
		boolean isGranted = aclService.isPermissionGranted(Board.class, 1, user, BasePermission.READ);
		log.debug("============== isGranted:{}", isGranted);
	}
	
	
	@Test
	public void testPermission() throws UserNotFoundException {
		
		
		setAuthentication("king");
		User user = userManager.getUser("king");
		
		aclService.addPermission(Board.class, 1, user, BasePermission.READ);
		
		boolean isGranted = aclService.isPermissionGranted(Board.class, 1, user, BasePermission.READ);
		log.debug("============== isGranted:{}", isGranted);
		
		aclService.removePermission(Board.class, 1, user, BasePermission.READ);
	}
	
	private  void setAuthentication(String username) {
		UserDetails user = userDetailsManager.loadUserByUsername(username);
		Authentication authentication = new UsernamePasswordAuthenticationToken(user.getUsername(), user.getPassword(), user.getAuthorities());
		SecurityContextHolder.getContext().setAuthentication(authentication);
	}
	
	
	@After
	public void tearDown() {

	}
}
