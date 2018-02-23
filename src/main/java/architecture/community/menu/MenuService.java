package architecture.community.menu;

import java.util.List;

public interface MenuService {

	public abstract Menu createMenu(String name, String description) throws MenuAlreadyExistsException;
	
	public abstract void saveOrUpdateMenu(Menu menu);
	
	public abstract void saveOrUpdateMenuItem(MenuItem item);

	public abstract void deleteMenu(Menu menu);
	
	public abstract Menu getMenuById(long menuId) throws MenuNotFoundException ;
	
	public abstract Menu getMenuByName(String name) throws MenuNotFoundException ;
	
	public abstract List<Menu> getAllMenus();	
	
	public abstract MenuItem getMenuItemById(long menuItemId) throws MenuItemNotFoundException ;
	
}
