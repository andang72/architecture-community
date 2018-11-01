package architecture.community.wiki;

import java.util.Calendar;
import java.util.Date;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import architecture.community.model.ModelObjectAwareSupport;
import architecture.community.model.json.JsonDateDeserializer;
import architecture.community.model.json.JsonDateSerializer;
import architecture.community.model.json.JsonUserDeserializer;
import architecture.community.user.User;

public class Wiki extends ModelObjectAwareSupport {
	
	private Long wikiId;
	
	private Date creationDate;
	
	private Date modifiedDate;
	
	private String subject ;
	
	private String body;
	
	private Integer version ;
	
	private User creater;
	
	private User modifier;
	
	
	public Wiki( ) {
		this(-1, -1L);
		this.wikiId = -1L;
		this.version = 0;
		this.creationDate = Calendar.getInstance().getTime();
		this.modifiedDate = this.creationDate;		
	}
	
	public Wiki(int objectType, long objectId) {
		super(objectType, objectId); 
		this.wikiId = -1L;
		this.version = 0;
		this.creationDate = Calendar.getInstance().getTime();
		this.modifiedDate = this.creationDate;		 
	} 
	
	public Wiki(int objectType, long objectId, long wikiId) {
		super(objectType, objectId);
		this.wikiId = wikiId;
		this.version = 0;
		this.creationDate = Calendar.getInstance().getTime();
		this.modifiedDate = this.creationDate;		
	}

	@JsonSerialize(using = JsonDateSerializer.class)
	public Date getCreationDate() {
		return creationDate;
	}

	@JsonDeserialize(using = JsonDateDeserializer.class)
	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}

	@JsonSerialize(using = JsonDateSerializer.class)
	public Date getModifiedDate() {
		return modifiedDate;
	}

	@JsonDeserialize(using = JsonDateDeserializer.class)
	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}

	public Long getWikiId() {
		return wikiId;
	}

	public void setWikiId(Long wikiId) {
		this.wikiId = wikiId;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public User getCreater() {
		return creater;
	}

	@JsonDeserialize(using = JsonUserDeserializer.class)
	public void setCreater(User creater) {
		this.creater = creater;
	}

	public User getModifier() {
		return modifier;
	}

	@JsonDeserialize(using = JsonUserDeserializer.class)
	public void setModifier(User modifier) {
		this.modifier = modifier;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}
	
	
}
