package architecture.community.board;

import java.util.Date;

public interface Topic {
	
	public long getThreadId();
	
	/**
	 * Thread 를 소유하는 객체 타입.
	 * @return
	 */
	public abstract int getObjectType();
	
	/**
	 * Thread 를 소유하는 객체 아이디 
	 * @return
	 */
	public abstract long getObjectId();	
	
	
	public abstract long getRootPostId();
		
	public abstract Date getCreationDate();

	public abstract Date getModifiedDate();
}
