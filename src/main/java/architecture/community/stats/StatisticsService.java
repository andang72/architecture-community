package architecture.community.stats;

import java.util.List;

import architecture.community.query.ParameterValue;

public interface StatisticsService {

	public List stat(String target , String statName, List<ParameterValue> values);
	
}
