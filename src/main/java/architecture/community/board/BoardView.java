package architecture.community.board;

import java.io.Serializable;
import java.util.Date;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import architecture.community.model.json.JsonDateSerializer;

public class BoardView implements Board , Serializable {
	
	@JsonIgnore
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
 
	 
	public void setProperties(Map<String, String> properties) {
		board.setProperties(properties);
	}
 
	public Map<String, String> getProperties() {
		return board.getProperties();
	}


	public boolean getBooleanProperty(String name, boolean defaultValue) {
		return board.getBooleanProperty(name, defaultValue);
	}

 
	public long getLongProperty(String name, long defaultValue) {
		 
		return board.getLongProperty(name, defaultValue);
	}

	 
	public int getIntProperty(String name, int defaultValue) {
		return 0;
	}

	 
	public String getProperty(String name, String defaultValue) {
		return null;
	}

}
