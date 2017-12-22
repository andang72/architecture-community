package architecture.community.web.spring.controller.page;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import architecture.community.board.Board;
import architecture.community.board.BoardNotFoundException;
import architecture.community.board.BoardService;
import architecture.community.board.BoardThread;
import architecture.community.board.BoardThreadNotFoundException;
import architecture.community.viewcount.ViewCountService;
import architecture.community.web.util.ServletUtils;

@Controller("community-board-page-controller")
@RequestMapping("/display/boards")
public class BoardPageController {
	
	private static final Logger log = LoggerFactory.getLogger(BoardPageController.class);	

	@Inject
    @Qualifier("boardService")
    private BoardService boardService;

	
	@Inject
	@Qualifier("viewCountService")
	private ViewCountService viewCountService;
	
	public BoardPageController() {
		
	}
	
	@RequestMapping(value = {"/", "/index"}, method = { RequestMethod.POST, RequestMethod.GET } )
	public String displayBoardList(
			HttpServletRequest request,
		    HttpServletResponse response, Model model) {		
		ServletUtils.setContentType(ServletUtils.DEFAULT_HTML_CONTENT_TYPE, response);		
		return "/boards/list-board" ;
	}
		 
	@PreAuthorize("hasPermission(#boardId, 'architecture.community.board.Board', 'READ')")
	@RequestMapping(value = {"/{boardId:[\\p{Digit}]+}"}, method = { RequestMethod.POST, RequestMethod.GET } )
	public String displayThreadList (
			@PathVariable Long boardId, 
			HttpServletRequest request,
		    HttpServletResponse response, 
		    Model model) throws BoardNotFoundException{				
		ServletUtils.setContentType(ServletUtils.DEFAULT_HTML_CONTENT_TYPE, response);		
		Board board = boardService.getBoardById(boardId);
		model.addAttribute("__board", board);				
		return "/boards/list-thread" ;
	}
		 
	@PreAuthorize("hasPermission(#boardId, 'architecture.community.board.Board', 'READ')")
	@RequestMapping(value = {"/{boardId:[\\p{Digit}]+}/threads/{threadId:[\\p{Digit}]+}"}, method = { RequestMethod.POST, RequestMethod.GET } )
	public String displayThread (
			@PathVariable Long boardId, 
			@PathVariable Long threadId, 
			HttpServletRequest request,
		    HttpServletResponse response, 
		    Model model) throws BoardNotFoundException, BoardThreadNotFoundException{		
		ServletUtils.setContentType(ServletUtils.DEFAULT_HTML_CONTENT_TYPE, response);		
		Board board = boardService.getBoardById(boardId);
		BoardThread thread = boardService.getBoardThread(threadId);		
		model.addAttribute("__board", board);		
		model.addAttribute("__thread", thread);		
		if(viewCountService!=null)
			viewCountService.addViewCount(thread);		
		return "/boards/view-thread" ;
	}
	
}
