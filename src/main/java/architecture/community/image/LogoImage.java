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

import java.util.Date;

import architecture.community.model.ModelObject;

public interface LogoImage extends ModelObject {

	public static final String DEFAULT_THUMBNAIL_CONTENT_TYPE = "image/png";

	public Long getLogoId();

	public void setLogoId(Long logoId);

	public Long getUserId();

	public Boolean isPrimary();

	public String getFilename();

	public void setFilename(String filename);

	public void setPrimary(boolean primary);

	public String getImageContentType();

	public void setImageContentType(String imageContentType);

	public Integer getImageSize();

	public void setImageSize(Integer imageSize);

	public String getThumbnailContentType();

	public Integer getThumbnailSize();

	public void setThumbnailContentType(String thumbnailContentType);

	public void setThumbnailSize(Integer thumbnailSize);

	public Date getCreationDate();

	public void setCreationDate(Date creationDate);

	public Date getModifiedDate();

	public void setModifiedDate(Date modifiedDate);
}
