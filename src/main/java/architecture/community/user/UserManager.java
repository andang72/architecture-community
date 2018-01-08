package architecture.community.user;

import java.util.List;

public interface UserManager {
	
	public abstract User getUser(User template );
	
	public abstract User getUser(User template , boolean caseSensitive );
	
	public abstract User getUser(String username) throws UserNotFoundException;
	
	public abstract User getUser(long userId) throws UserNotFoundException;
	
	public abstract User createUser(User newUser) throws UserAlreadyExistsException, EmailAlreadyExistsException;
	
	public abstract void deleteUser(User user) throws UserNotFoundException ;
	
	public abstract void updateUser(User user)  throws UserNotFoundException, UserAlreadyExistsException ;
	
    /**
     * 
     * @param nameOrEmail
     * @return
     */
    public abstract List<User> findUsers(String nameOrEmail);

    /**
     * 
     * @param nameOrEmail
     * @param startIndex
     * @param numResults
     * @return
     */
    public abstract List<User> findUsers(String nameOrEmail, int startIndex, int numResults);

    public abstract int getFoundUserCount(String nameOrEmail);
    
    
    public abstract int getUserCount();
    
    public abstract List<User> getUsers();

    public abstract List<User> getUsers(int startIndex, int numResults);
    
}
