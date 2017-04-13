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

package architecture.community.model;

import architecture.community.comment.Comment;
import architecture.community.util.LongTree;

public class ModelObjectTreeWalker {

	private LongTree tree;
	
	private ModelObject modelObject;

	public ModelObjectTreeWalker(ModelObject modelObject, LongTree tree) {
		this.modelObject = modelObject;
		this.tree = tree;
	}

	public ModelObjectTreeWalker(int objectType, long objectId, LongTree tree) {
		this.modelObject = new DefaultModelObject(objectType, objectId);
		this.tree = tree;
	}
	
	
	public int getObjectType(){
		return modelObject.getObjectType();
	}
	
	public long getObjectId(){
		return modelObject.getObjectId();
	}

	protected LongTree getTree() {
		return tree;
	}

	protected ModelObject getModelObject() {
		return modelObject;
	}
	
	protected long[] getCommentIds(Comment parent) {
		return tree.getChildren(parent.getCommentId());
	}

	protected long[] getRecursiveCommentIds(Comment parent) {
		return tree.getRecursiveChildren(parent.getCommentId());
	}
	
	protected int getRecursiveChildCount(long parentId) {
		int numChildren = 0;
		int num = tree.getChildCount(parentId);
		numChildren += num;
		for (int i = 0; i < num; i++) {
			long childID = tree.getChild(parentId, i);
			if (childID != -1L)
				numChildren += getRecursiveChildCount(childID);
		}
		return numChildren;
	}

}
