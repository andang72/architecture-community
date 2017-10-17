package architecture.community.web.spring.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import architecture.community.board.Board;
import architecture.community.board.BoardNotFoundException;
import architecture.community.board.BoardService;
import architecture.community.board.ForumService;
import architecture.community.board.BoardThread;
import architecture.community.board.BoardThreadNotFoundException;
import architecture.community.viewcount.ViewCountService;
import architecture.community.web.util.ServletUtils;

@Controller("board-page-controller")
public class BoardPageController {
	
	private static final Logger log = LoggerFactory.getLogger(BoardPageController.class);	

	@Inject
    @Qualifier("boardService")
    private BoardService boardService;

	@Inject
	@Qualifier("forumService")
	private ForumService forumService;
	
	@Inject
	@Qualifier("viewCountService")
	private ViewCountService viewCountService;
	
	public BoardPageController() {
	}
	
	@RequestMapping(value = {"/boards/{boardId:[\\p{Digit}]+}", "/board/{boardId:[\\p{Digit}]+}"}, method = { RequestMethod.POST, RequestMethod.GET })
	public String displayBoardPage(
			@PathVariable Long boardId, 
			HttpServletRequest request,
		    HttpServletResponse response, Model model) throws BoardNotFoundException{
		ServletUtils.setContentType(null, response);	
		
		Board board = boardService.getBoard(boardId);
		model.addAttribute("board", board);
		
		return "/forums/list-thread" ;
	}
	
	@RequestMapping(value = {"/boards/{boardId:[\\p{Digit}]+}/threads/{threadId:[\\p{Digit}]+}", "/board/{boardId:[\\p{Digit}]+}/thread/{threadId:[\\p{Digit}]+}"}, method = { RequestMethod.POST, RequestMethod.GET })
	public String displayForumThreadPage(
			@PathVariable Long boardId, 
			@PathVariable Long threadId, 
			HttpServletRequest request,
		    HttpServletResponse response, 
		    Model model) throws BoardNotFoundException, BoardThreadNotFoundException{
		ServletUtils.setContentType(null, response);			
		Board board = boardService.getBoard(boardId);
		BoardThread thread = forumService.getForumThread(threadId);

		viewCountService.addViewCount(thread);
		
		model.addAttribute("board", board);
		model.addAttribute("thread", thread);
		
		return "/forums/view-thread" ;
	}

	@RequestMapping(value = { "/board/{boardId:[\\p{Digit}]+}/message/{messageId:[\\p{Digit}]+}"}, method = { RequestMethod.POST, RequestMethod.GET })
	public String displayForumMessagePage(
			@PathVariable Long boardId, 
			@PathVariable Long threadId, 
			HttpServletRequest request,
		    HttpServletResponse response, 
		    Model model) throws BoardNotFoundException, BoardThreadNotFoundException{
		ServletUtils.setContentType(null, response);			
		Board board = boardService.getBoard(boardId);
		BoardThread thread = forumService.getForumThread(threadId);

		viewCountService.addViewCount(thread);
		
		model.addAttribute("board", board);
		model.addAttribute("thread", thread);
		
		return "/forums/view-thread" ;
	}
	
}
