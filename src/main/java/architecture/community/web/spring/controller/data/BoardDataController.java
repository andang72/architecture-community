package architecture.community.web.spring.controller.data;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.board.Board;
import architecture.community.board.BoardNotFoundException;
import architecture.community.board.BoardService;
import architecture.community.board.ForumService;
import architecture.community.board.BoardThread;
import architecture.community.model.ModelObjectAware;
import architecture.community.model.Models;
import architecture.community.web.model.ItemList;

@Controller("boards-data-controller")
@RequestMapping("/data/boards")
public class BoardDataController {
	
	private Logger log = LoggerFactory.getLogger(getClass());	
	
	@Inject
	@Qualifier("boardService")
	private BoardService boardService;
	
	@Inject
	@Qualifier("forumService")
	private ForumService forumService;
	
	
	@RequestMapping(value = "/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public List<Board> listBoard (NativeWebRequest request) {	
		return boardService.getAllBoards();
	}

	/**
	 * 
	 * /data/boards/{boardId}/threads/list.json
	 * 
	 * @param boardId
	 * @param request
	 * @return
	 * @throws BoardNotFoundException
	 */
	@RequestMapping(value = "/{boardId:[\\p{Digit}]+}/threads/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public ItemList listThread (@PathVariable Long boardId, 
			@RequestParam(value = "skip", defaultValue = "0", required = false) int skip,
			@RequestParam(value = "page", defaultValue = "0", required = false) int page,
			@RequestParam(value = "pageSize", defaultValue = "0", required = false) int pageSize,
			NativeWebRequest request) throws BoardNotFoundException {	
		
		log.debug(" skip: {}, page: {}, pageSize: {}", skip, page, pageSize );
		
		Board board = boardService.getBoard(boardId);	
		List<BoardThread> list;
		int totalSize = forumService.getFourmThreadCount(Models.BOARD.getObjectType(), board.getBoardId());
		
		if( pageSize == 0 && page == 0){
			list = forumService.getForumThreads(Models.BOARD.getObjectType(), board.getBoardId());
		}else{
			list = forumService.getForumThreads(Models.BOARD.getObjectType(), board.getBoardId(), skip, pageSize);
		}
		
		return new ItemList(list, totalSize);
	}
	
	
}
