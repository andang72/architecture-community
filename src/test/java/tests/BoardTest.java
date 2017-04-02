package tests;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import architecture.community.board.Board;
import architecture.community.board.BoardNotFoundException;
import architecture.community.board.BoardService;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration("WebContent/")
@ContextConfiguration(locations = { "classpath:application-community-context.xml" })
public class BoardTest {

	private static Logger log = LoggerFactory.getLogger(BoardTest.class);
	
	@Autowired
	private BoardService boardService;
	
	@Test
	public void testSelectOrCreateBoard(){
		
		List<Board> list = boardService.getAllBoards();
		long boardId = -1L;
		for( Board board : list){
			if( boardId < 0 )
				boardId = board.getBoardId();
			log.debug("BOARD {}, {}, {}", board.getBoardId(), board.getName(), board.getDisplayName() );
		}
		
		
		if( list.size() == 0)
			createBoardTest();
		
		
		if( boardId > 0){
			try {
				
				log.debug("add topic");
				Board board = boardService.getBoard(boardId);		
				
				
			} catch (BoardNotFoundException e) {
				e.printStackTrace();
			}
			
			
		}
		
	}
		
	
	public void createBoardTest(){		
		boardService.createBoard("질문답변게시판", "질문&답변 게시판", "");
	}
	
}
