<#ftl encoding="UTF-8"/>
<#compress>
<!DOCTYPE html>
<html>
<head>
	<title>${ CommunityContextHelper.getConfigService().getApplicationProperty("website.title", "REPLICANT") } - <#if __page?? >${__page.title}</#if></title>
	<!-- Required Meta Tags Always Come First -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="x-ua-compatible" content="ie=edge">
 	
 	<!-- Kendoui with bootstrap theme CSS -->			 
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.common.core.min.css"/>" rel="stylesheet" type="text/css" />
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.common-bootstrap.core.min.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	 
	
	<!-- Bootstrap core CSS -->
   	<link href="<@spring.url "/css/bootstrap/4.0.0/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	
   	
   	<!-- Fonts & Icons CSS -->
	<link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/fonts/nanumgothic.min.css"/>" rel="stylesheet" type="text/css" />		
	<link href="<@spring.url "/css/community.ui/community.ui.icons.min.css"/>" rel="stylesheet" type="text/css" />	
			
	<!-- Dzsparallaxer CSS -->
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/dzsparallaxer.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/dzsscroller/scroller.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/advancedscroller/plugin.css"/>" rel="stylesheet" type="text/css" />	
			
			
	<!-- CSS Bootstrap Theme Unify -->		    
    <link href="<@spring.url "/css/bootstrap.theme/unify/vendor/icon-hs/style.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/css/bootstrap.theme/unify/vendor/hs-megamenu/hs.megamenu.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/css/bootstrap.theme/unify/vendor/hamburgers/hamburgers.min.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/css/bootstrap.theme/unify/vendor/icon-line/simple-line-icons.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/css/bootstrap.theme/unify/vendor/icon-line-pro/style.css"/>" rel="stylesheet" type="text/css" />			 
	
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-core.css"/>">
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-components.css"/>">
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-globals.css"/>">
	
	
  	<link href="<@spring.url "/js/summernote/summernote-bs4.css"/>" rel="stylesheet" type="text/css" />
  	
	<link rel="stylesheet" href="<@spring.url "/css/community.ui/community.ui.style_v2.css"/>">

	
	  	  	
  	<!-- Page landing js -->	   	
	<script data-pace-options='{ "ajax": false }' src='<@spring.url "/js/pace/pace.min.js"/>'></script>   	
	
	<!-- Requirejs for js loading -->
	<script src="<@spring.url "/js/require.js/2.3.5/require.js"/>" type="text/javascript"></script>
	<!-- Application JavaScript
    		================================================== -->    
	<script>
	
	var __boardId = <#if RequestParameters.boardId?? >${RequestParameters.boardId}<#else>0</#if>;
	var __threadId = <#if RequestParameters.threadId?? >${RequestParameters.threadId}<#else>0</#if>;
	var __messageId = <#if RequestParameters.messageId?? >${RequestParameters.messageId}<#else>0</#if>;
	
	require.config({
		shim : {
			"bootstrap" : { "deps" :['jquery'] },
			<!-- kendo -->
			"kendo.ui.core.min" : { "deps" :['jquery'] },
	        "kendo.culture.ko-KR.min" : { "deps" :[ 'jquery', 'kendo.ui.core.min'] },
	        "community.ui.core" : { "deps" :['jquery', 'kendo.ui.core.min'] },
	        "community.data" : { "deps" :['jquery', 'kendo.ui.core.min','community.ui.core'] },	 
	        "summernote-ko-KR" : { "deps" :['summernote.min'] },
			"hs.core" : { "deps" :['jquery', 'bootstrap'] },
			"hs.header" : { "deps" :['jquery', 'hs.core'] },
			"hs.hamburgers" : { "deps" :['jquery', 'hs.core'] },
	        "dzsparallaxer" : { "deps" :['jquery'] },
	        "dzsparallaxer.dzsscroller" : { "deps" :['jquery', 'dzsparallaxer' ] },
			"dzsparallaxer.advancedscroller" : { "deps" :['jquery', 'dzsparallaxer' ] }
	    },
		paths : {
			"jquery"    					: "/js/jquery/jquery-3.1.1.min",
			"bootstrap" 					: "/js/bootstrap/4.0.0/bootstrap.bundle.min",
			<!-- kendo -->
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"		: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"community.ui.core" 			: "/js/community.ui/community.ui.core",
			"community.data" 				: "/js/community.ui/community.data",
			<!-- summernote -->
			"summernote.min"             : "/js/summernote/summernote-bs4.min",
			"summernote-ko-KR"           : "/js/summernote/lang/summernote-ko-KR"	,
			"dropzone"					: "/js/dropzone/dropzone",
			<!-- unify -->
	    	"hs.core" 	   					: "/js/bootstrap.theme/unify/hs.core",
			"hs.header" 	   				: "/js/bootstrap.theme/unify/components/hs.header",
			"hs.hamburgers"   				: "/js/bootstrap.theme/unify/helpers/hs.hamburgers",
			<!-- Dzsparallaxer -->		
			"dzsparallaxer"           	: "/assets/vendor/dzsparallaxer/dzsparallaxer",
			"dzsparallaxer.dzsscroller"	: "/assets/vendor/dzsparallaxer/dzsscroller/scroller",
			"dzsparallaxer.advancedscroller"	: "/assets/vendor/dzsparallaxer/advancedscroller/plugin"
		}
	});
	require([ "jquery", "bootstrap", "kendo.culture.ko-KR.min", "community.data",  "hs.header", "hs.hamburgers",  'dzsparallaxer.advancedscroller', "summernote-ko-KR" , "dropzone" ], function($) { 
		
		// init header 
		$.HSCore.components.HSHeader.init($('#js-header'));	
		$.HSCore.helpers.HSHamburgers.init('.hamburger');
		
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
		
		var observable = new community.ui.observable({ 
			currentUser : new community.model.User(),
			board : new community.model.Board(),
			thread : new community.model.Thread(),
			message : new community.model.Message(),
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
			},
			autherAvatarSrc : "/images/no-avatar.png",
			autherJoinDate : "",
			autherName : "",
			isNew : false,
			isReplyAllowed : false,
			isAttachmentAllowed : true,
			isCommentAllowed : false,
			editable : false,
			visible : true,
			edit : function(e){
				var $this = this;	
				if( $this.thread.threadId > 0 ){
					$this.set('isNew', false);
					$this.set('isAttachmentAllowed', true);
					$this.message.set('parentMessageId', $this.thread.rootMessage.parentMessageId );	
					$this.message.set('messageId', $this.thread.rootMessage.messageId );	
					$this.message.set('objectType', $this.thread.rootMessage.objectType );
					$this.message.set('objectId', $this.thread.rootMessage.objectId );
					$this.message.set('threadId', $this.thread.rootMessage.threadId );
					$this.message.set('subject',  $this.thread.rootMessage.subject );
					$this.message.set('body', $this.thread.rootMessage.body );					
				}else{
					$this.set('isNew', true);
					$this.set('isAttachmentAllowed', false);
					$this.message.set('parentMessageId', -1 );	
					$this.message.set('messageId', -1 );	
					$this.message.set('objectType', 5 );
					$this.message.set('objectId', $this.board.boardId );
					$this.message.set('threadId', -1 );
					$this.message.set('subject',  '' );
					$this.message.set('body', '' );		
				}
				
				$this.set('editable' , true);
				$this.set('isReplyAllowed' , false);
												
				console.log('summernote create.');
			 	var editorTo = $('#message-body-editor');
			 	editorTo.summernote({
					placeholder: '내용을 입력하여 주세요.',
					dialogsInBody: false,
					height: 500,
					fontNames: ['Gulim', 'Dotum', 'Malgun Gothic', 'Batang', 'Gungsuh', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New'],
					callbacks: {
						onImageUpload : function(files, editor, welEditable) {
				            community.data.uploadImageAndInsertLink(files[0], editorTo );
				        }
			        }
				});			 	
				editorTo.summernote('code', $this.message.get('body') );
				if( $this.thread.threadId > 0 ){
					createAttachmentDropzone($('#message-attachment-dropzone'), $this.get('message.messageId') );
				}
			},
			cancle : function () {
				var $this = this;	
				if( $this.get('isNew') ) 
				{
					$this.back();
				}
				$this.set('editable' , false);
			},
			saveOrUpdate : function (){
				var $this = this;
				
				var editorTo = $('#message-body-editor');
				$this.message.set('body', editorTo.summernote('code') );	
				
				community.ui.progress(renderTo, true);				
				community.ui.ajax( '<@spring.url "/data/api/v1/messages/save-or-update.json" />', {
					data: community.ui.stringify($this.message),
					contentType : "application/json",
					success : function(data){
						community.ui.send("<@spring.url "/display/pages/community-article-viewer.html" />", { boardId: $this.board.boardId , threadId:data.threadId }); 
						return false;
					}
				}).always( function () {
					community.ui.progress(renderTo, false);
				});	
				
			},
			setSource : function (data ){
				var $this = this;		 
				data.copy($this.thread); 
				$this.set('isCommentAllowed', true);
				$this.set('autherAvatarSrc',  community.data.getUserProfileImage( $this.thread.rootMessage.user ) );
				$this.set('autherName',  community.data.getUserDisplayName( $this.thread.rootMessage.user ) );
				$this.set('autherJoinDate',  community.data.getFormattedDate( $this.thread.rootMessage.user.creationDate , 'yyyy.MM.dd') );  
				if($this.board.readComment && $this.thread.rootMessage.messageId > 0 ){
			    	createMessageCommentListView($this.thread.rootMessage);
			    } 
			    createMessageAttachmentListView($('#message-attachments-listview'), $this.thread.rootMessage.messageId );
			},
			back : function () {
				var $this = this;
				community.ui.send("<@spring.url "/display/pages/community-article-list.html" />", { boardId: $this.board.boardId }); 
				return false;
			},
			load : function(boardId, threadId, messageId){
				var $this = this;		 
				if( boardId > 0 ){
					community.ui.ajax('/data/api/v1/boards/' + boardId + '/info.json', {
						success: function(data){				
							$this.set('board', new community.model.Board(data) );			
							if($this.board.readable)	
							{	
								if( threadId > 0 ){
									community.ui.progress($("#features"), true);
									community.ui.ajax('/data/api/v1/threads/' + threadId + '/info.json', {
										success: function(data){						
											$this.setSource( new community.model.Thread(data) );
										}
									}).always( function () {
										community.ui.progress($("#features"), false);
									});	
								}else{
									$this.edit();
								}		
							}
						}
					});
				}
			}
    	});

		var renderTo = $('#features');
		community.ui.bind( renderTo , observable );
		renderTo.data('model', observable);
		
    	observable.load( __boardId, __threadId ,  __messageId );
    	
		renderTo.on("click", "button[data-subject=comment], a[data-subject=comment], a[data-kind=attachment]", function(e){		
			var $this = $(this); 
			if( community.ui.defined(  $this.data("kind") ) &&  $this.data("kind") === 'attachment' ){
				if( confirm("파일을 삭제하시겠습까?") ){
					community.ui.progress($('#message-attachments-listview'), true);
					
					community.ui.ajax( '<@spring.url "/data/api/v1/messages/" />' + $this.data("owner-object-id") + '/attachments/' + $this.data("object-id") + '/remove.json', {
						contentType : "application/json",
						data : community.ui.stringify({}) ,
						success : function(response){		
							community.ui.listview( $('#message-attachments-listview') ).dataSource.read();				
						}
					}).always( function () {
						community.ui.progress($('#message-attachments-listview'), false);
					});			            		
				}		
				return false;
			}
			
			
			if( observable.board.createComment ) {		
				var actionType = $this.data("action");		
				var targetObject = $( $this.data("target") );			
				if( actionType === 'list'){
					var messageId = $this.data("message-id");
					var commentId = $this.data("comment-id");				
					createMessageChildCommentListView( targetObject, {messageId:messageId , commentId:commentId } );
				}else if ( actionType === 'create' ){									
					var messageId = $this.data("object-id");
					var parentCommentId = $this.data("parent-comment-id");
					showCommentModalAndCreateIfNotExist( actionType , messageId , parentCommentId , targetObject );				
				}	
			}			
			return false;		
		});	 			    	
	});
	
	function isOwner () {
		var renderTo = $('#features'); 
		if( renderTo.data('model').currentUser.userId === renderTo.data('model').thread.rootMessage.user.userId )
			return true;
		else 
			return false;	
	}
	
	function isAuthor(user){
		var renderTo = $('#features');
		if( user.userId === renderTo.data('model').thread.rootMessage.user.userId )
			return true;
		else 
			return false;	
	}
	
	function isCommentEnabled(){
		var renderTo = $('#features');
		if( renderTo.data('model').board.createComment )
			return true;
		else 
			return false;	
	}	
 
	function createAttachmentDropzone( renderTo, messageId ){	
		// attachment dorpzone
		var myDropzone = new Dropzone('#' + renderTo.attr('id'), {
			url: '/data/api/v1/attachments/upload.json',
			paramName: 'file',
			maxFilesize: 10,
			previewsContainer: '#' + renderTo.attr('id') + ' .dropzone-previews',
			previewTemplate: '<div class="dz-preview dz-file-preview"><div class="dz-progress"><span class="dz-upload" data-dz-uploadprogress></span></div></div>',
			maxfilesexceeded : function() {
				community.ui.notification().show({ title:null, 'message': '첨부파일은 10MB 를 초과할 수 없습니다.' },"error");
			}
		});
		 
		myDropzone.on("sending", function(file, xhr, formData) {
			console.log("sending file to server.");
			formData.append("objectType", 7);
			formData.append("objectId", messageId );
		});			
		myDropzone.on("success", function(file, response) {
			file.previewElement.innerHTML = "";
		});
		myDropzone.on("addedfile", function(file) {
			community.ui.progress(renderTo, true);
		});		
		myDropzone.on("complete", function() {
			community.ui.progress(renderTo, false);
			community.ui.listview( $('#message-attachments-listview') ).dataSource.read();
		});		
		console.log('create dropzone.');	
	}
	
	function createMessageAttachmentListView ( renderTo ,  messageId ){
		renderTo = renderTo || $('#message-attachments-listview');	
		if( !community.ui.exists( renderTo ) ){					
			console.log('create attachment listview');
			var listview = community.ui.listview( renderTo , {
				dataSource: community.ui.datasource('/data/api/v1/attachments/list.json', {
					transport : {
						parameterMap :  function (options, operation){
							return { startIndex: options.skip, pageSize: options.pageSize, objectType : 7 , objectId : messageId }
						}
					},
					pageSize: 10,
					schema: {
						total: "totalCount",
						data: "items",
						model : community.model.Attachment
					}
				}),
				template: community.ui.template($("#message-attachments-template").html()),
			    dataBound : function(e){
					community.ui.tooltip(renderTo);
					if( this.items().length == 0){
						renderTo.html('<tr class="g-height-150"><td colspan="3" class="align-middle g-font-weight-300 g-color-black text-center">첨부파일이 없습니다.</td></tr>');
					}
				}	
			});
		}
	}  
	
	/**
	* 뎃글 리스트 뷰를 생성함.
	*
	* data : message object.
	* renderTo : listview 를 생성할 노드.
	*/
	function createMessageCommentListView( data, renderTo ){			
		renderTo = renderTo || $('#message-comment-listview');	
		var template = community.ui.template('/data/api/v1/threads/#=threadId#/messages/#= messageId #/comments/list.json'); 
		var target_url = template( data );	
		var listview = community.ui.listview( renderTo , {
			dataSource : community.ui.datasource(target_url, {
				schema: {
					total: "totalCount",
					data: "items"
				},
				pageSize : 10
			}),
			template: community.ui.template($("#comment-template").html()),
			dataBound : function(e){
				if( this.items().length == 0){
					renderTo.html('<p class="g-mt-70 g-font-weight-300 g-color-black text-center">등록된 댓글이 없습니다.</p>');
				}
			}
		});
	} 
	
		
	function createMessageChildCommentListView(renderTo, options){	
		renderTo.collapse('toggle');
		if( !community.ui.exists( renderTo ) ){
			var template = community.ui.template('/data/api/v1/threads/<#if __thread?? >${__thread.objectId}<#else>0</#if>/messages/#: messageId #/comments/#: commentId #/list.json'); 
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

	function showCommentModalAndCreateIfNotExist(actionType , messageId , parentCommentId, targetObject ){	
		var renderTo = $('#message-comment-modal');
		if( !renderTo.data("model") ){
			var editorRenderTo = $('#editable-message-message-body');
			editorRenderTo.summernote({
				toolbar: [ 'codeview' ], 
				placeholder: '댓글...',
				dialogsInBody: true,
				height: 200,
				lang: 'ko-KR',
				callbacks: {
					onImageUpload : function(files, editor, welEditable) {
						community.data.uploadImageAndInsertLink(files[0], editorRenderTo );
				    }
			    }
			});
			var observable = new community.ui.observable({ 
				autherAvatarSrc :community.data.getUserProfileImage( $('#features').data('model').currentUser ) ,
				text : "",
				email : "",
				name : "",
				threadId : __threadId,
				messageId : 0,				
				parentCommentId : 0,
				setMessage: function(data){
					var $this = this;
					$this.set( 'messageId', data.messageId );
					$this.set( 'parentCommentId', data.parentCommentId );
					$this.set( 'text', "" );
					$this.set( 'email', "" );
					$this.set( 'name', "" );					
					editorRenderTo.summernote('code', $this.get('text'));
				},
				save : function () {
					var $this = this;
					$this.set('text', editorRenderTo.summernote('code') );
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
			renderTo.on('show.bs.modal', function (e) { });
		} 
		renderTo.data("model").setMessage( { 'messageId': messageId , 'parentCommentId': parentCommentId  });
		renderTo.modal('show');
	} 			 	
	</script>
	</head>
<body>
<main>
	<#include "includes/header.ftl">
    <!-- Promo Block -->
    <section class="dzsparallaxer auto-init height-is-based-on-content use-loading mode-scroll loaded dzsprx-readyall g-bg-cover g-color-white" data-options='{direction: "reverse", settings_mode_oneelement_max_offset: "150"}'>
		<div class="divimage dzsparallaxer--target w-100 g-bg-pos-bottom-center" style="height: 120%; background-image: url(  /images/bg/endless_streets_by_andreasrocha-d3fhbhg.jpg );"></div>
     	<div class="container g-bg-cover__inner g-py-50 g-mt-50 g-mb-0">
			<header class="g-mb-20">
				<h3 class="h5 g-font-weight-300 g-mb-5"><#if __page?? &&  __page.summary?? >${__page.summary}<#else>${ CommunityContextHelper.getConfigService().getApplicationProperty("website.title", "REPLICANT") }</#if></h3>
				<h2 class="h1 g-font-weight-300 text-uppercase"><#if __page?? >${__page.title}</#if>
		        <!--<span class="g-color-primary">enim</span>
		        sapien-->
				</h2>
			</header> 
		    <ul class="u-list-inline">
		      <li class="list-inline-item g-mr-7">
		        <a class="u-link-v5 g-color-white g-color-primary--hover" href="#!">Home</a>
		        <i class="fa fa-angle-right g-ml-7"></i>
		      </li>
		      <li class="list-inline-item g-color-primary">
		        <span><#if __page?? >${__page.title}</#if></span>
		      </li>
			</ul>
		</div>
    </section>
    <!-- End Promo Block -->
    
	<section class="g-py-60">
		<div class="container" id="features">
			<!--
			<div class="mb-5">
          		<h2 class="h3 g-color-black mb-0" data-bind="text:board.displayName"></h2>
          		<div class="d-inline-block g-width-50 g-height-1 g-bg-black"></div>
          		<p class="" data-bind="text:board.description"></p>
          	</div>
           -->
            <!-- Toolbar -->
			<div class="d-flex g-pos-rel justify-content-end align-items-center g-brd-bottom g-brd-gray-light-v4 g-pt-40 g-pb-20">
				<!-- Back Button -->
				<div class="g-mr-60 g-pos-abs g-left-0 g-pb-30" >
					<a href="#!" class="back" data-bind="click: back" data-toggle="tooltip" data-placement="top" title="" data-original-title="뒤로가기"><i class="icon-svg icon-svg-sm icon-svg-ios-back"></i></a>
				</div>
				<!-- End Back Button -->
            </div> 
        	<!-- Ent Toolbar -->
			<div class="row">
            	<!-- Articles Content -->
            	<div class="col-lg-9 g-mb-50 g-mb-0--lg">
              		<article class="g-mb-60 g-mt-20">
                		<header class="g-mb-30">
                  			<span class="g-font-weight-400 text-muted small" data-bind="text:board.displayName"></span>	
                  			<h2 class="h1 mb-5"  data-bind="html:thread.rootMessage.subject, invisible:editable"></h2> 
                  			<!-- Subject Input -->
                  			<div class="form-group g-mb-20" data-bind="visible:editable" style="display:none;">
			                  	<input class="form-control form-control-lg rounded-0" type="text" placeholder="제목" data-bind="value:message.subject" />
			                </div>
			                <!-- End Subject Input -->
			                <div data-bind="invisible:editable" >
							<!-- Author -->
							<div class="media align-items-center g-brd-0 g-brd-gray-light-v4 pb-0 mb-4"  >
				              <img class="d-flex img-fluid g-width-40 g-height-40 rounded-circle mr-3" src="/images/no-avatar.png" data-bind="attr:{ src: autherAvatarSrc  }" alt="Image Description">
				              <div class="media-body">
				                <h4 class="h6 g-color-black g-font-weight-600 mb-0">글쓴이: <span data-bind="text:autherName" ></span></h4>
				                <span class="d-block g-color-gray-dark-v5 g-font-size-12" data-bind="text:autherJoinDate" ></span>
				              </div> 
				              <!-- Figure Social Icons -->
				              <!--
				              <ul class="list-inline mb-0">
				                <li class="list-inline-item g-mx-2">
				                  <a class="u-icon-v2 u-icon-size--xs g-brd-gray-light-v4 g-brd-primary--hover g-color-gray-dark-v3 g-color-white--hover g-bg-primary--hover rounded-circle g-text-underline--none--hover" href="#!">
				                    <i class="fa fa-facebook"></i>
				                  </a>
				                </li>
				              </ul>
				              -->
				              <!-- End Figure Social Icons -->
				            </div>
							<!-- End Author --> 
							<ul class="list-inline d-sm-flex g-color-gray-dark-v4 mb-0 g-font-size-14" >
		                    <li class="list-inline-item" > 작성일 : <span data-bind="text: thread.creationDate" data-format="g"> </span> </li>
		                    <li class="list-inline-item g-mx-10">/</li>
		                    <li class="list-inline-item g-mr-10"><i class="icon-eye u-line-icon-pro align-middle mr-1"></i> 읽음 <span data-bind="text:thread.viewCount">0</span></li>
		                    </ul> 
                  			<hr class="g-brd-gray-light-v4 g-my-15">
                  			</div>
						</header>
                		<div class="g-font-size-16 g-line-height-1_8 g-mb-30">
							<!-- Message Body -->
							<div class="message-body g-my-50 g-min-height-100" data-bind="html:thread.rootMessage.body,invisible:editable"></div>
                 			<!-- End Message Body -->
                 			<!-- Message Body Editor -->
                 			<div id="message-body-editor" class="hide message-composer"></div>
                 			<!-- End Message Body Editor -->
			                <!-- Sources & Tags -->
			                <!--
			                <div class="g-mb-30">
			                  <h6 class="g-color-gray-dark-v1 g-mb-15">
			                    <strong class="g-mr-5">Source:</strong> <a class="u-link-v5 g-color-gray-dark-v4 g-color-primary--hover" href="#!">The Next Web (TNW)</a>
			                  </h6>
			                  <h6 class="g-color-gray-dark-v1">
			                    <strong class="g-mr-5">Tags:</strong>
			                    <a class="u-tags-v1 g-font-size-12 g-brd-around g-brd-gray-light-v4 g-bg-primary--hover g-brd-primary--hover g-color-black-opacity-0_8 g-color-white--hover rounded g-py-6 g-px-15 g-mr-5" href="#!">IT</a>
			                  </h6>
			                </div>
			                -->
			                <!-- End Sources & Tags --> 
			                <!-- Attachments -->
			                <!--<hr class="g-brd-gray-light-v4">-->
			                <div class="g-mb-60 g-mt-30" data-bind="visible:isAttachmentAllowed" style="display:none;">
			                	<h3 class="h5 mb-3">첨부파일</h3>
			                	<!-- Attachment Upload -->
			                	<form action="" method="post" enctype="multipart/form-data" id="message-attachment-dropzone"  class="u-dropzone g-rounded-5 g-brd-1 g-brd-gray-light-v3 g-brd-1 g-brd-style-solid g-mb-20 g-pa-20 g-bg-gray-light-v6--hover g-brd-primary--hover g-color-black-opacity-0_8 g-color-black--hover" data-bind="visible:editable">
									<div class="dz-default dz-message text-center">
					            	 	<i class="icon-svg icon-svg-dusk-upload"></i>
					                    <p class="note">업로드할 첨부파일은 이곳에 드레그하여 놓아주세요.</p>
					                </div>       
					                <div class="dropzone-previews"></div>                 
									<div class="fallback">
									     <input name="file" type="file" multiple style="display:none;"/>
									</div>
								</form> 	
										
			                	<!-- End Attachment Upload -->
								<table class="table u-table--v2">
			                  	<!--
			                  	<thead class="text-uppercase g-letter-spacing-1 g-bg-gray-light-v5">
			                  		<tr>
			                      		<th class="g-font-weight-300 g-color-black" width="60">&nbsp;</th>
			                      		<th class="g-font-weight-300 g-color-black" width="60">&nbsp;</th>
			                      		<th class="g-font-weight-300 g-color-black g-min-width-200">크기</th>
			                      		<th class="g-font-weight-300 g-color-black g-min-width-200">크기</th>
                       			 		<th class="g-font-weight-300 g-color-black g-width-50" >&nbsp;</th>
                    				</tr>
                  				</thead>
                  				-->
                  				<tbody id="message-attachments-listview" class="g-brd-0 u-listview" style="min-height:100px;"></tbody>
			            		</table> 					
			                </div>
			 				<!-- End Attachments -->
			 				 <div class="g-mb-60">
			                  <div class="text-right g-mt-30">
									<a href="#!" class="btn u-btn-outline-darkgray g-font-size-14 g-px-25 g-py-13" data-bind="click:back">목록</a>
									<#if __thread.rootMessage?? >
									<button type="button" class="btn u-btn-outline-darkgray g-font-size-14 g-px-25 g-py-13 g-mr-5" style="display:none;" data-subject="message" data-bind="visible:isReplyAllowed" data-action="create" data-object-id="${__thread.rootMessage.messageId}" >새로운 글 게시하기</button> 		                                
		                            </#if>
		                            <button type="button" class="btn u-btn-outline-darkgray g-px-25 g-py-13" data-bind="visible:editable,click:saveOrUpdate" >저장</a> 
		                            <button type="button" class="btn u-btn-outline-darkgray g-px-25 g-py-13 g-ml-5" data-bind="click:cancle, visible:editable" >취소</a> 
		                            <#if __thread.rootMessage?? && __thread.rootMessage.user.userId == currentUser.userId >
		                            <button type="button" class="btn u-btn-outline-darkgray g-px-25 g-py-13" data-bind="click:edit, invisible:editable" >수정</a> 
		                            <button type="button" class="btn u-btn-outline-darkgray g-px-25 g-py-13 g-ml-5" disabled" data-subject="messages" data-action="delete" data-object-id="${ __thread.rootMessage.messageId}" ><i class="fa fa-remove"></i> 삭제</a>
		                     		</#if>			                  		
			                  </div>
			                </div>
			                <!-- Comments -->
			                <div class="g-mb-60" data-bind="visible:isCommentAllowed" style="display:none;">
			                  <div class="u-heading-v3-1 g-mb-30">
			                    <h2 class="h5 u-heading-v3__title g-color-gray-dark-v1 text-uppercase g-brd-primary">댓글</h2>
			                  </div>				  
							  <div id="message-comment-listview" class="g-brd-around g-brd-gray-light-v4 rounded" style="min-height:150px;"></div> 
			                  <div class="text-right g-mt-30">
			                  		<a href="#!" data-bind="visible: board.createComment" class="btn u-btn-outline-darkgray g-font-size-14 g-px-25 g-py-13"  
									data-subject="comment" 
									data-object-id="0" 
									data-target="#message-comment-listview" 
									data-action="create" 
									data-parent-comment-id="0">
									<span class=""><i class="icon-finance-206 u-line-icon-pro align-middle g-pos-rel g-top-1 mr-2"></i> 댓글쓰기</span>
									</a> 
			                  </div>
			                </div>
			                <!-- Comments -->
						</article>
            		</div>
            		<!-- End Articles Content -->

            <!-- Sidebar -->
            <div class="col-lg-3 g-pt-25"> 
            
              <!-- Recent Posts -->
              
              <!-- End Recent Posts -->
              

              <!-- Popular Tags -->
             
              <!-- End Popular Tags -->
            </div>
            <!-- End Sidebar -->
          </div>
        </div>
      </section>
      <!-- End News Content -->

	<!-- message comment modal -->
	<div class="modal fade comment-composer" id="message-comment-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="colored-line"></div>
				<div class="modal-header no-padding"> 
					<div class="social-avatar">
		            	<a href="javascript:void(0);" class="pull-left"> <img alt="image" src="/images/no-avatar.png" data-bind="attr:{ src: autherAvatarSrc }" class="d-flex u-shadow-v25 g-width-50 g-height-50 rounded-circle g-mr-15" > </a>
		                <!--
		                <div class="media-body">
		                		<a href="#">Andrew Williams</a>
		                     <small class="text-muted">Today 4:21 pm - 12.06.2014</small>
		                </div>
		                -->
		            </div>
				</div>
				<div class="modal-body g-pa-0">
					<div class="text-editor">
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
	<script type="text/x-kendo-template" id="message-attachments-template">   
	<tr class="g-height-55">
		<td class="align-middle text-center g-width-50 g-pa-0">				
			#if ( contentType.match("^image") ) {#	
			<img class="g-width-50 g-height-50" src="#= community.data.getAttachmentThumbnailUrl( data, true) #" />
			# }else if( contentType === "application/pdf" ){ #		
			<img class="g-brd-around g-brd-gray-light-v4 g-width-50 g-height-50" src="#= community.data.getAttachmentThumbnailUrl( data, true) #" />
			# } else { #			
				<i class="icon-svg icon-svg-sm icon-svg-dusk-attach m-t-xs"></i>
			# } #
		</td> 
		<td class="align-middle text-center g-width-50 g-pa-0">
			<!--
			<a class="btn btn-xs icon-svg-btn g-mt-15" href="#: community.data.getAttachmentUrl(data) #" target="_blank" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="PC 저장">
				<i class="icon-svg icon-svg-xs m-t-xs icon-svg-dusk-desktop-download"></i>
			</a>-->
		
			<a class="u-icon-v1 g-font-size-16 g-text-underline--none--hover" href="#: community.data.getAttachmentUrl(data) #" title="" data-toggle="tooltip" data-placement="top" data-original-title="PC 저장">
				<i class="icon-communication-038 u-line-icon-pro"></i>
			</a>			
		</td>
		<td class="align-middle"> #: name #  </td>
		<td class="align-middle text-right"><span class='text-muted'>#: formattedSize() #</span></td>
		#if(isOwner()){#
		<td class="align-middle g-width-50 g-pa-0">		
			<a class="u-icon-v1 g-font-size-16 g-text-underline--none--hover" href="\\#!" title="" data-toggle="tooltip" data-placement="top" data-original-title="삭제" data-kind="attachment" data-action="remove" data-object-id="#= attachmentId #" data-owner-object-id="#= objectId #" >
				<i class="icon-hotel-restaurant-214 u-line-icon-pro"></i>
			</a>
        </td>
        #}#              
	</tr>            	        	        	
	</script> 
                 
	<script type="text/x-kendo-template" id="comment-template">
	<div class="social-talk p-xxs">
		<div class="media social-profile clearfix g-pa-15">
			<a class="pull-left">
				<img class="d-flex u-shadow-v25 g-width-50 g-height-50 rounded-circle g-mr-15" src="#= community.data.getUserProfileImage( user ) #" alt="profile-picture">
			</a>
			<div class="media-body">
				<div class="g-mb-15"> 
				<h5 class="d-flex justify-content-between align-items-center g-font-size-16 g-color-gray-dark-v1 mb-0">
					<span class="d-block g-mr-10">#= community.data.getUserDisplayName( user ) #</span>
					# if (isAuthor(user)) {#
					<a class="u-tags-v1 g-font-size-12 g-brd-around g-brd-gray-light-v4 g-bg-primary--hover g-brd-primary--hover g-color-black-opacity-0_8 g-color-white--hover rounded g-py-6 g-px-15" href="\\#!">Author</a>
					# } #
				</h5>
				<span class="g-color-gray-dark-v4 g-font-size-12">#: kendo.toString( new Date(creationDate), "g") #</span>
				</div>
				<div class="g-mb-15 g-color-gray-dark-v2"> 
				#= body #	 
				</div>
 
				<ul class="list-inline d-sm-flex my-0">
					<li class="list-inline-item g-mr-20">
					<a class="u-link-v5 g-color-gray-dark-v4 g-color-primary--hover" href="\\#!" data-subject="comment" data-action="list" data-message-id="#:objectId#" data-comment-id="#:commentId#" data-target="\\#message-#:objectId#-comment-#:commentId#-listview" aria-expanded="false" aria-controls="message-#:objectId#-comment-#:commentId#-listview"> <i class="icon-bubbles"></i> 답글 더보기 (<span>#: replyCount #</span>)</a>
					</li>
					# if (isCommentEnabled()) {#
					<li class="list-inline-item g-mr-20">
					<a class="u-link-v5 g-color-gray-dark-v4 g-color-primary--hover" href="\\#!" data-subject="comment" data-action="create" data-object-id="#: objectId #" data-parent-comment-id="#: commentId#" ><i class="icon-bubble"></i> 답글쓰기</a>	
					</li>
					# } #	
				</ul>		
				<div class="collapse g-brd-0 comment-reply" id="message-#:objectId#-comment-#:commentId#-listview"></div>		
			</div>
		</div>
	</div>	
	</script>      	           
</main>
</body>
</html>
</#compress>