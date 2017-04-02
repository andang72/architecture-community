package architecture.community.board;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.community.board.dao.BoardDao;
import architecture.community.i18n.CommunityLogLocalizer;
import architecture.community.user.User;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

public class DeafultBoardService implements BoardService {
	
	private Logger logger = LoggerFactory.getLogger(getClass().getName());
	
	@Inject
	@Qualifier("boardDao")
	private BoardDao boardDao;
	
	@Inject
	@Qualifier("boardCache")
	private Cache boardCache;
	

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public Board createBoard(String name, String displayName, String description) {				
		DefaultBoard newBoard = new DefaultBoard();		
		if(name == null || "".equals(name.trim()))
            throw new IllegalArgumentException("Board name must be specified.");
		newBoard.setName(name);		
        if(displayName == null || "".equals(displayName.trim()))
            throw new IllegalArgumentException("Board display name must be specified.");
        newBoard.setDisplayName(displayName);        
        newBoard.setDescription(description);
        newBoard.setCreationDate(new Date());		
		boardDao.createBoard(newBoard);		
		return newBoard;
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateBoard(Board board) {	
		evictCaches(board);
	}

 
	public Board getBoard(long boardId) throws BoardNotFoundException {				
		
		Board board = getBoardInCache(boardId);		
		if( board == null && boardId > 0L ){
			try {			
				board = boardDao.getBoardById(boardId);
				updateCaches(board);
			} catch (Throwable e) {				
				throw new BoardNotFoundException(CommunityLogLocalizer.format("013003", boardId), e);
			}
		}
		return board;
	}

 
	public List<Board> getAllBoards() {
		List<Long> ids = boardDao.getAllBoardIds();
		List<Board> boards = new ArrayList<Board>(ids.size());
		for( Long id : ids )
		{
			try {
				boards.add(getBoard(id));
			} catch (BoardNotFoundException e) {
				logger.warn(e.getMessage(), e);
			}
		}
		return boards;
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void deleteBoard(Board board) {
				
	}
	
	protected Board getBoardInCache(Long boardId) {
		if (boardCache.get(boardId) != null)
			return (Board)boardCache.get(boardId).getObjectValue();
		else
			return null;
	}
	
	protected void updateCaches(Board board) {
		if (board != null) {
			if (board.getBoardId() > 0 ) {
				if (boardCache.get(board.getBoardId()) != null)
					boardCache.remove(board.getBoardId());
				boardCache.put(new Element(board.getBoardId(), board ));
			}
		}
	}
	
	protected void evictCaches(Board board){		
		boardCache.remove(Long.valueOf(board.getBoardId()));
	}

}
