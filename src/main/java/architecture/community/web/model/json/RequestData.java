package architecture.community.web.model.json;

import java.util.HashMap;

import com.fasterxml.jackson.annotation.JsonAnySetter;

public class RequestData {
	
	private HashMap<String, Object> data;
	
    public RequestData() {
    	data = new HashMap<String, Object>();
	}

	@JsonAnySetter
    public void handleUnknown(String key, Object value) {
        data.put(key, value);
    }
        
    public HashMap<String, Object> getData() {
        return data;
    }    
    
    public String getDataAsString(String key, String defaultValue){
    	if( data.containsKey(key)){
    		return data.get(key).toString();
    	}
    	return defaultValue;
    }
    
}
