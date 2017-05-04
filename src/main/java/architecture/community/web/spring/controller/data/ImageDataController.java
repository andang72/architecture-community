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

package architecture.community.web.spring.controller.data;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

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

import architecture.community.exception.NotFoundException;
import architecture.community.image.Image;
import architecture.community.image.ImageService;
import architecture.community.user.User;
import architecture.community.util.SecurityHelper;
import architecture.ee.util.StringUtils;

@Controller("images-data-controller")
@RequestMapping("/data/images")

public class ImageDataController {

	private Logger log = LoggerFactory.getLogger(ImageDataController.class);

	@Inject
	@Qualifier("imageService")
	private ImageService imageService;

	public ImageDataController() {
	}

	@RequestMapping(value = "/image/{imageId}/{filename:.+}", method = RequestMethod.GET)
	@ResponseBody
	public void handleImage(@PathVariable("imageId") Long imageId, @PathVariable("filename") String filename,
			@RequestParam(value = "width", defaultValue = "0", required = false) Integer width,
			@RequestParam(value = "height", defaultValue = "0", required = false) Integer height,
			HttpServletResponse response) throws IOException {

		log.debug(" ------------------------------------------");
		log.debug("imageId:" + imageId);
		log.debug("width:" + width);
		log.debug("height:" + height);
		log.debug("------------------------------------------");
		try {
			if (imageId > 0 && !StringUtils.isNullOrEmpty(filename)) {
				Image image = imageService.getImage(imageId);
				User user = SecurityHelper.getUser();

				if (filename.equals(image.getName())) {
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
				} else {
					throw new NotFoundException();
				}
			} else {
				throw new NotFoundException();
			}
		} catch (NotFoundException e) {
			response.sendError(404);
		}
	}

}
