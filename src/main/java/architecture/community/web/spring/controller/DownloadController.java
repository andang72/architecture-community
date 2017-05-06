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

package architecture.community.web.spring.controller;

import java.io.IOException;
import java.io.InputStream;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import architecture.community.image.ImageService;
import architecture.community.image.LogoImage;
import architecture.community.web.spring.controller.data.ImageDataController;
import architecture.ee.service.ConfigService;

@Controller("download-controller")
@RequestMapping("/download")
public class DownloadController {

	private Logger log = LoggerFactory.getLogger(ImageDataController.class);

	@Inject
	@Qualifier("imageService")
	private ImageService imageService;

	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	public DownloadController() {
		
	}

	


	@RequestMapping(value = "/logos/{objectType}/{objectId}", method = RequestMethod.GET)
	@ResponseBody
	public void downloadLogo(
			@PathVariable("objectType") int objectType, 
			@PathVariable("objectId") long objectId,
			@RequestParam(value = "width", defaultValue = "0", required = false) Integer width,
			@RequestParam(value = "height", defaultValue = "0", required = false) Integer height,
			HttpServletResponse response) throws IOException {

		try {
			LogoImage image = imageService.getPrimaryLogoImage(objectType, objectId);
			if (image != null) {
				InputStream input;
				String contentType;
				int contentLength;
				if (width > 0 && width > 0) {
					input = imageService.getImageThumbnailInputStream(image, width, height);
					contentType = image.getThumbnailContentType();
					contentLength = image.getThumbnailSize();
				} else {
					input = imageService.getImageInputStream(image);
					contentType = image.getContentType();
					contentLength = image.getSize();
				}
				response.setContentType(contentType);
				response.setContentLength(contentLength);
				IOUtils.copy(input, response.getOutputStream());
				response.flushBuffer();
			}

		} catch (Exception e) {
			log.warn(e.getMessage(), e);
			response.setStatus(301);
			String url = configService.getApplicationProperty("components.download.images.no-logo-url", "/images/common/what-to-know-before-getting-logo-design.png");
			response.addHeader("Location", url);
		}
	}

	
}
