package architecture.community.web.spring.controller.data.v1;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.acls.model.MutableAcl;
import org.springframework.security.acls.model.NotFoundException;
import org.springframework.security.acls.model.Permission;
import org.springframework.security.acls.model.Sid;
import org.springframework.security.core.Authentication;

import architecture.community.attachment.Attachment;
import architecture.community.board.Board;
import architecture.community.board.BoardService;
import architecture.community.board.BoardView;
import architecture.community.model.Models;
import architecture.community.security.spring.acls.CommunityPermissions;
import architecture.community.security.spring.acls.JdbcCommunityAclService;
import architecture.community.security.spring.acls.PermissionsSetter;
import architecture.community.security.spring.userdetails.CommuintyUserDetails;
import architecture.community.util.SecurityHelper;

public abstract class AbstractCommunityDateController {

	protected Logger log = LoggerFactory.getLogger(getClass());	
	
	protected abstract BoardService getBoardService();
	
	protected abstract JdbcCommunityAclService getCommunityAclService (); 	
	
	protected boolean hasPermission ( int objectType , long objectId,  CommunityPermissions permission ) {	
		return getCommunityAclService().isPermissionGrantedFinally(SecurityHelper.getAuthentication(), Models.valueOf(objectType).getObjectClass(), objectId, Arrays.asList( (Permission) permission));
	}
	
	protected BoardView getBoardView(Board board) {		
		CommuintyUserDetails userDetails = SecurityHelper.getUserDetails();
		log.debug("Board View : {} {} for {}.", board.getBoardId(),  board.getName(), userDetails.getUsername() );		
		PermissionsBundle bundle = getPermissionBundle(Board.class, board.getBoardId());				
		BoardView boardView = new BoardView(board);
		boardView.setWritable(bundle.write);
		boardView.setReadable(bundle.read);
		boardView.setCreateAttachement(bundle.createAttachment);
		boardView.setReadComment(bundle.readComment);
		boardView.setCreateComment(bundle.createComment);
		boardView.setCreateImage(bundle.createImage);
		boardView.setCreateThread(bundle.createThread);
		boardView.setCreateThreadMessage(bundle.createThreadMessage);
		int totalThreadCount = getBoardService().getBoardThreadCount(Models.BOARD.getObjectType(), board.getBoardId());
		int totalMessageCount = getBoardService().getBoardMessageCount(board);	
		boardView.setTotalMessage(totalMessageCount);
		boardView.setTotalThreadCount(totalThreadCount);		
		return boardView;
	}
	
    protected String getEncodedFileName(Attachment attachment) {
		try {
		    return URLEncoder.encode(attachment.getName(), "UTF-8");
		} catch (UnsupportedEncodingException e) {
		    return attachment.getName();
		}
    }
    
    protected PermissionsBundle getPermissionBundle( Class objectType , long objectId ) {    	
    		final PermissionsBundle bundle = new PermissionsBundle();
    		Authentication authentication = SecurityHelper.getAuthentication();
    		getCommunityAclService().getFinalGrantedPermissions(authentication, Board.class,  objectId, new PermissionsSetter() {    			
				
    			private boolean isGranted ( MutableAcl acl, Permission permission, List<Sid> sids ) {
    				boolean isGranted = false;
    				try {
    					isGranted = acl.isGranted(Arrays.asList(permission), sids, false);
				} catch (NotFoundException e) { }	
    				return isGranted;
    			}
    			
    			public void execute(List<Sid> sids, MutableAcl acl) {			 		
					log.debug("anonymous : {}", SecurityHelper.isAnonymous());
			 		if( !SecurityHelper.isAnonymous() )
			 		{
			 			log.debug("is granted {} {}" , CommunityPermissions.ADMIN, sids );
			 			try {
							bundle.admin = isGranted( acl, (Permission)CommunityPermissions.ADMIN, sids);
						} catch (NotFoundException e) {
							
						}			 	
			 			log.debug("is granted {} > {}" , CommunityPermissions.ADMIN, bundle.admin );
			 		}	
			 		
			 		if( bundle.admin ) {
		    				bundle.read = true;
		    				bundle.write = true;
		    				bundle.create = true;
		    				bundle.delete = true;
		    				bundle.createThread = true;
		    				bundle.createThreadMessage = true;
		    				bundle.createAttachment = true;
		    				bundle.createImage = true;
		    				bundle.createComment = true;
		    				bundle.readComment = true;    			 					
					}else {
						bundle.read = isGranted( acl, (Permission)CommunityPermissions.READ, sids);		
						bundle.write = isGranted( acl, (Permission)CommunityPermissions.WRITE, sids);		
						bundle.create = isGranted( acl, (Permission)CommunityPermissions.CREATE, sids);		
						bundle.delete = isGranted( acl, (Permission)CommunityPermissions.DELETE, sids);		
						bundle.createThread = isGranted( acl, (Permission)CommunityPermissions.CREATE_THREAD, sids);		
						bundle.createThreadMessage = isGranted( acl, (Permission)CommunityPermissions.CREATE_THREAD_MESSAGE, sids);		
						bundle.createAttachment = isGranted( acl, (Permission)CommunityPermissions.CREATE_ATTACHMENT, sids);		
						bundle.createImage = isGranted( acl, (Permission)CommunityPermissions.CREATE_IMAGE, sids);		
						bundle.createComment = isGranted( acl, (Permission)CommunityPermissions.CREATE_COMMENT, sids);		
						bundle.readComment = isGranted( acl, (Permission)CommunityPermissions.READ_COMMENT, sids);	
					}
				}});    		
    		return bundle;
    }
    
    static class PermissionsBundle {    	
    		private boolean read = false;
    		private boolean write = false;
    		private boolean create = false;
    		private boolean delete = false;
    		private boolean admin = false;
    		private boolean createThread = false;
    		private boolean createThreadMessage = false;
    		private boolean createAttachment = false;
    		private boolean createImage = false;
    		private boolean createComment = false;
    		private boolean readComment = false;
    }
    
}
