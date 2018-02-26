package architecture.community.menu;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

import javax.annotation.PostConstruct;
import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;

import architecture.community.menu.dao.MenuDao;

public class CommunityMenuService implements MenuService {

	private Logger logger = LoggerFactory.getLogger(getClass().getName());

	private com.google.common.cache.LoadingCache<Long, Menu> menuCache = null;
	
	private com.google.common.cache.LoadingCache<String, Long> menuIdCache = null;

	private com.google.common.cache.LoadingCache<Long, MenuItem> menuItemCache = null;
	
	
	
	public CommunityMenuService() {
	}

	@PostConstruct
	public void initialize(){		
		logger.debug("creating cache ...");		
		menuCache = CacheBuilder.newBuilder().maximumSize(50).expireAfterAccess(30, TimeUnit.MINUTES).build(		
				new CacheLoader<Long, Menu>(){			
					public Menu load(Long menuId) throws Exception {
						return menuDao.getMenuById(menuId);
				}}
			);
		
		menuIdCache = CacheBuilder.newBuilder().maximumSize(50).expireAfterAccess(30, TimeUnit.MINUTES).build(		
				new CacheLoader<String, Long>(){			
					public Long load(String name) throws Exception {	
						return menuDao.getMenuIdByName(name);
				}}
		);
		menuItemCache = CacheBuilder.newBuilder().maximumSize(50).expireAfterAccess(30, TimeUnit.MINUTES).build(		
				new CacheLoader<Long, MenuItem>(){			
					public MenuItem load(Long menuItemId) throws Exception {
						return menuDao.getMenuItemById(menuItemId);
				}}
			);
		
	}
	
	@Inject
	@Qualifier("menuDao")
	private MenuDao menuDao;
 
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public Menu createMenu(String name, String description) throws MenuAlreadyExistsException {
		Menu menu = new Menu();
		menu.setName(name);
		menu.setDescription(description);		
		
		try {
			getMenuByName(name);
			throw new MenuAlreadyExistsException();
		} catch (MenuNotFoundException e) {}
		menuDao.saveOrUpdate(menu);		
		return menu;
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void saveOrUpdateMenu(Menu menu) {		
		menuDao.saveOrUpdate(menu);
		invalidateMenuCache(menu);
	}
 
	public void deleteMenu(Menu menu) {
		invalidateMenuCache(menu);
	}

	
	public Menu getMenuByName(String name) throws MenuNotFoundException {
		Long menuId;
		try {
			menuId = menuIdCache.get(name);
		} catch (Throwable e) {
			throw new MenuNotFoundException(e);
		}		
		return getMenuById(menuId);
	}

	
	public Menu getMenuById(long menuId) throws MenuNotFoundException {
		try {			
			Menu menu = menuCache.get(menuId);	
			if( menuIdCache.getIfPresent(menu.getName()) == null ){
				logger.debug("put ID:{}, NAME:{} into menuIdcache. ", menu.getMenuId(), menu.getName());
				menuIdCache.put(menu.getName(), menu.getMenuId());
			}			
			return menu;
		} catch (ExecutionException e) {
			throw new MenuNotFoundException(e);
		}
	}

	public MenuItem getMenuItemById(long menuItemId) throws MenuItemNotFoundException {
		try {			
			MenuItem item = menuItemCache.get(menuItemId);			
			return item;
		} catch (ExecutionException e) {
			throw new MenuItemNotFoundException(e);
		}
	}


	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void saveOrUpdateMenuItem(MenuItem menuItem) {		
		
		if( menuItem.getParentMenuItemId() == null )
		{
			menuItem.setParentMenuItemId(-1L);
		}
		menuDao.saveOrUpdate(menuItem);
		menuItemCache.invalidate(menuItem.getMenuItemId());
	}
 
	public void deleteMenuItem(MenuItem menuItem) {
		menuItemCache.invalidate(menuItem.getMenuItemId());
	}
	
	public List<Menu> getAllMenus() {
		List<Menu> menus = new ArrayList<Menu>();
		List<Long> menuIds = menuDao.getAllMenuIds();
		for (long menuId : menuIds) {
		    try {
		    	menus.add(getMenuById(menuId));
		    } catch (MenuNotFoundException e) {
		    }
		}
		return menus;
	}
	
	
	
	
	private void invalidateMenuCache(Menu menu){		
		menuCache.invalidate(menu.getMenuId());
		menuIdCache.invalidate(menu.getName());
	}
 
}
