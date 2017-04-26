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

package architecture.community.image;

import java.util.Calendar;
import java.util.Date;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import architecture.community.model.json.JsonDateDeserializer;
import architecture.community.model.json.JsonDateSerializer;

public class DefaultLogoImage implements LogoImage {

	private int objectType;

    private Long objectId;

    private Long logoId;

    private Long userId;

    private boolean primary;

    private String imageContentType;

    private Integer imageSize;

    private String thumbnailContentType;

    private Integer thumbnailSize;

    private Date creationDate;

    private Date modifiedDate;

    private String filename;

    public DefaultLogoImage() {
		this.logoId = UNKNOWN_OBJECT_ID ;
		this.objectType = UNKNOWN_OBJECT_TYPE;
		this.objectId = -1L;
		this.primary = false;
		this.imageContentType = null;
		this.imageSize = 0;
		this.thumbnailContentType = DEFAULT_THUMBNAIL_CONTENT_TYPE;
		this.thumbnailSize = 0;
		Date now = Calendar.getInstance().getTime();
		this.creationDate = now;
		this.modifiedDate = now;
    }

    /**
     * @param logoId
     *            설정할 logoId
     */
    public void setLogoId(Long logoId) {
	this.logoId = logoId;
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

	/**
     * @return userId
     */
    public Long getUserId() {
	return userId;
    }

    /**
     * @param userId
     *            설정할 userId
     */
    public void setUserId(Long userId) {
	this.userId = userId;
    }

    /**
     * @param primary
     *            설정할 primary
     */
    public void setPrimary(boolean primary) {
	this.primary = primary;
    }

    public Boolean isPrimary() {
	return primary;
    }

    /**
     * @return imageContentType
     */
    public String getImageContentType() {
	return imageContentType;
    }

    /**
     * @param imageContentType
     *            설정할 imageContentType
     */
    public void setImageContentType(String imageContentType) {
	this.imageContentType = imageContentType;
    }

    /**
     * @return imageSize
     */
    public Integer getImageSize() {
	return imageSize;
    }

    /**
     * @param imageSize
     *            설정할 imageSize
     */
    public void setImageSize(Integer imageSize) {
	this.imageSize = imageSize;
    }

    /**
     * @return thumbnailContentType
     */
    public String getThumbnailContentType() {
	return thumbnailContentType;
    }

    /**
     * @param thumbnailContentType
     *            설정할 thumbnailContentType
     */
    public void setThumbnailContentType(String thumbnailContentType) {
	this.thumbnailContentType = thumbnailContentType;
    }

    /**
     * @return thumbnailSize
     */
    public Integer getThumbnailSize() {
	return thumbnailSize;
    }

    /**
     * @param thumbnailSize
     *            설정할 thumbnailSize
     */
    public void setThumbnailSize(Integer thumbnailSize) {
	this.thumbnailSize = thumbnailSize;
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
    @JsonDeserialize(using = JsonDateDeserializer.class)
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
    @JsonDeserialize(using = JsonDateDeserializer.class)
    public void setModifiedDate(Date modifiedDate) {
	this.modifiedDate = modifiedDate;
    }

    /**
     * @return filename
     */
    public String getFilename() {
	return filename;
    }

    /**
     * @param filename
     *            설정할 filename
     */
    public void setFilename(String filename) {
	this.filename = filename;
    }

    /**
     * @return logoId
     */
    public Long getLogoId() {
	return logoId;
    }


    @Override
    public String toString() {
	StringBuilder builder = new StringBuilder();
	builder.append("LogoImage [");
	if (logoId != null)
	    builder.append("logoId=").append(logoId).append(", ");
	builder.append("objectType=").append(objectType).append(", ");
	if (objectId != null)
	    builder.append("objectId=").append(objectId).append(", ");
	if (userId != null)
	    builder.append("userId=").append(userId).append(", ");

	builder.append("primary=").append(primary).append(", ");

	if (filename != null)
	    builder.append("filename=").append(filename).append(", ");
	if (imageContentType != null)
	    builder.append("imageContentType=").append(imageContentType).append(", ");
	if (imageSize != null)
	    builder.append("imageSize=").append(imageSize).append(", ");
	if (thumbnailContentType != null)
	    builder.append("thumbnailContentType=").append(thumbnailContentType).append(", ");
	if (thumbnailSize != null)
	    builder.append("thumbnailSize=").append(thumbnailSize).append(", ");
	if (creationDate != null)
	    builder.append("creationDate=").append(creationDate).append(", ");
	if (modifiedDate != null)
	    builder.append("modifiedDate=").append(modifiedDate);
	builder.append("]");
	return builder.toString();
    }
}
