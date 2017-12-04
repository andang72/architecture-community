package architecture.community.web.spring.controller.data.v1;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.board.Board;
import architecture.community.board.BoardNotFoundException;
import architecture.community.board.BoardService;
import architecture.community.board.DefaultBoard;
import architecture.community.security.spring.acls.JdbcCommunityAclService;
import architecture.community.web.model.ItemList;
import architecture.ee.util.StringUtils;

@Controller("community-data-v1-mgmt-boards-controller")
@RequestMapping("/data/api/mgmt/v1")
public class BoardMgmtDataController extends AbstractCommunityDateController {

	private Logger log = LoggerFactory.getLogger(getClass());	
	
	@Inject
	@Qualifier("boardService")
	private BoardService boardService;
	
	@Inject
	@Qualifier("communityAclService")
	private JdbcCommunityAclService communityAclService;
	
	
	protected BoardService getBoardService () {
		return boardService;
	}

	protected JdbcCommunityAclService getCommunityAclService () {
		return communityAclService;
	}
	
 
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/boards/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList getBoardList (NativeWebRequest request) {	
		
		List<Board> list = boardService.getAllBoards();
		List<Board> list2 = new ArrayList<Board> (list.size());
		for( Board board : list)
		{	
			list2.add(toBoardView(board));
		}
		return new ItemList(list2, list2.size());
	}
	
	@Secured({ "ROLE_ADMINISTRATOR"})
	@RequestMapping(value = "/boards/save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public Board saveOrUpdate(@RequestBody DefaultBoard board, NativeWebRequest request) throws BoardNotFoundException {
		
		DefaultBoard boardToUse = board ;		
		
		if(board.getBoardId() > 0 ) {
			boardToUse = (DefaultBoard) boardService.getBoardById(board.getBoardId());			
			if(!StringUtils.isNullOrEmpty(board.getName()))
				boardToUse.setName(board.getName());			
			if(!StringUtils.isNullOrEmpty(board.getDisplayName()))
				boardToUse.setDisplayName(board.getDisplayName());			
			if(!StringUtils.isNullOrEmpty(board.getDescription()))
				boardToUse.setDescription(board.getDescription());			
			Date modifiedDate = new Date();
			boardToUse.setModifiedDate(modifiedDate);			
			boardService.updateBoard(boardToUse);			
		}else {
			// create...
			boardToUse = (DefaultBoard) boardService.createBoard(board.getName(), board.getDisplayName(), board.getDescription());
		}		
		return boardService.getBoardById(boardToUse.getBoardId());				
	}
}
