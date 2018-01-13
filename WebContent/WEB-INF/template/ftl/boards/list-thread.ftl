<#ftl encoding="UTF-8"/>
<#compress>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title><#if __page?? >${__page.title}</#if></title>
	<!-- Kendoui with bootstrap theme CSS -->			
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.common.core.min.css"/>" rel="stylesheet" type="text/css" />
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.bootstrap.min.css"/>" rel="stylesheet" type="text/css" />
	    
	<!-- Bootstrap core CSS -->
	<link href="<@spring.url "/css/bootstrap/3.3.7/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />
	<link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />
	
	<!-- Bootstrap Theme CSS -->
	<link href="<@spring.url "/css/bootstrap.theme/inspinia/style.css"/>" rel="stylesheet" type="text/css" />
	<link href="<@spring.url "/css/bootstrap.theme/inspinia/custom.css"/>" rel="stylesheet" type="text/css" />	
	
	<!-- Community CSS -->
	<link href="<@spring.url "/css/community.ui/community.ui.globals.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/community.ui/community.ui.components.min.css"/>" rel="stylesheet" type="text/css" />
  	<link href="<@spring.url "/css/community.ui/community.ui.style.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/js/summernote/summernote.css"/>" rel="stylesheet" type="text/css" />
	<link href="<@spring.url "/css/animate/animate.css"/>" rel="stylesheet" type="text/css" />
	
	
	<script data-pace-options='{ "ajax": false }' src='<@spring.url "/js/pace/pace.min.js"/>'></script> 
	<!-- Requirejs for js loading -->
	<script src="<@spring.url "/js/require.js/2.3.5/require.js"/>" type="text/javascript"></script>

	<!-- Application JavaScript
    ================================================== -->    
	<script>
	
	var __boardId = <#if RequestParameters.boardId?? >${RequestParameters.boardId}<#else>0</#if>;
	
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
		
		console.log("welcome !!!");
		
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

		// Topnav animation feature
 		var cbpAnimatedHeader = (function() {
        		var docElem = document.documentElement, header = document.querySelector( '.navbar-default' ), didScroll = false, changeHeaderOn = 200;
        		function init() {
            		window.addEventListener( 'scroll', function( event ) {
	                if( !didScroll ) {
	                    didScroll = true;
	                    setTimeout( scrollPage, 250 );
	                }
            		}, false );
        		}
        		function scrollPage() {
            		var sy = scrollY();
	            if ( sy >= changeHeaderOn ) {
	                $(header).addClass('navbar-scroll')
	            }
	            else {
	                $(header).removeClass('navbar-scroll')
	            }
            		didScroll = false;
        		}
	        function scrollY() {
	            return window.pageYOffset || docElem.scrollTop;
	        }
        		init();
		})();
		
		var renderTo = $('#board-listview');
		
		var observable = new community.ui.observable({ 
			currentUser : new community.model.User(),
			board : new community.model.Board(),
			boardId : __boardId,
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
			},
			write : openThreadEditorModal
    		});     
    				
		community.ui.ajax('/data/api/v1/boards/' + observable.get('boardId') + '/info.json', {
			success: function(data){				
				observable.set('board', new community.model.Board(data) );			
				if(observable.board.readable)	
					createThreadListView(renderTo, observable);
			}
		});				
		community.ui.bind($('#page-top'), observable );			
	});	

	function createThreadListView(renderTo, observable){
		community.ui.listview( renderTo , {
			dataSource: community.ui.datasource('<@spring.url "/data/api/v1/boards/"/>'+ observable.get('boardId') +'/threads/list.json', {
				schema: {
					total: "totalCount",
					data: "items",
					model: community.model.Thread
				}
			}),
			template: community.ui.template($("#template").html())
		});	
	}	
	
	function openThreadEditorModal(){ 		
		var renderTo = $('#message-editor-modal');
		if( !renderTo.data("model") ){
			var editorTenderTo = $('#editable-message-body');
			editorTenderTo.summernote({
				placeholder: '내용',
				dialogsInBody: true,
				height: 300
			});
			var observable = new community.ui.observable({ 
				isNew : false,
				message : new community.model.Message(),
				setMessage : function (){
					var $this = this;	
					$this.message.set('parentMessageId', -1 );	
					$this.message.set('messageId', -1 );	
					$this.message.set('objectType', 5 );
					$this.message.set('objectId', __boardId);
					$this.message.set('threadId', -1 );
					$this.message.set('subject',  '' );
					$this.message.set('body', '' );					
					$this.set('isNew', true );
					editorTenderTo.summernote('code', $this.message.get('body'));
				},
				saveOrUpdate : function(e){				
					var $this = this;
					community.ui.progress(renderTo, true);				
					$this.message.set('body', editorTenderTo.summernote('code') );	
					community.ui.ajax( '<@spring.url "/data/api/v1/messages/save-or-update.json" />', {
						data: community.ui.stringify($this.message),
						contentType : "application/json",
						success : function(response){
							community.ui.listview( $('#board-listview') ).dataSource.read();
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
		renderTo.data("model").setMessage();
		renderTo.modal('show');
	}	
	</script> 
  </head>
  <body id="page-top" class="landing-page no-skin-config">
	<!-- NAVBAR START -->   
	<#include "/includes/user-top-navbar.ftl">
	<!-- NAVBAR END -->   
	
	<section class="u-bg-overlay g-bg-cover g-bg-size-cover g-bg-bluegray-opacity-0_3--after" style="background: url(/images/bg/BladeRunner-car-1920x1080.jpg)">      
      <div class="container text-center g-bg-cover__inner g-py-150">
        <div class="row justify-content-center">
          <div class="col-lg-6">
            <div class="mb-5">
              <h1 class="g-color-white g-font-size-60 mb-4"><span data-bind="text:board.displayName"></span></h1>
              <h2 class="g-color-white g-font-weight-300 g-font-size-20 mb-0"><span data-bind="text:board.description"></span></h2>
            </div>
            <!-- Promo Blocks - Input -->
            
            <!-- End Promo Blocks - Input -->
          </div>
        </div>
      </div>
    </section>

	<section id="features" class="container services">
		<div class="wrapper wrapper-content">
            		<div class="container">            
                		<div class="row">
                    		<div class="col-lg-12">
                        		<div class="ibox float-e-margins">
                            		<div class="ibox-title">
                                		<h5 data-bind="text:board.displayName"></h5>
									<div class="pull-right forum-desc">
										<samll>Total posts: <span data-bind="text:board.totalMessage"></span></samll>
									</div>                                		
                            		</div>
								<div class="ibox-content ibox-heading">
                                    <h3>You have meeting today!</h3>
                                    <small><i class="fa fa-map-marker"></i> Meeting is on 6:00am. Check your schedule to see detail.</small>
                                    <div class="ibox-tools">
		                                <button type="button" class="btn btn-primary g-mr-20" data-bind="{ enabled: board.createThread, click:write ">새로운 글 게시하기</button>
		                            </div>
                                </div>                            		
	                            <div class="ibox-content">
									<div id="board-listview" class="no-border" style="border-style:none; min-height:150px;"></div>
	                            </div>
                        		</div>
                    		</div>
                		</div>
            		</div>
        		</div>
	</section>
	
	<!-- message editor modal -->
	<div class="modal fade" id="message-editor-modal" tabindex="-1" role="dialog" aria-labelledby="message-editor-modal-labal" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
		      	<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<span aria-hidden="true">&times;</span>
			        </button>
		      	</div><!-- /.modal-content -->
		      	<div class="modal-body">
			        <form>
			        	 <h5 class="text-info"><span class="text-muted">새로운 글쓰기</span></h5>	        	 	        	  
			          <div class="form-group">
			            <input type="text" class="form-control" placeholder="제목" data-bind="value: message.subject">
			          </div>
			          <div id="editable-message-body" contenteditable="true" data-placeholder="내용"></div>	   
			        </form>
		      	</div><!-- /.modal-body -->
		      	<div class="modal-footer">
			        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
			        <button type="button" class="btn btn-primary" data-bind="{ click: saveOrUpdate }">확인</button>
		      	</div><!-- /.modal-footer -->
	    		</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->	
	<!-- FOOTER START -->   
	<#include "/includes/user-footer.ftl">
	<!-- FOOTER END -->  		
	<script type="text/x-kendo-template" id="template">
			<div class="forum-item">
				<div class="row">
					<div class="col-md-9">
						<div class="forum-icon">
							<a class="forum-avatar small" href="\\#"><img src="#= community.data.getUserProfileImage( rootMessage.user ) #" class="Avatar" alt="image"></a>
						</div>
						<a href="/display/pages/view-thread.html?threadId=#=threadId#" class="forum-item-title">#: rootMessage.subject #</a>
						<ul class="forum-list-item-info">
                            <li class="p-xs"><i class="icon fa fa-reply small"></i>  
                            #: latestMessage.subject #
                            <div class="u-avatar u-avatar-xs m-t-xs">
                                 <a href="\#">
                                     <img src="#= community.data.getUserProfileImage( latestMessage.user ) #" class="Avatar" alt="image">
                                     <span>#= community.data.getUserDisplayName( latestMessage.user ) #</span>
                                     <span class="date">#= community.data.getFormattedDate(latestMessage.modifiedDate) #</span>
                                </a>
                            </div>                            
                            </li>
                            <li>
	                            <button class="btn btn-default btn-xs btn-outline" type="button" data-toggle="collapse" data-target="\\#last-message-for-#:threadId#" aria-expanded="false" aria-controls="last-message-for-#:threadId#">
	                            최근글 내용보기 <i class="icon-arrow-down icons"></i>
	                            </button>
	                            <div class="collapse" id="last-message-for-#:threadId#">
		                            <div class="panel panel-default">
		                              <div class="panel-body message-body">
		                              #= latestMessage.body #
		                              </div>
		                            </div>
	                            </div>        
                            </li>          
                        </ul>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> #: viewCount # </span>
						<div>
							<small>Views</small>
						</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> #: messageCount  # </span>
						<div>
							<small>Posts</small>
						</div>
					</div>
				</div>
			</div>
    </script>   
</body>
</html>
</#compress>
