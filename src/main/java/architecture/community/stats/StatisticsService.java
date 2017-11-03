package architecture.community.stats;

import java.util.List;

public interface StatisticsService {

	public List stat(String target , String statName, List<ParameterValue> values);
	
}
