package architecture.community.export;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.ColumnMapRowMapper;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameterValue;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

import architecture.community.export.excel.DataExportConfig;
import architecture.community.export.excel.DataExportConfig.Column;
import architecture.community.export.excel.ExportConfigXmlReader;
import architecture.community.i18n.CommunityLogLocalizer;
import architecture.community.query.CustomColumnMapMapper;
import architecture.community.query.CustomQueryService;
import architecture.community.query.dao.CustomQueryJdbcDao;
import architecture.community.util.CommunityContextHelper;
import architecture.community.util.excel.XSSFExcelWriter;
import architecture.community.web.model.json.DataSourceRequest;
import architecture.community.web.util.ServletUtils;
import architecture.ee.jdbc.sqlquery.factory.Configuration;
import architecture.ee.jdbc.sqlquery.mapping.BoundSql;
import architecture.ee.jdbc.sqlquery.mapping.ParameterMapping;
import architecture.ee.service.Repository;
import architecture.ee.spring.jdbc.ExtendedJdbcDaoSupport;
import architecture.ee.spring.jdbc.ExtendedJdbcTemplate;
import architecture.ee.util.StringUtils;

public class CommunityExportService {

	@Autowired
	@Qualifier("sqlConfiguration")
	private Configuration sqlConfiguration;
	
	@Inject
	@Qualifier("repository")
	private Repository repository;
	
	@Autowired
	@Qualifier("customQueryJdbcDao")
	private CustomQueryJdbcDao customQueryJdbcDao;
	
	@Autowired
	@Qualifier("customQueryService")
	private CustomQueryService customQueryService;
	
	private Logger log = LoggerFactory.getLogger(CommunityExportService.class);
	
	private String configFileName ;
		
	private boolean usingTempFile = false;
	
	protected final BiMap<String, DataExportConfig> exports = HashBiMap.create();
	
	public CommunityExportService() { 
		
	}

	public void setConfigFileName(String configFileName) {
		this.configFileName = configFileName;
	}

	public void initialize() {
		
		File dir = repository.getFile("services-config");
		File configFile = new File(dir, configFileName);
		
		log.debug("initailizing... with {}" , configFile.getAbsolutePath());
		
		if( configFile.exists() ) {
			try {
				ExportConfigXmlReader reader = new ExportConfigXmlReader(configFile, exports);
				reader.parse();
			} catch (Exception e) {
				log.warn(CommunityLogLocalizer.format("014001", configFile.getAbsolutePath()));
			}
			
		}
	}
	
	public DataExportConfig getExcelExportConfig(String id) throws ExportConfigFoundException {
		if( !StringUtils.isNullOrEmpty(id) && exports.containsKey(id) ){
			return exports.get(id);
		}
		throw new ExportConfigFoundException( "" );
	}
	
	
	public void export(String name, DataSourceRequest dataSourceRequest, HttpServletResponse response ) throws IOException {	
		
		final DataExportConfig config = getExcelExportConfig(name);
		List<Map<String, Object>> data = getData(config, dataSourceRequest);
		
		log.debug("data size : {}", data.size() );
		log.debug("column mapping size : {}, header : {}", config.isSetParameterMappings() ? config.getParameterMappings().size() : 0 , config.isHeader());
		XSSFExcelWriter writer = new XSSFExcelWriter();
		writer.createSheet(StringUtils.defaultString(config.getSheetName(), "DATA"));
		
		for(Column column : config.getColumns()) {
				log.debug("column {} , {} ", column.getIndex(), column.getField());
				 writer.setColumn(column.getIndex(), column.getTitle(), column.getField(), column.getWidth() == 0 ? 3000 : column.getWidth() );
		}
		if(config.isHeader())
			writer.setHeaderToFirstRow();
		
		writer.setColumnsWidth();
		writer.setData(data);		
		response.setHeader("Content-Disposition", "attachment;filename=" + ServletUtils.getEncodedFileName(config.getFileName()));
		response.setHeader("Content-Type", "application/octet-stream");
        response.setHeader("Content-Transfer-Encoding", "binary;");
        response.setHeader("Pragma", "no-cache;");
        response.setHeader("Expires", "-1;");
		if(usingTempFile) {
			File file = File.createTempFile("tempExcelFile", ".xls");
			FileOutputStream fileOutStream = new FileOutputStream(file);			
			writer.write(fileOutStream);			
	        FileUtils.copyFile(file, response.getOutputStream());			
		}else {
			writer.write(response.getOutputStream());
		}
	}
	
	
	public List<Map<String, Object>> getData(String name, DataSourceRequest dataSourceRequest){
		final DataExportConfig config = getExcelExportConfig(name);
		List<Map<String, Object>> data = getData(config, dataSourceRequest);
		return data;
	}
	
	
	protected List<Map<String, Object>> getData(final DataExportConfig config, final DataSourceRequest dataSourceRequest) {	
		final List<SqlParameterValue> parameters = config.isSetParameterMappings() ? getSqlParameterValues(dataSourceRequest.getData(), config.getParameterMappings()) : Collections.EMPTY_LIST;
		List<Map<String, Object>> data = null;	
		if( config.isSetDataSourceName() ) {
			DataSource dataSource = CommunityContextHelper.getComponent(config.getDataSourceName(), DataSource.class);
			ExtendedJdbcDaoSupport dao = new ExtendedJdbcDaoSupport(sqlConfiguration);
			dao.setDataSource(dataSource);
			ExtendedJdbcTemplate template = dao.getExtendedJdbcTemplate();
			if( config.isSetQueryString() ) {
				data = template.query(
						config.getQueryString(), 
						getColumnMapRowMapper(config), 
						getSqlParameterValues(dataSourceRequest.getData(), config.getParameterMappings()).toArray());
			}else{
				BoundSql sql = customQueryJdbcDao.getBoundSqlWithAdditionalParameter(config.getStatement(), getAdditionalParameter(dataSourceRequest));
				data = template.query(
						sql.getSql(),
						getColumnMapRowMapper(config), 
						getSqlParameterValues(dataSourceRequest.getData(), config.getParameterMappings()).toArray());
			}
		}else {
			ExtendedJdbcTemplate template = customQueryJdbcDao.getExtendedJdbcTemplate();
			BoundSql sql = customQueryJdbcDao.getBoundSqlWithAdditionalParameter(config.getStatement(), getAdditionalParameter(dataSourceRequest));
			data = template.query(
					sql.getSql(),
					getColumnMapRowMapper(config),
					parameters.toArray());
		}
		return data;
	}
	
	protected Map<String, Object> getAdditionalParameter( DataSourceRequest dataSourceRequest ){
		Map<String, Object> additionalParameter = new HashMap<String, Object>();
		additionalParameter.put("filter", dataSourceRequest.getFilter());
		additionalParameter.put("sort", dataSourceRequest.getSort());		
		additionalParameter.put("data", dataSourceRequest.getData());		
		additionalParameter.put("user", dataSourceRequest.getUser());		
		return additionalParameter;
	}
	
	protected RowMapper<Map<String, Object>> getColumnMapRowMapper( DataExportConfig config ) {
		if(config.isSetResultMappings())
			return new CustomColumnMapMapper(config.getResultMappings());
		else
			return new ColumnMapRowMapper();
	}
	
	protected List<SqlParameterValue> getSqlParameterValues (Map<String, Object>  values, List<ParameterMapping> mappings){
		ArrayList<SqlParameterValue> vals = new ArrayList<SqlParameterValue>();	
		for(ParameterMapping m : mappings) {
			vals.add(new SqlParameterValue(m.getJdbcType().TYPE_CODE, values.get(m.getProperty())));
		}
		return vals;
	} 
	
}
