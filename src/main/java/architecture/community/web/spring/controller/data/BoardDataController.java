package architecture.community.web.spring.controller.data;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import architecture.community.board.Board;
import architecture.community.board.BoardService;

@Controller("boards-data-controller")
@RequestMapping("/data/boards")
public class BoardDataController {
	
	private Logger logger = LoggerFactory.getLogger(getClass());	
	
	@Inject
	@Qualifier("boardService")
	private BoardService boardService;
	
	@RequestMapping(value = "/list.json", method = { RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public List<Board> listBoard (NativeWebRequest request) {	
		return boardService.getAllBoards();
	}
	
}
