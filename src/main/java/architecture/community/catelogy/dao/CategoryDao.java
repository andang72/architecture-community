package architecture.community.catelogy.dao;

import architecture.community.catelogy.Category;
import architecture.community.catelogy.CategoryNotFoundException;

public interface CategoryDao {

    public abstract Category load(long categoryId) throws CategoryNotFoundException;

    public abstract long getNextCategoryId();

    public void saveOrUpdate(Category category);
    
    public abstract void update(Category category);

    public abstract void insert(Category category);

    public abstract void delete(Category category);
    
}
