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

package tests;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import architecture.community.model.Models;

public class ModelTest {

	private Logger log = LoggerFactory.getLogger(getClass());
	
	public ModelTest() {

	}
	
	@Test
	public void testGetModelIds(){
		for(Models m : Models.values()){
			log.debug("{} = {} = {} ", m.ordinal(), m.name(), m.getObjectType() );
		}
		log.debug("{}" , Models.valueOf(14).name() ) ;

	}

}
