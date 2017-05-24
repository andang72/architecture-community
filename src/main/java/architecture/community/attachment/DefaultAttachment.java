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

package architecture.community.attachment;

import java.io.InputStream;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class DefaultAttachment implements Attachment {

	private long userId = UNKNOWN_OBJECT_ID;
	
    private long attachmentId = UNKNOWN_OBJECT_ID;
	
    private String name;
	
	private String contentType ;
	
	private int objectType ;
	
	private long objectId;
	
	private int size = 0 ;
	
	private int downloadCount = 0;
	
	private Map<String, String> properties ;
	
	private InputStream inputStream;
	
	private Date creationDate;
	
	private Date modifiedDate;
	
	public DefaultAttachment() {
		this.name = null;
		this.inputStream = null;
		this.properties = new HashMap<String, String>();
		this.objectType = UNKNOWN_OBJECT_TYPE ;
		this.objectId = UNKNOWN_OBJECT_ID;
		this.creationDate = Calendar.getInstance().getTime();
		this.modifiedDate = this.creationDate;
	}

	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public long getAttachmentId() {
		return attachmentId;
	}

	public void setAttachmentId(long attachmentId) {
		this.attachmentId = attachmentId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public int getObjectType() {
		return objectType;
	}

	public void setObjectType(int objectType) {
		this.objectType = objectType;
	}

	public long getObjectId() {
		return objectId;
	}

	public void setObjectId(long objectId) {
		this.objectId = objectId;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}

	public int getDownloadCount() {
		return downloadCount;
	}

	public void setDownloadCount(int downloadCount) {
		this.downloadCount = downloadCount;
	}

	public Map<String, String> getProperties() {
		return properties;
	}

	public void setProperties(Map<String, String> properties) {
		this.properties = properties;
	}

	public InputStream getInputStream() {
		return inputStream;
	}

	public void setInputStream(InputStream inputStream) {
		this.inputStream = inputStream;
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

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("Attachement{");
	    sb.append("attachmentId=").append(attachmentId);
	    sb.append(",name=").append(getName());
	    sb.append(",contentType=").append(contentType);
	    sb.append("size=").append(size);
		sb.append("}");
		return sb.toString();
	}
}
