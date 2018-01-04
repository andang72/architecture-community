package architecture.community.web.model.json;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonAnySetter;

public class RequestData {

	private int page;

	private int pageSize;

	private int take;

	private int skip;

	private HashMap<String, Object> data;

	private FilterDescriptor filter;
	
	public RequestData() {
		filter = new FilterDescriptor();
		data = new HashMap<String, Object>();
		page = 0;
		pageSize = 0;
		take = 0;
		skip = 0;
	}

	public FilterDescriptor getFilter() {
		return filter;
	}

	public void setFilter(FilterDescriptor filter) {
		this.filter = filter;
	}
	
	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getTake() {
		return take;
	}

	public void setTake(int take) {
		this.take = take;
	}

	public int getSkip() {
		return skip;
	}

	public void setSkip(int skip) {
		this.skip = skip;
	}

	@JsonAnySetter
	public void handleUnknown(String key, Object value) {
		data.put(key, value);
	}

	public HashMap<String, Object> getData() {
		return data;
	}

	public String getDataAsString(String key, String defaultValue) {
		if (data.containsKey(key)) {
			try {
				return data.get(key).toString();
			} catch (Exception ignore) {
			}
		}
		return defaultValue;
	}

	public Long getDataAsLong(String key, Long defaultValue) {
		if (data.containsKey(key)) {
			try {
				return Long.parseLong(data.get(key).toString());
			} catch (Exception ignore) {
			}
		}
		return defaultValue;
	}

	public Boolean getDataAsBoolean(String key, Boolean defaultValue) {
		if (data.containsKey(key)) {
			try {
				return Boolean.parseBoolean(data.get(key).toString());
			} catch (Exception ignore) {
			}
		}
		return defaultValue;
	}
	

	public static class FilterDescriptor {
		
		private String logic;
		
		private List<FilterDescriptor> filters;
		
		private String field;
		
		private Object value;
		
		private String operator;
		
		private boolean ignoreCase = true;

		public FilterDescriptor() {
			filters = new ArrayList<FilterDescriptor>();
		}

		public String getField() {
			return field;
		}

		public void setField(String field) {
			this.field = field;
		}

		public Object getValue() {
			return value;
		}

		public void setValue(Object value) {
			this.value = value;
		}

		public String getOperator() {
			return operator;
		}

		public void setOperator(String operator) {
			this.operator = operator;
		}

		public String getLogic() {
			return logic;
		}

		public void setLogic(String logic) {
			this.logic = logic;
		}

		public boolean isIgnoreCase() {
			return ignoreCase;
		}

		public void setIgnoreCase(boolean ignoreCase) {
			this.ignoreCase = ignoreCase;
		}

		public List<FilterDescriptor> getFilters() {
			return filters;
		}

		@Override
		public String toString() {
			return "FilterDescriptor [logic=" + logic + ", filters=" + filters + ", field=" + field + ", value=" + value
					+ ", operator=" + operator + ", ignoreCase=" + ignoreCase + "]";
		}

	}
}
