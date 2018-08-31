package architecture.community.web.spring.controller.view.binding;

import java.util.Map;

import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.ui.Model;

public interface ObjectBinder {

	public void bind(Model model, String name, Map<String, String> properties, Map<String, String> vairables, ConfigurableBeanFactory beanFactory ) throws Exception ;
}
