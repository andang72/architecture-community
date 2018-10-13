package services.script
 
 /** common package import here! */
import java.util.Map;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Qualifier;
import architecture.community.web.util.ParamUtils;

/** custom package import here! */

import architecture.community.page.Page;
import architecture.community.viewcount.ViewCountService;
import architecture.community.board.*;

public class BoardView extends architecture.community.web.spring.view.AbstractScriptView  {

	
	@Inject
    @Qualifier("boardService")
    private BoardService boardService;
	
	@Inject
	@Qualifier("viewCountService")
	private ViewCountService viewCountService;
	
	public ScmView() { 
		
	} 

	protected void renderMergedOutputModel(
		Map<String, Object> model, 
		HttpServletRequest request, 
		HttpServletResponse response) throws Exception { 
		
		Page page = model.get("__page");
		Map<String, String> variables = model.get("__variables");

		boolean preview = ParamUtils.getBooleanParameter(request, "preview", false);
		String name1 = "board";  
		boolean required1 =  getBooleanProperty( page.getProperties(), new StringBuilder(getPrefix()).append(".attributes").append(name1).append(".required").toString(), false );
		
		log.debug( "page properties is {}", page.getProperties());
		log.debug( "attribute {} with {} is {}", name1, new StringBuilder(getPrefix()).append("attributes.").append(name1).append(".required").toString(), required1);
		if(required1){
			String parameterName = getProperty(page.getProperties(), new StringBuilder(getPrefix()).append("parameters.").append(name1).append(".key").toString() , name1.toLowerCase() + "Id");
		    String attributeName = getProperty(page.getProperties(), new StringBuilder(getPrefix()).append("attributes.").append(name1).append(".key").toString() , "__"+ name1.toLowerCase());
		    
		    
		    long objectId = ParamUtils.getLongParameter(request, parameterName, -1L);
		    
		    Board board = new DefaultBoard();
			if( boardId > 0 ) {
				try {
					board = boardService.getBoardById(boardId);
				} catch (BoardNotFoundException e) { 
				}	
			} 
			model.addAttribute(attributeName, board);	
		}
		
		String name2 = "thread";  
		boolean required2 =  getBooleanProperty( page.getProperties(), new StringBuilder(getPrefix()).append("attributes.").append(name2).append(".required").toString(), false );
		log.debug( "attribute {} is {}", name2, required2);
		if(required2){
			String parameterName = getProperty(page.getProperties(), new StringBuilder(getPrefix()).append("parameters.").append(name2).append(".key").toString() , name2.toLowerCase() + "Id");
		    String attributeName = getProperty(page.getProperties(), new StringBuilder(getPrefix()).append("attributes.").append(name2).append(".key").toString() , "__"+ name2.toLowerCase());
		    long objectId = ParamUtils.getLongParameter(request, parameterName, -1L);
		    BoardThread thread = new DefaultBoardThread();
			if( objectId > 0 ) {
				thread = boardService.getBoardThread(objectId);
				if(!preview  )
					viewCountService.addViewCount(thread);			
			}
			model.addAttribute(attributeName, thread);	
		}
		
		String name3 = "message";  
		boolean required3 =  getBooleanProperty( page.getProperties(), new StringBuilder(getPrefix()).append("attributes.").append(name3).append(".required").toString(), false );
		log.debug( "attribute {} is {}", name3, required3);
		if(required3){
			String parameterName = getProperty(page.getProperties(), new StringBuilder(getPrefix()).append("parameters.").append(name3).append(".key").toString() , name3.toLowerCase() + "Id");
			String attributeName = getProperty(page.getProperties(), new StringBuilder(getPrefix()).append("attributes.").append(name3).append(".key").toString() , "__"+ name3.toLowerCase());
			long objectId = ParamUtils.getLongParameter(request, parameterName, -1L);
		} 
		
	}
 

}