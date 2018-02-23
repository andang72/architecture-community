package architecture.community.menu.dao;

import java.util.List;

import architecture.community.menu.Menu;
import architecture.community.menu.MenuItem;
import architecture.community.menu.MenuNotFoundException;

public interface MenuDao {
	
	public void saveOrUpdate(Menu menu);
	
	public void saveOrUpdate(MenuItem item);
	
	public long getMenuIdByName(String name) throws MenuNotFoundException ;
	
	public Menu getMenuById(long menuId);
	
	public List<Long> getAllMenuIds();
	
	public MenuItem getMenuItemById(long menuItemId);
	
	public List<MenuItem> getMenuItemsByMenuId(long menuId);
	
}
