package architecture.community.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import architecture.community.board.BoardService;
import architecture.community.comment.CommentService;
import architecture.community.i18n.CommunityLogLocalizer;
import architecture.community.viewcount.ViewCountService;
import architecture.ee.exception.ComponentNotFoundException;
import architecture.ee.util.StringUtils;

public final class CommunityContextHelper implements ApplicationContextAware {

	private static final Logger logger = LoggerFactory.getLogger(CommunityContextHelper.class);

	private static ApplicationContext applicationContext = null;

	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.applicationContext = applicationContext;
	}

	public static boolean isReady(){
		if( applicationContext == null )
			return false;
		return true;
	}
	
	public static BoardService getBoardService(){
		return getComponent(BoardService.class);
	}

	public static CommentService getCommentService(){
		return getComponent(CommentService.class);
	}
	
	public static ViewCountService getViewCountServive(){
		return getComponent(ViewCountService.class);
	}
	
	public static <T> T getComponent(Class<T> requiredType) {
		if (applicationContext == null) {
			throw new IllegalStateException(CommunityLogLocalizer.getMessage("012005"));
		}
		
		if (requiredType == null) {
			throw new IllegalArgumentException(CommunityLogLocalizer.getMessage("012001"));
		}

		try {
			return applicationContext.getBean(requiredType);
		} catch (NoSuchBeanDefinitionException e) {
			throw new ComponentNotFoundException(CommunityLogLocalizer.format("012002", requiredType.getName()), e);
		}
	}

	public <T> T getComponent(String requiredName, Class<T> requiredType) {
		
		if (applicationContext == null) {
			throw new IllegalStateException(CommunityLogLocalizer.getMessage("012005"));
		}		
		
		if (requiredType == null) {
			throw new IllegalArgumentException(CommunityLogLocalizer.getMessage("012001"));
		}
		
		try {
			if( !StringUtils.isNullOrEmpty(requiredName) ){
				return applicationContext.getBean(requiredName, requiredType);
			}else {
				return applicationContext.getBean(requiredType);
			}
		} catch (NoSuchBeanDefinitionException e) {
			throw new ComponentNotFoundException(CommunityLogLocalizer.format("012004", requiredType.getName(), requiredType.getName() ), e);
		}

	}

}
