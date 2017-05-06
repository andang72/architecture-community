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

public class ExternalLink extends DefaultModelObject {

	private String linkId;

	private boolean publicShared;

	public ExternalLink(int objectType, long objectId, String linkId, boolean publicShared) {
		super(objectType, objectId);
		this.linkId = linkId;
		this.publicShared = publicShared;
	}

	public boolean isPublicShared() {
		return publicShared;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("ExternalLink [objectType=").append(objectType).append(", objectId=").append(objectId)
				.append(", ");
		if (linkId != null)
			builder.append("linkId=").append(linkId).append(", ");
		builder.append("publicShared=").append(publicShared).append("]");
		return builder.toString();
	}

}
