package architecture.community.web.spring.controller.data.admin.v1;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.ResourceLoader;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import architecture.community.exception.NotFoundException;
import architecture.community.model.Property;
import architecture.community.model.json.JsonDateDeserializer;
import architecture.community.model.json.JsonDateSerializer;
import architecture.community.page.DefaultBodyContent;
import architecture.community.page.DefaultPage;
import architecture.community.page.Page;
import architecture.community.page.PageService;
import architecture.community.page.PageView;
import architecture.community.user.User;
import architecture.community.util.SecurityHelper;
import architecture.community.web.model.ItemList;
import architecture.community.web.model.json.Result;
import architecture.ee.service.ConfigService;

@Controller("community-data-v1-mgmt-pages-controller")
@RequestMapping("/data/api/mgmt/v1/pages")
public class PageMgmtDataController {

	private Logger log = LoggerFactory.getLogger(getClass());

	@Inject
	@Qualifier("pageService")
	private PageService pageService;

	
	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	
	@Autowired
	private ResourceLoader resourceLoader;

	public PageMgmtDataController() {

	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getPages(
			@RequestParam(value = "startIndex", defaultValue = "0", required = false) Integer startIndex,
			@RequestParam(value = "pageSize", defaultValue = "15", required = false) Integer pageSize,
			@RequestParam(value = "fields", defaultValue = "", required = false) String fields,
			NativeWebRequest request) {

		boolean includeBodyContent = StringUtils.containsOnly(fields, "bodyContent");

		int objectType = -1;
		long objectId = -1L;

		ItemList items = new ItemList();
		int total = pageService.getPageCount(objectType, objectId);
		if (total > 0) {
			List<Page> list = pageService.getPages(objectType, objectId, startIndex, pageSize);
			List<Page> list2 = new ArrayList<Page>(list.size());
			for (Page p : list)
				list2.add(new PageView(p, includeBodyContent));
			items.setTotalCount(total);
			items.setItems(list2);
		}

		log.debug("" + items.getTotalCount());

		return items;

	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/save-or-update.json", method = { RequestMethod.POST })
	@ResponseBody
	public Result saveOrUpdate(@RequestBody DefaultPage page,
			@RequestParam(value = "fields", defaultValue = "", required = false) String fields,
			NativeWebRequest request) throws NotFoundException {

		boolean includeBodyContent = StringUtils.containsOnly(fields, "bodyContent");
		boolean includeProperties = StringUtils.containsOnly(fields, "properties");

		boolean doUpdate = false;
		User user = SecurityHelper.getUser();

		Page pageToUse;
		if (page.getPageId() > 0) {
			pageToUse = pageService.getPage(page.getPageId());
			if (!StringUtils.equals(page.getName(), pageToUse.getName())
					|| !StringUtils.equals(page.getTitle(), pageToUse.getTitle())
					|| pageToUse.getPageState() != page.getPageState()
					|| !StringUtils.equals(page.getSummary(), pageToUse.getSummary()) 
					|| !StringUtils.equals(page.getTemplate(), pageToUse.getTemplate()) 
					|| pageToUse.isSecured() != page.isSecured()
					|| !StringUtils.equals(page.getBodyContent().getBodyText(), pageToUse.getBodyContent().getBodyText()) ) {
				doUpdate = true;
			}
		} else {
			pageToUse = new DefaultPage(page.getObjectType(), page.getObjectId());
			pageToUse.setUser(user);
			pageToUse.setBodyContent(new DefaultBodyContent());
			doUpdate = true;
		}

		if (doUpdate) {
			pageToUse.setName(page.getName());
			pageToUse.setTitle(page.getTitle());
			
			if( page.getPageState() != null)
					pageToUse.setPageState(page.getPageState());
			
			pageToUse.setSummary(page.getSummary());
			pageToUse.setTemplate(page.getTemplate());
			pageToUse.setSecured(page.isSecured());
			if (includeBodyContent)
				pageToUse.setBodyText(page.getBodyContent().getBodyText());			
			if (includeProperties)
				pageToUse.setProperties(page.getProperties());
			pageService.saveOrUpdatePage(pageToUse);
		}
		
		return  Result.newResult("item", pageToUse );
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/update_state.json", method = RequestMethod.POST)
	@ResponseBody
	public Result updatePageState(@RequestBody DefaultPage page, NativeWebRequest request) throws NotFoundException {

		Page target = pageService.getPage(page.getPageId());
		target.setPageState(page.getPageState());
		pageService.saveOrUpdatePage(target);

		return Result.newResult();
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/get_template_content.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public FileInfo getTemplateContent(@RequestParam(value = "path", defaultValue = "", required = false) String path,
			NativeWebRequest request) throws NotFoundException {

		StringBuilder sb = new StringBuilder("/WEB-INF/template/ftl");
		if( StringUtils.startsWith(path, "/")) {
			sb.append(path);
		}else {
			sb.append('/').append(path);
		}
		
		File file;
		try {
			file = resourceLoader.getResource( sb.toString() ).getFile();
			FileInfo fileInfo = new FileInfo(file);
			fileInfo.setFileContent(file.isDirectory() ? "" : FileUtils.readFileToString(file, "UTF-8"));
			return fileInfo;
		} catch (IOException e) {
			throw new NotFoundException(e);
		}		
		
	}
	
	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/{pageId:[\\p{Digit}]+}/get.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Page getPage(@PathVariable Long pageId,
			@RequestParam(value = "content", defaultValue = "false") Boolean includeBodyContent,
			@RequestParam(value = "versionId", defaultValue = "1") Integer versionId, 
			NativeWebRequest request)
			throws NotFoundException {

		User user = SecurityHelper.getUser();
		Page page = pageService.getPage(pageId, versionId);
		return new PageView(page, includeBodyContent) ;
	}
	

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/{pageId:[\\p{Digit}]+}/properties/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Property> getPageProperties(@PathVariable Long pageId,
			@RequestParam(value = "versionId", defaultValue = "1") Integer versionId, NativeWebRequest request)
			throws NotFoundException {

		User user = SecurityHelper.getUser();
		if (pageId <= 0) {
			return Collections.EMPTY_LIST;
		}
		Page page = pageService.getPage(pageId, versionId);
		Map<String, String> properties = page.getProperties();
		return toList(properties);
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/{pageId:[\\p{Digit}]+}/properties/update.json", method = RequestMethod.POST)
	@ResponseBody
	public List<Property> updatePageProperties(
			@PathVariable Long pageId,
			@RequestParam(value = "versionId", defaultValue = "1") Integer versionId,
			@RequestBody List<Property> newProperties, 
			NativeWebRequest request) throws NotFoundException {
		User user = SecurityHelper.getUser();
		Page page = pageService.getPage(pageId, versionId);
		Map<String, String> properties = page.getProperties();
		// update or create
		for (Property property : newProperties) {
			properties.put(property.getName(), property.getValue().toString());
		}
		if (newProperties.size() > 0) {
			pageService.saveOrUpdatePage(page);
		}
		return toList(properties);
	}

	@Secured({ "ROLE_ADMINISTRATOR" })
	@RequestMapping(value = "/{pageId:[\\p{Digit}]+}/properties/delete.json", method = { RequestMethod.POST, RequestMethod.DELETE })
	@ResponseBody
	public List<Property> deletePageProperties(
			@PathVariable Long pageId,
			@RequestParam(value = "versionId", defaultValue = "1") Integer versionId,
			@RequestBody List<Property> newProperties, 
			NativeWebRequest request) throws NotFoundException {
		User user = SecurityHelper.getUser();
		Page page = pageService.getPage(pageId, versionId);
		Map<String, String> properties = page.getProperties();
		for (Property property : newProperties) {
			properties.remove(property.getName());
		}
		if (newProperties.size() > 0) {
			pageService.saveOrUpdatePage(page);
		}
		return toList(properties);
	}

	protected List<Property> toList(Map<String, String> properties) {
		List<Property> list = new ArrayList<Property>();
		for (String key : properties.keySet()) {
			String value = properties.get(key);
			list.add(new Property(key, value));
		}
		return list;
	}

	public static class FileInfo {

		private boolean customized;
		private boolean directory;
		private String path;
		private String absolutePath;
		private String name;
		private long size;
		private Date lastModifiedDate;
		private String fileContent;

		/**
		 * 
		 */
		public FileInfo(File file) {
			this.customized = false;
			this.lastModifiedDate = new Date(file.lastModified());
			this.name = file.getName();
			this.path = file.getPath();
			this.absolutePath = file.getAbsolutePath();
			this.directory = file.isDirectory();
			if (this.directory) {
				this.size = FileUtils.sizeOfDirectory(file);
			} else {
				this.size = FileUtils.sizeOf(file);
			}
		}

		public FileInfo(File root, File file) {
			this.lastModifiedDate = new Date(file.lastModified());
			this.name = file.getName();
			this.path = StringUtils.removeStart(file.getAbsolutePath(), root.getAbsolutePath());
			this.absolutePath = file.getAbsolutePath();
			this.directory = file.isDirectory();
			if (this.directory) {
				this.size = FileUtils.sizeOfDirectory(file);
			} else {
				this.size = FileUtils.sizeOf(file);
			}

			this.customized = false;
		}

		public FileInfo(File root, File file, boolean customized) {
			this(root, file);
			this.customized = customized;
		}

		/**
		 * @return fileContent
		 */
		public String getFileContent() {
			return fileContent;
		}

		/**
		 * @param fileContent
		 *            설정할 fileContent
		 */
		public void setFileContent(String fileContent) {
			this.fileContent = fileContent;
		}

		/**
		 * @return customized
		 */
		public boolean isCustomized() {
			return customized;
		}

		/**
		 * @param customized
		 *            설정할 customized
		 */
		public void setCustomized(boolean customized) {
			this.customized = customized;
		}

		/**
		 * @return directory
		 */
		public boolean isDirectory() {
			return directory;
		}

		/**
		 * @param directory
		 *            설정할 directory
		 */
		public void setDirectory(boolean directory) {
			this.directory = directory;
		}

		/**
		 * @return path
		 */
		public String getPath() {
			return path;
		}

		/**
		 * @param path
		 *            설정할 path
		 */
		public void setPath(String path) {
			this.path = path;
		}

		/**
		 * @return absolutePath
		 */
		public String getAbsolutePath() {
			return absolutePath;
		}

		/**
		 * @param absolutePath
		 *            설정할 absolutePath
		 */
		public void setAbsolutePath(String absolutePath) {
			this.absolutePath = absolutePath;
		}

		/**
		 * @return name
		 */
		public String getName() {
			return name;
		}

		/**
		 * @param name
		 *            설정할 name
		 */
		public void setName(String name) {
			this.name = name;
		}

		/**
		 * @return size
		 */
		public long getSize() {
			return size;
		}

		/**
		 * @param size
		 *            설정할 size
		 */
		public void setSize(long size) {
			this.size = size;
		}

		/**
		 * @return lastModifiedDate
		 */
		@JsonSerialize(using = JsonDateSerializer.class)
		public Date getLastModifiedDate() {
			return lastModifiedDate;
		}

		/**
		 * @param lastModifiedDate
		 *            설정할 lastModifiedDate
		 */
		@JsonDeserialize(using = JsonDateDeserializer.class)
		public void setLastModifiedDate(Date lastModifiedDate) {
			this.lastModifiedDate = lastModifiedDate;
		}
	}
}
