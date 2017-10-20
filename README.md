# architecture-community

오픈소스 게시판 ... 

How to install and start 

1. creat tables using database/create_table_oracle.sql

2. setting database connection in WEB-INF/startup-config.xml

3. build project using maven.

4. deploy WebContent as web application .


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




