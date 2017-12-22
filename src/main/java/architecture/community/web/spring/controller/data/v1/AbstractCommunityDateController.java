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
import architecture.community.security.spring.acls.JdbcCommunityAclService.PermissionsBundle;
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
	
    protected String getEncodedFileName(Attachment attachment) {
		try {
		    return URLEncoder.encode(attachment.getName(), "UTF-8");
		} catch (UnsupportedEncodingException e) {
		    return attachment.getName();
		}
    }
    
    
}
