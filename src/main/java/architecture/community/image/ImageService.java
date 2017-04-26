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

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import architecture.community.model.ModelObject;

public interface ImageService {

	public LogoImage createLogoImage();
	
	public void addLogoImage(LogoImage logoImage, File file);
	
	public void addLogoImage(LogoImage logoImage, InputStream is);
	
	public void removeLogoImage(LogoImage logoImage) throws ImageNotFoundException ;
	
	public void updateLogoImage( LogoImage logoImage, File file ) throws ImageNotFoundException ;
	
	public LogoImage getLogoImageById(Long logoId)  throws ImageNotFoundException ;
	
	public LogoImage getPrimaryLogoImage(int objectType, long objectId) throws ImageNotFoundException ;
	
	public List<LogoImage> getLogoImages(int objectType, long objectId);
	
	public int getLogoImageCount(int objectType, long objectId);
	
	public InputStream getImageInputStream(LogoImage logoImage )  throws IOException ;
	
	public InputStream getImageThumbnailInputStream(LogoImage image, int width, int height ) ;
	
	public List<LogoImage> getLogoImages(ModelObject model);
	
	public LogoImage getPrimaryLogoImage(ModelObject model)  throws ImageNotFoundException  ;
		
	public int getLogoImageCount(ModelObject model);
	
	
}
