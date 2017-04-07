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
import architecture.community.forum.ForumService;
import architecture.community.forum.ForumThread;
import architecture.community.web.model.ItemList;

@Controller("boards-data-controller")
@RequestMapping("/data/boards")
public class BoardDataController {
	
	private Logger logger = LoggerFactory.getLogger(getClass());	
	
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
	public ItemList listThread (@PathVariable Long boardId, NativeWebRequest request) throws BoardNotFoundException {	
		Board board = boardService.getBoard(boardId);	
		
		int totalSize = forumService.getFourmThreadCount(Board.MODLE_TYPE, board.getBoardId());
		List<ForumThread> list = forumService.getForumThreads(Board.MODLE_TYPE, board.getBoardId());
		
		return new ItemList(list, totalSize);
	}
	
	
}
