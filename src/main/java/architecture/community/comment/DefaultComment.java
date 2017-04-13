/**
 *    Copyright 2015-2017 donghyuck
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package architecture.community.comment;

import java.util.Calendar;
import java.util.Date;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import architecture.community.model.json.JsonDateSerializer;
import architecture.community.user.User;
import architecture.community.user.UserTemplate;

public class DefaultComment implements Comment {

	private long commentId;	

	private int objectType;

	private long objectId;
	
	private int parentObjectType;

	private long parentObjectId;
	
	private long parentCommentId;
	
	private Date creationDate;
	
	private Date modifiedDate;
	
	private String name;
	
	private String email;
	
	private String url;
	
	private String ip;
	
	private String body;

	private User user;
	
	private Status status;

	public DefaultComment() {
		this.commentId = -1L;
		this.parentCommentId = -1L;
		this.user = new UserTemplate(-1L);
		this.name = null;
		this.email = null;
		this.url = null;
		this.status = Status.PUBLISHED;
		this.creationDate = Calendar.getInstance().getTime();
		this.modifiedDate = this.creationDate;
		this.body = null;
		this.objectType = -1;
		this.objectId = -1L;
		this.parentObjectType = -1;
		this.parentObjectId = -1L;		
	}

	public DefaultComment(long commentId) {
		this();
		this.commentId = commentId;
	}

	public int getContainerType() {
		return objectType;
	}

	public void setContainerType(int containerType) {
		this.objectType = containerType;
	}

	public long getContainerId() {
		return objectId;
	}

	public void setContainerId(long containerId) {
		this.objectId = containerId;
	}

	public int getObjectType() {
		return objectType;
	}

	public long getObjectId() {
		return commentId;
	}

	public long getCommentId() {
		return commentId;
	}

	public void setCommentId(long commentId) {
		this.commentId = commentId;
	}

	public long getParentCommentId() {
		return parentCommentId;
	}

	public void setParentCommentId(long parentCommentId) {
		this.parentCommentId = parentCommentId;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	/**
	 * @return name
	 */
	public String getName() {
		if (!user.isAnonymous() && user.isNameVisible())
			return user.getName();

		return name;
	}

	/**
	 * @param name
	 *            설정할 name
	 */
	public void setName(String name) {
		this.name = name;
	}

	public int getParentObjectType() {
		return parentObjectType;
	}

	public void setParentObjectType(int parentObjectType) {
		this.parentObjectType = parentObjectType;
	}

	public long getParentObjectId() {
		return parentObjectId;
	}

	public void setParentObjectId(long parentObjectId) {
		this.parentObjectId = parentObjectId;
	}

	public void setObjectType(int objectType) {
		this.objectType = objectType;
	}

	public void setObjectId(long objectId) {
		this.objectId = objectId;
	}

	/**
	 * @return email
	 */
	public String getEmail() {
		if (!user.isAnonymous() && user.isEmailVisible())
			return user.getEmail();

		return email;
	}

	/**
	 * @param email
	 *            설정할 email
	 */
	public void setEmail(String email) {
		this.email = email;
	}

	/**
	 * @return url
	 */
	public String getURL() {
		return url;
	}

	/**
	 * @param url
	 *            설정할 url
	 */
	public void setURL(String url) {
		this.url = url;
	}

	/**
	 * @return ip
	 */
	public String getIPAddress() {
		return ip;
	}

	/**
	 * @param ip
	 *            설정할 ip
	 */
	public void setIPAddress(String ip) {
		this.ip = ip;
	}

	/**
	 * @return body
	 */
	public String getBody() {
		return body;
	}

	/**
	 * @param body
	 *            설정할 body
	 */
	public void setBody(String body) {
		this.body = body;
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

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	public boolean isAnonymous() {
		return user.isAnonymous();
	}

}
