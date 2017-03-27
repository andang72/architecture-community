package architecture.community.board;

import java.util.Date;

import architecture.community.user.User;

public interface Post {

	/**
	 * Post 를 소유하는 객체 타입.
	 * @return
	 */
	public abstract int getObjectType();
	
	/**
	 * Post 를 소유하는 객체 아이디 
	 * @return
	 */
	public abstract long getObjectId();	
	
	public abstract long getBoardId();
	
	public abstract long getPostId();
	
	public abstract long getParentPostId();
	
	public abstract long getThreadId();
		
	public abstract String getSubject();
	
	public abstract String getBody();
	
	public abstract String getDescription();
	
	public abstract User getUser();
	
	public abstract Date getCreationDate();

	public abstract Date getModifiedDate();	
	
	
}
