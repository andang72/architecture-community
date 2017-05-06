package architecture.community.model;

public interface ModelObject {
	
	public static final int UNKNOWN_OBJECT_TYPE = -1 ;
	
	public static final long UNKNOWN_OBJECT_ID = -1L ;
	
	public static final int USER = 1 ;	
	
	public static final int ROLE = 3 ;	
	
	
	public static final int BOARD = 5 ;
	
	public static final int FORUM_THREAD = 6;
	
	public static final int FORUM_MESSAGE = 7;
	
	public static final int COMMENT = 8 ;	
	
	public static final int ATTACHEMNT = 10 ;
	
	public static final int IMAGE = 11 ;
	
	public static final int LOGO_IMAGE = 12 ;
	
	public static final int PROFILE_IMAGE = 13 ;
	
	public abstract int getObjectType();
	
	public abstract long getObjectId();
	
}
