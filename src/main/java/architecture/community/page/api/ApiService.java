package architecture.community.page.api;

public interface ApiService {

	public Api getApiById( long apiId ) throws ApiNotFoundException; 
	
	public Api getApi(String name ) throws ApiNotFoundException ;
	
	public void deleteApi( Api api ) ;
	
	public void saveOrUpdate(Api api);
	
}
