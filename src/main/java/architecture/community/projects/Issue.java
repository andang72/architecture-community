package architecture.community.projects;

import java.util.List;

import architecture.community.model.PropertyAwareSupport;
import architecture.community.user.User;

public class Issue extends PropertyAwareSupport {
	
	private User repoter;
	
	private List<User> assignees ;
	
	private String issueType;
	
	// 0(하), 1(중), 2 (상)
	private int priority;
	
	private String status;
	
	private String title;
	
	private String description;	
	
	// 접수일자
	// 작업일자 계획  시작 - 종료
	// 작업완료 실적
	// 작업시간 계획 
	// 작업시간 실적  
	
	private Project project;
	
	public Issue() {

	}

}
