<#ftl encoding="UTF-8"/>
<#assign user = SecurityHelper.getUser() />	
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title></title>
	<!-- Bootstrap core CSS -->
	<link href="/fonts/font-awesome.css" rel="stylesheet" type="text/css" />
	<link href="/fonts/simple-line-icons.css" rel="stylesheet" type="text/css" />
	<!--<link href="/css/bootstrap/3.3.7/bootstrap-theme.min.css" rel="stylesheet" type="text/css" />-->
	<link href="/css/bootstrap/3.3.7/bootstrap.min.css" rel="stylesheet" type="text/css" />
	
	<!--
	<link href="/css/bootstrap/4.0.0-alpha.6/bootstrap.min.css" rel="stylesheet" type="text/css" />
	-->	
	
	<link href="/css/bootstrap.theme/unify/unify-glogals.css" rel="stylesheet" type="text/css" />
	<link href="/css/bootstrap.theme/inspinia/style.css" rel="stylesheet" type="text/css" />
	
	<link href="/css/kendo.ui.core/web/kendo.common-bootstrap.core.css" rel="stylesheet" type="text/css" />
	<link href="/css/kendo.ui.core/web/kendo.bootstrap.min.css" rel="stylesheet" type="text/css" />
	
	<link href="/js/summernote/summernote.css" rel="stylesheet" type="text/css" />
	
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
			"community.ui.core" 			: "/js/community/community.ui.core",
			"community.data" 			: "/js/community/community.data",
			"summernote.min"             : "/js/summernote/summernote.min",
			"summernote-ko-KR"           : "/js/summernote/lang/summernote-ko-KR"		
		}
	});
	
	require([ "jquery", "kendo.ui.core.min",  "kendo.culture.ko-KR.min", "community.data", "community.ui.core", "bootstrap", "summernote.min", "summernote-ko-KR" ], function($, kendo ) {
		console.log("hello");
		
		community.ui.culture("ko-KR");
		var observable = new community.ui.observable({ 
			thread : new community.model.Thread({ threadId : ${currentThread.threadId} , rootMessage: {subject: '', body: ''}}),
			totalMessage : 0,
			messageDataSource : community.ui.datasource('/data/v1/threads/${currentThread.threadId}/messages/list.json', {
				schema: {
					total: "totalCount",
					data: "items",
					mdoel: community.model.Message
				},
				pageSize : 10
			}),
			getThreadInfo : function ( handler ) {
				var $this = this;
				community.ui.ajax('/data/v1/threads/' + $this.get('thread.threadId') + '/info.json', {
					success: function(data){						
						if( handler != null && $.isFunction(handler) ){
							handler( data );
						}else{
							$this.set('thread', new community.model.Thread(data));
						}
					}
				});		
			}
    		});   
    		
    		observable.getThreadInfo( function ( data ) {
    			observable.set('thread', new community.model.Thread(data));
			createMessageListView(observable);
    		});
    				
		var renderTo = $('#page-wrapper');			
		renderTo.data('model', observable);
		community.ui.bind(renderTo, observable );
								
		renderTo.on("click", "button[data-target=message], a[data-target=message]", function(e){			
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
			openMessageEditorModal( actionType , message );			
			return false;		
		});													
	});
	
	
	function isRootMessage( message ){		
		if( message != null && message.messageId === ${ currentThread.rootMessage.messageId} ){
			return true;
		}
		return false;
	}
	
	function getThreadModel(){
		var renderTo = $('#page-wrapper');	
		return renderTo.data('model');
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
	
	function openMessageEditorModal(actionType, message){
	
		var renderTo = $("#message-editor-modal");
		if( !renderTo.data("model") ){	
			var editorTenderTo = $('#editable-message-body');
			editorTenderTo.summernote({
				dialogsInBody: true,
				height: 300
			});
			var observable = new community.ui.observable({ 
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
					console.log( community.ui.stringify( $this.message ) );
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
				saveOrUpdate : function(e){
					var $this = this;
					community.ui.progress(renderTo, true);				
					$this.message.set('body', editorTenderTo.summernote('code') );	
					community.ui.ajax( '<@spring.url "/data/v1/messages/save-or-update.json" />', {
						data: community.ui.stringify($this.message),
						contentType : "application/json",
						success : function(response){
							if( isRootMessage($this.message) ){								
								getThreadModel().getThreadInfo();								
							}else{
								getThreadModel().messageDataSource.read();
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
		
		console.log( community.ui.stringify(message) );
		
		if( actionType === 'post'){
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
		                                    <img src="https://discuss.flarum.org/assets/avatars/yzejjqriqrwntpab.jpg" class="Avatar" alt="image">
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
		                                    <div class="actions">
                                            		<a class="btn btn-xs btn-white"><i class="fa fa-thumbs-up"></i> Like </a>
                                                 <a class="btn btn-xs btn-white"><i class="fa fa-heart"></i> Love</a>
                                            </div>
		                                </div>
		                            </div>
		                         	<div class="ibox-tools">
		                                 <a href="/boards/${boardId}/list" class="btn btn-default btn-flat" >목록</a> 
		                                 <button type="button" class="btn btn-primary btn-flat" data-target="message" data-action="post" data-object-id="${ currentThread.rootMessage.messageId}" >새로운 글 게시하기</button> 		                                
		                                 <button type="button" class="btn btn-default btn-flat" data-target="message" data-action="update" data-object-id="${ currentThread.rootMessage.messageId}" ><i class="fa fa-edit"></i> 수정</a> 
		                                 <button type="button" class="btn btn-default btn-flat" data-target="message" data-action="remove" data-object-id="${ currentThread.rootMessage.messageId}" ><i class="fa fa-remove"></i> 삭제</a>
		                            </div>
		                            <!-- start of message comments -->
									<div class="row">
		                                <div class="col-lg-12">
		                                    <h2>뎃글:</h2>
		                                    <div class="social-feed-box">
		                                        <div class="social-avatar">
		                                            <a href="" class="pull-left">
		                                                <img alt="image" src="/images/no-avatar.png">
		                                            </a>
		                                            <div class="media-body">
		                                                <a href="#">
		                                                    Andrew Williams
		                                                </a>
		                                                <small class="text-muted">Today 4:21 pm - 12.06.2014</small>
		                                            </div>
		                                        </div>
		                                        <div class="social-body">
		                                            <p>
		                                                Many desktop publishing packages and web page editors now use Lorem Ipsum as their
		                                                default model text, and a search for 'lorem ipsum' will uncover many web sites still
		                                                default model text.
		                                            </p>		                                            
								                    <ul class="list-inline my-0">
								                      <li class="list-inline-item g-mr-20">
								                        <a class="g-color-gray-dark-v5 g-text-underline--none--hover" href="#">
								                          <i class="icon-like g-pos-rel g-top-1 g-mr-3"></i> 214
								                        </a>
								                      </li>
								                      <li class="list-inline-item g-mr-20">
								                        <a class="g-color-gray-dark-v5 g-text-underline--none--hover" href="#">
								                          <i class="icon-dislike g-pos-rel g-top-1 g-mr-3"></i> 35
								                        </a>
								                      </li>
								                      <li class="list-inline-item g-mr-20">
								                        <a class="g-color-gray-dark-v5 g-text-underline--none--hover" href="#">
								                          <i class="icon-share g-pos-rel g-top-1 g-mr-3"></i> 52
								                        </a>
								                      </li>
								                    </ul>
		                                        </div>
		                                    </div>		                                   
		                                </div>
		                            </div>		                                      			                            			          			                            			
		                            <!-- end of message comments -->          			                            			          			                            					                                      			                            			          			                            					                                      			                            			          			                            			
	                            </div>
	                            <div class="ibox-content no-padding">
		                            <div id="message-listview" class="no-border" style="border-style:none;"></div>
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

	<div class="modal fade" id="message-editor-modal" tabindex="-1" role="dialog" aria-labelledby="message-editor-modal-labal" aria-hidden="true">
	  <div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <!-- <h5 class="modal-title" id="message-editor-modal-labal">New message</h5> -->
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <form>
	        	 <h5 class="text-info" data-bind="visible:isNew" ><span data-bind="text:parentMessageSubject" ></span> <span class="text-muted">에 대한 답글</span></h5>	        	 	        	  
	          <div class="form-group">
	            <input type="text" class="form-control" placeholder="제목" data-bind="value: message.subject">
	          </div>
	          <!--
	          <div class="form-group">
	            <textarea class="form-control" placeholder="내용" data-bind="value: message.body"></textarea>	            
	                     
	            </div>
	          </div>
	          -->
	          <div id="editable-message-body" contenteditable="true" data-placeholder="내용">	   
	        </form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	        <button type="button" class="btn btn-primary" data-bind="{ click: saveOrUpdate }">확인</button>
	      </div>
	    </div>
	  </div>
	</div>		
	
	<script type="text/x-kendo-template" id="template">
	<div class="media post">
		<a class="forum-avatar" href="\\#">
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
				<div class="btn-group btn-xs">
					<a class="btn btn-xs btn-danger btn-outline" data-target="message" data-action="update" data-object-id="#=messageId#">수정</a>
					<a class="btn btn-xs btn-danger btn-outline" data-target="message" data-action="delete" data-object-id="#=messageId#">삭제</a>				
				</div>			                    			
			</div>
		</div>
    </div>
    </script>  	
</body>
</html>
