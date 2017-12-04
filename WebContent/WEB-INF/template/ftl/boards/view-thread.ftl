<#ftl encoding="UTF-8"/>
<#assign user = SecurityHelper.getUser() />	
<#compress>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>${currentBoard.displayName}</title>
	<!-- Kendoui with bootstrap theme CSS -->			
	<link href="/css/kendo.ui.core/web/kendo.common-bootstrap.core.css" rel="stylesheet" type="text/css" />
	<link href="/css/kendo.ui.core/web/kendo.bootstrap.min.css" rel="stylesheet" type="text/css" />
	
	<!-- Bootstrap CSS -->
	<link href="/css/bootstrap/3.3.7/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<link href="/fonts/font-awesome.css" rel="stylesheet" type="text/css" />
	
	<!-- Bootstrap Unify Theme CSS -->
	<link href="/css/bootstrap.theme/inspinia/style.css" rel="stylesheet" type="text/css" />
	
    <!-- Community CSS -->
    <link href="/css/community.ui/community.ui.style.css" rel="stylesheet" type="text/css" />
    	
	<link href="/js/summernote/summernote.css" rel="stylesheet" type="text/css" />
	<link href="/css/animate/animate.css" rel="stylesheet" type="text/css" />
	
	<!-- Requirejs for js loading -->
	<script src="/js/require.js/2.3.5/require.js" type="text/javascript"></script>

	<!-- Application JavaScript
    ================================================== -->    
	<script>
	require.config({
		shim : {
	        "bootstrap" : { "deps" :['jquery'] },
	        "kendo.ui.core.min" : { "deps" :['jquery'] },
	        "kendo.culture.ko-KR.min" : { "deps" :['kendo.ui.core.min'] },
	        "community.ui.core" : { "deps" :['kendo.culture.ko-KR.min'] },
	        "community.data" : { "deps" :['community.ui.core'] },	        
	        "summernote-ko-KR" : { "deps" :['summernote.min'] }
	    },
		paths : {
			"jquery"    					: "/js/jquery/jquery-2.2.4.min",
			"bootstrap" 					: "/js/bootstrap/3.3.7/bootstrap.min",
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"community.ui.core" 			: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data",
			"summernote.min"             : "/js/summernote/summernote.min",
			"summernote-ko-KR"           : "/js/summernote/lang/summernote-ko-KR"		
		}
	});
	
	require([ "jquery", "kendo.ui.core.min",  "kendo.culture.ko-KR.min", "community.data", "community.ui.core", "bootstrap", "summernote.min", "summernote-ko-KR" ], function($, kendo ) {
		
		community.ui.setup({
		  	features : {
				accounts: true
		  	},
		  	'features.accounts.authenticate' :function(e){
		  		if( !e.token.anonymous ){
		  			observable.setUser(e.token);
		    		}
		  	}
		});
		
		
		// enable tooltip .
		$('[data-toggle="tooltip"]').tooltip();
		 
		var observable = new community.ui.observable({ 
			currentUser : new community.model.User(),
			board : new community.model.Board({ boardId : ${currentBoard.boardId}}),
			thread : new community.model.Thread({ threadId : ${currentThread.threadId} , rootMessage: {subject: '', body: ''}}),
			autherAvatarSrc : "/images/no-avatar.png",
			editalbe : false,
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
			},
			messageDataSource : community.ui.datasource('/data/api/v1/threads/${currentThread.threadId}/messages/list.json', {
				schema: {
					total: "totalCount",
					data : "items",
					mdoel: community.model.Message
				},
				pageSize : 10
			}),
			getThreadInfo : function ( handler ) {
				var $this = this;
				community.ui.ajax('/data/api/v1/threads/' + $this.get('thread.threadId') + '/info.json', {
					success: function(data){						
						if( handler != null && $.isFunction(handler) ){
							handler( data );
						}else{
							$this.set('thread', new community.model.Thread(data));
							$this.set('autherAvatarSrc', community.data.getUserProfileImage( $this.thread.rootMessage.user ) );
						}
					}
				});		
			}
    		});   
 
		community.ui.ajax('/data/api/v1/boards/' + observable.board.get('boardId') + '/info.json', {
			success: function(data){				
				observable.set('board', new community.model.Board(data) );			
				if(observable.board.readable)	
				{
			    		observable.getThreadInfo( function ( data ) {    		
			    			observable.set('thread', new community.model.Thread(data));
			    			observable.set('autherAvatarSrc', community.data.getUserProfileImage( observable.thread.rootMessage.user ) );
			    			createMessageListView(observable);
			    			if(observable.board.readComment){
			    				createMessageCommentListView(observable.thread.rootMessage);
			    			}
			    		});					
				}
			}
		});	
    				
		var renderTo = $('#page-wrapper');			
		renderTo.data('model', observable);
		community.ui.bind(renderTo, observable );				
								
		renderTo.on("click", "button[data-subject=message], a[data-subject=message]", function(e){			
			var $this = $(this);
			var actionType = $this.data("action");		
			var messageId = $this.data("object-id");			
 			var message = new community.model.Message(); 	 			
 			if( messageId === observable.thread.rootMessage.messageId ){
				message = observable.thread.rootMessage ;
			}else if ( messageId > 0 ) {
				message = observable.messageDataSource.get( messageId );
				if( message == null ){
					$.each( observable.messageDataSource.data() , function ( index, data ){
						if( data.messageId === messageId ){
							message = data ;
							return false;
						 }
					});
				}
			}	
			openMessageEditorModal( actionType , observable.board, message );			
			return false;		
		});			
		
		renderTo.on("click", "button[data-subject=comment], a[data-subject=comment]", function(e){		
			if( observable.board.createComment ) {		
				var $this = $(this);
				var actionType = $this.data("action");		
				var targetObject = $( $this.data("target") );			
				if( actionType === 'list'){
					var messageId = $this.data("message-id");
					var commentId = $this.data("comment-id");				
					createMessageChildCommentListView( targetObject, {messageId:messageId , commentId:commentId } );
				}else if ( actionType === 'create' ){									
					var messageId = $this.data("object-id");
					var parentCommentId = $this.data("parent-comment-id");
					//openMessageCommentModal( actionType , messageId , parentCommentId , targetObject );		
					openMessageCommentModal2( actionType , messageId , parentCommentId , targetObject );				
				}	
			}			
			return false;		
		});		
		
																						
																																																														
	});
	
	
	function isRootMessage( message ){		
		if( message != null && message.messageId === ${ currentThread.rootMessage.messageId} ){
			return true;
		}
		return false;
	}
	
	function getPageModel(){
		var renderTo = $('#page-wrapper');	
		return renderTo.data('model');
	}
	
	function isCommentEnabled(){
		if( getPageModel().board.createComment )
			return true;
		else 
			return false;	
	}
		
	function isAuthor(user){
		if( user.userId === getPageModel().currentUser.userId )
			return true;
		else 
			return false;	
	}
	
	function createMessageListView(model){	
		var renderTo = $('#message-listview');		
		var listview = community.ui.listview( renderTo , {
			dataSource: model.messageDataSource,
			template: community.ui.template($("#template").html())
		});			
		community.ui.pager( $("#message-listview-pager"), {
            dataSource: listview.dataSource
        });            
	}
	
	function createMessageChildCommentListView(renderTo, options){	
		renderTo.collapse('toggle');
		if( !community.ui.exists( renderTo ) ){
			var template = community.ui.template('/data/api/v1/threads/${currentThread.threadId}/messages/#: messageId #/comments/#: commentId #/list.json'); 
			var target_url = template(options);
			var listview = community.ui.listview( renderTo , {
				dataSource : community.ui.datasource(target_url, {
					schema: {
						total: "totalCount",
						data: "items"
					},
					pageSize : 10
				}),
				template: community.ui.template($("#comment-template").html())
			});	
		}else{
		
		}
		
	}
	
	function createMessageCommentListView( model, renderTo ){			
		renderTo = renderTo || $('#message-comment-listview');	
		var template = community.ui.template('/data/api/v1/threads/${currentThread.threadId}/messages/#= messageId #/comments/list.json'); 
		var target_url = template(model);	
		var listview = community.ui.listview( renderTo , {
			dataSource : community.ui.datasource(target_url, {
				schema: {
					total: "totalCount",
					data: "items"
				},
				pageSize : 10
			}),
			template: community.ui.template($("#comment-template").html())
		});	
		
	}

	function openMessageCommentModal2(actionType , messageId , parentCommentId, targetObject){	
		var renderTo = $('#message-comment-modal');
		if( !renderTo.data("model") ){
			var editorTenderTo = $('#editable-message-message-body');
			editorTenderTo.summernote({
				toolbar: [],
				placeholder: '댓글...',
				dialogsInBody: true,
				height: 100,
				lang: 'ko-KR'
			});
			var observable = new community.ui.observable({ 
				autherAvatarSrc :community.data.getUserProfileImage( getPageModel().currentUser ) ,
				text : "",
				email : "",
				name : "",
				threadId : ${currentThread.threadId},
				messageId : 0,				
				parentCommentId : 0,
				setMessage: function(data){
					var $this = this;
					$this.set( 'messageId', data.messageId );
					$this.set( 'parentCommentId', data.parentCommentId );
					$this.set( 'text', "" );
					$this.set( 'email', "" );
					$this.set( 'name', "" );					
					editorTenderTo.summernote('code', $this.get('text'));
				},
				save : function () {
					var $this = this;
					$this.set('text', editorTenderTo.summernote('code') );
				  	var template = community.ui.template("/data/api/v1/threads/#= threadId #/messages/#= messageId #/comments/add.json"); 
				  	var target_url = template($this);			  	
				  	community.ui.progress(renderTo, true);				
					community.ui.ajax( target_url , {
						data: community.ui.stringify({ data : { email:$this.get('email'), name:$this.get('name'), text:$this.get('text'), parentCommentId:$this.get('parentCommentId') } }),
						contentType : "application/json",
						success : function(response){
							community.ui.listview(targetObject).dataSource.read();
						}	
					}).always( function () {
							community.ui.progress(renderTo, false);
							renderTo.modal('hide');
					});				
				}
			});		
			renderTo.data("model", observable );
			community.ui.bind(renderTo, observable);		
			renderTo.on('show.bs.modal', function (e) {
			  			
			});
		}
		
		renderTo.data("model").setMessage( { 'messageId': messageId , 'parentCommentId': parentCommentId  });
		renderTo.modal('show');
	}
						
	function openMessageCommentModal(actionType , messageId , parentCommentId, targetObject){	
		var renderTo = $('#message-comment-modal');
		if( !renderTo.data("model") ){
			var observable = new community.ui.observable({ 
				autherAvatarSrc :community.data.getUserProfileImage( getPageModel().currentUser ) ,
				text : "",
				email : "",
				name : "",
				threadId : ${currentThread.threadId},
				messageId : 0,				
				parentCommentId : 0,
				save : function () {
					var $this = this;
				  	var template = community.ui.template("/data/api/v1/threads/#= threadId #/messages/#= messageId #/comments/add.json"); 
				  	var target_url = template($this);			  	
				  	community.ui.progress(renderTo, true);				
					community.ui.ajax( target_url , {
						data: community.ui.stringify({ data : { email:$this.get('email'), name:$this.get('name'), text:$this.get('text'), parentCommentId:$this.get('parentCommentId') } }),
						contentType : "application/json",
						success : function(response){
							community.ui.listview(targetObject).dataSource.read();
						}	
					}).always( function () {
							community.ui.progress(renderTo, false);
							renderTo.modal('hide');
					});				
				}
			});		
			renderTo.data("model", observable );
			community.ui.bind(renderTo, observable);		
			renderTo.on('show.bs.modal', function (e) {			  			
			});
		}
		
		renderTo.data("model").set( 'messageId', messageId );
		renderTo.data("model").set( 'parentCommentId', parentCommentId );
		renderTo.data("model").set( 'text', "" );
		renderTo.data("model").set( 'email', "" );
		renderTo.data("model").set( 'name', "" );
								
		renderTo.modal('show');
	}
	
	function openMessageEditorModal(actionType, board, message){
	
		var renderTo = $("#message-editor-modal");
		if( !renderTo.data("model") ){	
			var editorTenderTo = $('#editable-message-body');
			editorTenderTo.summernote({
				dialogsInBody: true,
				height: 300,
				lang: 'ko-KR'
			});
			var observable = new community.ui.observable({ 
				mode : 0,
				board : board,
				isNew : false,
				message : new community.model.Message(),
				parentMessageSubject : "",
				parentMessageBody : "",
				setMessage : function ( data ){
					var $this = this;
					$this.set('parentMessageSubject', '');
					$this.set('parentMessageBody', '');		
					$this.message.set('parentMessageId', data.parentMessageId );	
					$this.message.set('messageId', data.messageId );	
					$this.message.set('objectType', data.objectType );
					$this.message.set('objectId', data.objectId );
					$this.message.set('threadId', data.threadId );
					$this.message.set('subject',  data.subject );
					$this.message.set('body', data.body );					
					$this.set('isNew', false );
					editorTenderTo.summernote('code', $this.message.get('body'));
					
					if($this.get('mode') != 0)
					{
						$this.set('mode', 0);
						renderTo.find('.message-editor').show();
						renderTo.find('.message-attachments').hide();
						renderTo.find('.message-images').hide();		
					}
				},
				setParentMessage: function(data){
					var $this = this;
					$this.message.set('parentMessageId', data.messageId );
					$this.message.set('objectType', data.objectType );
					$this.message.set('objectId', data.objectId );
					$this.message.set('threadId', data.threadId );
					$this.message.set('subject', 'RE:' + data.subject );
					$this.message.set('body', '' );
					$this.set('parentMessageSubject', data.subject );
					$this.set('parentMessageBody', data.body );
					$this.set('isNew', true );			
					editorTenderTo.summernote('code', $this.message.get('body'));
				},
				showImageUploader : function (e){
					var $this = this;
					$this.set('mode', 1);
					renderTo.find('.message-editor').hide();
					renderTo.find('.message-images').show();				
				},
				showAttachmentUploader : function (e){
					var $this = this;
					$this.set('mode', 2);
					renderTo.find('.message-editor').hide();
					renderTo.find('.message-attachments').show();
				},
				hideUploader: function(e){
					var $this = this;
					if( $this.get('mode') === 1 ){
						renderTo.find('.message-images').hide();		
						renderTo.find('.message-editor').show();
						$this.set('mode', 0);
					}else if($this.get('mode') === 2 ){
						renderTo.find('.message-attachments').hide();
						renderTo.find('.message-editor').show();
						$this.set('mode', 0);
					}
				
				},			
				saveOrUpdate : function(e){
					var $this = this;
					community.ui.progress(renderTo, true);				
					$this.message.set('body', editorTenderTo.summernote('code') );	
					community.ui.ajax( '<@spring.url "/data/api/v1/messages/save-or-update.json" />', {
						data: community.ui.stringify($this.message),
						contentType : "application/json",
						success : function(response){
							if( isRootMessage($this.message) ){								
								getPageModel().getThreadInfo();								
							}else{
								getPageModel().messageDataSource.read();
								//community.ui.listview($('#message-listview')).dataSource.read();
							}
						}
					}).always( function () {
						community.ui.progress(renderTo, false);
						renderTo.modal('hide');
					});							
				}
			});
	    		
			renderTo.data("model", observable );
			community.ui.bind( renderTo, observable );		
			renderTo.on('show.bs.modal', function (e) {
			  	
			});
		}	
		
		//console.log( community.ui.stringify(message) );
		
		if( actionType === 'create'){
			renderTo.data("model").setParentMessage( message );
		} else if ( actionType === 'update' ){
			renderTo.data("model").setMessage( message );
		}		
		renderTo.modal('show');
	}
	
	</script>
    
</head>
<body class="top-navigation">
    <div id="wrapper">
        <div id="page-wrapper" class="gray-bg">
        		<div class="row border-bottom white-bg">
        		<!-- NAVBAR START -->     			
        		<#include "/common/inspinia-top-navbar-ftl">
        		<!-- NAVBAR END -->        		
        		<div class="wrapper wrapper-content">
            		<div class="container">            
                		<div class="row">
                    		<div class="col-lg-12">
                        		<div class="ibox bordered float-e-margins">
                            		<div class="ibox-title">
                                		<h5>${currentBoard.displayName}</h5>
									<div class="pull-right forum-desc">
										<samll>Total posts: <span data-bind="text:thread.messageCount"></span></samll>
									</div>                                		
                            		</div>
	                            <div class="ibox-content post">
	                              	<div class="media">
		                                <a class="forum-avatar" href="#">
		                                    <img data-bind="attr:{ src: autherAvatarSrc  }"  width="64" height="64" src="/images/no-avatar.png" class="Avatar" alt="image">
		                                    <div class="author-info">
		                                        <strong>Posts:</strong> 542<br>
		                                        <strong>Joined:</strong> April 11.2015<br>
		                                    </div>
		                                </a>
		                                <div class="media-body">
		                                    <h2 class="media-heading" data-bind="html: thread.rootMessage.subject" >${ currentThread.rootMessage.subject}</h2>
		                                    <div class="message-body" data-bind="html: thread.rootMessage.body">
		                                    ${ currentThread.rootMessage.body }
		                                    </div>
		                                    <!--
		                                    <div class="actions">
                                            		<a class="btn btn-xs btn-white"><i class="fa fa-thumbs-up"></i> Like </a>
                                                 <a class="btn btn-xs btn-white"><i class="fa fa-heart"></i> Love</a>
                                            </div>-->
		                                </div>		                                
		                            </div>	 
									<div class="text-right p-xs">
										<a href="/boards/${currentBoard.boardId}/list" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15">목록</a>
		                                 <button type="button" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" data-subject="message" data-bind="enabled: board.createThread" data-action="create" data-object-id="${ currentThread.rootMessage.messageId}" >새로운 글 게시하기</button> 		                                
		                                 <a href="#!" data-bind="enabled:board.createComment" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" data-subject="comment" data-object-id="${ currentThread.rootMessage.messageId}" data-target="#message-comment-listview" data-action="create" data-parent-comment-id="0" >
						                    <span class=""><i class="icon-bubble g-mr-3"></i>댓글쓰기</span>
						                 </a>
		                                 <#if currentThread.rootMessage.user.userId == user.userId >
		                                 <button type="button" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" data-subject="message" data-action="update" data-object-id="${ currentThread.rootMessage.messageId}" ><i class="fa fa-edit"></i> 수정</a> 
		                                 <button type="button" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15 disabled" data-subject="messages" data-action="delete" data-object-id="${ currentThread.rootMessage.messageId}" ><i class="fa fa-remove"></i> 삭제</a>
		                           		 </#if>
		                             </div>			                                     			                            					                                      			                            			          			                            					                                      			                            			          			                            			
	                            </div> 
		                          <div class="ibox-content comment" data-bind="visible:board.readComment" style="display:none;">                                        
		                            <!-- start of message comments -->
									<div class="row">
		                                <div class="col-lg-12">
		                                    <h2>댓글:</h2>		                                    
		                                    <div id="message-comment-listview" class="no-border" style="min-height:50px;"></div>
		                                    <a href="#!" data-bind="enabled:board.createComment" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15 pull-right" data-subject="comment" data-object-id="${ currentThread.rootMessage.messageId}" data-target="#message-comment-listview" data-action="create" data-parent-comment-id="0" >
						                    	<span class="">
						                      <i class="icon-bubble g-mr-3"></i>
						                      댓글쓰기
						                    </span>
						                  </a>
		                                </div>
		                            </div>		                                      			                            			          			                            			
		                            <!-- end of message comments -->      		                                                                                                                
	                            </div>
	                            <div class="ibox-content no-padding">
		                            <div id="message-listview" class="no-border" style="border-style:none; min-height: 150px;"></div>
	                            	</div>             
	                            <div class="ibox-footer">  
	                            		<div id="message-listview-pager" class="k-pager-wrap no-border"></div>
	                            </div>             
                        		</div>
                    		</div>
                		</div>
            		</div>
        		</div>
        		<!-- FOOTER START -->
	        <div class="footer">
	            <div class="pull-right">
	                10GB of <strong>250GB</strong> Free.
	            </div>
	            <div>
	                <strong>Copyright</strong> Example Company &copy; 2014-2017
	            </div>
	        </div>
	        <!-- FOOTER END -->
		</div>
	</div>
	
	
	<!-- message comment modal -->
	<div class="modal fade comment-composer" id="message-comment-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="colored-line"></div>
				<div class="modal-header no-padding">
					<!--<h4 class="modal-title">Modal title</h4>-->
					<div class="social-avatar">
		            		<a href="javascript:void(0);" class="pull-left">
		                		<img alt="image" src="/images/no-avatar.png" data-bind="attr:{ src: autherAvatarSrc }" >
		                </a>
		                <!--
		                <div class="media-body">
		                		<a href="#">Andrew Williams</a>
		                     <small class="text-muted">Today 4:21 pm - 12.06.2014</small>
		                </div>
		                -->
		            </div>
				</div>
				<div class="modal-body no-padding">
					<div class="text-editor">
			           <!-- <textarea class="form-control" placeholder="내용" data-bind="value:text"></textarea>	-->		            
			            <div id="editable-message-message-body" contenteditable="true" ></div>	   	            
				    </div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" data-bind="{click:save}">확인</button>
				</div>
			</div>
		</div>
	</div>
		
	<!-- message editor modal -->
	<div class="modal fade" id="message-editor-modal" tabindex="-1" role="dialog" aria-labelledby="message-editor-modal-labal" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">	
				<div class="message-editor">		
		      	<div class="modal-header">
			        <!-- <h5 class="modal-title" id="message-editor-modal-labal">New message</h5> -->
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
			        </button>
		      	</div><!-- /.modal-content -->
		      	
		      	<div class="modal-body">
			        <form>
			        	 <h5 class="text-info" data-bind="visible:isNew" ><span data-bind="text:parentMessageSubject" ></span> <span class="text-muted">에 대한 답글</span></h5>	        	 	        	  
			          <div class="form-group">
			            <input type="text" class="form-control" placeholder="제목" data-bind="value: message.subject">
			          </div>
			          <div id="editable-message-body" contenteditable="true" data-placeholder="내용"></div>	   
			          <div class="p-sm" data-bind="invisible:isNew">
			          	
			          	<span class="text-danger">이미지를 업로드하여 이미지 갤러리를 만들거나 첨부파일을 업로드 할 수 있습니다.</span>
			          	
			          	<button type="button" class="btn btn-outline btn-xs icon-svg-btn m-n" data-toggle="tooltip" data-placement="bottom" title="첨부파일 업로드" data-bind="enabled:board.createAttachement, click:showAttachmentUploader "><i class="icon-svg icon-svg-sm icon-svg-dusk-upload"></i></button>
			          	<button type="button" class="btn btn-outline btn-xs icon-svg-btn m-n" data-toggle="tooltip" data-placement="bottom" title="이미지 업로드"  data-bind="enabled:board.createImage, click:showImageUploader"><i class="icon-svg icon-svg-sm icon-svg-dusk-gallery"></i></button>
			          </div>
			        </form>			        
		      	</div><!-- /.modal-body -->
		      	<div class="modal-footer">
			        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
			        <button type="button" class="btn btn-primary" data-bind="{ click: saveOrUpdate }">확인</button>
		      	</div><!-- /.modal-footer -->
		      	</div>
		      	
	    			<div class="message-attachments" style="display:none;">
		    			<div class="modal-header">
				        <button type="button" class="close" data-bind="click:hideUploader">
				          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close-pane m-t-xs"></i>
				        </button>
			      	</div><!-- /.modal-content -->
		    			<div class="modal-body">
		    			파일 업로드 ...
		    			</div>
	    			</div>
	    			<div class="message-images"  style="display:none;">
		    			<div class="modal-header">
				        <button type="button" class="close" data-bind="click:hideUploader">
				          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close-pane m-t-xs"></i>
				        </button>
			      	</div><!-- /.modal-content -->	    			
					<div class="modal-body">
					이미지 업로드 ..
		    			</div>	    			
	    			</div>	    			
	    		</div><!-- /.modal-content -->	    		
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->	

	<script type="text/x-kendo-template" id="comment-template">
	<div class="social-talk p-xxs">
		<div class="media social-profile clearfix">
			<a class="pull-left">
				<img src="#= community.data.getUserProfileImage( user ) #" alt="profile-picture">
			</a>
			<div class="media-body">
				<span class="font-bold">#= community.data.getUserDisplayName( user ) #</span>
				<small class="text-muted">#: kendo.toString( new Date(creationDate), "g") #</small>
				<div class="social-content">
              	#= body #	
				</div>
				<div class="m-t-xs">
					<button class="btn btn-sm u-btn u-btn-outline-blue u-btn-outline u-btn-3d" type="button" data-subject="comment" data-action="list" data-message-id="#:objectId#" data-comment-id="#:commentId#" data-target="\\#message-#:objectId#-comment-#:commentId#-listview" aria-expanded="false" aria-controls="message-#:objectId#-comment-#:commentId#-listview"> <i class="icon-bubbles"></i> 댓글 (<span>#: replyCount #</span>)</button>
					# if (isCommentEnabled()) {#
					<button class="btn btn-sm u-btn u-btn-outline-blue u-btn-outline u-btn-3d" type="button" data-subject="comment" data-action="create" data-object-id="#: objectId #" data-parent-comment-id="#: commentId#" ><i class="icon-bubble"></i> 댓글쓰기</button>	
					# } #	
				</div>		
				<div class="collapse no-border comment-reply" id="message-#:objectId#-comment-#:commentId#-listview"></div>		
			</div>
		</div>
	</div>	
	</script>
     <script type="text/x-kendo-template" id="comment2-template">
	 <div class="social-feed-box">
		                                        <div class="social-avatar">
		                                            <a href="" class="pull-left">
		                                                <img alt="image" src="#= community.data.getUserProfileImage( user ) #">
		                                            </a>
		                                            <div class="media-body">
		                                                <a href="javascript:void(0);">
		                                                   #:  community.data.getUserDisplayName( user ) #
		                                                </a>
		                                                <small class="text-muted">#: kendo.toString( new Date(creationDate), "g") # - #: ipaddress #</small>
		                                            </div>
		                                        </div>
		<div class="social-body">
		 #: body #
		</div>                        
		<!--
								                    <ul class="list-inline my-0">
								                      <li class="list-inline-item g-mr-20">
								                        <a class="g-color-gray-dark-v5 g-text-underline--none--hover" href="\\#">
								                          <i class="icon-like g-pos-rel g-top-1 g-mr-3"></i> 214
								                        </a>
								                      </li>
								                      <li class="list-inline-item g-mr-20">
								                        <a class="g-color-gray-dark-v5 g-text-underline--none--hover" href="\\#">
								                          <i class="icon-dislike g-pos-rel g-top-1 g-mr-3"></i> 35
								                        </a>
								                      </li>
								                      <li class="list-inline-item g-mr-20">
								                        <a class="g-color-gray-dark-v5 g-text-underline--none--hover" href="\\#">
								                          <i class="icon-share g-pos-rel g-top-1 g-mr-3"></i> 52
								                        </a>
								                      </li>
								                    </ul>
								                    -->
		                                       
	</div>
    </script>  
               	
	<script type="text/x-kendo-template" id="template">
	<div class="media post">
		<a class="forum-avatar" href="javascript:void(0);">
			<img src="#= community.data.getUserProfileImage( user ) #" class="Avatar" alt="image">
			<div class="author-info">
				<!--<strong>Posts:</strong> 542<br>
				<strong>Joined:</strong> April 11.2015<br>
				-->
			</div>
		</a>		                                		
		<div class="media-body">		
		<h4 class="media-heading text-muted">#: subject #</h4>
		#= community.data.getUserDisplayName( user )  # , #= kendo.toString( new Date(creationDate), "g") #	| #= kendo.toString( new Date(modifiedDate), "g") #		
		<div class="message-body">
		#= body #
		</div>
			<div class="actions">
				<!--
				<ul class="list-inline my-0">
					<li class="list-inline-item g-mr-20">
						<a class="g-color-gray-dark-v5 g-text-underline--none--hover" href="\\#">
							<i class="icon-like g-pos-rel g-top-1 g-mr-3"></i> 214
						</a>
					</li>
					<li class="list-inline-item g-mr-20">
						<a class="g-color-gray-dark-v5 g-text-underline--none--hover" href="\\#">
							<i class="icon-dislike g-pos-rel g-top-1 g-mr-3"></i> 35
						</a>
					</li>
					<li class="list-inline-item g-mr-20">
						<a class="g-color-gray-dark-v5 g-text-underline--none--hover" href="\\#">
							<i class="icon-share g-pos-rel g-top-1 g-mr-3"></i> 52
						</a>
					</li>
				</ul>
				-->
				# if (isAuthor(user)) { #
				<div class="btn-group btn-md">
					<a class="btn u-btn-outline-darkgray" data-subject="message" data-action="update" data-object-id="#=messageId#">수정</a>
					<a class="btn u-btn-outline-darkgray" disabled data-object-id="#=messageId#">삭제</a>				
				</div>			 
				# } #                   			
			</div>
		</div>
    </div>
    </script>  	
</body>
</html>
</#compress>