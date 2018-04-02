package architecture.community.catelogy;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.community.catelogy.dao.CategoryDao;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

public class CommunityCategoryService implements CategoryService {

	@Inject
	@Qualifier("categoryDao")
	private CategoryDao categoryDao;
    
	@Inject
	@Qualifier("categoryCache")
	private Cache categoryCache;

	public Category getCategory(long categoryId) throws CategoryNotFoundException {
		Category category = null;
		if (categoryCache.get(categoryId) != null) {
			category = (Category) categoryCache.get(categoryId).getObjectValue();
		}
		if (category == null) {
			category = categoryDao.load(categoryId);
			updateCache(category);
		}
		return category;
	}
	

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void saveOrUpdate(Category category) {	 
		categoryDao.saveOrUpdate(category); 
		if (categoryCache.get(category.getCategoryId()) != null) {
			categoryCache.remove(category.getCategoryId());
		}
	}
	
	private void updateCache(Category category) {
		categoryCache.put(new Element(category.getCategoryId(), category));
	}
}
