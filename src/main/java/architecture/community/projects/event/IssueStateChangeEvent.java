package architecture.community.projects.event;

import org.springframework.context.ApplicationEvent;

public class IssueStateChangeEvent extends ApplicationEvent {
	
	public IssueStateChangeEvent(Object source) {
		super(source);
	}

}
