package architecture.community.forum;

public class ForumMessageNotFoundException extends Exception {

	public ForumMessageNotFoundException() { 
	}

	public ForumMessageNotFoundException(String message) {
		super(message); 
	}

	public ForumMessageNotFoundException(Throwable cause) {
		super(cause); 
	}

	public ForumMessageNotFoundException(String message, Throwable cause) {
		super(message, cause); 
	}

	public ForumMessageNotFoundException(String message, Throwable cause, boolean enableSuppression,
			boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace); 
	}

}
