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
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import architecture.community.attachment.Attachment;
import architecture.community.attachment.AttachmentService;
import architecture.community.exception.NotFoundException;
import architecture.community.exception.UnAuthorizedException;
import architecture.community.image.Image;
import architecture.community.user.User;
import architecture.community.util.SecurityHelper;
import architecture.community.web.model.ItemList;

@Controller("attachments-data-controller")
@RequestMapping("/data/attachments")
public class AttachmentDataController {

	
	@Inject
	@Qualifier("attachmentService")
	private AttachmentService attachmentService;
	
	
	private Logger log = LoggerFactory.getLogger(AttachmentDataController.class);
	

	@Secured({ "ROLE_USER" })
    @RequestMapping(value = "/upload.json", method = RequestMethod.POST)
    @ResponseBody
    public List<Attachment> uploadFiles(
    		@RequestParam(value = "objectType", defaultValue = "-1", required = false) Integer objectType,
    		@RequestParam(value = "objectId", defaultValue = "-1", required = false) Long objectId,
    		MultipartHttpServletRequest request ) throws NotFoundException, IOException, UnAuthorizedException {

		User user = SecurityHelper.getUser();
		if( user.isAnonymous() )
		    throw new UnAuthorizedException();
	
		Image imageToUse = null ;		
		
		List<Attachment> list = new ArrayList<Attachment>();
		Iterator<String> names = request.getFileNames();		
		while (names.hasNext()) {
		    String fileName = names.next();
		    MultipartFile mpf = request.getFile(fileName);
		    InputStream is = mpf.getInputStream();
		    log.debug("upload - file:{}, size:{}, type:{} ", mpf.getOriginalFilename(), mpf.getSize() , mpf.getContentType() );
		    Attachment attachment = attachmentService.createAttachment(objectType, objectId, mpf.getOriginalFilename(), mpf.getContentType(), is, (int) mpf.getSize());
		    attachmentService.saveAttachment(attachment);
		    list.add(attachment);
		}			
		//return new ExternalLink( "", objectType, objectId, true);
		return list;
    }
	
	@RequestMapping(value = "/list.json", method = RequestMethod.POST)
	@ResponseBody
	public ItemList listMessageFile(
    		@RequestParam(value = "objectType", defaultValue = "-1", required = false) Integer objectType,
    		@RequestParam(value = "objectId", defaultValue = "-1", required = false) Long objectId,
    		NativeWebRequest request) throws NotFoundException {

		ItemList list = new ItemList();
		if( objectType > 0 && objectId > 0 ){
		List<Attachment> attachments = attachmentService.getAttachments(objectType, objectId);
		list.setItems(attachments);
		list.setTotalCount(attachments.size());
		}
		return list;

	}	
}
