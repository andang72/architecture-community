package tests;

import java.io.IOException;
import java.nio.charset.Charset;
import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.util.StreamUtils;

import architecture.community.board.Board;
import architecture.community.board.BoardMessage;
import architecture.community.board.BoardService;
import architecture.community.board.BoardThread;
import architecture.community.board.BoardThreadNotFoundException;
import architecture.community.model.Models;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration("WebContent/")
@ContextConfiguration(locations = { "classpath:application-community-context.xml" })

public class ForumTest {
	
	private static Logger log = LoggerFactory.getLogger(ForumTest.class);
	
	@Autowired
	private BoardService boardService;

	
	private String getBodyText(String filename){
		
		String body = "";
		try {
			ClassLoader cl = Thread.currentThread().getContextClassLoader();
			body = StreamUtils.copyToString(cl.getResourceAsStream(filename), Charset.defaultCharset() );
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return body;
	}
	
	@Test
	public void testCreateTheadIfNoExist(){
		
		List<Board> boards = boardService.getAllBoards();
		long boardId = 0 ;
		if( boards.size() == 0 )
		{
			Board board = boardService.createBoard("질문답변게시판", "질문&답변 게시판", "");
			boardId = board.getBoardId();
		}else {
			boardId = boards.get(0).getBoardId();
		}
		int objectType = Models.BOARD.getObjectType();
		long objectId = boardId;
		
		List<BoardThread> list = boardService.getForumThreads(objectType, objectId);
		log.debug(" THREAD COUNT {}" , list.size() );		
		if( list.size() == 0 ){
			BoardMessage rootMessage = boardService.createMessage(objectType, objectId);
			rootMessage.setSubject("인간이란 무엇인가?");
			rootMessage.setBody("인간은 고기 덩어리 인가 아님 다른 존재이가?");
			BoardThread thread = boardService.createThread(objectType, objectId, rootMessage);
			boardService.addThread(objectType, objectId, thread);
		}
		
		for( BoardThread t : list ){
			
			BoardMessage message = t.getRootMessage();
			
			if( message.getMessageId() == 2 && message.getBody().length() < 20000 ){
				message.setBody(getBodyText("text1.txt"));
				boardService.updateMessage(message);				
			}else if( message.getMessageId() == 4 && message.getBody().length() < 20000 ){
				message.setBody(getBodyText("text2.txt"));
				boardService.updateMessage(message);				
			}
			
			log.debug(" FORUM THREAD : " + t );
			log.debug( message.getSubject() );
			log.debug( "UPDATE : {} \n {} ", message.getModifiedDate(), message.getBody() );
		}

		
	}
	
	@Test
	public void testReplayMessage(){
		
		int objectType = 1;
		long objectId = 1L;
		log.debug("replay ============ ");
		try {
			BoardThread thread = boardService.getForumThread(1);
			objectType = thread.getObjectType();
			objectId = thread.getObjectId();
			log.debug(thread.toString());
			BoardMessage parentMessage = thread.getRootMessage();
			
			log.debug("Parent Message : {}", parentMessage.toString());
			BoardMessage replayMessage =boardService.createMessage(objectType, objectId);			
			replayMessage.setSubject("RE:" + parentMessage.getSubject());
			replayMessage.setBody("인간은 고기 덩어리가 맞다...." + new Date());			
			boardService.addMessage(thread, parentMessage, replayMessage);
			
		} catch (BoardThreadNotFoundException e) {
			e.printStackTrace();
		}
		
		
		
		
		
	}
}
