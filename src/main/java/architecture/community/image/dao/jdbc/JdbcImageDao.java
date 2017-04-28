/**
 *    Copyright 2015-2017 donghyuck
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package architecture.community.image.dao.jdbc;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

import javax.inject.Inject;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameterValue;
import org.springframework.jdbc.core.support.SqlLobValue;

import architecture.community.image.DefaultLogoImage;
import architecture.community.image.ImageNotFoundException;
import architecture.community.image.LogoImage;
import architecture.community.image.dao.ImageDao;
import architecture.community.model.ModelObject;
import architecture.ee.jdbc.sequencer.SequencerFactory;
import architecture.ee.spring.jdbc.ExtendedJdbcDaoSupport;
import architecture.ee.spring.jdbc.ExtendedJdbcUtils.DB;
import architecture.ee.spring.jdbc.InputStreamRowMapper;

public class JdbcImageDao extends ExtendedJdbcDaoSupport implements ImageDao {

    
	@Inject
	@Qualifier("sequencerFactory")
	private SequencerFactory sequencerFactory;
	
	private Logger logger = LoggerFactory.getLogger(getClass().getName());
	
	private final RowMapper<LogoImage> logoMapper = new RowMapper<LogoImage>() {
		public LogoImage mapRow(ResultSet rs, int rowNum) throws SQLException {
		    DefaultLogoImage image = new DefaultLogoImage();
		    image.setLogoId(rs.getLong("LOGO_ID"));
		    image.setObjectType(rs.getInt("OBJECT_TYPE"));
		    image.setObjectId(rs.getLong("OBJECT_ID"));
		    image.setFilename(rs.getString("FILE_NAME"));
		    image.setPrimary((rs.getInt("PRIMARY_IMAGE") == 1 ? true : false));
		    image.setImageSize(rs.getInt("FILE_SIZE"));
		    image.setImageContentType(rs.getString("CONTENT_TYPE"));
		    image.setCreationDate(rs.getTimestamp("CREATION_DATE"));
		    image.setModifiedDate(rs.getTimestamp("MODIFIED_DATE"));
		    return image;
		}
	    };
	    
	public JdbcImageDao() {
	}

	public long getNextImageId(){
		return sequencerFactory.getNextValue(ModelObject.IMAGE, "IMAGE");
	}	
	
	public long getNextLogoId(){
		return sequencerFactory.getNextValue(ModelObject.LOGO_IMAGE, "LOGO_IMAGE");
	}
	
	public long getNextProfileId(){
		return sequencerFactory.getNextValue(ModelObject.PROFILE_IMAGE, "PROFILE_IMAGE");
	}
	
	
	
	public void addLogoImage(LogoImage logoImage, File file) {
		try {
			if (logoImage.getImageSize() == 0)
				logoImage.setImageSize((int) FileUtils.sizeOf(file));
			
			addLogoImage(logoImage, file != null ? FileUtils.openInputStream(file) : null);
		} catch (IOException e) {
			logger.error("", e);
		}
	}

	public void addLogoImage(LogoImage logoImage, InputStream is) {
		LogoImage toUse = logoImage;
		long logoIdToUse = logoImage.getLogoId();
		if (logoIdToUse < 1) {
			logoIdToUse = getNextLogoId();
			logoImage.setLogoId(logoIdToUse);
		}
		getExtendedJdbcTemplate().update(
				getBoundSql("COMMUNITY_CORE.RESET_LOGO_IMAGE_BY_OBJECT_TYPE_AND_OBJECT_ID").getSql(),
				new SqlParameterValue(Types.INTEGER, toUse.getObjectType()),
				new SqlParameterValue(Types.NUMERIC, toUse.getObjectId()));

		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_CORE.CREATE_LOGO_IMAGE").getSql(),
				new SqlParameterValue(Types.NUMERIC, logoImage.getLogoId()),
				new SqlParameterValue(Types.NUMERIC, logoImage.getObjectType()),
				new SqlParameterValue(Types.NUMERIC, logoImage.getObjectId()),
				new SqlParameterValue(Types.NUMERIC, logoImage.isPrimary() ? 1 : 0),
				new SqlParameterValue(Types.VARCHAR, logoImage.getFilename()),
				new SqlParameterValue(Types.NUMERIC, logoImage.getImageSize()),
				new SqlParameterValue(Types.VARCHAR, logoImage.getImageContentType()),
				new SqlParameterValue(Types.DATE, logoImage.getModifiedDate()),
				new SqlParameterValue(Types.DATE, logoImage.getCreationDate()));
		
		updateImageImputStream(logoImage, is);
	}

	public void updateLogoImage(LogoImage logoImage, File file) {
		try {
			updateLogoImage(logoImage, file != null ? FileUtils.openInputStream(file) : null);
		} catch (IOException e1) {

		}
	}

	public void updateLogoImage(LogoImage logoImage, InputStream is) {

		if (logoImage.isPrimary()) {
			getExtendedJdbcTemplate().update(
					getBoundSql("COMMUNITY_CORE.RESET_LOGO_IMAGE_BY_OBJECT_TYPE_AND_OBJECT_ID").getSql(),
					new SqlParameterValue(Types.INTEGER, logoImage.getObjectType()),
					new SqlParameterValue(Types.NUMERIC, logoImage.getObjectId()));
		}

		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_CORE.UPDATE_LOGO_IMAGE").getSql(),
				new SqlParameterValue(Types.NUMERIC, logoImage.getObjectType()),
				new SqlParameterValue(Types.NUMERIC, logoImage.getObjectId()),
				new SqlParameterValue(Types.NUMERIC, logoImage.isPrimary() ? 1 : 0),
				new SqlParameterValue(Types.VARCHAR, logoImage.getFilename()),
				new SqlParameterValue(Types.NUMERIC, logoImage.getImageSize()),
				new SqlParameterValue(Types.VARCHAR, logoImage.getImageContentType()),
				new SqlParameterValue(Types.DATE, logoImage.getModifiedDate()),
				new SqlParameterValue(Types.NUMERIC, logoImage.getLogoId()));
		if (is != null)
			updateImageImputStream(logoImage, is);
	}

	protected void updateImageImputStream(LogoImage logoImage, InputStream inputStream) {
		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_CORE.DELETE_LOGO_IMAGE_DATA_BY_ID").getSql(),
				new SqlParameterValue(Types.NUMERIC, logoImage.getLogoId()));
		
		if ( getExtendedJdbcTemplate().getDBInfo() == DB.ORACLE ){
			getExtendedJdbcTemplate().update(
					getBoundSql("COMMUNITY_CORE.INSERT_EMPTY_LOGO_IMAGE_DATA").getSql(),
					new SqlParameterValue(Types.NUMERIC, logoImage.getLogoId()));
			getExtendedJdbcTemplate().update(
					getBoundSql("COMMUNITY_CORE.UPDATE_LOGO_IMAGE_DATA").getSql(),
					new SqlParameterValue(Types.BLOB, new SqlLobValue(inputStream, logoImage.getImageSize(), getLobHandler())),
					new SqlParameterValue(Types.NUMERIC, logoImage.getLogoId()));
		} else {
			getExtendedJdbcTemplate().update(
					getBoundSql("COMMUNITY_CORE.INSERT_LOGO_IMAGE_DATA").getSql(),
					new SqlParameterValue(Types.NUMERIC, logoImage.getLogoId()), 
					new SqlParameterValue(Types.BLOB, new SqlLobValue(inputStream, logoImage.getImageSize(), getLobHandler())));
		}
	}

	public void removeLogoImage(LogoImage logoImage) {
		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_CORE.DELETE_LOGO_IMAGE_BY_ID").getSql(),
				new SqlParameterValue(Types.NUMERIC, logoImage.getLogoId()));
		getExtendedJdbcTemplate().update(getBoundSql("COMMUNITY_CORE.DELETE_LOGO_IMAGE_DATA_BY_ID").getSql(),
				new SqlParameterValue(Types.NUMERIC, logoImage.getLogoId()));
	}

	public InputStream getInputStream(LogoImage logoImage) throws IOException {
		return getExtendedJdbcTemplate().queryForObject(
				getBoundSql("COMMUNITY_CORE.SELECT_LOGO_IMAGE_DATA_BY_ID").getSql(),
				new InputStreamRowMapper(), 
				new SqlParameterValue(Types.NUMERIC, logoImage.getLogoId()));
	}

	public Long getPrimaryLogoImageId(int objectType, long objectId) throws ImageNotFoundException {
		try {
			return getExtendedJdbcTemplate().queryForObject(
					getBoundSql("COMMUNITY_CORE.SELECT_PRIMARY_LOGO_IMAGE_ID_BY_OBJECT_TYPE_AND_OBJECT_ID").getSql(),
					Long.class,
					new SqlParameterValue(Types.NUMERIC, objectType), 
					new SqlParameterValue(Types.NUMERIC, objectId));
		} catch (DataAccessException e) {
			throw new ImageNotFoundException(e);
		}
	}

	public LogoImage getLogoImageById(long logoId) throws ImageNotFoundException {
		try {
			return getExtendedJdbcTemplate().queryForObject(
					getBoundSql("COMMUNITY_CORE.SELECT_LOGO_IMAGE_BY_ID").getSql(), logoMapper,
					new SqlParameterValue(Types.NUMERIC, logoId));
		} catch (DataAccessException e) {
			e.printStackTrace();
			throw new ImageNotFoundException(e);
		}
	}

	public List<Long> getLogoImageIds(int objectType, long objectId) {
		return getExtendedJdbcTemplate().queryForList(
				getBoundSql("COMMUNITY_CORE.SELECT_LOGO_IMAGE_IDS_BY_OBJECT_TYPE_AND_OBJECT_ID").getSql(), 
				Long.class,
				new SqlParameterValue(Types.NUMERIC, objectType), 
				new SqlParameterValue(Types.NUMERIC, objectId));
	}

	public int getLogoImageCount(int objectType, long objectId) {
		return getExtendedJdbcTemplate().queryForObject(
				getBoundSql("COMMUNITY_CORE.COUNT_LOGO_IMAGE_BY_OBJECT_TYPE_AND_OBJECT_ID").getSql(),
				Integer.class,
				new SqlParameterValue(Types.NUMERIC, objectType), 
				new SqlParameterValue(Types.NUMERIC, objectId));
	}
}