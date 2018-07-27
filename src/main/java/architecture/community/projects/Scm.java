package architecture.community.projects;

import java.util.Calendar;
import java.util.Date;

import architecture.community.model.ModelObjectAwareSupport;

public class Scm extends ModelObjectAwareSupport {

	private Long scmId;
	
	private String name;
	
	private String description;
	
	private String tags;
	
	private String url;
	
	private String username;
	
	private String password;
	
	private Date creationDate;
	
	private Date modifiedDate;
	
	public Scm( ) {
		this(-1, -1L);
		this.scmId = -1L;
		this.creationDate = Calendar.getInstance().getTime();
		this.modifiedDate = this.creationDate;		
 
	}
	
	public Scm(int objectType, long objectId) {
		super(objectType, objectId); 
		this.scmId = -1L;
		this.creationDate = Calendar.getInstance().getTime();
		this.modifiedDate = this.creationDate;		
 
	} 
	
	public Scm(int objectType, long objectId, long taskId) {
		super(objectType, objectId);
		this.scmId = taskId;
		this.creationDate = Calendar.getInstance().getTime();
		this.modifiedDate = this.creationDate;	 
	}

	public Long getScmId() {
		return scmId;
	}

	public void setScmId(Long scmId) {
		this.scmId = scmId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
 

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
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
