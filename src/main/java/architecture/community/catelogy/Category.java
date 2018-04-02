package architecture.community.catelogy;

import java.io.Serializable;
import java.util.Date;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import architecture.community.model.Models;
import architecture.community.model.PropertyAwareSupport;
import architecture.community.model.json.JsonDateDeserializer;
import architecture.community.model.json.JsonDateSerializer;

public class Category extends PropertyAwareSupport implements Serializable {
    
	private Integer objectType;
    private Long objectId; 
    private Long categoryId;
	private String name;
	private String displayName;
	private String description;
	private Date creationDate;
	private Date modifiedDate;
	
	public Category() {
		this.objectType = Models.UNKNOWN.getObjectType();
		this.objectId = -1L;
		this.categoryId = -1L;
		this.name = null;
		this.displayName = null;
		this.description = null;
		Date now = new Date();
		this.creationDate = now;
		this.modifiedDate = creationDate;
	}

	public Category(Long categoryId) {
		this.objectType = Models.UNKNOWN.getObjectType();
		this.objectId = -1L;
		this.categoryId = categoryId;
		this.name = null;
		this.displayName = null;
		this.description = null;
		Date now = new Date();
		this.creationDate = now;
		this.modifiedDate = creationDate;
	}	
	
    public Integer getObjectType() {
		return objectType;
	}

	public void setObjectType(Integer objectType) {
		this.objectType = objectType;
	}

	public Long getObjectId() {
		return objectId;
	}

	public void setObjectId(Long objectId) {
		this.objectId = objectId;
	}



	public Long getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(Long categoryId) {
		this.categoryId = categoryId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
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
	
}
