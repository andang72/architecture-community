package tests;

import java.io.File;
import java.util.List;

import javax.servlet.ServletContext;

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
import architecture.community.image.ImageNotFoundException;
import architecture.community.image.ImageService;
import architecture.community.image.LogoImage;
import architecture.community.model.Models;
import architecture.ee.service.Repository;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration("WebContent/")
@ContextConfiguration(locations = { "classpath:application-community-context.xml" })
public class BoardTest {

	private static Logger log = LoggerFactory.getLogger(BoardTest.class);
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private ImageService imageService;
	
	@Autowired
	private Repository repository;
	
	
	@Autowired
	ServletContext context; 
	
	
	public File getRandomLogoFile(){
		
		String path = context.getRealPath("/images");
		File file = new File(path);		
		int rand = (int) ((Math.random() * 4) + 1);
		File img = new File(file, rand + ".png");
		log.debug("random file : {}", img.getName()  );
		return img;
	}
	
	@Test
	public void testSelectOrCreateBoard(){ 
		
		List<Board> list = boardService.getAllBoards();
		long boardId = -1L;
		for( Board board : list){
			if( boardId < 0 )
				boardId = board.getBoardId();
			log.debug("===================");
			log.debug("BOARD {}, {}, {}", board.getBoardId(), board.getName(), board.getDisplayName() );
			
			int count = imageService.getLogoImageCount(Models.BOARD.getObjectType(), board.getBoardId());
			
			log.debug("logo image count : {}, {}, {}", Models.BOARD.getObjectType(), board.getBoardId(), count);
			
			if( count == 0){
				File file = getRandomLogoFile();
				log.debug("adding" );
				if( file.exists() ) {
				LogoImage img = imageService.createLogoImage( Models.BOARD.getObjectType(), board.getBoardId(), true, file.getName(), "image/png", file );
				imageService.addLogoImage(img, file);
				}
			}else{
				try {
					log.debug("getting" );
					LogoImage img = imageService.getPrimaryLogoImage(Models.BOARD.getObjectType(), board.getBoardId());
					
				} catch (ImageNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
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
