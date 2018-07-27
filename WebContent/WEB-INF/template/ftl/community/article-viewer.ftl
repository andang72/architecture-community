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

 		
	<!-- Bootstrap core CSS -->
   	<link href="<@spring.url "/css/bootstrap/4.0.0/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	
   	
	<!-- Professional Kendo UI --> 	 
	<link href="<@spring.url "/css/bootstrap.theme/unify-bootstrap-v4/all.css"/>" rel="stylesheet" type="text/css" />	
		
   	<!-- Fonts & Icons CSS -->
	<link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/fonts/nanumgothic.min.css"/>" rel="stylesheet" type="text/css" />		
	<link href="<@spring.url "/css/community.ui/community.ui.icons.min.css"/>" rel="stylesheet" type="text/css" />	
		
	<!-- Dzsparallaxer CSS -->
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/dzsparallaxer.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/dzsscroller/scroller.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/advancedscroller/plugin.css"/>" rel="stylesheet" type="text/css" />	
			
	<!-- summernote CSS -->		
	<link rel="stylesheet" href="<@spring.url "/js/summernote/summernote-bs4.css"/>">
	
					
	<!-- CSS Bootstrap Theme Unify -->		    
    <link href="<@spring.url "/assets/vendor/icon-hs/style.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/assets/vendor/hs-megamenu/src/hs.megamenu.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/assets/vendor/hamburgers/hamburgers.min.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/assets/vendor/icon-line/css/simple-line-icons.css"/>" rel="stylesheet" type="text/css" />			 
	<link href="<@spring.url "/assets/vendor/icon-line-pro/style.css"/>" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-core.css"/>">
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-components.css"/>">
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-globals.css"/>"> 
	
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/custom.css"/>">
	  	  	
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
 
	<#if CommunityContextHelper.getBoardService().getBoardById( ServletUtils.getStringAsLong( RequestParameters.boardId ) )?? >
	<#assign __board = CommunityContextHelper.getBoardService().getBoardById( ServletUtils.getStringAsLong( RequestParameters.boardId ) ) />
	</#if>
	
	<#if __board?? && CommunityContextHelper.getCategoryService().getCategory(__board)?? >
	<#assign __category = CommunityContextHelper.getCategoryService().getCategory(__board) />
	</#if>
			
	require.config({
		shim : {
			"summernote-ko-KR" : { "deps" :['summernote.min'] },
			<!-- Bootstrap -->
			"jquery.cookie" 			: { "deps" :['jquery'] },
	        "bootstrap" 				: { "deps" :['jquery'] },
			<!-- Professional Kendo UI -->
			"kendo.web.min" 			: { "deps" :['jquery'] },
	        "kendo.culture.min" 		: { "deps" :['jquery', 'kendo.web.min'] },	   
	        "kendo.messages.min" 		: { "deps" :['jquery', 'kendo.web.min'] },	  
			<!-- community -- >
	        "community.ui.core"			: { "deps" :['jquery', 'kendo.web.min', 'kendo.culture.min' ] },
	        "community.data" 			: { "deps" :['jquery', 'kendo.web.min', 'community.ui.core' ] },
	        <!-- Unify -- > 			
			"hs.core" : { "deps" :['jquery', 'bootstrap'] },
			"hs.header" : { "deps" :['jquery', 'hs.core'] },
			"hs.hamburgers" : { "deps" :['jquery', 'hs.core'] },
	        "dzsparallaxer" : { "deps" :['jquery'] },
	        "dzsparallaxer.dzsscroller" : { "deps" :['jquery', 'dzsparallaxer' ] },
			"dzsparallaxer.advancedscroller" : { "deps" :['jquery', 'dzsparallaxer' ] }			
	    },
		paths : {
			"jquery"    				: "/js/jquery/jquery-3.1.1.min",
			"jquery.cookie"    			: "/js/jquery.cookie/1.4.1/jquery.cookie",
			"bootstrap" 				: "/js/bootstrap/4.0.0/bootstrap.bundle.min",
			<!-- Professional Kendo UI --> 
			"kendo.web.min"	 			: "/js/kendo/2018.1.221/kendo.web.min",
			"kendo.culture.min"			: "/js/kendo/2018.1.221/cultures/kendo.culture.ko-KR.min",	
			"kendo.messages.min"		: "/js/kendo.extension/kendo.messages.ko-KR",	
			<!-- summernote -->
			"summernote.min"             : "/js/summernote/summernote-bs4.min",
			"summernote-ko-KR"           : "/js/summernote/lang/summernote-ko-KR"	,
			"dropzone"					: "/js/dropzone/dropzone",			
			<!-- community -- >
			"community.ui.core" 		: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data",   
			<!-- Unify -->
	    	"hs.core" 	   					: "/js/bootstrap.theme/unify/hs.core",
			"hs.header" 	   				: "/js/bootstrap.theme/unify/components/hs.header",
			"hs.hamburgers"   				: "/js/bootstrap.theme/unify/helpers/hs.hamburgers",
			<!-- Dzsparallaxer -->		
			"dzsparallaxer"           	: "/assets/vendor/dzsparallaxer/dzsparallaxer",
			"dzsparallaxer.dzsscroller"	: "/assets/vendor/dzsparallaxer/dzsscroller/scroller",
			"dzsparallaxer.advancedscroller"	: "/assets/vendor/dzsparallaxer/advancedscroller/plugin"
		}
	});
	require([ 
		"jquery", "bootstrap", 
		"community.data", "kendo.messages.min",
		"hs.header", "hs.hamburgers",  'dzsparallaxer.advancedscroller',
		"summernote-ko-KR", "dropzone" 
	 ], function($) { 
		
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
			currentUserAvatarSrc : "/images/no-avatar.png", 
			currentUserDisplayName : "",
			board : new community.model.Board(),
			thread : new community.model.Thread(),
			message : new community.model.Message(),
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
				$this.set("currentUserAvatarSrc", community.data.getUserProfileImage( $this.currentUser) );
				$this.set('currentUserDisplayName', community.data.getUserDisplayName( $this.currentUser ) );
			},
			autherAvatarSrc : "/images/no-avatar.png",
			autherJoinDate : "",
			autherName : "",
			isNew : false,
			isReplyAllowed : false,
			isAttachmentAllowed : true,
			isCommentAllowed : false,
			editable : false,
			visible : false,
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
												
				var editorTo = $('#message-body-editor');
			 	if( !community.ui.defined(editorTo.data('summernote')) ){
			 		console.log('summernote create.');
					editorTo.summernote({
						/*placeholder: '내용을 입력하여 주세요.',*/
						dialogsInBody: false,
						height: 600,
						tabsize: 2,
						lang: 'ko-KR',
						fontNames: ['나눔 고딕', 'Gulim', 'Dotum', 'Malgun Gothic', 'Batang', 'Gungsuh', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New'],
						fontNamesIgnoreCheck: ['나눔 고딕'],
						callbacks: {
							onImageUpload : function(files, editor, welEditable) {
					            community.data.uploadImageAndInsertLink(files[0], editorTo );
					        }
				        }
					}); 
			 	} 
			 			 	
				editorTo.summernote('code', $this.message.get('body') );
				if( $this.thread.threadId > 0 ){
					editorTo.summernote('focus');
					createAttachmentDropzone($('#message-attachment-dropzone'), $this.get('message.messageId') );
				}
			},
			setKeywords : function(str){
				console.log( 'setting keywords - ' + str);
				if( str != null && str.length > 0 ){
					$.each( str.split(','), function(index, value ){
						if( value !=null && value.length > 0){
							$('input:checkbox[data-object-value="' + value.trim() + '"]').prop("checked", true)
						}
					});
				}
			},			
			cancle : function () {
				var $this = this;	
				if( $this.get('isNew') ) 
				{
					$this.back();
				}
				
				var editorTo = $('#message-body-editor');
				if( community.ui.defined(editorTo.data('summernote')) ){
					editorTo.summernote('destroy'); 
					editorTo.html("");
				}
				$this.set('editable' , false);
			},
			saveOrUpdate : function (){
				var $this = this;
				var keywords = "";
				var editorTo = $('#message-body-editor');
				$this.message.set('body', editorTo.summernote('code') ); 
				
				$.each ( $('#message-keywords input[data-kind=keywords]:checked') , function (index, value) {
					if( index > 0 )
					{
						keywords = keywords + ',';
					}
					keywords = keywords + $(value).data('object-value') ;
				});				
				
				$this.message.set('keywords', keywords );
								
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
			delete : function () {
				var $this = this;
				console.log( $this.message ) ;
				if( confirm("메시지를 삭제하시겠습까?") ){
					community.ui.progress(renderTo, true);
					community.ui.ajax( '<@spring.url "/data/api/v1/messages/" />' + $this.get('thread.rootMessage.messageId') + '/delete.json', {
							contentType : "application/json",
							data : community.ui.stringify({}) ,
							success : function(response){	
								$this.back();		
							}
					}).always( function () {
						community.ui.progress(renderTo, false);
					});			
				}
				return false;
			},
			setSource : function (data ){
				var $this = this;		 
				data.copy($this.thread); 
				$this.set('isCommentAllowed', true);
				$this.set('autherAvatarSrc',  community.data.getUserProfileImage( $this.thread.rootMessage.user ) );
				$this.set('autherName',  community.data.getUserDisplayName( $this.thread.rootMessage.user ) );
				$this.set('autherJoinDate',  community.data.getFormattedDate( $this.thread.rootMessage.user.creationDate , 'yyyy.MM.dd') );   
				$this.setKeywords( $this.thread.rootMessage.keywords );	 
				if($this.board.readComment && $this.thread.rootMessage.messageId > 0 ){ 
			    	createMessageCommentListView($this.thread.rootMessage);
			    } 
			    createMessageAttachmentListView($('#message-attachments-listview'), $this.thread.rootMessage.messageId );
			},
			back : function(){
				var $this = this;
				window.history.back();
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
											$this.set('visible', true);
										}
									}).always( function () {
										community.ui.progress($("#features"), false);
									});	
								}else{
									$this.set('visible', true);
									$this.edit();
								}		
							}
						}
					});
					// loading emojis url..
					getEmojis();
				}else{
					
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
					if(messageId === 0){
						messageId = observable.thread.rootMessage.messageId;
					}
					showCommentModalAndCreateIfNotExist( actionType , observable.thread.threadId, messageId , parentCommentId , targetObject );				
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
			maxFilesize: 30,
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
			
			renderTo.removeClass('k-listview');
			renderTo.removeClass('k-widget'); 
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
	
	
	
	/** 
	 * Emoji loading 
	 */
	 function getEmojis(){
		$.ajax({
		  url: 'https://api.github.com/emojis',
		  async: false 
		}).then(function(data) {
		  window.emojis = Object.keys(data);
		  window.emojiUrls = data; 
		}); 
	 }
	
		
	function createMessageChildCommentListView(renderTo, options){	
		renderTo.collapse('toggle');
		if( !community.ui.exists( renderTo ) ){
			var template = community.ui.template('/data/api/v1/threads/<#if __thread?? >${__thread.objectId}<#else>#=threadId#</#if>/messages/#: messageId #/comments/#: commentId #/list.json'); 
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

	function showCommentModalAndCreateIfNotExist(actionType , threadId, messageId , parentCommentId, targetObject ){	
		var renderTo = $('#message-comment-modal');
		if( !renderTo.data("model") ){
			var editorRenderTo = $('#editable-message-message-body');
			editorRenderTo.summernote({
				toolbar:[ ['picture', ['picture']], ['video', ['video']], ['link', ['link']], 'codeview' ], 
				placeholder: '댓글을 남겨주세요.',
				dialogsInBody: true,
				height: 200,
				lang: 'ko-KR',
				hint: {
				    match: /:([\-+\w]+)$/,
				    search: function (keyword, callback) {
				      callback($.grep(emojis, function (item) {
				        return item.indexOf(keyword)  === 0;
				      }));
				    },
				    template: function (item) {
				      var content = emojiUrls[item];
				      return '<img src="' + content + '" width="20" /> :' + item + ':';
				    },
				    content: function (item) {
				      var url = emojiUrls[item];
				      if (url) {
				        return $('<img />').attr('src', url).css('width', 20)[0];
				      }
				      return '';
				    }
				},
				callbacks: {
					onImageUpload : function(files, editor, welEditable) {
						community.data.uploadImageAndInsertLink(files[0], editorRenderTo );
				    }
			    }
			});
			var observable2 = new community.ui.observable({ 
				autherAvatarSrc :community.data.getUserProfileImage( $('#features').data('model').currentUser ) ,
				text : "",
				email : "",
				name : "",
				threadId : __threadId,
				messageId : 0,				
				parentCommentId : 0,
				setMessage: function(data){
					var $this = this;
					$this.set( 'threadId', data.threadId );
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
				  	var target_url = template( $this );			  	
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
			renderTo.data("model", observable2 );
			community.ui.bind(renderTo, observable2);		
			renderTo.on('show.bs.modal', function (e) { });
		} 
		renderTo.data("model").setMessage( { 'threadId':  threadId, 'messageId': messageId , 'parentCommentId': parentCommentId  });
		renderTo.modal('show');
	} 			 	
	</script>
	<style>
	.img-responsive {
		max-width:100%;
	}

	.message-body {
	    font-weight: 400;
	    font-size: 18px;
	    line-height: 20px;
	}	

	.note-editor {
	    font-weight: 400;
	    font-size: 18px;
	    line-height: 20px;	
	}		

	.comment-composer.modal .note-editor {
	    font-weight: 400;
	    font-size: 16px;
	    line-height: 18px;		
	}

	.comment-composer  .colored-line {
	    background: #c0392b;
	}
	
	.comment-composer.modal {
		top:unset;
	}
	
	.comment-composer.modal .modal-dialog {
		margin-bottom: 15px;
	}	
	
	.comment-composer.modal .modal-content{
		border-radius : 15px ;
	}
	
	.comment-composer.modal .modal-content .note-toolbar {
		border-radius : 0;
	}
	.comment-composer.modal .modal-content .note-editor.note-frame {
		border : 0;
	}
	
	</style>
	</head>
<body>
<main>
	<#include "includes/header.ftl">
    <!-- Promo Block -->
    <section class="dzsparallaxer auto-init height-is-based-on-content use-loading mode-scroll loaded dzsprx-readyall g-bg-cover g-color-white" data-options='{direction: "reverse", settings_mode_oneelement_max_offset: "150"}'>
		<div class="divimage dzsparallaxer--target w-100 g-bg-pos-bottom-center" style="height: 120%; background-image: url(  /images/bg/endless_streets_by_andreasrocha-d3fhbhg.jpg );"></div>
     	<div class="container g-bg-cover__inner g-py-50 g-mt-50 g-mb-0">
			<header class="g-mb-20">
				<#if ( __page.getLongProperty( "pages.parent.pageId",0 ) > 0 ) > 
				<h3 class="h5 g-font-weight-300 g-mb-5">${ CommunityContextHelper.getPageService().getPage(  __page.getLongProperty( "pages.parent.pageId",0 )  ).getTitle() }</h3>
				</#if>
				<h2 class="h1 g-font-weight-400 text-uppercase" data-bind="text:board.displayName" >
				<#if __board?? >${__board.displayName}</#if>
		        <span class="g-color-primary"></span>
				</h2>
				<p class="g-font-size-18 g-font-weight-300" data-bind="text:board.description">${__board.description!""}</p>
			</header> 
			
			<div class="d-flex justify-content-end g-font-size-11">
            <ul class="u-list-inline g-bg-gray-dark-v1 g-font-weight-300 g-rounded-50 g-py-5 g-px-20">
              <li class="list-inline-item g-mr-5">
                <a class="u-link-v5 g-color-white g-color-primary--hover" href="/">Home</a>
                <i class="g-color-white-opacity-0_5 g-ml-5">/</i>
              </li> 
			  <#if ( __page.getLongProperty( "pages.parent.pageId",0 ) > 0 ) >
              <li class="list-inline-item g-mr-5">
                <a class="u-link-v5 g-color-white g-color-primary--hover" href="${ CommunityContextHelper.getPageService().getPage(  __page.getLongProperty( "pages.parent.pageId",0 )  ).getName() }">${ CommunityContextHelper.getPageService().getPage(  __page.getLongProperty( "pages.parent.pageId",0 )  ).getTitle() }</a>
                <i class="g-color-white-opacity-0_5 g-ml-5">/</i>
              </li> 
			  </#if>              
              <#if __board?? >
              <li class="list-inline-item g-color-primary g-font-weight-400">
                <span>${__board.displayName}</span>
              </li>
              </#if>
            </ul>
          	</div>
		</div>
    </section>
    <!-- End Promo Block -->
    
	<section class="g-py-30">
		<div class="container" id="features">
            <!-- Toolbar -->
			<div class="d-flex g-pos-rel justify-content-end align-items-center g-brd-bottom g-brd-gray-light-v4 g-pt-40 g-pb-20" style="display:none!important;">
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
              		<article class="g-mb-60 g-min-height-500" data-bind="visible:visible" style="display:none;">
                		<header class="g-mb-30"> 
							<h1 data-bind="html:thread.rootMessage.subject, invisible:editable"></h2> 
                  			<!-- Subject Input -->
                  			<div class="form-group g-mb-20" data-bind="visible:editable" style="display:none;">
			                  	<input class="form-control form-control-lg rounded-3" type="text" placeholder="제목" data-bind="value:message.subject" />
			                </div>
			                <!-- End Subject Input -->
			                                		
                  			<div data-bind="invisible:editable" >
							<!-- Author -->
							<div class="media align-items-center g-brd-0 g-brd-gray-light-v4 pb-0 mb-4"  >
				              <img class="d-flex img-fluid g-width-40 g-height-40 rounded-circle mr-3" src="/images/no-avatar.png" data-bind="attr:{ src: autherAvatarSrc  }" alt="Image Description">
				              <div class="media-body">
				                <h4 class="h6 g-color-black g-font-weight-600 mb-0">글쓴이: <span data-bind="text:autherName" ></span></h4>
				                <span class="d-block g-color-gray-dark-v5 g-font-size-11" data-bind="text:autherJoinDate" ></span>
				              </div>  
				            </div>
							<!-- End Author --> 
							<ul class="list-inline d-sm-flex g-color-gray-dark-v4 mb-0 g-font-size-14" >
		                    <li class="list-inline-item" > 작성일 : <span data-bind="text: thread.creationDate" data-format="g"> </span> </li>
		                    <li class="list-inline-item g-mx-10">/</li>
		                    <li class="list-inline-item g-mr-10"><i class="icon-eye u-line-icon-pro align-middle mr-1"></i> 읽음 <span data-bind="text:thread.viewCount">0</span></li>
		                    </ul> 
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
									<a href="#!" class="btn btn-md u-btn-3d u-btn-darkgray g-px-25 g-py-13 pull-left" data-bind="click:back">목록</a>
									<#if __thread.rootMessage?? >
									<button type="button" class="btn u-btn-outline-darkgray g-font-size-14 g-px-25 g-py-13" style="display:none;" data-subject="message" data-bind="visible:isReplyAllowed" data-action="create" data-object-id="${__thread.rootMessage.messageId}" >새로운 글 게시하기</button> 		                                
		                            </#if>
		                            <button type="button" class="btn u-btn-outline-darkgray g-font-size-14 g-px-25 g-py-13 g-mr-5" style="display:none;" data-bind="visible:editable,click:saveOrUpdate" >저장</a> 
		                            <button type="button" class="btn u-btn-outline-darkgray g-font-size-14 g-px-25 g-py-13 g-mr-5" style="display:none;" data-bind="click:cancle, visible:editable" >취소</a> 
		                            <#if __thread.rootMessage?? && ( __thread.rootMessage.user.userId == currentUser.userId  ||  SecurityHelper.isUserInRole("ROLE_ADMINISTRATOR") ) >
		                            <button type="button" class="btn u-btn-outline-darkgray g-font-size-14 g-px-25 g-py-13 g-mr-5" style="display:none;" data-bind="click:edit, invisible:editable" >수정</a> 
		                            <button type="button" class="btn u-btn-outline-darkgray g-font-size-14 g-px-25 g-py-13" style="display:none;" data-bind="click:delete, invisible:editable" ><i class="fa fa-remove"></i> 삭제</a>
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
            <div class="g-brd-left--lg g-brd-gray-light-v4 col-lg-3 g-mb-10 g-mb-0--md"> 
  				<section class="g-mb-10 g-mt-20" >			
					<div class="media g-mb-20" data-bind="visible:editable" style="display:none;">
						<div class="d-flex align-self-center">
							<img class="g-width-24 g-height-24 rounded-circle g-mr-10" data-bind="attr:{ src: currentUserAvatarSrc }" src="/images/no-avatar.png" alt="Image description">
						</div>
						<div class="media-body align-self-center text-left" data-bind="text:currentUserDisplayName"></div>
					</div> 
					<div>		
					<p class="g-mb-20" data-bind="visible:editable" style="display:none;" >반듯이 저장 버튼을 클릭해야 변경됩니다.</p>
					<button class="btn u-btn-darkgray g-mb-15" type="button" role="button" data-bind="click:back" >목록</button>
					<#if __thread.rootMessage?? && ( __thread.rootMessage.user.userId == currentUser.userId  ||  SecurityHelper.isUserInRole("ROLE_ADMINISTRATOR") ) >			
					<button class="btn u-btn-outline-blue g-mb-15" type="button" role="button" data-bind="click:edit, invisible:editable">수정</button>
					<button class="btn u-btn-outline-blue g-mb-15" type="button" role="button" data-bind="click:delete, invisible:editable">삭제</button>
					</#if>			
					<button class="btn u-btn-outline-darkgray g-mb-15" type="button" role="button" data-bind="click:cancle, visible:editable" style="display:none;">최소</button>
					<button class="btn u-btn-outline-blue g-mb-15" type="button" role="button" data-bind="click:saveOrUpdate, visible:editable" style="display:none;">저장</button>
					</div> 						
				</section>							                      
              <!-- Recent Posts -->
              
              <!-- End Recent Posts -->
              

				<!-- Popular Tags -->
		  		<#if __category??>
		        <#assign __tagDelegator = CommunityContextHelper.getTagService().getTagDelegator(__category) />		
		        	<hr/>
		            <h3 class="h6 mb-3">키워드:</h3> 
					<ul class="list-unstyled g-font-size-15 g-font-weight-400" id="message-keywords">
             		<#list __tagDelegator.getTags() as item >
	                   	<li class="my-2">
	                    <label class="form-check-inline u-check d-block u-link-v5 g-color-gray-dark-v4 g-color-primary--hover g-pl-30">
	                      <input class="g-hidden-xs-up g-pos-abs g-top-0 g-left-0" type="checkbox" data-object-id="${item.tagId}" data-kind="keywords" data-object-value="${item.name}" data-bind="enabled:editable">
	                      <span class="d-block u-check-icon-checkbox-v4 g-absolute-centered--y g-left-0">
	                        <i class="fa" data-check-icon=""></i>
	                      </span>
	                      ${item.name}  
	                    </label>
	                  	</li>            		
             		</#list>
             		</ul>
		       	</#if>            
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
			# }else if( contentType === "application/pdf" || contentType === "application/vnd.openxmlformats-officedocument.presentationml.presentation" ){ #		
			<img class="g-brd-around g-brd-gray-light-v4 g-width-50 g-height-50" src="#= community.data.getAttachmentThumbnailUrl( data, true) #" />
			# } else { #			
				<i class="icon-svg icon-svg-sm icon-svg-dusk-attach m-t-xs"></i>
			# } #
		</td> 
		<td class="align-middle text-center g-width-50 g-pa-0">
			<a class="u-icon-v1 g-font-size-16 g-text-underline--none--hover" href="#: community.data.getAttachmentUrl(data) #" title="" data-toggle="tooltip" data-placement="top" data-original-title="PC 저장">
				<i class="icon-communication-038 u-line-icon-pro"></i>
			</a>			
		</td>
		<td class="align-middle"> 
		#if( contentType === "application/pdf" ) { #
		<a href="pdf-viewer.html?file=#= community.data.getAttachmentUrl(data) #" target="_blank;">
		#: name #  
		</a>
		# } else { # 
		#: name #  
		#}#
		</td>
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
				<img class="d-flex u-shadow-v25 g-width-40 g-height-40 rounded-circle g-mr-15" src="#= community.data.getUserProfileImage( user ) #" alt="profile-picture">
			</a>
			<div class="media-body">
				<div class="g-mb-15"> 
				<h5 class="d-flex justify-content-between align-items-center g-font-size-14 g-color-gray-dark-v1 mb-0">
					<span class="d-block g-mr-10">#= community.data.getUserDisplayName( user ) #</span>
					# if (isAuthor(user)) {#
					<a class="u-tags-v1 g-font-size-12 g-brd-around g-brd-gray-light-v4 g-bg-primary--hover g-brd-primary--hover g-color-black-opacity-0_8 g-color-white--hover rounded g-py-4 g-px-10" href="\\#!">Author</a>
					# } #
				</h5>
				<span class="g-color-gray-dark-v4 g-font-size-12">#: kendo.toString( new Date(creationDate), "g") #</span>
				</div>
				<div class="g-mb-15 g-color-gray-dark-v2"> 
				#= body #	 
				</div>
 
				<ul class="list-inline d-sm-flex my-0 g-font-weight-500 g-font-size-12">
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