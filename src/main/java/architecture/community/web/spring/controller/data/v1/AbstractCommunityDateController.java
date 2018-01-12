package architecture.community.web.spring.controller.data.v1;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Arrays;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.acls.model.Permission;

import architecture.community.attachment.Attachment;
import architecture.community.board.Board;
import architecture.community.board.BoardService;
import architecture.community.board.BoardView;
import architecture.community.model.Models;
import architecture.community.projects.Project;
import architecture.community.projects.ProjectView;
import architecture.community.security.spring.acls.CommunityPermissions;
import architecture.community.security.spring.acls.JdbcCommunityAclService;
import architecture.community.security.spring.acls.JdbcCommunityAclService.PermissionsBundle;
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
		PermissionsBundle bundle = getCommunityAclService().getPermissionBundle(SecurityHelper.getAuthentication(), Board.class, board.getBoardId());				
		BoardView boardView = new BoardView(board);
 
		boardView.setWritable(bundle.isWrite());
		boardView.setReadable(bundle.isRead());
		boardView.setCreateAttachement(bundle.isCreateAttachment());
		boardView.setReadComment(bundle.isReadComment());
		boardView.setCreateComment(bundle.isCreateComment());
		boardView.setCreateImage(bundle.isCreateImage());
		boardView.setCreateThread(bundle.isCreateThread());
		boardView.setCreateThreadMessage(bundle.isCreateThreadMessage());
		int totalThreadCount = getBoardService().getBoardThreadCount(Models.BOARD.getObjectType(), board.getBoardId());
		int totalMessageCount = getBoardService().getBoardMessageCount(board);	
		boardView.setTotalMessage(totalMessageCount);
		boardView.setTotalThreadCount(totalThreadCount);		
		return boardView;
	}
	
	protected ProjectView getProjectView(JdbcCommunityAclService communityAclService, Project project) {		
		
		CommuintyUserDetails userDetails = SecurityHelper.getUserDetails();
		log.debug("Board View : {} {} for {}.", project.getProjectId(),  project.getName(), userDetails.getUsername() );		
		
		PermissionsBundle bundle = communityAclService.getPermissionBundle(SecurityHelper.getAuthentication(), Project.class, project.getProjectId() );				
		ProjectView projectView = new ProjectView(project);
 
		projectView.setWritable(bundle.isWrite());
		projectView.setReadable(bundle.isRead());
		projectView.setCreateAttachement(bundle.isCreateAttachment());
		projectView.setReadComment(bundle.isReadComment());
		projectView.setCreateComment(bundle.isCreateComment());
		projectView.setCreateImage(bundle.isCreateImage());
		projectView.setCreateThread(bundle.isCreateThread());
		projectView.setCreateThreadMessage(bundle.isCreateThreadMessage());	
		
		return projectView;
	}
	
    protected String getEncodedFileName(Attachment attachment) {
		try {
		    return URLEncoder.encode(attachment.getName(), "UTF-8");
		} catch (UnsupportedEncodingException e) {
		    return attachment.getName();
		}
    }
    
    
}
