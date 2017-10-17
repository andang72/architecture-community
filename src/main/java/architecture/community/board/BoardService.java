package architecture.community.board;

import java.util.List;

public interface BoardService {
		
	public abstract Board createBoard(String name, String displayName, String description);
	
	public abstract void updateBoard(Board board);

	public abstract void deleteBoard(Board board);
	
	public abstract Board getBoard(long boardId) throws BoardNotFoundException ;
	
	public abstract List<Board> getAllBoards();	
	
	
	
			
}
