package architecture.community.issue;

import java.util.Calendar;
import java.util.Date;

public class Project {

	private long projectId;
	
	private String name;
	
	private String summary;
	
	private Date startDate ;
	
	private Date endDate;
	
	private Date creationDate;
	
	private Date modifiedDate;
	
	public Project() {
		this.projectId = -1L;
		this.name = null;
		this.summary = null;
		this.startDate = null;
		this.endDate = null;
		this.creationDate = Calendar.getInstance().getTime();
		this.modifiedDate = this.creationDate;
	}

	public Project(long projectId) {
		this.projectId = projectId;
		this.name = null;
		this.summary = null;
		this.startDate = null;
		this.endDate = null;
		this.creationDate = Calendar.getInstance().getTime();
		this.modifiedDate = this.creationDate;
	}

	public long getProjectId() {
		return projectId;
	}

	public void setProjectId(long projectId) {
		this.projectId = projectId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public Date getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}

	public Date getModifiedDate() {
		return modifiedDate;
	}

	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}

}
