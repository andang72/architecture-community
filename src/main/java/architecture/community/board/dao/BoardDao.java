package architecture.community.board.dao;

import java.util.List;

import architecture.community.board.Board;

public interface BoardDao {
	
	public abstract void createBoard(Board board);
	
	public abstract Board getBoardById(long boardId);
	
	public abstract List<Long> getAllBoardIds();
	
	public void deleteBoard(Board board);
	
}
