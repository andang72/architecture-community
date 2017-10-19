package architecture.community.board.dao;

import java.util.Date;
import java.util.List;

import architecture.community.board.Board;
import architecture.community.board.BoardMessage;
import architecture.community.board.BoardThread;
import architecture.community.board.MessageTreeWalker;

public interface BoardDao {
	
	
	
	public abstract void createBoard(Board board);
	
	public abstract Board getBoardById(long boardId);
	
	public abstract List<Long> getAllBoardIds();
	
	public void deleteBoard(Board board);
	
	

	public abstract void createForumThread( BoardThread thread );
	
	public abstract void createForumMessage (BoardThread thread, BoardMessage message, long parentMessageId);
	
	public abstract int getForumThreadCount(int objectType, long objectId);
	
	
	public abstract List<Long> getForumThreadIds(int objectType, long objectId);
	
	public abstract List<Long> getForumThreadIds(int objectType, long objectId, int startIndex, int numResults);
	
	public abstract long getLatestMessageId(BoardThread thread);
	
	public abstract List<Long> getAllMessageIdsInThread(BoardThread thread);
	
	public abstract BoardThread getForumThreadById(long threadId);
	
	public abstract BoardMessage getForumMessageById(long messageId) ;
	
	public abstract void updateForumMessage(BoardMessage message);
	
	public abstract void updateForumThread(BoardThread thread);
	
	public abstract void updateModifiedDate(BoardThread thread, Date date);
	
	public abstract List<Long> getMessageIds(BoardThread thread);
	
	public abstract int getMessageCount(BoardThread thread);
	
	public abstract MessageTreeWalker getTreeWalker(BoardThread thread) ;
	
}
