package tests;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import architecture.community.board.BoardService;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration("WebContent/")
@ContextConfiguration(locations = { "classpath:application-community-context.xml" })
public class BoardTest {

	@Autowired
	private BoardService boardService;
	
	@Test
	public void createBoardTest(){
		
		
		boardService.createBoard("질문답변게시판", "질문&답변 게시판", "");
		
		
	}
}
