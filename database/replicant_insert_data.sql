-- sequencer 

Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (1,'USER',2);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (2,'GROUP',1);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (3,'ROLE',4);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (5,'BOARD',1);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (6,'BOARD_THREAD',1);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (7,'BOARD_MESSAGE',1);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (8,'COMMENT',1);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (11,'IMAGE',1);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (10,'ATTACHMENT',1);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (14,'PAGE',10);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (15,'PAGE_BODY',10);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (18,'ISSUE',1);
Insert into REP_SEQUENCER (SEQUENCER_ID,NAME,VALUE) values (19,'PROJECT',1);

-- user 
Insert into REP_USER (USER_ID,USERNAME,PASSWORD_HASH,NAME,NAME_VISIBLE,FIRST_NAME,LAST_NAME,EMAIL,EMAIL_VISIBLE,USER_ENABLED,STATUS ) values (1,'king','$2a$10$Ly5hmDajddt0/NtE7PuiLuYLGm85mzcuIOiIogo9QznS7oJae4QWG','킹',0,null,null,'king@king.com',0,1,4 );

Insert into REP_USER_ROLES (USER_ID,ROLE_ID) values (1,1);

-- role 
 

Insert into REP_ROLE (ROLE_ID,NAME,DESCRIPTION ) values (1,'ROLE_ADMINISTRATOR','관리자 롤');
Insert into REP_ROLE (ROLE_ID,NAME,DESCRIPTION ) values (2,'ROLE_DEVELOPER','개발자 롤');
Insert into REP_ROLE (ROLE_ID,NAME,DESCRIPTION ) values (3,'ROLE_USER', '일반 사용자 롤');


-- page helpdesk...
 
Insert into REP_PAGE (PAGE_ID,OBJECT_TYPE,OBJECT_ID,NAME,VERSION_ID,USER_ID,READ_COUNT) values (1,-1,-1,'index.html',1,1,0 );
Insert into REP_PAGE (PAGE_ID,OBJECT_TYPE,OBJECT_ID,NAME,VERSION_ID,USER_ID,READ_COUNT) values (2,-1,-1,'privacy.html',1,1,0 );
Insert into REP_PAGE (PAGE_ID,OBJECT_TYPE,OBJECT_ID,NAME,VERSION_ID,USER_ID,READ_COUNT) values (3,-1,-1,'terms.html',1,1,0 );
Insert into REP_PAGE (PAGE_ID,OBJECT_TYPE,OBJECT_ID,NAME,VERSION_ID,USER_ID,READ_COUNT) values (4,-1,-1,'boards.html',1,1,0 );
Insert into REP_PAGE (PAGE_ID,OBJECT_TYPE,OBJECT_ID,NAME,VERSION_ID,USER_ID,READ_COUNT) values (5,-1,-1,'threads.html',1,1,0 );
Insert into REP_PAGE (PAGE_ID,OBJECT_TYPE,OBJECT_ID,NAME,VERSION_ID,USER_ID,READ_COUNT) values (6,-1,-1,'view-thread.html',1,1,0 );
Insert into REP_PAGE (PAGE_ID,OBJECT_TYPE,OBJECT_ID,NAME,VERSION_ID,USER_ID,READ_COUNT) values (7,-1,-1,'technical-support.html',1,1,0 );
Insert into REP_PAGE (PAGE_ID,OBJECT_TYPE,OBJECT_ID,NAME,VERSION_ID,USER_ID,READ_COUNT) values (8,-1,-1,'issues.html',1,1,0 );
Insert into REP_PAGE (PAGE_ID,OBJECT_TYPE,OBJECT_ID,NAME,VERSION_ID,USER_ID,READ_COUNT) values (9,-1,-1,'issue.html',1,1,0 );

Insert into REP_PAGE_BODY (BODY_ID,PAGE_ID,BODY_TYPE) values (1,1,3);
Insert into REP_PAGE_BODY (BODY_ID,PAGE_ID,BODY_TYPE) values (2,2,3);
Insert into REP_PAGE_BODY (BODY_ID,PAGE_ID,BODY_TYPE) values (3,3,3);
Insert into REP_PAGE_BODY (BODY_ID,PAGE_ID,BODY_TYPE) values (4,4,3);
Insert into REP_PAGE_BODY (BODY_ID,PAGE_ID,BODY_TYPE) values (5,5,3);
Insert into REP_PAGE_BODY (BODY_ID,PAGE_ID,BODY_TYPE) values (6,6,3);
Insert into REP_PAGE_BODY (BODY_ID,PAGE_ID,BODY_TYPE) values (7,7,3);
Insert into REP_PAGE_BODY (BODY_ID,PAGE_ID,BODY_TYPE) values (8,8,3);
Insert into REP_PAGE_BODY (BODY_ID,PAGE_ID,BODY_TYPE) values (9,9,3);