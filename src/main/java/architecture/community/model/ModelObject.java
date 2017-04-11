package architecture.community.model;

public interface ModelObject {
	
	public static final int UNKNOWN_OBJECT_TYPE = -1 ;
	
	public static final long UNKNOWN_OBJECT_ID = -1L ;
	
	public static final int BOARD = 5 ;
	
	public static final int FORUM_THREAD = 6;
	
	public static final int FORUM_MESSAGE = 7;
	
	public static final int COMMENT = 8 ;
	
	
	public abstract int getObjectType();
	
	public abstract long getObjectId();
	
}
