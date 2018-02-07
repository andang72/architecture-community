package architecture.community.export;

import org.springframework.core.NestedRuntimeException;

public class ExportConfigFoundException extends NestedRuntimeException {
	
	public ExportConfigFoundException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public ExportConfigFoundException(String msg) {
		super(msg); 
	}

}
