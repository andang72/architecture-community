package architecture.community.board;

import java.util.Date;

import architecture.community.model.ModelObject;

public interface Board extends ModelObject {

	//public static final int MODLE_OBJECT_TYPE = 5;
	
	public abstract long getBoardId();
	
	public abstract String getName();
	
	public abstract String getDisplayName();
	
	public abstract String getDescription();
	
	public abstract Date getCreationDate();

	public abstract Date getModifiedDate();
	
}
