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

package architecture.community.link;

import architecture.community.model.ModelObjectAwareSupport;

public class ExternalLink extends ModelObjectAwareSupport {

	private String externalId;

	private boolean publicShared;
	
	private Object target;

	public ExternalLink(int objectType, long objectId) {
		super(objectType, objectId);
	}

	public ExternalLink( String externalId, int objectType, long objectId, boolean publicShared) {
		super(objectType, objectId);
		this.externalId = externalId;
		this.publicShared = publicShared;
	}

	public String getExternalId() {
		return externalId;
	}

	public void setExternalId(String externalId) {
		this.externalId = externalId;
	}

	public boolean isPublicShared() {
		return publicShared;
	}

	public void setPublicShared(boolean publicShared) {
		this.publicShared = publicShared;
	}

	public Object getTarget() {
		return target;
	}

	public void setTarget(Object target) {
		this.target = target;
	}
	
	
}
