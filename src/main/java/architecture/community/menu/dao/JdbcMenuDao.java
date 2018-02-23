package architecture.community.menu.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameterValue;

import architecture.community.menu.Menu;
import architecture.community.menu.MenuItem;
import architecture.community.menu.MenuNotFoundException;
import architecture.community.model.Models;
import architecture.ee.jdbc.property.dao.PropertyDao;
import architecture.ee.jdbc.sequencer.SequencerFactory;
import architecture.ee.service.ConfigService;
import architecture.ee.spring.jdbc.ExtendedJdbcDaoSupport;

public class JdbcMenuDao extends ExtendedJdbcDaoSupport implements MenuDao { 

	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	@Inject
	@Qualifier("sequencerFactory")
	private SequencerFactory sequencerFactory;

	@Inject
	@Qualifier("propertyDao")
	private PropertyDao propertyDao;
	
	private String menuItemPropertyTableName = "AC_UI_MENU_ITEM_PROPERTY";
	private String menuItemPropertyPrimaryColumnName = "MENU_ITEM_ID";
	
	private final RowMapper<Menu> menuMapper = new RowMapper<Menu>() {		
		public Menu mapRow(ResultSet rs, int rowNum) throws SQLException {			
			Menu item = new Menu(rs.getLong("MENU_ID"));		
			item.setName(rs.getString("NAME"));
			item.setDescription(rs.getString("DESCRIPTION"));
			item.setCreationDate(rs.getDate("CREATION_DATE"));
			item.setModifiedDate(rs.getDate("MODIFIED_DATE"));		
			return item;
		}		
	};
	
	private final RowMapper<MenuItem> menuItemMapper = new RowMapper<MenuItem>() {		
		public MenuItem mapRow(ResultSet rs, int rowNum) throws SQLException {			
			MenuItem item = new MenuItem(rs.getLong("MENU_ITEM_ID"));		
			item.setMenuId(rs.getLong("MENU_ITEM_ID"));
			item.setParentMenuItemId(rs.getLong("PARENT_ID"));
			item.setName(rs.getString("NAME"));
			item.setLocation(rs.getString("LINK_URL"));
			item.setSortOrder(rs.getInt("SORT_ORDER"));
			item.setDescription(rs.getString("DESCRIPTION"));
			item.setCreationDate(rs.getDate("CREATION_DATE"));
			item.setModifiedDate(rs.getDate("MODIFIED_DATE"));		
			return item;
		}		
	};
	
	public JdbcMenuDao() {
	}


	public String getMenuItemPropertyTableName() {
		return menuItemPropertyTableName;
	}


	public void setMenuItemPropertyTableName(String menuItemPropertyTableName) {
		this.menuItemPropertyTableName = menuItemPropertyTableName;
	}


	public String getMenuItemPropertyPrimaryColumnName() {
		return menuItemPropertyPrimaryColumnName;
	}


	public void setMenuItemPropertyPrimaryColumnName(String menuItemPropertyPrimaryColumnName) {
		this.menuItemPropertyPrimaryColumnName = menuItemPropertyPrimaryColumnName;
	}

	public Map<String, String> getMenuItemProperties(long menuItemId) {
		return propertyDao.getProperties(menuItemPropertyTableName, menuItemPropertyPrimaryColumnName, menuItemId);
	}

	public void deleteMenuItemProperties(long menuItemId) {
		propertyDao.deleteProperties(menuItemPropertyTableName, menuItemPropertyPrimaryColumnName, menuItemId);
	}
	
	public void setMenuItemProperties(long menuItemId, Map<String, String> props) {
		propertyDao.updateProperties(menuItemPropertyTableName, menuItemPropertyPrimaryColumnName, menuItemId, props);
	}
		
	public long getNextMenuItemId(){		
		return sequencerFactory.getNextValue(Models.MENU_ITEM.getObjectType(), Models.MENU_ITEM.name());
	}
 
	public long getNextMenuId(){		
		return sequencerFactory.getNextValue(Models.MENU.getObjectType(), Models.MENU.name());
	}

 
	public void saveOrUpdate(Menu menu) {		
		if( menu.getMenuId() < 1) {
			
			// insert case 
			if (menu.getName() == null)
				throw new IllegalArgumentException();		

			if ("".equals(menu.getDescription()))
				menu.setDescription(null);
			menu.setMenuId(getNextMenuId());
			
			try {
				Date now = new Date();
				getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_UI.CREATE_MENU").getSql(),
						new SqlParameterValue(Types.NUMERIC, menu.getMenuId()),
						new SqlParameterValue(Types.VARCHAR, menu.getName()),
						new SqlParameterValue(Types.VARCHAR, menu.getDescription()),
						new SqlParameterValue(Types.TIMESTAMP, menu.getCreationDate() != null ? menu.getCreationDate() : now ),
						new SqlParameterValue(Types.TIMESTAMP, menu.getModifiedDate() != null ? menu.getModifiedDate() : now )
				);
			} catch (DataAccessException e) {
				//logger.error(CommunityLogLocalizer.getMessage("010013"), e);
				throw e;
			}					
			
		}else {
			// update case 
			Date now = new Date();
			getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_UI.UPDATE_MENU").getSql(),
					new SqlParameterValue(Types.VARCHAR, menu.getName()),
					new SqlParameterValue(Types.VARCHAR, menu.getDescription()),
					new SqlParameterValue(Types.TIMESTAMP, menu.getModifiedDate() != null ? menu.getModifiedDate() : now ),
					new SqlParameterValue(Types.NUMERIC, menu.getMenuId()));
		}

	}

	
	public long getMenuIdByName(String name) throws MenuNotFoundException {
		return getExtendedJdbcTemplate().queryForObject( getBoundSql("COMMUNITY_UI.SELECT_MENU_ID_BY_NAME").getSql(),  Long.class,  new SqlParameterValue(Types.VARCHAR, name));
	}
	
	public Menu getMenuById(long menuId) {
		return getExtendedJdbcTemplate().queryForObject( getBoundSql("COMMUNITY_UI.SELECT_MENU_BY_ID").getSql(),  menuMapper,  new SqlParameterValue(Types.NUMERIC, menuId));
	}	

	public List<MenuItem> getMenuItemsByMenuId(long menuId) {
		return getExtendedJdbcTemplate().query(
			getBoundSql("COMMUNITY_UI.SELECT_MENU_ITEMS_BY_MENU_ID").getSql(), 
			menuItemMapper,
			new SqlParameterValue(Types.NUMERIC, menuId )
		);
	}

	public List<Long> getAllMenuIds() {
		return getExtendedJdbcTemplate().queryForList( getBoundSql("COMMUNITY_UI.SELECT_ALL_MENU_IDS").getSql(),  Long.class );
	}


	@Override
	public MenuItem getMenuItemById(long menuItemId) {
		return getExtendedJdbcTemplate().queryForObject( getBoundSql("COMMUNITY_UI.SELECT_MENU_ITEM_BY_ID").getSql(),  menuItemMapper,  new SqlParameterValue(Types.NUMERIC, menuItemId));
	}

	public void saveOrUpdate(MenuItem menu) {		
		if( menu.getMenuId() < 1) {
			
			// insert case 
			if (menu.getName() == null || menu.getMenuId() < 1)
				throw new IllegalArgumentException();		

			if ("".equals(menu.getDescription()))
				menu.setDescription(null);
			
			menu.setMenuItemId(getNextMenuItemId());
			
			try {
				Date now = new Date();
				getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_UI.CREATE_MENU_ITEM").getSql(),
						new SqlParameterValue(Types.NUMERIC, menu.getMenuId()),
						new SqlParameterValue(Types.NUMERIC, menu.getParentMenuItemId()),
						new SqlParameterValue(Types.NUMERIC, menu.getMenuItemId()),
						new SqlParameterValue(Types.INTEGER, menu.getSortOrder()),
						new SqlParameterValue(Types.VARCHAR, menu.getName()),
						new SqlParameterValue(Types.VARCHAR, menu.getDescription()),
						new SqlParameterValue(Types.VARCHAR, menu.getLocation()),
						new SqlParameterValue(Types.TIMESTAMP, menu.getCreationDate() != null ? menu.getCreationDate() : now ),
						new SqlParameterValue(Types.TIMESTAMP, menu.getModifiedDate() != null ? menu.getModifiedDate() : now )
				);
			} catch (DataAccessException e) {
				//logger.error(CommunityLogLocalizer.getMessage("010013"), e);
				throw e;
			}					
 
		}else {
			// update case 
			Date now = new Date();
			getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_UI.UPDATE_MENU_ITEM").getSql(),
					new SqlParameterValue(Types.NUMERIC, menu.getParentMenuItemId()),
					new SqlParameterValue(Types.INTEGER, menu.getSortOrder()),
					new SqlParameterValue(Types.VARCHAR, menu.getName()),
					new SqlParameterValue(Types.VARCHAR, menu.getDescription()),
					new SqlParameterValue(Types.VARCHAR, menu.getLocation()),
					new SqlParameterValue(Types.TIMESTAMP, menu.getModifiedDate() != null ? menu.getModifiedDate() : now ),
					new SqlParameterValue(Types.NUMERIC, menu.getMenuItemId()));
		}

	}
	
}
