package architecture.community.page.api.dao;

import architecture.community.page.api.Api;

public interface ApiDao {
	
	public void saveOrUpdate(Api api);
	
	public Api getApiById(long apiId);
	
	public Long getApiIdByName(String name);
	
	public void deleteApi(Api api);
	
}
