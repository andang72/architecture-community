package architecture.community.web.spring.controller.data.v1;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import architecture.community.attachment.Attachment;
import architecture.community.board.Board;
import architecture.community.board.BoardService;
import architecture.community.board.BoardView;
import architecture.community.model.Models;

public abstract class AbstractCommunityDateController {

	protected abstract BoardService getBoardService();
	
	protected BoardView toBoardView(Board board) {
		BoardView b = new BoardView(board);
		int totalThreadCount = getBoardService().getBoardThreadCount(Models.BOARD.getObjectType(), board.getBoardId());
		int totalMessageCount = getBoardService().getBoardMessageCount(board);
		b.setTotalMessage(totalMessageCount);
		b.setTotalThreadCount(totalThreadCount);
		return b;
	}
	
    protected String getEncodedFileName(Attachment attachment) {
		try {
		    return URLEncoder.encode(attachment.getName(), "UTF-8");
		} catch (UnsupportedEncodingException e) {
		    return attachment.getName();
		}
    }
}
