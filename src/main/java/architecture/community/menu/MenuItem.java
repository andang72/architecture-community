package architecture.community.menu;

import java.io.Serializable;
import java.util.Date;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import architecture.community.model.json.JsonDateSerializer;

public class MenuItem implements Serializable {
	
	private long menuId;
	
	private long menuItemId;
	
	private long parentMenuItemId;
	
	private String name;
	
	private String description;
	
	private String location;
	
	private int sortOrder;
	
	private Date creationDate;

	private Date modifiedDate;
	
	public MenuItem() {
		this.menuId = -1L;
		this.parentMenuItemId = -1L;
		this.menuItemId = -1L;
		this.sortOrder = 0;
		this.creationDate = new Date();
		this.modifiedDate = creationDate;
	}

	public MenuItem(long menuItemId) {
		this.menuId = -1L;
		this.parentMenuItemId = -1L;
		this.menuItemId = menuItemId ;
		this.sortOrder = 0;
		this.creationDate = new Date();
		this.modifiedDate = creationDate;
	}
	
	public int getSortOrder() {
		return sortOrder;
	}

	public void setSortOrder(int sortOrder) {
		this.sortOrder = sortOrder;
	}

	public long getMenuId() {
		return menuId;
	}

	public void setMenuId(long menuId) {
		this.menuId = menuId;
	}

	public long getMenuItemId() {
		return menuItemId;
	}

	public void setMenuItemId(long menuItemId) {
		this.menuItemId = menuItemId;
	}

	public long getParentMenuItemId() {
		return parentMenuItemId;
	}

	public void setParentMenuItemId(long parentMenuItemId) {
		this.parentMenuItemId = parentMenuItemId;
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

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}


	/**
	 * @return creationDate
	 */
	@JsonSerialize(using = JsonDateSerializer.class)
	public Date getCreationDate() {
		return creationDate;
	}

	/**
	 * @param creationDate
	 *            설정할 creationDate
	 */
	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}

	/**
	 * @return modifiedDate
	 */
	@JsonSerialize(using = JsonDateSerializer.class)
	public Date getModifiedDate() {
		return modifiedDate;
	}

	/**
	 * @param modifiedDate
	 *            설정할 modifiedDate
	 */
	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}

}
