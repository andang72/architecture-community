package architecture.community.stats;

public class ParameterValue {

	private int index;
	
	private String name;
	
	private int jdbcType ;
	
	private String valueText;

	
	public ParameterValue() {
		this.index = 0;
		this.name = null;
		this.jdbcType = java.sql.Types.VARCHAR;
		this.valueText = null;
	}
	
	public ParameterValue(int index, String name, int jdbcType, String valueText) {
		this.index = index;
		this.name = name;
		this.jdbcType = jdbcType;
		this.valueText = valueText;
	}

	public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
		this.index = index;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getJdbcType() {
		return jdbcType;
	}

	public void setJdbcType(int jdbcType) {
		this.jdbcType = jdbcType;
	}

	public String getValueText() {
		return valueText;
	}

	public void setValueText(String valueText) {
		this.valueText = valueText;
	}
		
}