package architecture.community.forum.dao.jdbc;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.IncorrectResultSizeDataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameterValue;

import architecture.community.forum.DefaultForumMessage;
import architecture.community.forum.DefaultForumThread;
import architecture.community.forum.ForumMessage;
import architecture.community.forum.ForumThread;
import architecture.community.forum.dao.ForumDao;
import architecture.community.i18n.CommunityLogLocalizer;
import architecture.community.user.UserTemplate;
import architecture.ee.jdbc.sequencer.SequencerFactory;
import architecture.ee.service.ConfigService;
import architecture.ee.spring.jdbc.ExtendedJdbcDaoSupport;

public class JdbcForumDao extends ExtendedJdbcDaoSupport implements ForumDao{

	
	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	@Inject
	@Qualifier("sequencerFactory")
	private SequencerFactory sequencerFactory;

	private final RowMapper<ForumThread> threadMapper = new RowMapper<ForumThread>() {	
		
		public ForumThread mapRow(ResultSet rs, int rowNum) throws SQLException {			
			DefaultForumThread thread = new DefaultForumThread(rs.getLong("THREAD_ID"));			
			thread.setObjectType(rs.getInt("OBJECT_TYPE"));
			thread.setObjectId(rs.getLong("OBJECT_ID"));
			thread.setRootMessage(  new DefaultForumMessage( rs.getLong("ROOT_MESSAGE_ID") ) );
			thread.setCreationDate(rs.getDate("CREATION_DATE"));
			thread.setModifiedDate(rs.getDate("MODIFIED_DATE"));		
			return thread;
		}
		
	};

	private final RowMapper<ForumMessage> messageMapper = new RowMapper<ForumMessage>() {	

		public ForumMessage mapRow(ResultSet rs, int rowNum) throws SQLException {			
			DefaultForumMessage message = new DefaultForumMessage(rs.getLong("MESSAGE_ID"));		
			message.setParentMessageId(rs.getLong("PARENT_MESSAGE_ID"));
			message.setThreadId(rs.getLong("THREAD_ID"));
			message.setObjectType(rs.getInt("OBJECT_TYPE"));
			message.setObjectId(rs.getLong("OBJECT_ID"));
			message.setUser(new UserTemplate(rs.getLong("USER_ID")));
			message.setSubject(rs.getString("SUBJECT"));
			message.setBody(rs.getString("BODY"));
			message.setCreationDate(rs.getDate("CREATION_DATE"));
			message.setModifiedDate(rs.getDate("MODIFIED_DATE"));		
			return message;
		}
		
	};
	
	public long getNextThreadId(){
		return sequencerFactory.getNextValue("FORUM_THREAD");
	}	
	
	public long getNextMessageId(){
		return sequencerFactory.getNextValue("FORUM_MESSAGE");
	}	
	
	
	public List<Long> getForumThreadIds(int objectType, long objectId){
		return getExtendedJdbcTemplate().queryForList(
				getBoundSql("COMMUNITY_FORUM.SELECT_FORUM_THREAD_IDS_BY_OBJECT_TYPE_AND_OBJECT_ID").getSql(), Long.class,
				new SqlParameterValue(Types.NUMERIC, objectType ),
				new SqlParameterValue(Types.NUMERIC, objectId )
				);
	}
	
	public long getLatestMessageId(ForumThread thread){
		try
        {
            return getExtendedJdbcTemplate().queryForObject(
            		getBoundSql("COMMUNITY_FORUM.SELECT_LATEST_FORUM_MESSAGE_ID_BY_THREAD_ID").getSql(), 
            		Long.class,
            		new SqlParameterValue(Types.NUMERIC, thread.getThreadId() ) );
        }
        catch(IncorrectResultSizeDataAccessException e)
        {
            logger.error(CommunityLogLocalizer.format("013009", thread.getThreadId() ), e );
        }
        return -1L;		
	}
	
	public List<Long> getAllMessageIdsInThread(ForumThread thread){
		return getExtendedJdbcTemplate().queryForList(
			getBoundSql("COMMUNITY_FORUM.SELECT_ALL_FORUM_MESSAGE_IDS_BY_THREAD_ID").getSql(), 
			Long.class,
			new SqlParameterValue(Types.NUMERIC, thread.getThreadId() )
		);		
	}
	
	public void createForumThread(ForumThread thread) {		
		DefaultForumThread threadToUse = (DefaultForumThread)thread;		
		threadToUse.setThreadId(getNextThreadId());		
		
		if( threadToUse.getRootMessage().getMessageId() <= 0 ){
			DefaultForumMessage messageToUse = (DefaultForumMessage)thread.getRootMessage();		
			messageToUse.setMessageId(getNextMessageId());		
		}
		
		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_FORUM.CREATE_FORUM_THREAD").getSql(),
				new SqlParameterValue(Types.NUMERIC, threadToUse.getThreadId() ),
				new SqlParameterValue(Types.NUMERIC, threadToUse.getObjectType()),
				new SqlParameterValue(Types.NUMERIC, threadToUse.getObjectId()),				
				new SqlParameterValue(Types.NUMERIC, threadToUse.getRootMessage().getMessageId()),				
				new SqlParameterValue(Types.TIMESTAMP, threadToUse.getCreationDate() ),
				new SqlParameterValue(Types.TIMESTAMP, threadToUse.getModifiedDate() )
		);
	}
	
	public void createForumMessage (ForumThread thread, ForumMessage message, long parentMessageId) {
			
		DefaultForumMessage messageToUse = (DefaultForumMessage) message;
		if(messageToUse.getCreationDate() == null )
		{
			Date now = new Date();	
			messageToUse.setCreationDate(now);
			messageToUse.setModifiedDate(now);
		}	
		
		if(messageToUse.getMessageId() == -1L){
			messageToUse.setMessageId(getNextMessageId());
		}
		
		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_FORUM.CREATE_FORUM_MESSAGE").getSql(),
				new SqlParameterValue(Types.NUMERIC, messageToUse.getMessageId() ),
				new SqlParameterValue(Types.NUMERIC, parentMessageId),
				new SqlParameterValue(Types.NUMERIC, thread.getThreadId()),
				new SqlParameterValue(Types.NUMERIC, thread.getObjectType()),
				new SqlParameterValue(Types.NUMERIC, thread.getObjectId()),
				new SqlParameterValue(Types.NUMERIC, messageToUse.getUser().getUserId()),
				new SqlParameterValue(Types.VARCHAR, messageToUse.getSubject()),
				new SqlParameterValue(Types.VARCHAR, messageToUse.getBody()),
				new SqlParameterValue(Types.TIMESTAMP, messageToUse.getCreationDate() ),
				new SqlParameterValue(Types.TIMESTAMP, messageToUse.getModifiedDate() )
		);	
	}

	public ForumThread getForumThreadById(long threadId) {
		ForumThread thread = null;
		if (threadId <= 0L) {
			return thread;
		}		
		try {
			thread = getExtendedJdbcTemplate().queryForObject(getBoundSql("COMMUNITY_FORUM.SELECT_FORUM_THREAD_BY_ID").getSql(), 
					threadMapper, 
					new SqlParameterValue(Types.NUMERIC, threadId ));
		} catch (DataAccessException e) {
			logger.error(CommunityLogLocalizer.format("013005", threadId), e);
		}
		return thread;
	}
	
	public ForumMessage getForumMessageById(long messageId) {
		ForumMessage message = null;
		if (messageId <= 0L) {
			return message;
		}		
		try {
			message = getExtendedJdbcTemplate().queryForObject(getBoundSql("COMMUNITY_FORUM.SELECT_FORUM_MESSAGE_BY_ID").getSql(), 
					messageMapper, 
					new SqlParameterValue(Types.NUMERIC, messageId ));
		} catch (DataAccessException e) {
			logger.error(CommunityLogLocalizer.format("013007", messageId), e);
		}
		return message;
	}

	public void updateForumThread(ForumThread thread) {
		Date now = new Date();
		thread.setModifiedDate(now);		
		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_FORUM.UPDATE_FORUM_THREAD").getSql(), 
				new SqlParameterValue(Types.VARCHAR, thread.getRootMessage().getMessageId()),
				new SqlParameterValue(Types.TIMESTAMP, thread.getModifiedDate() ),	
				new SqlParameterValue(Types.NUMERIC, thread.getThreadId())
		);
	}
	
	public void updateForumMessage(ForumMessage message) {
		Date now = new Date();
		message.setModifiedDate(now);		
		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_FORUM.UPDATE_FORUM_MESSAGE").getSql(), 
				new SqlParameterValue(Types.VARCHAR, message.getSubject() ),
				new SqlParameterValue(Types.VARCHAR, message.getBody()),
				new SqlParameterValue(Types.TIMESTAMP, message.getModifiedDate() ),	
				new SqlParameterValue(Types.NUMERIC, message.getMessageId() )
		);
	}
 
	public void updateModifiedDate(ForumThread thread, Date date) {
		thread.setModifiedDate(date);	
		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_FORUM.UPDATE_FORUM_THREAD_MODIFIED_DATE").getSql(), 
				new SqlParameterValue(Types.TIMESTAMP, date ),	
				new SqlParameterValue(Types.NUMERIC, thread.getThreadId() )
		);
	}	
	

}
