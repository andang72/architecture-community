package architecture.community.board;

import architecture.community.exception.NotFoundException;

public class ForumThreadNotFoundException extends NotFoundException {

	public ForumThreadNotFoundException() {
		super(); 
	}

	public ForumThreadNotFoundException(String message, Throwable cause, boolean enableSuppression,
			boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace); 
	}

	public ForumThreadNotFoundException(String message, Throwable cause) {
		super(message, cause); 
	}

	public ForumThreadNotFoundException(String message) {
		super(message); 
	}

	public ForumThreadNotFoundException(Throwable cause) {
		super(cause); 
	}

}
