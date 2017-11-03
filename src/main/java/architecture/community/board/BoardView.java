package architecture.community.board;

import java.io.Serializable;
import java.util.Date;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import architecture.community.model.json.JsonDateSerializer;

public class BoardView implements Board , Serializable {
	
	private Board board;
	
	private int totalThreadCount = 0;
	
	private int totalViewCount = 0;
	
	private int totalMessage = 0;
	
	public BoardView(Board board) {
		this.board = board;
	}
 
	public int getObjectType() {
		return board.getObjectType();
	}
 
	public long getObjectId() {
		return board.getObjectId();
	}

 
	public long getBoardId() {
		return board.getBoardId();
	}
 
	public String getName() {
		return board.getName();
	}

 
	public String getDisplayName() {
		return board.getDisplayName();
	}

 
	public String getDescription() {		
		return board.getDescription();
	}

	@JsonSerialize(using = JsonDateSerializer.class)
	public Date getCreationDate() {
		return board.getCreationDate();
	}

 
	public void setCreationDate(Date creationDate) {		
	}

	@JsonSerialize(using = JsonDateSerializer.class)
	public Date getModifiedDate() {
		return board.getModifiedDate();
	}

	public void setModifiedDate(Date modifiedDate) {
		
	}

	public Board getBoard() {
		return board;
	}

	public void setBoard(Board board) {
		this.board = board;
	}

	public int getTotalThreadCount() {
		return totalThreadCount;
	}

	public void setTotalThreadCount(int totalThreadCount) {
		this.totalThreadCount = totalThreadCount;
	}

	public int getTotalViewCount() {
		return totalViewCount;
	}

	public void setTotalViewCount(int totalViewCount) {
		this.totalViewCount = totalViewCount;
	}

	public int getTotalMessage() {
		return totalMessage;
	}

	public void setTotalMessage(int totalMessage) {
		this.totalMessage = totalMessage;
	}

}
