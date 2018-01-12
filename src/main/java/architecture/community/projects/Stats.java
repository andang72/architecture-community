package architecture.community.projects;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonIgnore;

public class Stats {
		
	private List<StatsItem> items ;
	
	public Stats() {
		items = new ArrayList<StatsItem>();
	}

	public void add(String name, Integer value ) {
		items.add(new StatsItem(name, value ));
	}
	
	@JsonGetter
	public List<StatsItem> getItems() {
		return items;
	}

	@JsonIgnore	
	public void setItems(List<StatsItem> items) {
		this.items = items;
	}
	
	public class StatsItem {
		
		private String name;
		private Integer value;
		
		public StatsItem(String name, Integer value) {
			this.name = name;
			this.value = value;
		}
	}

}
