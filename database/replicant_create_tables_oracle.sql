-- REPLICANT v1
-- last update 2018.1.18


		-- =================================================  
		-- CORE
		-- =================================================  		
		-- 1. 프로퍼티 테이블 생성 스크립트
		drop table REP_LOCALIZED_PROPERTY cascade constraints PURGE ;		
		drop table REP_PROPERTY cascade constraints PURGE ;		
		drop table REP_SEQUENCER cascade constraints PURGE ;		
		drop table REP_I18N_TEXT cascade constraints PURGE ; 
				
		CREATE TABLE REP_LOCALIZED_PROPERTY (
				  LOCALE_CODE            VARCHAR2(100)   NOT NULL,
				  PROPERTY_NAME          VARCHAR2(100)   NOT NULL,
				  PROPERTY_VALUE         VARCHAR2(1024)  NOT NULL,
				  CONSTRAINT REP_LOCALIZED_PROPERTY_PK PRIMARY KEY (LOCALE_CODE, PROPERTY_NAME)
		); 
		COMMENT ON TABLE "REP_LOCALIZED_P
2(100) NOT NULL,
		  EMAIL_VISIBLE          NUMBER(1, 0)  DEFAULT 1,
		  USER_ENABLED           NUMBER(1, 0)  DEFAULT 1, 
		  STATUS                 NUMBER(1, 0)  DEFAULT 0,
		  CREATION_DATE          DATE DEFAULT  SYSDATE NOT NULL,
		  MODIFIED_DATE          DATE DEFAULT  SYSDATE NOT NULL,		    
		  CONSTRAINT REP_USER_PK PRIMARY KEY (USER_ID)
		);		
		
		CREATE UNIQUE INDEX REP_USER_IDX_USERNAME ON REP_USER (USERNAME);
		
		COMMENT ON TABLE  "REP_USER"  IS '사용자 테이블';
		COMMENT ON COLUMN "REP_USER"."USER_ID" IS 'ID'; 
		COMMENT ON COLUMN "REP_USER"."USERNAME" IS '로그인 아이디'; 
        COMMENT ON COLUMN "REP_USER"."NAME" IS '전체 이름';
		COMMENT ON COLUMN "REP_USER"."PASSWORD_HASH" IS '암호화된 패스워드'; 
        COMMENT ON COLUMN "REP_USER"."NAME_VISIBLE" IS '이름 공개 여부';        
		COMMENT ON COLUMN "REP_USER"."FIRST_NAME" IS '이름'; 
        COMMENT ON COLUMN "REP_USER"."LAST_NAME" IS '성';        
		COMMENT ON COLUMN "REP_USER"."EMAIL" IS '메일주소'; 
        COMMENT ON COLUMN "REP_USER"."EMAIL_VISIBLE" IS '메일주소 공개여부';           
		COMMENT ON COLUMN "REP_USER"."USER_ENABLED" IS '계정 사용여부';     
        COMMENT ON COLUMN "REP_USER"."STATUS" IS '계정 상태';	    
        COMMENT ON COLUMN "REP_USER"."CREATION_DATE" IS '생성일자';	    
        COMMENT ON COLUMN "REP_USER"."MODIFIED_DATE" IS '수정일자';	
        
        -- Role
		CREATE TABLE REP_ROLE (
		  ROLE_ID                     INTEGER NOT NULL,
		  NAME                        VARCHAR2(100)   NOT NULL,
		  DESCRIPTION              VARCHAR2(1000)  NOT NULL,
		  CREATION_DATE           DATE DEFAULT  SYSDATE NOT NULL,
		  MODIFIED_DATE           DATE DEFAULT  SYSDATE NOT NULL,	
		  CONSTRAINT REP_ROLE_PK PRIMARY KEY (ROLE_ID)
		);
		
		COMMENT ON TABLE "REP_ROLE"  IS '롤 테이블';
		COMMENT ON COLUMN "REP_ROLE"."ROLE_ID" IS '롤 ID'; 
		COMMENT ON COLUMN "REP_ROLE"."NAME" IS '롤 이름'; 
		COMMENT ON COLUMN "REP_ROLE"."DESCRIPTION" IS '설명'; 	
		COMMENT ON COLUMN "REP_ROLE"."CREATION_DATE" IS '생성일자'; 
		COMMENT ON COLUMN "REP_ROLE"."MODIFIED_DATE" IS '수정일자'; 				
		
		CREATE UNIQUE INDEX REP_ROLE_NAME_IDX ON REP_ROLE (NAME)
		
		-- User Roles 
		CREATE TABLE REP_USER_ROLES (
		  USER_ID                 INTEGER NOT NULL,
		  ROLE_ID                 INTEGER NOT NULL,
		  CONSTRAINT REP_USER_ROLES_PK PRIMARY KEY (USER_ID, ROLE_ID)
		);

		COMMENT ON TABLE "REP_USER_ROLES"  IS '사용자 롤 테이블';
		COMMENT ON COLUMN "REP_USER_ROLES"."USER_ID" IS '그룹 ID'; 
		COMMENT ON COLUMN "REP_USER_ROLES"."ROLE_ID" IS '롤 ID'; 
		
		
		-- User remember me
		CREATE TABLE REP_USER_LOGIN_TOKEN (
			UUID			VARCHAR2(100) NOT NULL,
			USERNAME		VARCHAR2(100) NOT NULL, 
		 	TOKEN 			VARCHAR2(100) NOT NULL, 
		 	LAST_USE_DATE	TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
		);
 
		COMMENT ON TABLE "REP_USER_LOGIN_TOKEN"  IS '인증 정보 저장 테이블';
		COMMENT ON COLUMN "REP_USER_LOGIN_TOKEN"."UUID" IS '시퀀스 값'; 
		COMMENT ON COLUMN "REP_USER_LOGIN_TOKEN"."USERNAME" IS '로그인아이디'; 	
		COMMENT ON COLUMN "REP_USER_LOGIN_TOKEN"."TOKEN" IS '인증 토큰 값'; 
		COMMENT ON COLUMN "REP_USER_LOGIN_TOKEN"."LAST_USE_DATE" IS '마지막 사용일자'; 	
		
		-- User Avatar
		
		CREATE TABLE REP_AVATAR_IMAGE (	
			"AVATAR_IMAGE_ID" NUMBER(*,0) NOT NULL ENABLE, 
			"USER_ID" NUMBER(*,0) NOT NULL ENABLE, 
			"PRIMARY_IMAGE" NUMBER(1,0) DEFAULT 1, 
			"FILE_NAME" VARCHAR2(255 BYTE) NOT NULL ENABLE, 
			"FILE_SIZE" NUMBER(*,0) NOT NULL ENABLE, 
			"CONTENT_TYPE" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
			"CREATION_DATE" DATE DEFAULT SYSDATE NOT NULL ENABLE, 
			"MODIFIED_DATE" DATE DEFAULT SYSDATE NOT NULL ENABLE, 
			CONSTRAINT REP_AVATAR_IMAGE_PK PRIMARY KEY (AVATAR_IMAGE_ID)
		);
		CREATE INDEX  REP_AVATAR_IMAGE_IDX1  ON REP_AVATAR_IMAGE  ("USER_ID") ;

		COMMENT ON COLUMN  "REP_AVATAR_IMAGE"."AVATAR_IMAGE_ID" IS 'ID';	 
		COMMENT ON COLUMN  "REP_AVATAR_IMAGE"."USER_ID" IS '사용자 ID';	 
		COMMENT ON COLUMN  "REP_AVATAR_IMAGE"."PRIMARY_IMAGE" IS '주 이미지 여부';	 
		COMMENT ON COLUMN  "REP_AVATAR_IMAGE"."FILE_NAME" IS '이미지 파일 이름';	 
		COMMENT ON COLUMN  "REP_AVATAR_IMAGE"."FILE_SIZE" IS '이미지 파일 크기';	 
	   COMMENT ON COLUMN  "REP_AVATAR_IMAGE"."CONTENT_TYPE" IS 'CONTENT TYPE 값';	 
	   COMMENT ON COLUMN  "REP_AVATAR_IMAGE"."CREATION_DATE" IS '생성일';	 
	   COMMENT ON COLUMN  "REP_AVATAR_IMAGE"."MODIFIED_DATE" IS '수정일';	 
	   COMMENT ON TABLE   "REP_AVATAR_IMAGE"  IS '아바타 이미지 테이블';
 
  		CREATE TABLE  "REP_AVATAR_IMAGE_DATA" (	
  			"AVATAR_IMAGE_ID" NUMBER(*, 0) NOT NULL ENABLE, 
			"AVATAR_IMAGE_DATA" BLOB, 
	 		CONSTRAINT "REP_AVATAR_IMAGE_DATA_PK" PRIMARY KEY ("AVATAR_IMAGE_ID")
	 	);

		COMMENT ON COLUMN  "REP_AVATAR_IMAGE_DATA"."AVATAR_IMAGE_ID" IS 'ID'; 
		COMMENT ON COLUMN  "REP_AVATAR_IMAGE_DATA"."AVATAR_IMAGE_DATA" IS '이미지 데이터'; 
		COMMENT ON TABLE   "REP_AVATAR_IMAGE_DATA"  IS '아바타 이미지 데이터 테이블'; 
 		
		
		-- =================================================  
		-- BOARD
		-- =================================================  
		CREATE TABLE REP_BOARD_THREAD (
			THREAD_ID			INTEGER NOT NULL,
		  	OBJECT_TYPE			INTEGER NOT NULL,
		 	OBJECT_ID			INTEGER NOT NULL,
		  	ROOT_MESSAGE_ID		INTEGER NOT NULL,
		  	CREATION_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		  	MODIFIED_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		 	CONSTRAINT REP_BOARD_THREAD_PK PRIMARY KEY (THREAD_ID)
		);

		COMMENT ON TABLE "REP_BOARD_THREAD"  IS '게시물 스레드(토픽) 테이블';
		COMMENT ON COLUMN "REP_BOARD_THREAD"."THREAD_ID" IS '게시물 스레드 ID'; 
		COMMENT ON COLUMN "REP_BOARD_THREAD"."OBJECT_TYPE" IS '게시물이 속하는 객체 유형'; 	
		COMMENT ON COLUMN "REP_BOARD_THREAD"."OBJECT_ID" IS '게시물이 속하는 객체 ID'; 	
		COMMENT ON COLUMN "REP_BOARD_THREAD"."ROOT_MESSAGE_ID" IS '최초 게시물 ID'; 
		COMMENT ON COLUMN "REP_BOARD_THREAD"."CREATION_DATE" IS '생성일자'; 
		COMMENT ON COLUMN "REP_BOARD_THREAD"."MODIFIED_DATE" IS '수정일자'; 
		
		
		CREATE TABLE REP_BOARD_MESSAGE (
			MESSAGE_ID			INTEGER NOT NULL,
		    PARENT_MESSAGE_ID	INTEGER NOT NULL,
		    THREAD_ID			INTEGER NOT NULL,
		    OBJECT_TYPE			INTEGER NOT NULL,
		    OBJECT_ID			INTEGER NOT NULL,
		    USER_ID				INTEGER NOT NULL,
		    KEYWORDS			VARCHAR2(255),
		    SUBJECT				VARCHAR2(255),
		    BODY				CLOB,
		    CREATION_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		    MODIFIED_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		 	CONSTRAINT REP_BOARD_MESSAGE_PK PRIMARY KEY (MESSAGE_ID)
		);

		COMMENT ON TABLE "REP_BOARD_MESSAGE"  IS '게시물 테이블';
		COMMENT ON COLUMN "REP_BOARD_MESSAGE"."MESSAGE_ID" IS '게시물 ID'; 
		COMMENT ON COLUMN "REP_BOARD_MESSAGE"."PARENT_MESSAGE_ID" IS '부모 게시물 ID'; 
		COMMENT ON COLUMN "REP_BOARD_MESSAGE"."THREAD_ID" IS '게시물 스레드 ID'; 
		COMMENT ON COLUMN "REP_BOARD_MESSAGE"."OBJECT_TYPE" IS '게시물이 속하는 객체 유형'; 	
		COMMENT ON COLUMN "REP_BOARD_MESSAGE"."OBJECT_ID" IS '게시물이 속하는 객체 ID'; 	
		COMMENT ON COLUMN "REP_BOARD_MESSAGE"."USER_ID" IS '게시자 ID'; 	
		COMMENT ON COLUMN "REP_BOARD_MESSAGE"."SUBJECT" IS '제목'; 	
		COMMENT ON COLUMN "REP_BOARD_MESSAGE"."BODY" IS '내용'; 	
		COMMENT ON COLUMN "REP_BOARD_MESSAGE"."CREATION_DATE" IS '생성일자'; 
		COMMENT ON COLUMN "REP_BOARD_MESSAGE"."MODIFIED_DATE" IS '수정일자'; 
		
		
		CREATE INDEX REP_BOARD_MESSAGE_IDX_01 ON REP_BOARD_MESSAGE (THREAD_ID);
		CREATE INDEX REP_BOARD_MESSAGE_IDX_02 ON REP_BOARD_MESSAGE (USER_ID);
		CREATE INDEX REP_BOARD_MESSAGE_IDX_03 ON REP_BOARD_MESSAGE (PARENT_MESSAGE_ID);
		CREATE INDEX REP_BOARD_MESSAGE_IDX_04 ON REP_BOARD_MESSAGE (OBJECT_TYPE, OBJECT_ID, MODIFIED_DATE);
		CREATE INDEX REP_BOARD_MESSAGE_IDX_05 ON REP_BOARD_MESSAGE (OBJECT_TYPE, OBJECT_ID, KEYWORDS);

		DROP TABLE REP_BOARD;
		
		CREATE TABLE REP_BOARD (
			CATEGORY_ID             INTEGER NOT NULL,
			BOARD_ID                INTEGER NOT NULL,
			NAME					VARCHAR2(255) NOT NULL, 
		 	DISPLAY_NAME 			VARCHAR2(255) NOT NULL, 
		 	DESCRIPTION             VARCHAR2(1000) ,
		 	CREATION_DATE           DATE DEFAULT  SYSDATE NOT NULL,
		  	MODIFIED_DATE           DATE DEFAULT  SYSDATE NOT NULL,
		 	CONSTRAINT REP_BOARD_PK PRIMARY KEY (BOARD_ID)
		);
		
		COMMENT ON TABLE "REP_BOARD"  IS '게시판 테이블';
		COMMENT ON COLUMN "REP_BOARD"."CATEGORY_ID" IS '범주 ID';
		COMMENT ON COLUMN "REP_BOARD"."BOARD_ID" IS '게시판 ID'; 
		COMMENT ON COLUMN "REP_BOARD"."NAME" IS '게시판 이름'; 
		COMMENT ON COLUMN "REP_BOARD"."DISPLAY_NAME" IS '게시판 화면 출력 이름'; 
		COMMENT ON COLUMN "REP_BOARD"."DESCRIPTION" IS '설명'; 	
		COMMENT ON COLUMN "REP_BOARD"."CREATION_DATE" IS '생성일자'; 
		COMMENT ON COLUMN "REP_BOARD"."MODIFIED_DATE" IS '수정일자'; 
		
		CREATE INDEX REP_BOARD_NAME_IDX ON REP_BOARD (NAME);
		CREATE INDEX REP_BOARD_CATELOGY_IDX ON REP_BOARD (CATELOGY_ID);

  		CREATE TABLE "REP_BOARD_PROPERTY" (	
  			"BOARD_ID" NUMBER(*,0) NOT NULL ENABLE, 
			"PROPERTY_NAME" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
			"PROPERTY_VALUE" VARCHAR2(1024 BYTE) NOT NULL ENABLE, 
	 		CONSTRAINT "REP_BOARD_PROPERTY_PK" PRIMARY KEY ("BOARD_ID", "PROPERTY_NAME"));
 

		COMMENT ON COLUMN "REP_BOARD_PROPERTY"."BOARD_ID" IS 'BOARD ID'; 
		COMMENT ON COLUMN "REP_BOARD_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
		COMMENT ON COLUMN "REP_BOARD_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값'; 
		COMMENT ON TABLE  "REP_BOARD_PROPERTY"  IS 'BOARD 프로퍼티 테이블';	
		
	-- =================================================  
	--  VIEWCOUNT	
	-- =================================================	
		CREATE TABLE REP_VIEWCOUNT(	
			ENTITY_TYPE					INTEGER NOT NULL,
			ENTITY_ID					INTEGER NOT NULL,
			VIEWCOUNT					INTEGER NOT NULL,
			CONSTRAINT REP_VIEWCOUNT_PK PRIMARY KEY (ENTITY_TYPE, ENTITY_ID)
   		);		
   		
   		COMMENT ON TABLE "REP_VIEWCOUNT"  IS '뷰 카운트 테이블';
		COMMENT ON COLUMN "REP_VIEWCOUNT"."ENTITY_TYPE" IS '객체 타입'; 
		COMMENT ON COLUMN "REP_VIEWCOUNT"."ENTITY_ID" IS '객체 아이디'; 
		COMMENT ON COLUMN "REP_VIEWCOUNT"."VIEWCOUNT" IS '카운트'; 
		
		
	-- =================================================  
	--  COMMENT	
	-- =================================================	
	CREATE TABLE REP_COMMENT(	
		COMMENT_ID					INTEGER NOT NULL,		
		OBJECT_TYPE					INTEGER NOT NULL,
		OBJECT_ID						INTEGER NOT NULL,
		PARENT_COMMENT_ID		INTEGER,
		PARENT_OBJECT_TYPE		INTEGER,
		PARENT_OBJECT_ID			INTEGER,
		USER_ID						INTEGER,
		NAME							VARCHAR2(100),
		EMAIL							VARCHAR2(255),
		URL								VARCHAR2(255),
		IP								VARCHAR2(15),
		BODY                            VARCHAR2(4000),
		STATUS							INTEGER NOT NULL, 
		CREATION_DATE				DATE DEFAULT  SYSDATE NOT NULL,
		MODIFIED_DATE				DATE DEFAULT  SYSDATE NOT NULL,		
		CONSTRAINT REP_COMMENT_PK PRIMARY KEY (COMMENT_ID)
   );	
   
	CREATE INDEX REP_COMMENT_IDX1 ON REP_COMMENT (CREATION_DATE) ;
	CREATE INDEX REP_COMMENT_IDX2 ON REP_COMMENT (MODIFIED_DATE) ;
	CREATE INDEX REP_COMMENT_IDX3 ON REP_COMMENT (OBJECT_TYPE, OBJECT_ID) ;
	CREATE INDEX REP_COMMENT_IDX4 ON REP_COMMENT (PARENT_OBJECT_TYPE, PARENT_OBJECT_ID) ;
	CREATE INDEX REP_COMMENT_IDX5 ON REP_COMMENT (USER_ID) ;
	
	CREATE TABLE REP_COMMENT_PROPERTY (
	  COMMENT_ID               INTEGER NOT NULL,
	  PROPERTY_NAME          VARCHAR2(100)   NOT NULL,
	  PROPERTY_VALUE         VARCHAR2(1024)  NOT NULL,
	  CONSTRAINT REP_COMMENT_PROPERTY_PK PRIMARY KEY (COMMENT_ID, PROPERTY_NAME)
	);	
	
	COMMENT ON TABLE      "REP_COMMENT_PROPERTY"  IS 'COMMENT 프로퍼티 테이블';
	COMMENT ON COLUMN "REP_COMMENT_PROPERTY"."COMMENT_ID" IS 'COMMENT ID'; 
	COMMENT ON COLUMN "REP_COMMENT_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
	COMMENT ON COLUMN "REP_COMMENT_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값'; 		
	
	
	-- =================================================  
	--  ATTACHEMENT 	
	-- =================================================		
	CREATE TABLE REP_ATTACHMENT (
	    ATTACHMENT_ID		     INTEGER NOT NULL,
		OBJECT_TYPE              INTEGER NOT NULL,
		OBJECT_ID                INTEGER NOT NULL,	    		
		CONTENT_TYPE             VARCHAR2(255)  NOT NULL,			  
		FILE_NAME                VARCHAR2(500)   NOT NULL,
		FILE_SIZE                INTEGER   NOT NULL,
		USER_ID					 INTEGER NOT NULL,	 	
		CREATION_DATE            DATE DEFAULT  SYSDATE NOT NULL,
		MODIFIED_DATE            DATE DEFAULT  SYSDATE NOT NULL,	
	   CONSTRAINT REP_ATTACHMENT_PK PRIMARY KEY (ATTACHMENT_ID)	    
    );
	    
   
    CREATE INDEX REP_ATTACHMENT_IDX1 ON REP_ATTACHMENT( OBJECT_TYPE, OBJECT_ID ) ;	
	COMMENT ON TABLE "REP_ATTACHMENT"  IS '첨부파일 테이블';
	COMMENT ON COLUMN "REP_ATTACHMENT"."ATTACHMENT_ID" IS 'ID'; 
	COMMENT ON COLUMN "REP_ATTACHMENT"."OBJECT_TYPE" IS '첨부파일과 연관된 모델 유형'; 
    COMMENT ON COLUMN "REP_ATTACHMENT"."OBJECT_ID" IS '첨부파일과 연관된 모델 ID';
	COMMENT ON COLUMN "REP_ATTACHMENT"."FILE_NAME" IS '첨부파일 이름'; 
    COMMENT ON COLUMN "REP_ATTACHMENT"."FILE_SIZE" IS '첨부파일 크기';        
	COMMENT ON COLUMN "REP_ATTACHMENT"."CONTENT_TYPE" IS 'CONTENT TYPE 값'; 
	COMMENT ON COLUMN "REP_ATTACHMENT"."CREATION_DATE" IS '생성일'; 
    COMMENT ON COLUMN "REP_ATTACHMENT"."MODIFIED_DATE" IS '수정일';

    CREATE TABLE REP_ATTACHMENT_PROPERTY (
		ATTACHMENT_ID          INTEGER NOT NULL,
		PROPERTY_NAME          VARCHAR2(100)   NOT NULL,
		PROPERTY_VALUE         VARCHAR2(1024)  NOT NULL,
		CONSTRAINT REP_ATTACHMENT_PROPERTY_PK PRIMARY KEY (ATTACHMENT_ID, PROPERTY_NAME)
	);	
	
	COMMENT ON TABLE      "REP_ATTACHMENT_PROPERTY"  IS '첨부파일 프로퍼티 테이블';
	COMMENT ON COLUMN "REP_ATTACHMENT_PROPERTY"."ATTACHMENT_ID" IS '첨부파일 ID'; 
	COMMENT ON COLUMN "REP_ATTACHMENT_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
	COMMENT ON COLUMN "REP_ATTACHMENT_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값'; 		

	CREATE TABLE REP_ATTACHMENT_DATA (
		ATTACHMENT_ID               	INTEGER NOT NULL,
		ATTACHMENT_DATA               	BLOB,
		CONSTRAINT REP_ATTACHMENT_DATA_PK PRIMARY KEY (ATTACHMENT_ID)
	);		        
		
	COMMENT ON TABLE "REP_ATTACHMENT_DATA"  IS '첨부파일 데이터 테이블';
	COMMENT ON COLUMN "REP_ATTACHMENT_DATA"."ATTACHMENT_ID" IS 'ID'; 
	COMMENT ON COLUMN "REP_ATTACHMENT_DATA"."ATTACHMENT_DATA" IS '첨부파일 데이터'; 		
		
	-- =================================================  
	--  IMAGE	
	-- =================================================		
		
	CREATE TABLE REP_IMAGE (
		IMAGE_ID                 INTEGER NOT NULL,
		OBJECT_TYPE              INTEGER NOT NULL,
		OBJECT_ID                INTEGER NOT NULL,
		FILE_NAME                VARCHAR2(255)   NOT NULL,
		FILE_SIZE                INTEGER   NOT NULL,
		CONTENT_TYPE             VARCHAR2(50)  NOT NULL,			  
		USER_ID				   	 INTEGER NOT NULL,	 	
		CREATION_DATE            DATE DEFAULT  SYSDATE NOT NULL,
		MODIFIED_DATE            DATE DEFAULT  SYSDATE NOT NULL,	
		CONSTRAINT REP_IMAGE_PK PRIMARY KEY (IMAGE_ID)
	);		        
		
		
		CREATE INDEX REP_IMAGE_IDX1 ON REP_IMAGE( OBJECT_TYPE, OBJECT_ID ) ;	
		COMMENT ON TABLE "REP_IMAGE"  IS '이미지 테이블';
		COMMENT ON COLUMN "REP_IMAGE"."IMAGE_ID" IS 'ID'; 
		COMMENT ON COLUMN "REP_IMAGE"."OBJECT_TYPE" IS '이미지와 연관된 모델 유형'; 
        COMMENT ON COLUMN "REP_IMAGE"."OBJECT_ID" IS '이미지와 연관된 모델 ID';
		COMMENT ON COLUMN "REP_IMAGE"."FILE_NAME" IS '이미지 파일 이름'; 
        COMMENT ON COLUMN "REP_IMAGE"."FILE_SIZE" IS '이미지 파일 크기';        
		COMMENT ON COLUMN "REP_IMAGE"."CONTENT_TYPE" IS 'CONTENT TYPE 값'; 
		COMMENT ON COLUMN "REP_IMAGE"."CREATION_DATE" IS '생성일'; 
        COMMENT ON COLUMN "REP_IMAGE"."MODIFIED_DATE" IS '수정일';
        
        CREATE TABLE REP_IMAGE_DATA (
			  IMAGE_ID                    INTEGER NOT NULL,
			  IMAGE_DATA               BLOB,
			  CONSTRAINT REP_IMAGE_DATA_PK PRIMARY KEY (IMAGE_ID)
		);		        
		
		COMMENT ON TABLE "REP_IMAGE_DATA"  IS '이미지 데이터 테이블';
		COMMENT ON COLUMN "REP_IMAGE_DATA"."IMAGE_ID" IS 'ID'; 
		COMMENT ON COLUMN "REP_IMAGE_DATA"."IMAGE_DATA" IS '이미지 데이터'; 		
		
		
		CREATE TABLE REP_IMAGE_LINK ( 
			LINK_ID						VARCHAR2(255)	NOT NULL, 
			IMAGE_ID					INTEGER NOT NULL,			
			PUBLIC_SHARED			NUMBER(1, 0)  DEFAULT 1,
			CONSTRAINT REP_IMAGE_LINK_PK PRIMARY KEY (LINK_ID)
		); 		
		CREATE UNIQUE INDEX REP_IMAGE_LINK_IDX ON REP_IMAGE_LINK (IMAGE_ID);
		
		COMMENT ON TABLE "REP_IMAGE_LINK"  IS '이미지 링크 테이블';
		COMMENT ON COLUMN "REP_IMAGE_LINK"."LINK_ID" IS '링크 아이디'; 
		COMMENT ON COLUMN "REP_IMAGE_LINK"."IMAGE_ID" IS '이미지 아이디'; 	
		
		
    CREATE TABLE AC_UI_IMAGE_PROPERTY (
		IMAGE_ID          INTEGER NOT NULL,
		PROPERTY_NAME          VARCHAR2(100)   NOT NULL,
		PROPERTY_VALUE         VARCHAR2(1024)  NOT NULL,
		CONSTRAINT AC_UI_IMAGE_PROPERTY_PK PRIMARY KEY (IMAGE_ID, PROPERTY_NAME)
	);	
	
	COMMENT ON TABLE  "AC_UI_IMAGE_PROPERTY"  IS '이미지 프로퍼티 테이블';
	COMMENT ON COLUMN "AC_UI_IMAGE_PROPERTY"."IMAGE_ID" IS '이미지 ID'; 
	COMMENT ON COLUMN "AC_UI_IMAGE_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
	COMMENT ON COLUMN "AC_UI_IMAGE_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값'; 		
	
	-- =================================================  
	--  EXTERNAL_LINK	
	-- =================================================	
		CREATE TABLE REP_EXTERNAL_LINK ( 
			LINK_ID						VARCHAR2(255)	NOT NULL, 
			OBJECT_TYPE					INTEGER NOT NULL,		
			OBJECT_ID                INTEGER NOT NULL,
			PUBLIC_SHARED			NUMBER(1, 0)  DEFAULT 1,
			CONSTRAINT REP_LINK_ID_PK PRIMARY KEY (LINK_ID)
		); 		
		
		CREATE UNIQUE INDEX REP_EXTERNAL_LINK_IDX1 ON REP_EXTERNAL_LINK (OBJECT_TYPE, OBJECT_ID);
		
		COMMENT ON TABLE "REP_EXTERNAL_LINK"  IS '외부 링크 테이블';
		COMMENT ON COLUMN "REP_EXTERNAL_LINK"."LINK_ID" IS '링크 아이디'; 
		COMMENT ON COLUMN "REP_EXTERNAL_LINK"."OBJECT_TYPE" IS '객체타입'; 	
		COMMENT ON COLUMN "REP_EXTERNAL_LINK"."OBJECT_ID" IS '객체 아이디'; 	
		COMMENT ON COLUMN "REP_EXTERNAL_LINK"."PUBLIC_SHARED" IS '공개여부'; 	
	 
		
	-- =================================================  
	--  TAG	
	-- =================================================	
	
    CREATE TABLE AC_UI_TAG(	 
	    TAG_ID					INTEGER NOT NULL,	
	    TAG_NAME				VARCHAR2(100) NOT NULL,
	    CREATION_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
	    CONSTRAINT AC_UI_TAG_PK PRIMARY KEY (TAG_ID)
    );
   
    CREATE UNIQUE INDEX AC_UI_TAG_IDX1 ON AC_UI_TAG( TAG_NAME ) ;	
    CREATE INDEX AC_UI_TAG_IDX2 ON AC_UI_TAG (CREATION_DATE) ;
   
    CREATE TABLE AC_UI_OBJECT_TAG(	 
    		TAG_ID					INTEGER NOT NULL,	
		OBJECT_TYPE			INTEGER NOT NULL,
		OBJECT_ID				INTEGER NOT NULL,
   		CREATION_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
	);
    
	CREATE INDEX AC_UI_OBJECT_TAG_IDX1 ON AC_UI_OBJECT_TAG (OBJECT_ID, TAG_ID, OBJECT_TYPE) ;
    CREATE INDEX AC_UI_OBJECT_TAG_IDX2 ON AC_UI_OBJECT_TAG (TAG_ID) ;
    CREATE INDEX AC_UI_OBJECT_TAG_IDX3 ON AC_UI_OBJECT_TAG (OBJECT_TYPE, OBJECT_ID, CREATION_DATE, TAG_ID) ;
    CREATE INDEX AC_UI_OBJECT_TAG_IDX4 ON AC_UI_OBJECT_TAG (OBJECT_TYPE, TAG_ID) ;

    

	-- =================================================  
	--  PAGE
	-- =================================================		 

	CREATE TABLE REP_PAGE(	
	PAGE_ID						INTEGER NOT NULL,
	OBJECT_TYPE					INTEGER NOT NULL,
	OBJECT_ID					INTEGER NOT NULL,
	NAME							VARCHAR2(255) NOT NULL,	
	VERSION_ID					INTEGER DEFAULT 1 NOT NULL,
	USER_ID						INTEGER NOT NULL,
	READ_COUNT          			INTEGER DEFAULT 0  NOT NULL,
	CREATION_DATE				DATE DEFAULT  SYSDATE NOT NULL,
	MODIFIED_DATE				DATE DEFAULT  SYSDATE NOT NULL,			
	CONSTRAINT REP_PAGE_PK PRIMARY KEY (PAGE_ID)
   );
   
	CREATE UNIQUE INDEX REP_PAGE_IDX1 ON REP_PAGE (NAME);
	CREATE INDEX REP_PAGE_IDX2   ON REP_PAGE (OBJECT_TYPE, OBJECT_ID, PAGE_ID);
	CREATE INDEX REP_PAGE_IDX3   ON REP_PAGE (USER_ID);

   
	CREATE TABLE REP_PAGE_BODY
	(	
	BODY_ID						INTEGER NOT NULL,
	PAGE_ID						INTEGER NOT NULL,
	BODY_TYPE					INTEGER NOT NULL,
	BODY_TEXT					CLOB,
	CONSTRAINT REP_PAGE_BODY_PK PRIMARY KEY (BODY_ID)
   ) ;
	
		
  CREATE TABLE REP_PAGE_BODY_VERSION
   (	
	BODY_ID					INTEGER NOT NULL,
	PAGE_ID						INTEGER NOT NULL,
	VERSION_ID				INTEGER DEFAULT 1 NOT NULL ,
	
	CONSTRAINT REP_PAGE_BODY_VERSION_PK PRIMARY KEY (BODY_ID, PAGE_ID, VERSION_ID )
   ) ;   
   CREATE INDEX REP_PAGE_BODY_VERSION_IDX1   ON REP_PAGE_BODY_VERSION (PAGE_ID, VERSION_ID);

		
  CREATE TABLE REP_PAGE_VERSION
   (	
	PAGE_ID					INTEGER NOT NULL,
	VERSION_ID				INTEGER DEFAULT 1 NOT NULL ,
	STATE					VARCHAR2(20), 
	TITLE					VARCHAR2(255), 
	SECURED          		NUMBER(1, 0)  DEFAULT 1,
	TEMPLATE					VARCHAR2(255), 
	SUMMARY					VARCHAR2(4000), 
	USER_ID					INTEGER	NOT NULL,
	CREATION_DATE			DATE DEFAULT  SYSDATE NOT NULL,
	MODIFIED_DATE			DATE DEFAULT  SYSDATE NOT NULL,	
	CONSTRAINT REP_PAGE_VERSION_PK PRIMARY KEY (PAGE_ID, VERSION_ID)
   ) ;

		
	CREATE INDEX REP_PAGE_VERSION_IDX1   ON REP_PAGE_VERSION (CREATION_DATE);
	CREATE INDEX REP_PAGE_VERSION_IDX2   ON REP_PAGE_VERSION (MODIFIED_DATE);
	CREATE INDEX REP_PAGE_VERSION_IDX3   ON REP_PAGE_VERSION (TITLE);
	CREATE INDEX REP_PAGE_VERSION_IDX4   ON REP_PAGE_VERSION (PAGE_ID, STATE);

			
	CREATE TABLE REP_PAGE_PROPERTY (
		  PAGE_ID				INTEGER NOT NULL,
		  VERSION_ID				INTEGER DEFAULT 1 NOT NULL,
		  PROPERTY_NAME          VARCHAR2(100)   NOT NULL,
		  PROPERTY_VALUE         VARCHAR2(1024)  NOT NULL,
		  CONSTRAINT REP_PAGE_PROPERTY_PK PRIMARY KEY (PAGE_ID, VERSION_ID, PROPERTY_NAME)
	);	

	COMMENT ON TABLE  "REP_PAGE_PROPERTY"  IS 'PAGE 프로퍼티 테이블';
	COMMENT ON COLUMN "REP_PAGE_PROPERTY"."PAGE_ID" IS 'PAGE ID'; 
	COMMENT ON COLUMN "REP_PAGE_PROPERTY"."VERSION_ID" IS 'PAGE VERSION'; 	
	COMMENT ON COLUMN "REP_PAGE_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
	COMMENT ON COLUMN "REP_PAGE_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값'; 			
	

	-- =================================================  
	--  PROJECT , ISSUE
	-- =================================================		 
	
	CREATE TABLE REP_PROJECT (	
		PROJECT_ID					INTEGER NOT NULL,
		NAME							VARCHAR2(255) NOT NULL,	
		SUMMARY						VARCHAR2(2000) NOT NULL,
		CONTRACT_STATE  			VARCHAR2(100) ,
		CONTRACTOR  				VARCHAR2(100) ,
		MAINTENANCE_COST			NUMBER DEFAULT 0,	
		START_DATE					DATE,
		END_DATE					DATE,	
		PROJECT_ENABLED           	NUMBER(1, 0)  DEFAULT 1, 
		CREATION_DATE				DATE DEFAULT  SYSDATE NOT NULL,
		MODIFIED_DATE				DATE DEFAULT  SYSDATE NOT NULL,			
		CONSTRAINT REP_PROJECT_PK PRIMARY KEY (PROJECT_ID)
	);

	
	CREATE TABLE REP_ISSUE (	
		OBJECT_TYPE					INTEGER NOT NULL,
		OBJECT_ID					INTEGER NOT NULL,
		ISSUE_ID					INTEGER NOT NULL,
		ISSUE_TYPE					VARCHAR2(100) ,
		ISSUE_KEY                   VARCHAR2(100) ,
		ISSUE_STATUS				VARCHAR2(100) ,
		RESOLUTION					VARCHAR2(100) ,
		PRIORITY					VARCHAR2(100) ,	
		COMPONENT					VARCHAR2(100) ,					
		ASSIGNEE 					INTEGER,
		REPOTER						INTEGER NOT NULL,
		SUMMARY						VARCHAR2(2000) NOT NULL,
		DESCRIPTION					CLOB, --VARCHAR2(2000) NOT NULL,
		START_DATE					DATE,
		DUE_DATE					DATE,	
		RESOLUTION_DATE 			TIMESTAMP,
		TIMEORIGINALESTIMATE		INTEGER,
		TIMEESTIMATE				INTEGER,
		TIMESPENT					INTEGER,
		CREATOR						INTEGER,
		REQUESTOR_NAME 				VARCHAR2(255),
		TASK_ID 					INTEGER,
		CREATION_DATE				DATE DEFAULT  SYSDATE NOT NULL,
		MODIFIED_DATE				DATE DEFAULT  SYSDATE NOT NULL,			
		CONSTRAINT REP_ISSUE_PK PRIMARY KEY (ISSUE_ID)
	); 
	
	CREATE INDEX REP_ISSUE_IDX1 ON REP_ISSUE (OBJECT_TYPE, OBJECT_ID) ;
	CREATE INDEX REP_ISSUE_IDX2 ON REP_ISSUE (OBJECT_TYPE, OBJECT_ID, ISSUE_TYPE) ;
	
	-- =================================================  
	--  STANDARD CODE	
	-- =================================================	
	
	CREATE TABLE REP_CODESET (
		CODESET_ID			INTEGER NOT NULL,
		OBJECT_TYPE			INTEGER NOT NULL,
		OBJECT_ID			INTEGER NOT NULL,	
		PARENT_CODESET_ID	INTEGER NOT NULL,		
		NAME					VARCHAR2(255) NOT NULL,
		CODE					VARCHAR2(255),
		GROUP_CODE			VARCHAR2(255),
		META_CODE			VARCHAR2(100),
		DESCRIPTION			VARCHAR2(4000),
		CREATION_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		MODIFIED_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		CONSTRAINT REP_CODESET_PK PRIMARY KEY (CODESET_ID)
	);
	
	
	CREATE INDEX REP_CODESET_IDX1 ON REP_CODESET (OBJECT_TYPE, OBJECT_ID) ;
	CREATE INDEX REP_CODESET_IDX2 ON REP_CODESET (PARENT_CODESET_ID) ;
	CREATE INDEX REP_CODESET_IDX3 ON REP_CODESET (OBJECT_TYPE, OBJECT_ID, NAME) ;
	CREATE INDEX REP_CODESET_IDX4 ON REP_CODESET (OBJECT_TYPE, OBJECT_ID, GROUP_CODE) ;
	CREATE UNIQUE INDEX REP_CODESET_UIDX1 ON REP_CODESET (META_CODE);
	
	CREATE TABLE REP_CODESET_PROPERTY (
	  CODESET_ID             INTEGER NOT NULL,
	  PROPERTY_NAME          VARCHAR2(100)   NOT NULL,
	  PROPERTY_VALUE         VARCHAR2(1024)  NOT NULL,
	  CONSTRAINT REP_CODESET_PROPERTY_PK PRIMARY KEY (CODESET_ID, PROPERTY_NAME)
	);	
	
	COMMENT ON TABLE  "REP_CODESET_PROPERTY"  IS '코드 프로퍼티 테이블';
	COMMENT ON COLUMN "REP_CODESET_PROPERTY"."CODESET_ID" IS '코드 ID'; 
	COMMENT ON COLUMN "REP_CODESET_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
	COMMENT ON COLUMN "REP_CODESET_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값';
	
	
	-- =================================================  
	--  UI MENU	
	-- =================================================	
	CREATE TABLE AC_UI_MENU (
		MENU_ID				INTEGER NOT NULL,
		NAME					VARCHAR2(255) NOT NULL,
		DESCRIPTION			VARCHAR2(4000),
		CREATION_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		MODIFIED_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		CONSTRAINT AC_UI_MENU_PK PRIMARY KEY (MENU_ID)
	);	
	COMMENT ON TABLE  "AC_UI_MENU"  IS 'UI 메뉴 테이블';
	COMMENT ON COLUMN "AC_UI_MENU"."MENU_ID" IS '메뉴 ID'; 
	COMMENT ON COLUMN "AC_UI_MENU"."NAME" IS '메뉴 이름'; 
	COMMENT ON COLUMN "AC_UI_MENU"."DESCRIPTION" IS '메뉴 설명';	
	
	CREATE UNIQUE INDEX AC_UI_MENU_UIDX1 ON AC_UI_MENU (NAME);
	
	CREATE TABLE AC_UI_MENU_PROPERTY (
	  MENU_ID             INTEGER NOT NULL,
	  PROPERTY_NAME          VARCHAR2(100)   NOT NULL,
	  PROPERTY_VALUE         VARCHAR2(1024)  NOT NULL,
	  CONSTRAINT AC_UI_MENU_PROPERTY_PK PRIMARY KEY (MENU_ID, PROPERTY_NAME)
	);	
	
	COMMENT ON TABLE  "AC_UI_MENU_PROPERTY"  IS 'AC_UI_MENU 프로퍼티 테이블';
	COMMENT ON COLUMN "AC_UI_MENU_PROPERTY"."MENU_ID" IS 'ID'; 
	COMMENT ON COLUMN "AC_UI_MENU_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
	COMMENT ON COLUMN "AC_UI_MENU_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값';
	
	CREATE TABLE AC_UI_MENU_ITEM (
		MENU_ID				INTEGER NOT NULL,
		PARENT_ID			INTEGER NOT NULL,
		MENU_ITEM_ID			INTEGER NOT NULL,
		SORT_ORDER			NUMBER  DEFAULT 0,	
		NAME					VARCHAR2(255) NOT NULL,
		DESCRIPTION			VARCHAR2(4000),
		PAGE					VARCHAR2(255),
		LINK_URL				VARCHAR2(255),
		ROLES				VARCHAR2(255),
		CREATION_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		MODIFIED_DATE		TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
		CONSTRAINT AC_UI_MENU_ITEM_PK PRIMARY KEY (MENU_ITEM_ID)
	);	
	
	COMMENT ON TABLE  "AC_UI_MENU_ITEM"  IS 'UI 메뉴 아이템 테이블';
	COMMENT ON COLUMN "AC_UI_MENU_ITEM"."MENU_ID" IS '메뉴 ID'; 
	COMMENT ON COLUMN "AC_UI_MENU_ITEM"."PARENT_ID" IS '부모 메뉴 아이템 이름'; 
	COMMENT ON COLUMN "AC_UI_MENU_ITEM"."MENU_ITEM_ID" IS '메뉴 아이템 ID';	
	
	CREATE INDEX AC_UI_MENU_ITEM_IDX1 ON AC_UI_MENU_ITEM (MENU_ID, PARENT_ID) ;
	
	CREATE INDEX AC_UI_MENU_ITEM_IDX2 ON AC_UI_MENU_ITEM (PARENT_ID) ;
	
	CREATE TABLE AC_UI_MENU_ITEM_PROPERTY (
	  MENU_ITEM_ID             INTEGER NOT NULL,
	  PROPERTY_NAME          VARCHAR2(100)   NOT NULL,
	  PROPERTY_VALUE         VARCHAR2(1024)  NOT NULL,
	  CONSTRAINT AC_UI_MENU_ITEM_PROPERTY_PK PRIMARY KEY (MENU_ITEM_ID, PROPERTY_NAME)
	);	
	
	COMMENT ON TABLE  "AC_UI_MENU_ITEM_PROPERTY"  IS 'AC_UI_MENU_ITEM 프로퍼티 테이블';
	COMMENT ON COLUMN "AC_UI_MENU_ITEM_PROPERTY"."MENU_ITEM_ID" IS 'ID'; 
	COMMENT ON COLUMN "AC_UI_MENU_ITEM_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
	COMMENT ON COLUMN "AC_UI_MENU_ITEM_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값';
	
	-- =================================================  
	--  ANNOUNCE
	-- =================================================		
	CREATE TABLE AC_ANNOUNCE (
		ANNOUNCE_ID						INTEGER NOT NULL,
		OBJECT_TYPE						INTEGER NOT NULL,
		OBJECT_ID						INTEGER NOT NULL,	 		
		USER_ID							INTEGER NOT NULL,	 		
		SUBJECT							VARCHAR2(255) NOT NULL,
		BODY								CLOB,
		START_DATE						TIMESTAMP DEFAULT  SYSTIMESTAMP NOT NULL,
		END_DATE							TIMESTAMP DEFAULT  SYSTIMESTAMP NOT NULL,
		STATUS							NUMBER(1, 0)  DEFAULT 0, 
		CREATION_DATE					DATE DEFAULT  SYSDATE NOT NULL,
		MODIFIED_DATE					DATE DEFAULT  SYSDATE NOT NULL,
		CONSTRAINT AC_ANNOUNCE_PK PRIMARY KEY (ANNOUNCE_ID)
	);
		
	CREATE INDEX AC_ANNOUNCE_IDX1 ON AC_ANNOUNCE (OBJECT_TYPE, OBJECT_ID);
	CREATE INDEX AC_ANNOUNCE_IDX2 ON AC_ANNOUNCE (START_DATE);
	CREATE INDEX AC_ANNOUNCE_IDX3 ON AC_ANNOUNCE (END_DATE);
	CREATE INDEX AC_ANNOUNCE_IDX4 ON AC_ANNOUNCE (USER_ID);
		
	CREATE TABLE AC_ANNOUNCE_PROPERTY (
		  ANNOUNCE_ID                     INTEGER NOT NULL,
		  PROPERTY_NAME          VARCHAR2(100)   NOT NULL,
		  PROPERTY_VALUE         VARCHAR2(1024)  NOT NULL,
		  CONSTRAINT AC_ANNOUNCE_PROPERTY_PK PRIMARY KEY (ANNOUNCE_ID, PROPERTY_NAME)
	);	
	
	COMMENT ON TABLE  "AC_ANNOUNCE_PROPERTY"  IS '공지 프로퍼티 테이블';
	COMMENT ON COLUMN "AC_ANNOUNCE_PROPERTY"."ANNOUNCE_ID" IS '공지 ID'; 
	COMMENT ON COLUMN "AC_ANNOUNCE_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
	COMMENT ON COLUMN "AC_ANNOUNCE_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값'; 
	
	-- =================================================  
	--  CATEGORY
	-- =================================================		
	CREATE TABLE AC_CATEGORY (
		CATEGORY_ID						INTEGER NOT NULL,
		OBJECT_TYPE						INTEGER NOT NULL,
		OBJECT_ID						INTEGER NOT NULL,	 		
		NAME							VARCHAR2(255) NOT NULL, 
	 	DISPLAY_NAME 					VARCHAR2(255) NOT NULL, 
	 	DESCRIPTION             		VARCHAR2(1000) ,
		CREATION_DATE					DATE DEFAULT  SYSDATE NOT NULL,
		MODIFIED_DATE					DATE DEFAULT  SYSDATE NOT NULL,
		CONSTRAINT AC_CATEGORY_PK PRIMARY KEY (CATEGORY_ID)
	);	
	
	CREATE INDEX AC_CATEGORY_IDX1 ON AC_CATEGORY (OBJECT_TYPE, OBJECT_ID);
	
	CREATE TABLE AC_CATEGORY_PROPERTY (
		  CATEGORY_ID            INTEGER NOT NULL,
		  PROPERTY_NAME          VARCHAR2(100)   NOT NULL,
		  PROPERTY_VALUE         VARCHAR2(1024)  NOT NULL,
		  CONSTRAINT AC_CATEGORY_PROPERTY_PK PRIMARY KEY (CATEGORY_ID, PROPERTY_NAME)
	);	
	
	COMMENT ON TABLE  "AC_CATEGORY_PROPERTY"  IS '공지 프로퍼티 테이블';
	COMMENT ON COLUMN "AC_CATEGORY_PROPERTY"."CATEGORY_ID" IS '공지 ID'; 
	COMMENT ON COLUMN "AC_CATEGORY_PROPERTY"."PROPERTY_NAME" IS '프로퍼티 이름'; 
	COMMENT ON COLUMN "AC_CATEGORY_PROPERTY"."PROPERTY_VALUE" IS '프로퍼티 값'; 
	