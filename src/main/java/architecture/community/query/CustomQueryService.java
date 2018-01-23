package architecture.community.query;

import java.util.List;
import java.util.Map;

public interface CustomQueryService {
	
	public List<Map<String, Object>> list(String source, String statement, List<ParameterValue> values) ;

}
