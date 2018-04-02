package architecture.community.catelogy;

public interface CategoryService {
 
	public Category getCategory(long categoryId) throws CategoryNotFoundException ; 
 
	public void saveOrUpdate(Category category);
	
}
