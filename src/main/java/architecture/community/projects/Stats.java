package architecture.community.projects;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

public class Stats implements Serializable{
		
	private List<Item> items ;
	
	public Stats() {
		items = new ArrayList<Item>();
	}

	public void add(String name, Integer value ) {
		boolean exist = false;
		for( Item i : items ) {
			if(StringUtils.equals(name, i.name)) {
				i.value = i.value + value;
				exist = true;
				break;
			}
		}
		if( !exist )
			items.add(new Item(name, value ));
	}
	
	public List<Item> getItems() {
		return items;
	}

	public void setItems(List<Item> items) {
		this.items = items;
	}
	
	public class Item implements Serializable {
		
		private String name;
		private Integer value;
		
		public Item() {
			this.name = null;
			this.value = 0;
		}

		public Item(String name, Integer value) {
			this.name = name;
			this.value = value;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public Integer getValue() {
			return value;
		}

		public void setValue(Integer value) {
			this.value = value;
		}

		@Override
		public int hashCode() {
			final int prime = 31;
			int result = 1;
			result = prime * result + getOuterType().hashCode();
			result = prime * result + ((name == null) ? 0 : name.hashCode());
			return result;
		}

		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			Item other = (Item) obj;
			if (!getOuterType().equals(other.getOuterType()))
				return false;
			if (name == null) {
				if (other.name != null)
					return false;
			} else if (!name.equals(other.name))
				return false;
			return true;
		}

		private Stats getOuterType() {
			return Stats.this;
		}
		
	}

}
