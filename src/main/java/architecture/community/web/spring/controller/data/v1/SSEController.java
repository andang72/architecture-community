package architecture.community.web.spring.controller.data.v1;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.context.event.EventListener;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import architecture.community.components.mail.MailEvent;
import architecture.community.projects.event.IssueStateChangeEvent;

@Controller("sse-data-controller")
@RequestMapping("/data/api/v1/notifications")
public class SSEController {

	private final CopyOnWriteArrayList<SseEmitter> emitters = new CopyOnWriteArrayList<>();

	public SSEController() {
		
	}

	
	@Secured({ "ROLE_USER" })
	@GetMapping("/issue.json")
	public SseEmitter handle() { 
	    final SseEmitter emitter = new SseEmitter();
	    this.emitters.add(emitter); 
	    emitter.onCompletion( new Runnable() {
			public void run() {
				emitters.remove(emitter); 
			}
	    }); 
	    emitter.onTimeout( new Runnable() {
			public void run() {
				emitters.remove(emitter); 
			}
	    });
	    return emitter;
	}
	
	
	@EventListener
	public void onIssueStateChangeEvent(IssueStateChangeEvent event) { 
		List<SseEmitter> deadEmitters = new ArrayList<>();
		for(SseEmitter emitter : emitters ) { 
			try {
				emitter.send(event);
			} catch (Exception e) {
				deadEmitters.add(emitter);
			}	 
		}
		this.emitters.removeAll(deadEmitters);
	}
	
	@EventListener
	public void onIssueStateChangeEvent(MailEvent event) {
		List<SseEmitter> deadEmitters = new ArrayList<>();
		for(SseEmitter emitter : emitters ) { 
			try {
				emitter.send(event);
			} catch (Exception e) {
				deadEmitters.add(emitter);
			}	 
		}
		this.emitters.removeAll(deadEmitters);
	}	

}
