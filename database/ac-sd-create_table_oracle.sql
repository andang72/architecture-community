	-- =================================================  
	--   SERVICE DESK  
	--   PROJECT
	-- =================================================	
	
	CREATE TABLE "AC_SD_PROJECT_PROPERTY" (	
  			"PROJECT_ID" NUMBER(*,0) NOT NULL ENABLE, 
			"PROPERTY_NAME" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
			"PROPERTY_VALUE" VARCHAR2(1024 BYTE) NOT NULL ENABLE, 
	 		CONSTRAINT "AC_SD_PROJECT_PROPERTY_PK" PRIMARY KEY ("PROJECT_ID", "PROPERTY_NAME"));
 

	COMMENT ON COLUMN "AC_SD_PROJECT_PROPERTY"."PROJECT_ID" IS 'PROJECT ID'; 
	COMMENT ON COLUMN "AC_SD_PROJECT_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
	COMMENT ON COLUMN "AC_SD_PROJECT_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값'; 
	COMMENT ON TABLE  "AC_SD_PROJECT_PROPERTY"  IS 'TASK 프로퍼티 테이블';	
		
	-- SCM --	
	CREATE TABLE AC_SD_SCM (
		SCM_ID				INTEGER NOT NULL,
		NAME				VARCHAR2(255) NOT NULL,
		DESCRIPTION			VARCHAR2(1000),
		TAGS				VARCHAR2(255),
		URL					VARCHAR2(255),
		USERNAME			VARCHAR2(255),
		PASSWORD			VARCHAR2(255),
		OBJECT_TYPE			INTEGER NOT NULL,
		OBJECT_ID			INTEGER NOT NULL,
		ROOT_MESSAGE_ID		INTEGER NOT NULL,
		CREATION_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		MODIFIED_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		CONSTRAINT AC_SD_SCM_PK PRIMARY KEY (SCM_ID)
	);
	
	CREATE INDEX AC_SD_SCM_IDX_01 ON AC_SD_SCM (OBJECT_TYPE, OBJECT_ID);
	CREATE INDEX AC_SD_SCM_IDX_02 ON AC_SD_SCM (OBJECT_TYPE, OBJECT_ID, TAGS);
	
	CREATE TABLE "AC_SD_SCM_PROPERTY" (	
  			"SCM_ID" NUMBER(*,0) NOT NULL ENABLE, 
			"PROPERTY_NAME" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
			"PROPERTY_VALUE" VARCHAR2(1024 BYTE) NOT NULL ENABLE, 
	 		CONSTRAINT "AC_SD_SCM_PROPERTY_PK" PRIMARY KEY ("SCM_ID", "PROPERTY_NAME"));
 

	COMMENT ON COLUMN "AC_SD_SCM_PROPERTY"."SCM_ID" IS 'SCM ID'; 
	COMMENT ON COLUMN "AC_SD_SCM_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
	COMMENT ON COLUMN "AC_SD_SCM_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값'; 
	COMMENT ON TABLE  "AC_SD_SCM_PROPERTY"  IS 'SCM 프로퍼티 테이블';			
 	