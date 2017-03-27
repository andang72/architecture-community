package architecture.community.board.dao.jdbc;

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
import org.springframework.stereotype.Repository;

import architecture.community.board.Board;
import architecture.community.board.DefaultBoard;
import architecture.community.board.dao.BoardDao;
import architecture.community.i18n.CommunityLogLocalizer;
import architecture.ee.jdbc.sequencer.SequencerFactory;
import architecture.ee.service.ConfigService;
import architecture.ee.spring.jdbc.ExtendedJdbcDaoSupport;
import architecture.ee.util.StringUtils;

//@Repository("boardDao")
public class JdbcBoardDao extends ExtendedJdbcDaoSupport implements BoardDao {

	@Inject
	@Qualifier("configService")
	private ConfigService configService;
	
	@Inject
	@Qualifier("sequencerFactory")
	private SequencerFactory sequencerFactory;

	
	private final RowMapper<Board> boardMapper = new RowMapper<Board>() {		
		public Board mapRow(ResultSet rs, int rowNum) throws SQLException {			
			DefaultBoard board = new DefaultBoard(rs.getLong("BOARD_ID"));			
			board.setName(rs.getString("NAME"));
			board.setDescription(rs.getString("DISPLAY_NAME"));
			board.setDescription(rs.getString("DESCRIPTION"));
			board.setCreationDate(rs.getTimestamp("CREATION_DATE"));
			board.setModifiedDate(rs.getTimestamp("MODIFIED_DATE"));			
			return board;
		}
		
	};
	
	

	
	public void createBoard(Board board) {		
		if( board == null)
			throw new IllegalArgumentException();
		
		if( board.getBoardId() <= 0 ){
			((DefaultBoard)board).setBoardId(getNextBoardId());
		}		
		Date now = new Date();		
		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_BOARD.CREATE_BOARD").getSql(),
				new SqlParameterValue(Types.NUMERIC, board.getBoardId()),
				//new SqlParameterValue(Types.NUMERIC, board.getObjectType()),
				//new SqlParameterValue(Types.NUMERIC, board.getObjectId()),
				new SqlParameterValue(Types.VARCHAR, board.getName()),
				new SqlParameterValue(Types.VARCHAR, StringUtils.isNullOrEmpty(board.getDisplayName()) ? board.getName() : board.getDisplayName()),
				new SqlParameterValue(Types.VARCHAR, board.getDescription()),
				new SqlParameterValue(Types.TIMESTAMP, board.getCreationDate() != null ? board.getCreationDate() : now ),
				new SqlParameterValue(Types.TIMESTAMP, board.getModifiedDate() != null ? board.getModifiedDate() : now )
		);
	}
	
	
	public long getNextBoardId(){
		return sequencerFactory.getNextValue("BOARD");
	}


	public Board getBoardById(long boardId) {
		if (boardId <= 0L) {
			return null;
		}
		Board board = null;
		try {
			board = getExtendedJdbcTemplate().queryForObject(getBoundSql("COMMUNITY_BOARD.SELECT_BOARD_BY_ID").getSql(), boardMapper, new SqlParameterValue(Types.NUMERIC, boardId));
		} catch (IncorrectResultSizeDataAccessException e) {
			if (e.getActualSize() > 1) {
				logger.warn(CommunityLogLocalizer.format("013002", boardId));
				throw e;
			}
		} catch (DataAccessException e) {
			logger.error(CommunityLogLocalizer.format("013001", boardId), e);
		}
		return board;
	}
	
	public List<Long> getAllBoardIds(){
		return getExtendedJdbcTemplate().queryForList(getBoundSql("COMMUNITY_BOARD.SELECT_ALL_BOARD_IDS").getSql(), Long.class);
	}


	public void deleteBoard(Board board) {
		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_BOARD.DELETE_BOARD").getSql(), new SqlParameterValue(Types.NUMERIC, board.getBoardId() ) );
	}
	
}
