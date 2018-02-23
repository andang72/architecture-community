# architecture-community

오픈소스 게시판 ... 


community 
- security 
- page  


------
## How to install and start 

1. creat tables using database/create_table_oracle.sql

2. setting database connection in WEB-INF/startup-config.xml

3. build project using maven.

4. deploy WebContent as web application .

------

** OPENSOURE for UI 

오픈소스 | 버전 | 라이선스 
JQuery | 2.2.4 | MIT
JQuery ICheck | 1.0.2 | MIT
JQuery metismenu | 2.7.1 | MIT
JQuery Slim Scroll | 1.3.8 | MIT, GPL
Pace  | 1.0.2 | 
Require JS  | 2.3.5 | MIT


Kendoui Core | | Apache LICENSE 2.0 
Bootstrap  | 3.3.7 | MIT
Summernote | 0.8.8 | MIT
Dropzone JS | | 


------
** PAGE API 

UI DATA
LAYOUT 
VISUALIZATION



/display/
/display/


/issues/
/boards/

------
** SERVER API 

/data/v1/boards/list.json
/data/v1/boards/create.json

/data/v1/boards/{boardId}/get.json
/data/v1/boards/{boardId}/threads/list.json
/data/v1/boards/{boardId}/threads/{threadId}/list.json
/data/v1/boards/{boardId}/threads/{threadId}/messages/{parentId}/list.json
/data/v1/boards/{boardId}/threads/{threadId}/messages/{parentId}/comments/add.json
/data/v1/boards/{boardId}/threads/{threadId}/messages/{parentId}/comments/list.json

/data/v1/messages/add.json
/data/v1/boards/{boardId}/messages/{messageId}/get.json
/data/v1/boards/{boardId}/messages/{messageId}/update.json
/data/v1/boards/{boardId}/messages/{messageId}/delete.json
/data/v1/boards/{boardId}/messages/{messageId}/attachments/list.json 
/data/v1/boards/{boardId}/messages/{messageId}/attachments/upload.json 




