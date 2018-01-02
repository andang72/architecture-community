package architecture.community.user.dao;

import java.sql.Types;
import java.util.List;

import org.springframework.jdbc.core.SqlParameterValue;

import architecture.community.user.User;

public interface UserDao {
	
	public abstract User createUser(User template);

	public abstract User getUserById(long userId);
		
	public abstract User getUserByUsername(String username);
	
	public abstract User getUserByEmail(String email);
	
	public abstract long getNextUserId();
	
	public abstract void deleteUser(User user);
	
	public abstract int getFoundUserCount(String nameOrEmail);
	
	public abstract List<User> findUsers(String nameOrEmail);
			
	public abstract List<Long> findUserIds(String nameOrEmail) ;
	
	public abstract List<Long> findUserIds(String nameOrEmail, int startIndex, int numResults) ;
}
