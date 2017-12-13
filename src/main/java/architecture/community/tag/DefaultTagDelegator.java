package architecture.community.tag;

import java.util.List;

import architecture.community.exception.UnAuthorizedException;

public class DefaultTagDelegator implements TagDelegator {

	private int objectType = -1;
	private long objectId = -1L;
	private TagManager tagManager;

	public DefaultTagDelegator(int objectType, long objectId, TagManager tagManager) {
		this.objectType = objectType;
		this.objectId = objectId;
		this.tagManager = tagManager;
	}

	public ContentTag createTag(String tagname) {
		return tagManager.createTag(tagname);
	}

	public ContentTag getTag(String tagname) throws TagNotFoundException {
		return tagManager.getTag(tagname);
	}

	public ContentTag getTag(long tagId) throws TagNotFoundException {
		return tagManager.getTag(tagId);
	}

	public void setTags(String tags) {
		tagManager.setTags(tags, objectType, objectId);
	}

	public String getTagsAsString() {
		return tagManager.getTagsAsString(objectType, objectId);
	}

	public void addTag(ContentTag tag) throws UnAuthorizedException {
		tagManager.addTag(tag, objectType, objectId);
	}

	public List<ContentTag> getTags() {
		return tagManager.getTags(objectType, objectId);
	}

	public void removeTag(ContentTag tag) throws UnAuthorizedException {
		tagManager.removeTag(tag, objectType, objectId);
	}

	public void removeAllTags() throws UnAuthorizedException {
		tagManager.removeAllTags(objectType, objectId);
	}
}