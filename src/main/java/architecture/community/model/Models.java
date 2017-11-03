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

public enum Models {
	
	UNKNOWN(-1), 
	USER(1), 
	ROLE(3),
	BOARD(5),
	BOARD_THREAD(6),
	BOARD_MESSAGE(7),
	COMMENT(8),
	ATTACHMENT(10),
	IMAGE(11),
	LOGO_IMAGE(12),
	PROFILE_IMAGE(13);
	
	private int objectType;
	
	private Models(int objectType) {
		this.objectType = objectType;
	}
	
	public int getObjectType()
	{
		return objectType;
	}
	
	public static Models valueOf(int objectType){
		Models selected = Models.UNKNOWN ;
		for( Models m : Models.values() )
		{
			if( m.getObjectType() == objectType ){
				selected = m;
				break;
			}
		}
		return selected;
	}
}


