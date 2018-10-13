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
 
  	<#include "/community/includes/header_globle_site_tag.ftl">
  			
	<!-- Bootstrap core CSS -->
   	<link href="<@spring.url "/css/bootstrap/4.0.0/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	
   	
	<!-- Professional Kendo UI --> 	
	<link href="<@spring.url "/css/bootstrap.theme/unify-bootstrap-v4/all.css"/>" rel="stylesheet" type="text/css" />	
		
   	<!-- Fonts & Icons CSS -->
	<link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/fonts/nanumgothic.min.css"/>" rel="stylesheet" type="text/css" />		
	<link href="<@spring.url "/css/community.ui/community.ui.icons.min.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/animate/animate.min.css"/>" rel="stylesheet" type="text/css" />	
		
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
	
	var __issueId = <#if RequestParameters.issueId?? >${RequestParameters.issueId}<#else>0</#if>;
	var __projectId = <#if RequestParameters.projectId?? >${RequestParameters.projectId}<#else>0</#if>;
	var __back_page = <#if RequestParameters.url?? >'${RequestParameters.url}'<#else>''</#if>;
	<#if CommunityContextHelper.getProjectService().getProject( ServletUtils.getStringAsLong( RequestParameters.projectId ) )?? >
	<#assign __project = CommunityContextHelper.getProjectService().getProject( ServletUtils.getStringAsLong( RequestParameters.projectId ) ) />
	</#if>	
	
	require.config({
		shim : {
			<!-- summernote -->
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
			"hs.tabs" : { "deps" :['jquery', 'hs.core'] },
			"hs.hamburgers" : { "deps" :['jquery', 'hs.core'] },
			"hs.dropdown" : { "deps" :['jquery', 'hs.core'] },
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
			"hs.tabs" 	   					: "/js/bootstrap.theme/unify/components/hs.tabs",
			"hs.hamburgers"   				: "/js/bootstrap.theme/unify/helpers/hs.hamburgers",
			"hs.dropdown" 	   				: "/assets/js/components/hs.dropdown",
			<!-- Dzsparallaxer -->		
			"dzsparallaxer"           			: "/assets/vendor/dzsparallaxer/dzsparallaxer",
			"dzsparallaxer.dzsscroller"			: "/assets/vendor/dzsparallaxer/dzsscroller/scroller",
			"dzsparallaxer.advancedscroller"	: "/assets/vendor/dzsparallaxer/advancedscroller/plugin"
		}
	});
	
	require([ 
		"jquery", "bootstrap", 
		"community.data", "kendo.messages.min",
		"hs.header", "hs.tabs", "hs.hamburgers", 'hs.dropdown', 'dzsparallaxer.advancedscroller',
		"summernote-ko-KR", "dropzone" 		
	], function($, kendo ) {	

		// init header 
		$.HSCore.components.HSHeader.init($('#js-header'));	
		$.HSCore.components.HSTabs.init('[role="tablist"]');
		$.HSCore.helpers.HSHamburgers.init('.hamburger');

		// initialization of HSDropdown component
      	$.HSCore.components.HSDropdown.init($('[data-dropdown-target]')); 
      			
		$(window).on('resize', function () {
		    setTimeout(function () {
		    	$.HSCore.components.HSTabs.init('[role="tablist"]');
		    }, 200);
		});
 	
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
		
        var featuresTo = $('#features');   	
       
		var observable = new community.ui.observable({ 
			currentUser : new community.model.User(),			
			isDeveloper : false,
			issue : new community.model.Issue(),
			project : new community.model.Project(),
			projectPeriod : "",
			autherAvatarSrc : "/images/no-avatar.png",
			repoterAvatarSrc : "/images/no-avatar.png",
			assigneeAvatarSrc : "/images/no-avatar.png",
			formatedCreationDate : "",
			formatedModifiedDate: "",
		 	editable : false,
		 	editing : false,
		 	editingForAssignee : false,
		 	visible : false, 
			isNew : false,
			isOpen : false,
			isClosed : false,		 
			isAssigned : false,	
			isNewAndSaved : false,
			isHurry : false,
			assignMe : function(){
				var $this = this;
				$this.set( 'issue.assignee', $this.currentUser );				
				$this.set('assigneeAvatarSrc',  community.data.getUserProfileImage( $this.issue.assignee ) );
				$this.set('isAssigned', true);
			},
			selectAssignee: function() {
			  	 
			},
			selectRepoter: function() {
				
			},
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
				$this.set('isDeveloper', isDeveloper($this.currentUser));
			},
			load : function( projectId, issueId ){
				var $this = this; 
				if( issueId > 0 ){
					community.ui.ajax('/data/api/v1/issues/'+ issueId +'/get-with-project.json', {
						success: function(data){	
							$this.set('project', new community.model.Project(data.project) );	
							$this.set('projectPeriod', community.data.getFormattedDate( $this.project.startDate , 'yyyy.MM.dd')  +' ~ '+  community.data.getFormattedDate( $this.project.endDate, 'yyyy.MM.dd' ) );
							$this.set('backUrl', '/display/pages/issues.html?projectId=' + $this.project.projectId );	
							$this.setSource(new community.model.Issue(data.issue) );	
						}	
					});
				}else{
					community.ui.ajax('/data/api/v1/projects/'+ projectId +'/info.json/', {
						success: function(data){		
							$this.set('project', new community.model.Project(data) );
							$this.set('projectPeriod', community.data.getFormattedDate( $this.project.startDate , 'yyyy.MM.dd')  +' ~ '+  community.data.getFormattedDate( $this.project.endDate, 'yyyy.MM.dd' ) );
							var targetObject = new community.model.Issue();	
							targetObject.set('issueId', 0);
							targetObject.set('objectType', 19);
							targetObject.set('objectId', $this.project.projectId ); 	
							targetObject.set('status', '001');
							targetObject.set('repoter', $this.currentUser );
							$this.setSource(targetObject);
						}	
					});	 
				}
				$this.set('visible', true);
			},
			back : function(){
				var $this = this;
				//community.ui.send("<@spring.url "/display/pages/" />" + __page , { projectId: $this.project.projectId });				
				window.history.back(); 
				if( __back_page != null && __back_page.length > 0 ){
					community.ui.send("<@spring.url "/display/pages/" />" + __back_page , { projectId: $this.project.projectId });
				}else{
					community.ui.send("<@spring.url "/display/pages/issues.html" />", { projectId: $this.project.projectId });
				}
				return false;
			},
			cancle : function(e){
				
				var $this = this;
				if($this.get('isNew')){
					$this.back();
					return ;
				}
			 	
			 	$this.set('editing', false );
			 	$this.set('editingForAssignee', false );
			 	$this.set('editable' , true ); 
			 	
			 	var editorTo = $('#issue-description-editor');
			 	if( community.ui.defined(editorTo.data('summernote')) ){
					editorTo.summernote('destroy'); 
					editorTo.html("");
				}
				
			},
			edit : function(e){
			 	var $this = this;
			 	$this.set('editing', true );
			 	if(isDeveloper( $this.currentUser )){
			 		$this.set('editingForAssignee', true );
			 	}else{
			 		$this.set('editingForAssignee', false );
			 	}
			 	console.log('summernote create.');
			 	var editorTo = $('#issue-description-editor');
			 	if( !community.ui.defined(editorTo.data('summernote')) ){
			 	 	editorTo.summernote({
						placeholder: '자세하게 기술하여 주세요.',
						dialogsInBody: false,
						height: 300,
						callbacks: {
							onImageUpload : function(files, editor, welEditable) {
					            community.data.uploadImageAndInsertLink(files[0], editorTo );
					        }
				        }
					});	
				}		 	
				editorTo.summernote('code', $this.issue.get('description'));
		 	},
		 	delete : function (e){
		 		var $this = this;
		 		if( ! $this.currentUser.hasRole('ROLE_ADMINISTRATOR') ){
		 			community.ui.alert("권한이 없습니다. 관리자에게 문의하여 주세요.");
		 			return false;
		 		}
		 		
				if( confirm("메시지를 삭제하시겠습까?") ){
					community.ui.progress(featuresTo, true);
					community.ui.ajax( '<@spring.url "/data/api/v1/issues/" />' + $this.issue.issueId  + '/delete.json', {
						data: community.ui.stringify($this.issue),
						contentType : "application/json",						
						success : function(response){ 
							$this.back();
						}
					}).always( function () {
						community.ui.progress(featuresTo, false);
					});						
				} 
		 		return ;
		 	},		 		 	
		 	saveOrUpdate : function(e){				
				var $this = this;		
				var stopediting = true;				
				var validator = community.ui.validator($("#issue-edit-form"), {});								
				if (validator.validate()) {	
					var editorTo = $('#issue-description-editor');
					if( editorTo.summernote('code') == null || editorTo.summernote('code').length == 0 ){
						editorTo.summernote('focus');
						return ;
					}
					console.log("now save or update.");
					community.ui.progress(featuresTo, true);						
					$this.issue.set('description', editorTo.summernote('code') );	
					community.ui.ajax( '<@spring.url "/data/api/v1/issues/save-or-update.json" />', {
						data: community.ui.stringify($this.issue),
						contentType : "application/json",						
						success : function(response){ 
							// do after create new issue !
							var itWasNew = $this.get('isNew') ;
							$this.setSource( new community.model.Issue(response) );
							if(itWasNew){
								$this.edit();
								$('html, body').stop().animate({ scrollTop: $("#issue-attachment-dropzone").offset().top - 120 }, 500);							
							}else{
								$this.cancle();
							}
						}
					}).always( function () {
						community.ui.progress(featuresTo, false);
						//if(stopediting)
						//	$this.cancle();
					});
				}					
			},
			setupAdditionalInfo : function (){
				var $this = this;		
				if(  $this.issue.issueId > 0 ){ 	
					$this.set('isAssigned', false);
					if ($this.issue.status != '005' && new Date() >= $this.issue.dueDate )
					{
						$this.set('isHurry', true);
					}
					$this.set('formatedCreationDate' , community.data.getFormattedDate( $this.issue.creationDate) );
					$this.set('formatedModifiedDate' , community.data.getFormattedDate( $this.issue.modifiedDate) );
				}else{
					$this.set('formatedCreationDate', "");
					$this.set('formatedModifiedDate', "");
				}
				if( $this.issue.repoter != null && $this.issue.repoter.userId > 0){
					$this.set('repoterAvatarSrc',  community.data.getUserProfileImage( $this.issue.repoter ) );
				}else{
					$this.set('repoterAvatarSrc',  "/images/no-avatar.png" );
				}					
				if( $this.issue.assignee != null && $this.issue.assignee.userId > 0){
					$this.set('isAssigned', true);
					$this.set('assigneeAvatarSrc',  community.data.getUserProfileImage( $this.issue.assignee ) );
				}else{	
					$this.set('assigneeAvatarSrc',  "/images/no-avatar.png" );
				} 					
				if($this.issue.status == '005' ){
			 		$this.set('isClosed', true);
			 	}else{
			 		$this.set('isOpen', true);
			 	}									
			},
			setSource : function( data ){
			 	var $this = this;
				var orgIssueId = $this.issue.issueId ;
				data.copy( $this.issue ); 
				
				$this.set('isOpen', false);
				$this.set('isClosed', false);
				$this.set('isNew', false );
				$this.set('isNewAndSaved', false );
				$this.set('editable', false );	
				$this.set('isAssigned', false);
				$this.set('isHurry', false);
				
				$this.setupAdditionalInfo();
				
				if(  $this.issue.issueId > 0 ){ 		
					$this.set('editable', true );
					createIssueCommentListView($this); 
				 	createIssueAttachmentListView($this);  
				 	createAttachmentDropzone($this);  
				 	$('#features').find(".nav[role=tablist] a:first").tab('show'); 
				}else{
					$this.set('isNew', true );	
					$this.set('editable', false );
					$this.edit();
				}
				getEmojis();
			},
			issueTypeDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/ISSUE_TYPE/list.json" />' , {} ),
			priorityDataSource  : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/PRIORITY/list.json" />' , {} ),
			resolutionDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/RESOLUTION/list.json" />' , {} ),
			statusDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/ISSUE_STATUS/list.json" />' , {} )	,
			taskDataSource : community.ui.datasource_v4( '<@spring.url "/data/api/v1/projects/" />' + __projectId + '/tasks/list.json' , {
				transport : {
					parameterMap: function (options, operation){	 
						if (operation !== "read" && options.models) { 
							return community.ui.stringify(options.models);
						} 
						return community.ui.stringify(options);
					}				
				},
			 	schema: {
					total: "totalCount",
					data: "items",
					model: community.model.Task
				}
			}),	
			userDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/users/find.json" />' , {
			 	serverFiltering: true,
			 	transport: {
				 	parameterMap: function (options, operation){
	                    	if (community.ui.defined(options.filter) && options.filter.filters.length > 0 ) {
							return { nameOrEmail: options.filter.filters[0].value };
						}else{
							return {};
						}
					}
				},
			 	schema: {
					total: "totalCount",
					data: "items",
					model: community.model.User
				}
			})		
    	});
    	
    	observable.bind("change", function(e){	
    		if( e.field == "issue.resolution" ){
    			if( ( this.get(e.field) === '005' ) || ( this.get(e.field) == '001' ) ){
    				observable.set('issue.status', '005');
    			}
    		}
    	});
    		
    	observable.load(__projectId, __issueId); 
    	var renderTo = $('#page-top');
		renderTo.data('model', observable);		
		community.ui.bind(renderTo, observable );	
		
		renderTo.on("click", "button[data-kind=issue][data-action=create], a[data-kind=issue][data-action=create], a[data-kind=issue][data-action=edit]", function(e){			
			var $this = $(this);
			var actionType = $this.data("action");		
			var objectId = $this.data("object-id");		
			var targetObject = new community.model.Issue();
			targetObject.set('issueId', objectId);
			targetObject.set('objectType', 19);
			targetObject.set('objectId', observable.project.projectId ); 	
			targetObject.set('repoter', observable.currentUser );
			targetObject.set('status', '001');
			observable.setSource(targetObject);
 
			return false;		
		}); 
		
		renderTo.on("click", "button[data-kind=comment], a[data-kind=comment]", function(e){		
				var $this = $(this);
				var actionType = $this.data("action");		
				var targetObject = $( $this.data("target") );	
				if( actionType === 'list'){
					var issueId = $this.data("object-id");
					var commentId = $this.data("comment-id");				
					createMessageChildCommentListView( targetObject, {issueId: issueId , commentId: commentId } );
				}else if ( actionType === 'create' ){									
					var messageId = $this.data("object-id");
					var parentCommentId = $this.data("parent-comment-id");
					openMessageCommentModal( actionType , observable.issue.issueId , parentCommentId , targetObject );				
				}	
			return false;		
		});	 		
	});

	function sendFile(file, editor ) {
	    data = new FormData();
	    	data.append("file", file);
	    $.ajax({
	        data: data,
	        type: "POST",
	        url: '<@spring.url "/data/api/v1/images/upload_image_and_link.json" />',
	        cache: false,
	        contentType: false,
	        processData: false,
	        success: function (response) {	        		
	        		$.each( response, function( index , item  ) {
		            var url = '<@spring.url "/download/images/" />' + item.linkId;
		            editor.summernote('insertImage', url, function ($image) {
		              $image.addClass('img-responsive');
					  $image.attr('data-public-shared', response.publicShared );
					});				  
				});
	        }
	    });
	}

	function createIssueCommentListView( observable, renderTo ){			
		renderTo = renderTo || $('#issue-comment-listview');			
		if( !community.ui.exists( renderTo ) ){		
			var template = community.ui.template('/data/api/v1/issues/#= issueId #/comments/list.json'); 
			var target_url = template(observable.issue);	
			var listview = community.ui.listview( renderTo , {
				dataSource : community.ui.datasource(target_url, {
					schema: {
						total: "totalCount",
						data: "items"
					},
					pageSize : 100
				}),
				template: community.ui.template($("#comment-template").html())
			});
			renderTo.removeClass('k-listview');
			renderTo.removeClass('k-widget'); 	
		}
	} 

	function createMessageChildCommentListView(renderTo, options){	
		renderTo.collapse('toggle');
		if( !community.ui.exists( renderTo ) ){
			var template = community.ui.template('/data/api/v1/issues/#= issueId #/comments/#: commentId #/list.json'); 
			var target_url = template(options);
			var listview = community.ui.listview( renderTo , {
				dataSource : community.ui.datasource(target_url, {
					schema: {
						total: "totalCount",
						data: "items"
					},
					pageSize : 100
				}),
				template: community.ui.template($("#comment-template").html())
			});	
			renderTo.removeClass('k-listview');
			renderTo.removeClass('k-widget'); 			
		}else{
		} 
	}

	function createIssueAttachmentListView ( observable, renderTo ){
		renderTo = renderTo || $('#issue-attachment-listview');	
		if( !community.ui.exists( renderTo ) ){		
			var listview = community.ui.listview( renderTo , {
				dataSource: community.ui.datasource('/data/api/v1/attachments/list.json', {
					transport : {
						parameterMap :  function (options, operation){
							return { startIndex: options.skip, pageSize: options.pageSize, objectType : 18 , objectId : observable.issue.issueId }
						}
					},
					pageSize: 10,
					schema: {
						total: "totalCount",
						data: "items",
						model : community.model.Attachment
					}
				}),
				template: community.ui.template($("#attachment-template").html()),
				dataBound: function() {
			        community.ui.tooltip(renderTo);
			    }
			});
			renderTo.removeClass('k-listview');
			renderTo.removeClass('k-widget'); 
		}
	}

	function createAttachmentDropzone( observable, renderTo ){	
		renderTo = renderTo || $('#issue-attachment-dropzone');	  
		if(! renderTo[0].dropzone ) {
			// create attachment dorpzone
			var myDropzone = new Dropzone("#issue-attachment-dropzone", {
				url: '/data/api/v1/attachments/upload.json',
				paramName: 'file',
				maxFilesize: 20,
				previewsContainer: '#issue-attachment-dropzone .dropzone-previews'	,
				previewTemplate: '<div class="dz-preview dz-file-preview"><div class="dz-progress"><span class="dz-upload" data-dz-uploadprogress></span></div></div>'
			});
			
			var featuresTo = $('#features');  		
			myDropzone.on("sending", function(file, xhr, formData) {
				formData.append("objectType", 18);
				formData.append("objectId", observable.issue.issueId);
			});			
			myDropzone.on("success", function(file, response) {
				file.previewElement.innerHTML = "";
			});
			myDropzone.on("addedfile", function(file) {
				community.ui.progress(featuresTo, true);
			});		
			myDropzone.on("complete", function() {
				community.ui.progress(featuresTo, false);
				community.ui.listview( $('#issue-attachment-listview') ).dataSource.read();
			});	
		}
	}
	
	/** 
	 * Emoji loading 
	 */
	 function getEmojis(){
	 	
	 	if( ! community.ui.defined( window.emojis ) ){ 
	 		console.log("loading emojis..");
			$.ajax({
			  url: 'https://api.github.com/emojis',
			  async: false 
			}).then(function(data) {
			  window.emojis = Object.keys(data);
			  window.emojiUrls = data; 
			}); 	 	
	 	} 
	 }
	
											
	function openMessageCommentModal(actionType , issueId , parentCommentId, targetObject){	
		targetObject = targetObject || $('#issue-comment-listview');	
		var renderTo = $('#issue-comment-modal');
		if( !renderTo.data("model") ){
			var editorRenderTo = $('#issue-comment-body');
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
			var observable = new community.ui.observable({ 
				autherAvatarSrc :"/images/no-avatar.png",
				text : "",
				email : "",
				name : "",
				issueId : 0,				
				parentCommentId : 0,
				setSource: function(data){
					var $this = this;
					$this.set( 'autherAvatarSrc', community.data.getUserProfileImage( getPageModel().currentUser ) );
					$this.set( 'issueId', data.issueId );
					$this.set( 'parentCommentId', data.parentCommentId );
					$this.set( 'text', "" );
					$this.set( 'email', "" );
					$this.set( 'name', "" );					
					editorRenderTo.summernote('code', $this.get('text'));
				},
				save : function () {
					var $this = this;
					$this.set('text', editorRenderTo.summernote('code') );
				  	var template = community.ui.template("/data/api/v1/issues/#= issueId #/comments/add.json"); 
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
		renderTo.data("model").setSource( { 'issueId': issueId , 'parentCommentId': parentCommentId  });
		renderTo.modal('show');
	} 	
				
	function getPageModel(){
		var renderTo = $('#page-top');
		return renderTo.data('model');
	}
		
	function createOrOpenIssueEditor( data ){ 
		var renderTo = $('#issue-editor-modal');
		var editorTo = renderTo.find('.text-editor');
		if( !renderTo.data("model") ){
			var observable = new community.ui.observable({ 
				isNew : false,	
				editable : false, 
				isDeveloper : false,
				isOpen : false,
				isClosed : false,
				issue : new community.model.Issue(),
				issueTypeDataSource : getPageModel().issueTypeDataSource ,
				priorityDataSource  : getPageModel().priorityDataSource,
			 	methodsDataSource   : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/SUPPORT_METHOD/list.json" />' , {} ),
			 	resolutionDataSource : getPageModel().resolutionDataSource,
			 	statusDataSource : getPageModel().statusDataSource,
			 	userDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/users/find.json" />' , {
			 		serverFiltering: true,
			 		transport: {
				 		parameterMap: function (options, operation){
	                        	if (community.ui.defined(options.filter) && options.filter.filters.length > 0 ) {
									return { nameOrEmail: options.filter.filters[0].value };
								}else{
									return { };
								}
						}
					},
			 	 	schema: {
						total: "totalCount",
						data: "items",
						model: community.model.User
					}
			 	}),
			 	setSource : function( data ){
			 		var $this = this;
					var orgIssueId = $this.issue.issueId ;
					data.copy( $this.issue ); 
					if(  $this.issue.issueId > 0 ){
						$this.set('isNew', false );
						$this.set('editable', false );
					}else{
						$this.set('isNew', true );	
						$this.edit();
						//$this.set('editable', true );
					}
					if($this.issue.status == '001' || $this.issue.status == '002' || $this.issue.status == '003' || $this.issue.status == '004' ){
			 			$this.set('isOpen', true);
			 			$this.set('isClosed', false);
			 		}else if($this.issue.status == '005' ){
			 			$this.set('isOpen', false);
			 			$this.set('isClosed', true);
			 		}else{
			 			$this.set('isOpen', false);
			 			$this.set('isClosed', false);
			 		}
					$this.set('isDeveloper', isDeveloper());
					
					$.each(renderTo.find('input[data-role=combobox]'), function( index, value ) {
					  	$(value).data('kendoComboBox').refresh();
					});
			 	},
			 	edit : function(e){
			 		var $this = this;
			 		$this.set('editable', true );
			 		console.log('summernote create.');
			 		editorTo.summernote({
						placeholder: '자세하게 기술하여 주세요.',
						dialogsInBody: true,
						height: 300
					});			 	
					editorTo.summernote('code', $this.issue.get('description'));	
			 	},
				saveOrUpdate : function(e){				
					var $this = this;
					community.ui.progress(renderTo.find('.modal-content'), true);	
					$this.issue.set('description', editorTo.summernote('code') );	
					community.ui.ajax( '<@spring.url "/data/api/v1/issues/save-or-update.json" />', {
						data: community.ui.stringify($this.issue),
						contentType : "application/json",						
						success : function(response){
							community.ui.listview( $('#issue-listview') ).dataSource.read();
						}
					}).always( function () {
						community.ui.progress(renderTo.find('.modal-content'), false);
						renderTo.modal('hide');
					});						
				}
			});
			renderTo.data("model", observable );	
			community.ui.bind( renderTo, observable );				
			renderTo.on('show.bs.modal', function (e) {	});
			renderTo.on('hide.bs.modal', function (e) {	
				if(observable.get('editable') == true ){
					console.log('summernote destory.');
					editorTo.summernote('destroy');
					editorTo.html('');
				}
			});
		}	
		
		if( community.ui.defined(data) ) 
			renderTo.data("model").setSource(data); 
		renderTo.modal('show');
	}

	function isDeveloper( user ){ 
		return user.hasRole('ROLE_DEVELOPER') || <#if __project?? >${ CommunityContextHelper.getCommunityAclService().getPermissionBundle(__project).admin?string } </#if> ;
	} 
 			
	</script>	
	<style>
	.k-widget.k-tooltip-validation {
		background-color: transparent;
	    border: 0;
	    color: red;
	    font-weight: 100;
	    padding-top: 5px;	
	}
	.g-brd-bottom-1 {
	    border-bottom-width: 1px !important;
	    font-weight : 400;
	}
	
	.g-brd-bottom-3 {
	    border-bottom-width: 3px !important;
	    font-weight : 400;
	}	
	.img-responsive {
		max-width:100%;
	}

	.issue-body {
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
	.help-block{
		display: block;
	    margin-top: 5px;
	    margin-bottom: 10px;
	    color: #737373;
    }	
	</style>	
</head>
<body id="page-top" class="landing-page no-skin-config">
	<#include "/community/includes/header.ftl">
    <!-- Promo Block -->
    <section class="dzsparallaxer auto-init height-is-based-on-content use-loading mode-scroll loaded dzsprx-readyall g-bg-cover g-color-white" data-options='{direction: "reverse", settings_mode_oneelement_max_offset: "150"}'>
		<#if (__page.getBooleanProperty( "header.image.random", false) ) >
		<div class="divimage dzsparallaxer--target w-100 g-bg-pos-top-center" style="height: 120%; background-image: url( '<@spring.url "/download/images/" />${ CommunityContextHelper.getCustomQueryService().queryForString("COMMUNITY_CS.SELECT_IMAGE_ID_RANDOMLY" ) }' );"></div>
		<#else>
		<div class="divimage dzsparallaxer--target w-100 g-bg-pos-top-center" 
			style="height: 120%; background-image: url(  /images/bg/endless_streets_by_andreasrocha-d3fhbhg.jpg );"></div>
		</#if>
     	<div class="container g-bg-cover__inner g-py-50 g-mt-50 g-mb-0">
			<header class="g-mb-20">
				<#if ( __page.getLongProperty( "pages.parent.pageId",0 ) > 0 ) > 
				<h3 class="h5 g-font-weight-300 g-mb-5">${ CommunityContextHelper.getPageService().getPage(  __page.getLongProperty( "pages.parent.pageId",0 )  ).getTitle() }</h3>
				</#if>
				<h2 class="h1 g-font-weight-400 text-uppercase" >
				<#if __project?? >${__project.name}</#if>
		        <span class="g-color-primary"></span>
				</h2>
				<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >
				<p class="g-font-size-16 g-font-weight-400" ><#if __project?? >${ __project.summary?html?replace("\n", "<br>")}</#if></p> 
				</#if>   
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
              <#if __project?? >
              <li class="list-inline-item g-color-primary g-font-weight-400">
                <span>${__project.name}</span>
              </li>
              </#if>
            </ul>
          	</div>
		</div>
    </section>
    <!-- End Promo Block -->
	<section id="features" class="services">
		<div class="container g-py-15">  
			<!-- Toolbar -->
			<div class="d-flex g-pos-rel justify-content-end align-items-center g-brd-gray-dark-v4 g-brd-bottom g-brd-bottom-3 g-pt-20 g-pb-20" style="min-height: 110px;">  
				<div class="g-pos-abs g-left-0">
					<i class="icon-svg icon-svg-md icon-svg-dusk-close-sign" data-bind="visible:isClosed" style="display: none;" data-toggle="tooltip" data-placement="top" data-original-title="종결된 이슈" ></i>
					<i class="icon-svg icon-svg-md icon-svg-dusk-open-sign" data-bind="visible:isOpen" style="display: none;" data-toggle="tooltip" data-placement="top" data-original-title="오픈된 이슈"></i>		
					<i class="icon-svg icon-svg-md icon-svg-dusk-warn" data-bind="visible:isHurry" style="display: none;" data-toggle="tooltip" data-placement="bottom" data-original-title="예정일이 지난 이슈"></i>			
				</div>	 						
	            <div class="g-mr-0">
	            	<a href="#!" class="btn btn-md u-btn-3d u-btn-darkgray g-px-25 g-py-13" data-bind="click: back">이전</a>
					<button class="btn btn-md u-btn-3d u-btn-blue g-px-25 g-py-13" type="button" role="button" data-bind="click:edit, visible:editable, invisible:editing" style="display:none;">수정</button>
					<#if SecurityHelper.isUserInRole("ROLE_ADMINISTRATOR") >
					<button class="btn btn-md u-btn-3d u-btn-red g-px-25 g-py-13" type="button" role="button" data-bind="click:delete, visible:editable, invisible:editing" style="display:none;">삭제</button>
					</#if>
					<button class="btn btn-md u-btn-3d u-btn-outline-blue g-px-25 g-py-13" type="button" role="button" data-bind="click:saveOrUpdate, visible:editing" style="display:none;">저장</button>
					<button class="btn btn-md u-btn-3d u-btn-outline-darkgray g-px-25 g-py-13" type="button" role="button" data-bind="click:cancle, visible:editing" style="display:none;">최소</button>															
	            </div> 
            </div> 
        	<!-- Ent Toolbar -->  
			<div class="row justify-content-between">
						<div class="col-lg-9">
							<div class="g-pr-20--lg g-my-15">
								<!-- Issue Blocks -->
								<article class="g-mb-100 g-font-size-15" id="issue-edit-form" data-bind="visible:visible" style="display:none;">
									<div class="g-mb-30">
										<span class="g-mb-20"> 계약기간 :<span class="text-warning g-ml-15 g-mb-10" data-bind="text:projectPeriod"></span></span>											
										<h2 class="h4 g-color-black g-font-weight-600 mb-3">						
											<a class="u-link-v5 g-color-black g-color-primary--hover" href="#!" data-bind="text:issue.summary, invisible:editing"></a>
										</h2> 
	 									<div class="form-group g-mb-20" data-bind="visible:editing">
	 										<h4 class="h6 text-light-gray text-semibold">요약 <span class="text-danger" >*</span></h4>	
								            <input type="text" name="issue-summary" class="form-control form-control-md" placeholder="간략하게 요약해주세요" data-bind="value: issue.summary" required validationMessage="요약정보를 입력하여주세요." />
								        </div>
								        
	 									<div class="form-group g-mb-20">
	 										<h4 class="h6 text-light-gray text-semibold">고객사 담당자</h4>	
								            <input type="text" name="issue-requestor-name" class="form-control" placeholder="고객사 담당자 이름을 입력하세요." 
								            	data-bind="value: issue.requestorName, enabled:editing" />
								        </div>								        
								        <div class="form-group g-mb-20">
	 										<h4 class="h6 text-light-gray text-semibold">과업 <span class="g-color-blue g-font-size-12">  특정 과업과 관련된 이슈인 경우 선택해 주세요.  </span></h4>	
								            <input name="task-type"
								               data-role="dropdownlist"   
											   data-placeholder="선택"
							                   data-auto-bind="true"
							                   data-text-field="taskName"
							                   data-value-field="taskId"
							                   data-bind="value:issue.task, source: taskDataSource, enabled:editing" 
							                   style="width:100%;"/>
								        </div>
										<div class="row">
								            <div class="col-sm-6">
								              <!-- Issue Type  -->
								              <div class="form-group g-mb-20">
								              <h4 class="h6 g-mb-5">요청구분 <span class="text-danger" data-bind="visible:editing">*</span></h4>
								              <input name="issue-type"
								               data-role="dropdownlist"  
								               placeholder = "어떤종류의 요청인지를 선택하여 주세요"
											   data-placeholder="어떤종류의 요청인지를 선택하여 주세요"
							                   data-auto-bind="true"
							                   data-value-primitive="true"
							                   data-text-field="name"
							                   data-value-field="code"
							                   data-bind="value:issue.issueType, source:issueTypeDataSource, enabled:editing"
							                   required data-required-msg="어떤 종류의 요청인지를 선택하여 주세요"
							                   style="width:100%;"/>
							                   <span class="k-widget k-tooltip k-tooltip-validation k-invalid-msg" data-for="issue-type" role="alert" style="display:none;"></span>	
							                   </div>						                    
								              <!-- End Issue Type -->
								            </div>					
								            <div class="col-sm-6">
								              <!-- Status -->
								              <div class="form-group g-mb-20">
								              <h4 class="h6 g-mb-5">상태</h4>
								              <input data-role="dropdownlist"  
											   data-placeholder="선택"
							                   data-auto-bind="true"
							                   data-value-primitive="true"
							                   data-text-field="name"
							                   data-value-field="code"
							                   data-bind="value:issue.status, source:statusDataSource, enabled:editingForAssignee"
							                   style="width: 100%;"/>
							                   </div>
								              <!-- End Status -->
								            </div>
								         </div>
								         <div class="row">
								            <div class="col-sm-6">
								              <!-- Priority Type  -->
								              <div class="form-group g-mb-20">
								              <h4 class="h6 g-mb-5">우선순위 <span class="text-danger" data-bind="visible:editing">*</span></h4>
								              <input data-role="dropdownlist"  
								               placeholder = "우선순위를 선택하여 주세요"
											   data-placeholder="선택"
							                   data-auto-bind="true"
							                   data-value-primitive="true"
							                   data-text-field="name"
							                   data-value-field="code"
							                   data-bind="value:issue.priority, source:priorityDataSource, enabled:editing"
							                   style="width: 100%;"/>	
							                    </div>
								              <!-- End Priority -->
								            </div>					
								            <div class="col-sm-6">
								              <!- Resolution -->
								              <div class="form-group g-mb-20">
								              <h4 class="h6 g-mb-5">결과</h4>
								              <input data-role="dropdownlist"  
											   data-placeholder="선택"
							                   data-auto-bind="true"
							                   data-value-primitive="true"
							                   data-text-field="name"
							                   data-value-field="code"
							                   data-bind="value:issue.resolution, source:resolutionDataSource, enabled:editingForAssignee"
							                   style="width: 100%;"/>
							                   </div>
								              <!-- End Resolution -->
								            </div>
								         </div>
										 <div class="row" data-bind="visible: isDeveloper" style="display:none;">
										 	<div class="col-sm-4">
								              <!-- Start Date  -->
								              <div class="form-group g-mb-20">
								              <h4 class="h6 g-mb-5">시작일</h4>
								              <input data-role="datepicker" data-bind="value: issue.startDate, visible: isDeveloper, enabled: editingForAssignee" style="width: 100%">
								               </div>
								              <!-- End Start Date -->
								            </div>	
								            <div class="col-sm-4">
								              <!-- Priority Type  -->
								              <div class="form-group g-mb-20">
								              <h4 class="h6 g-mb-5">완료예정일</h4>
								              <input data-role="datepicker" data-placeholder="완료예정일" data-bind="value: issue.dueDate, visible: isDeveloper, enabled: editingForAssignee" style="width: 100%">
								               </div>
								              <!-- End Priority -->
								            </div>					
								            <!-- Estimate Type  -->
								            <div class="col-sm-4">
								             	<div class="form-group g-mb-20">
								             		<h4 class="h6 g-mb-5">예상작업시간</h4>
										            <input data-role="numerictextbox" 
									                   data-min="0"
									                   data-max="100"
									                   data-bind="visible: isDeveloper,
									                              enabled: editingForAssignee,
									                              value: issue.estimate"
									                   style="width: 100%">
							                	</div>
								            </div>
								            <!-- End Estimate -->
								         </div>		
								         <div class="row" data-bind="visible: isDeveloper" style="display:none;">  
								         	<div class="col-sm-6">
								              <!- Resolution -->
								              <div class="form-group g-mb-20">
								              <h4 class="h6 g-mb-5">처리일자</h4>
								              <input data-role="datepicker" data-bind="value: issue.resolutionDate, visible: isDeveloper, enabled: editingForAssignee" style="width: 100%">
								               </div>
								              <!-- End Resolution -->
								            </div>
											<!-- TimeSpent Type  -->
								            <div class="col-sm-6">
								            	<div class="form-group g-mb-20">
								             		<h4 class="h6 g-mb-5">작업시간</h4>
									            	<input data-role="numerictextbox" 
								                   data-min="0"
								                   data-max="100"
								                   data-bind="visible: isDeveloper,
								                              enabled: editingForAssignee,
								                              value: issue.timeSpent"
								                   style="width: 100%">
							                   	</div>
								            </div>
								            <!-- End TimeSpent -->
								         </div>								         								         								         								         
								    </div>
									<div class="g-mb-30">     
										<div class="u-heading-v1-4 g-bg-main g-brd-gray-light-v2 g-mb-20">
					                     	<h2 class="h3 u-heading-v1__title g-mt-0 g-font-size-16">설명</h2>
										</div>
										<div id="issue-description-editor" class="hide"></div>
										<section class="g-mb-15 g-brd-2 g-brd-blue g-rounded-5 g-brd-around--lg g-pa-15 issue-body" data-bind="html:issue.description, invisible:editing"></section>
									</div>
									<div class="g-mb-30" data-bind="invisible:isNew" style="display:none;">
										<div class="u-heading-v1-4 g-bg-main g-brd-gray-light-v2 g-mb-20">
					                      	<h2 class="h3 u-heading-v1__title g-mt-0 g-font-size-16">첨부파일</h2>
										</div>
										<form action="" method="post" enctype="multipart/form-data" id="issue-attachment-dropzone" 
										class="u-dropzone g-rounded-5 g-brd-1 g-brd-gray-light-v3 g-brd-1 g-brd-style-dashed g-mb-20 g-pa-20 g-bg-gray-light-v6--hover g-brd-primary--hover g-color-black-opacity-0_8 g-color-black--hover"" data-bind="visible:editing">
												<div class="dz-default dz-message text-center">
					                       	 		<i class="icon-svg icon-svg-dusk-upload"></i>
					                       	 		<p class="note">업로드할 이슈 관련 첨부파일은 이곳에 드레그하여 놓아주세요.</p>
					                       	 	</div>       
					                       	 	<div class="dropzone-previews">                       	 
					                       	 	</div>                 
												 <div class="fallback">
												     <input name="file" type="file" multiple style="display:none;"/>
												 </div>
										</form>  
					                    <button class="btn u-btn-outline-blue g-mr-10 g-mb-15 pull-right" type="button" role="button" data-bind="click:back, visible:isNewAndSaved" style="">확인</button>	
							            <table class="table u-table--v2">
							            	<tbody id="issue-attachment-listview" class="no-border" style="min-height:50px;"></tbody>
										</table>
							               										
									</div>
								</article>
								
								
							</div>
							<!-- End Issue Blocks -->
						</div>
						<div class="col-lg-3 g-brd-left--lg g-brd-gray-light-v4">
							<div class="g-pl-15--lg g-my-15 g-font-size-14">
								<!-- Buttons  -->
								<div class="g-mb-50">
									<p class="">
									등록일 : <span class="g-color-gray-dark-v4 " data-bind="text: formatedCreationDate"></span>  
									</p>	  
									<p data-bind="invisible:isNew" class="" style="display:none;">
									수정일 : <span class="g-color-gray-dark-v4" data-bind="text: formatedModifiedDate"></span>  
									</p>	   
									<h3 class="h5 g-color-black g-font-weight-600 mb-4"></h3>
									<button class="btn u-btn-outline-blue g-mr-10 g-mb-15" type="button" role="button" data-bind="click:edit, visible:editable, invisible:editing" style="display:none;">수정</button>
									<button class="btn u-btn-outline-blue g-mr-10 g-mb-15" type="button" role="button" data-bind="click:saveOrUpdate, visible:editing" style="display:none;">저장</button>
									<button class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" type="button" role="button" data-bind="click:cancle, visible:editing" style="display:none;">최소</button>
								</div>
								<!-- End Links -->
								<hr class="g-brd-gray-light-v4 g-my-30">
								<!-- Assigner --> 
								<div class="g-transition-0_3">
									 
									<span class="u-label g-bg-black g-rounded-20 g-px-15 g-mr-10 g-mb-15 g-font-size-14 g-font-weight-400">담당자</span>
				                    <div class="media g-bg-white g-pa-5">
				                      <div class="d-flex g-width-40 g-height-40 mr-4">
				                        <img class="img-fluid g-brd-around g-brd-3 g-brd-gray-light-v3 rounded-circle g-width-40 g-height-40" data-bind="attr:{ src: assigneeAvatarSrc  }"  width="40" height="40" 
				                        	src="/images/no-avatar.png" alt="Image Description">
				                      </div>
				                      <div class="media-body">
				                        <h4 class="h6"><span class="g-color-black" data-bind="text:issue.assignee.name">미지정</span></h4> 
				                        <!--
				                        <span class="d-block g-color-gray-dark-v5 g-font-size-13 mb-1">&nbsp;</span>
				                        <span class="d-block g-font-size-13">Real Estate State</span>
				                        -->
				                        <div class="g-brd-top g-brd-gray-light-v3 g-pt-10 g-mt-10">
				                        	<button class="btn btn-sm u-btn-outline-indigo g-mb-15 g-mr-10 " type="button" role="button" data-bind="click:assignMe, invisible:isAssigned">나를 담당자로 지정합니다.</button>
				                        	
				                        	<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") > 
				                          	<span class="d-block g-font-size-13 g-mb-5">또는 이름 또는 아이디로 검색 후 지정합니다.</span>
				                          	<input data-role="combobox"
								                   		 data-placeholder="이름을 입력하세요."
														 data-filter="contains"
								                   		 data-text-field="name"
								                   	 	 data-value-field="username"
								                   	 	 data-autoBind: false,
								                   		 data-bind="value: issue.assignee, 
							                             source: userDataSource,
							                             visible: isDeveloper,
							                             enabled: editingForAssignee,
							                             events:{ change : selectAssignee }"
							                   			 style="width:100%;"/>	
							               <#else>
							               <#if __project?? >${ CommunityContextHelper.getCommunityAclService().getPermissionBundle(__project).admin?string } 
							               <span class="d-block g-font-size-13 g-mb-5">또는 이름 또는 아이디로 검색 후 지정합니다.</span>
				                          	<input data-role="combobox"
								                   		 data-placeholder="이름을 입력하세요."
														 data-filter="contains"
								                   		 data-text-field="name"
								                   	 	 data-value-field="username"
								                   	 	 data-autoBind: false,
								                   		 data-bind="value: issue.assignee, 
							                             source: userDataSource,
							                             visible: isDeveloper,
							                             enabled: editingForAssignee,
							                             events:{ change : selectAssignee }"
							                   			 style="width:100%;"/> 
							               </#if>
							               </#if>    			 
				                        </div>
				                      </div>
				                    </div> 
			                  	</div>
                  				<!-- End Assigner --> 		
                  				<!-- Repoter -->		
								<div class="g-mt-30">
									<span class="u-label g-bg-black g-rounded-20 g-px-15 g-mr-10 g-mb-15 g-font-size-14 g-font-weight-400">리포터</span>
				                    <div class="media g-bg-white g-pa-5">
				                      <div class="d-flex g-width-40 g-height-40 mr-4">
				                        <img class="img-fluid g-brd-around g-brd-3 g-brd-gray-light-v3 rounded-circle g-width-40 g-height-40" data-bind="attr:{ src: repoterAvatarSrc  }"  width="40" height="40" 
				                        	src="/images/no-avatar.png" alt="Image Description">
				                      </div>
				                      <div class="media-body">
				                        <h4 class="h6"><span class="g-color-black" data-bind="text:issue.repoter.name">미지정</span></h4> 
				                        <!--
				                        <span class="d-block g-color-gray-dark-v5 g-font-size-13 mb-1">&nbsp;</span>
				                        <span class="d-block g-font-size-13">Real Estate State</span>
				                        -->
				                        <div class="g-brd-top g-brd-gray-light-v3 g-pt-10 g-mt-10">
				                        	<span class="d-block g-font-size-13 g-mb-5">또는 이름 또는 아이디로 검색 후 지정합니다.</span>
				                          	<input data-role="combobox"
						                   		 data-placeholder="리포터 이름을 입력하세요."
												 data-filter="contains" 
						                   		 data-text-field="name"
						                   	 	 data-value-field="username"
						                   		 data-bind="value:issue.repoter, 
					                              source: userDataSource,
					                              visible: isDeveloper,
					                              enabled: editingForAssignee,
					                              events:{ change : selectRepoter }"
					                   			 style=""/>	 
				                        </div>
				                      </div>
				                    </div> 
			                  	</div>	 
								<!-- End Repoter -->
								<hr class="g-brd-gray-light-v4 g-my-50">
								<!-- Tags -->
								<div class="g-mb-40">
									<h3 class="h5 g-color-black g-font-weight-600 mb-4"></h3>
									<!--
									<ul class="u-list-inline mb-0">
									<li class="list-inline-item g-mb-10">
									<a class="u-tags-v1 g-color-gray-dark-v4 g-color-white--hover g-bg-gray-light-v5 g-bg-primary--hover g-font-size-12 g-rounded-50 g-py-4 g-px-15" href="#!">Design</a>
									</li>
									</ul>-->
									<!-- Buttons  -->
									<div class="g-mb-50">
										<button class="btn u-btn-outline-blue g-mr-10 g-mb-15" type="button" role="button" data-bind="click:edit, visible:editable, invisible:editing" style="display:none;">수정</button>
										<button class="btn u-btn-outline-blue g-mr-10 g-mb-15" type="button" role="button" data-bind="click:saveOrUpdate, visible:editing" style="display:none;">저장</button>
										<button class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" type="button" role="button" data-bind="click:cancle, visible:editing" style="display:none;">최소</button>
									</div>
									<!-- End Links -->
								</div>
								<!-- End Tags -->
							</div>
						</div>
			</div>                		
            <!-- END ISSUE --> 
			<div class="g-mb-30" data-bind="invisible:isNew" style="display:none;">
				<div class="u-divider u-divider-solid g-brd-gray-light-v3 g-brd-3 g-mb-30">
					<i class="fa fa-circle u-divider__icon g-bg-white g-color-gray-light-v3"></i>
				</div>	
				<div class="g-pa-15">	              																	
									<!-- Nav tabs --> 
									<ul class="g-font-size-16 nav u-nav-v5-3 g-brd-bottom--md g-brd-gray-light-v4 g-font-weight-400" role="tablist" data-target="nav-5-3-default-hor-left-border-bottom" data-tabs-mobile-type="slide-up-down" data-btn-classes="btn btn-md btn-block rounded-0 u-btn-outline-lightgray"> 
										<li class="nav-item"> 
											<a class="nav-link active" data-toggle="tab" href="#nav-5-3-default-hor-left-border-bottom--1" role="tab">댓글</a> 
										</li> 
										<li class="nav-item"> 
											<a class="nav-link" data-toggle="tab" href="#nav-5-3-default-hor-left-border-bottom--2" role="tab">활동</a> 
										</li> 
										<li class="nav-item"> 
											<a class="nav-link" data-toggle="tab" href="#nav-5-3-default-hor-left-border-bottom--3" role="tab">속성</a> 
										</li> 
									</ul> 
									<!-- End Nav tabs --> 
								
								<!-- Tab panes --> 
								<div id="nav-5-3-default-hor-left-border-bottom" class="tab-content g-pt-20"> 
								
									<div class="tab-pane fade show active" id="nav-5-3-default-hor-left-border-bottom--1" role="tabpanel"> 
										<div class="text-right g-brd-gray-light-v3 g-brd-0 g-brd-top-0 g-brd-left-0 g-brd-right-0 g-brd-style-solid">
											<a href="#!" class="btn u-btn-3d u-btn-darkgray g-mr-10 g-mb-15" data-kind="comment" data-action="create" data-target="#issue-comment-listview" data-object-id="0" data-parent-comment-id="0">
												<span class=""><i class="icon-bubble g-mr-3"></i>댓글쓰기</span>
											</a>
										</div>		
																	
										<div id="issue-comment-listview" class="no-border" style="min-height:50px;"></div>
									
									</div> 
									<div class="tab-pane fade" id="nav-5-3-default-hor-left-border-bottom--2" role="tabpanel"> 
									<p class="g-font-size-14">아직 지원하지 않는 기능입니다.</p>
									</div> 
									<div class="tab-pane fade" id="nav-5-3-default-hor-left-border-bottom--3" role="tabpanel"> 
									<p class="g-font-size-14">아직 지원하지 않는 기능입니다.</p>
									</div> 
 
								</div> 
								<!-- End Tab panes --> 
								

				</div>      					
			</div>  
        </div>
	</section>			
	<!-- FOOTER START -->   
	<#include "includes/user-footer.ftl">
	<!-- FOOTER END -->  				

	<!-- issue comment modal -->
	<div class="modal fade comment-composer" id="issue-comment-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="colored-line"></div>
				<div class="modal-header ">
					<h2 class="modal-title">
						<img src="/images/no-avatar.png" data-bind="attr:{ src: autherAvatarSrc }" class="d-flex g-width-35 g-height-35 rounded-circle mr-2" />
					</h2>				
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
					</button>
				</div>
				<div class="modal-body g-pa-0">
					<div class="text-editor"> 	            
			            <div id="issue-comment-body" contenteditable="true" ></div>	   	            
				    </div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" data-bind="{click:save}">확인</button>
				</div>
			</div>
		</div>
	</div>	
	<!-- issue editor modal -->
	<div class="modal fade" id="issue-editor-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
			        </button>
			        <h2 class="modal-title">
			        		<i class="icon-svg icon-svg-sm icon-svg-dusk-close-sign" data-bind="visible:isClosed"></i>
			        		<i class="icon-svg icon-svg-sm icon-svg-dusk-open-sign" data-bind="visible:isOpen"></i> 
			        		기술지원요청
			        	</h2>
		      	</div><!-- /.modal-content -->
				<div class="modal-body">				
				 <form>
				 	<h4 class="text-light-gray text-semibold">요청구분 <span class="text-danger" data-bind="visible:editable" >*</span></h4>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="value:issue.issueType, source:issueTypeDataSource, enabled:editable"
		                   style="width:100%;"/>	
		                   		        	  
					</div>	
					
					<!-- issue summary start -->
					<h4 class="text-light-gray text-semibold">요약 <span class="text-danger" data-bind="visible:editable">*</span></h4>		
					<div data-bind="text:issue.summary, invisible:editable" class="g-mb-15 g-brd-2 g-brd-bluegray g-rounded-5 g-brd-around--lg g-pa-15"></div>	
					
				 	<div class="form-group" data-bind="visible:editable">
			            <input type="text" class="form-control" placeholder="요약" data-bind="value: issue.summary">
			        </div> 	
					<!-- issue summary start -->

					<div class="form-group">			
						<div class="row">
						  	<div class="col-sm-6">
						  		<h4 class="text-light-gray text-semibold">리포터</h4>		
						  		<div data-bind="text:issue.repoter.name"></div>
						  	</div>
						    <div class="col-sm-6">
						    		<span class="help-block m-b-none">이름으로 검색하고 선택하면 리포터가 지정됩니다.</span>
						    		<input data-role="combobox"
		                   		 data-placeholder="리포터 이름을 입력하세요."
								 data-filter="contains" 
		                   		 data-text-field="name"
		                   	 	 data-value-field="username"
		                   		 data-bind="value: issue.repotes,
	                              source: userDataSource,
	                              visible: isDeveloper,
	                              enabled: editable"
	                   			 style="width: 100%"/>
						  	</div>
					  	</div>   
					</div>	

					<div class="form-group">			
						<div class="row">
						  	<div class="col-sm-6">
						  		<h4 class="text-light-gray text-semibold">담당자</h4>		
						  		<div data-bind="text:issue.assignee.name"></div>
						  	</div>
						    <div class="col-sm-6">
						    		<span class="help-block m-b-none">이름으로 검색하고 선택하면 담당자가 지정됩니다.</span>
						    		<input data-role="combobox"
		                   		 data-placeholder="담당자 이름을 입력하세요."
								 data-filter="contains"
		                   		 data-text-field="name"
		                   	 	 data-value-field="username"
		                   		 data-bind="value: issue.assignees,
	                              source: userDataSource,
	                              visible: isDeveloper,
	                              enabled: editable"
	                   			 style="width: 100%"/>
						  	</div>
					  	</div>   
					</div>						

					<!-- issue descripton start -->
					<h4 class="text-light-gray text-semibold">상세 내용 <span class="text-danger" data-bind="visible:editable">*</span></h4>	
					<div data-bind="html:issue.description, invisible:editable" class="g-mb-15 g-brd-2 g-brd-blue g-rounded-5 g-brd-around--lg g-pa-15"></div>
					
					<div class="text-editor" class="hide"></div>
					
	 				<!-- issue descripton end -->	
	 				
	 				<h4 class="text-light-gray text-semibold g-mt-20" data-bind="visible: isDeveloper">예정일</h4>	
					<input data-role="datepicker" data-bind="value: issue.dueDate, visible: isDeveloper, enabled: editable" style="width: 100%">
						  		 
	 										
					<h4 class="text-light-gray text-semibold g-mt-15">우선순위 <span class="text-danger" data-bind="visible:editable">*</span></h4>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="value:issue.priority, source:priorityDataSource, enabled:editable"
		                   style="width: 100%;"/>			        	  
					</div>
					 					
					<h4 class="text-light-gray text-semibold">지원방법</h4>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="source:methodsDataSource, visible: isDeveloper, enabled:editable"
		                   style="width: 100%;"/>
					</div>	

						
					<div class="row" >
						<div class="col-sm-6">
							<h4 class="text-light-gray text-semibold">처리결과</h4>
							<div class="form-group">
								<input data-role="dropdownlist"  
								   data-placeholder="선택"
				                   data-auto-bind="true"
				                   data-value-primitive="true"
				                   data-text-field="name"
				                   data-value-field="code"
				                   data-bind="visible: isDeveloper,value:issue.resolution, source:resolutionDataSource, enabled:editable"
				                   style="width: 100%;"/>
							</div>
						</div>
						<div class="col-sm-6">				
							<h4 class="text-light-gray text-semibold">처리일자</h4>
							<input data-role="datepicker" data-bind="value: issue.resolutionDate, visible: isDeveloper, enabled: editable" style="width: 100%">
						</div>
					</div>	
					<h4 class="text-light-gray text-semibold">상태</h4>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="visible: isDeveloper,value:issue.status, source:statusDataSource, enabled:editable"
		                   style="width: 100%;"/>
					</div>																													
				</form>   
				
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal" data-bind="visible:editable" >취소</button>
					<button type="button" class="btn btn-primary" data-bind="click:saveOrUpdate, visible:editable">확인</button>
					
					<button type="button" class="btn btn-default" data-dismiss="modal" data-bind="invisible:editable">취소</button>		
					<button type="button" class="btn btn-primary" data-bind="invisible:editable,click:edit">수정</button>			
				</div>
			</div>
		</div>
	</div>	
	<script type="text/x-kendo-template" id="template">
                    <tr>
                      <td class="align-middle text-center">
                      ISSUE-#: issueId # 	
                      </td>
                      <td class="align-middle">
                     <a class="btn-link text-wrap g-font-weight-200 g-font-size-20" href="javascript:void();" data-action="edit" data-object-id="#= issueId #" data-action-target="issue" > #: summary # </a>
                      </td>
                      <td class="align-middle">#: issueTypeName #</td>
                      <td class="align-middle">#: priorityName #</td>
                      <td class="align-middle">
                      	#if ( repoter.userId > 0 ) {#
                      	#= community.data.getUserDisplayName( repoter ) #
                      	#} else {#
                      		
                      	#}#
                      </td>
                      <td class="align-middle">
                      	#if ( assignee.userId > 0 ) {#
                      	#= community.data.getUserDisplayName( assignee ) #
                      	#} else {#
                      	미지정
                      	#}#
                      </td>
                      <td class="align-middle">
                       #if ( statusName != null ){# 
                       #: statusName #
                       #}#
                      </td>
                      <td class="align-middle">
                      #if( resolutionName != null){#
                      #: resolutionName #
                      #}#
                      </td>
                      <td class="align-middle">#if (dueDate != null){ # #: community.data.getFormattedDate( dueDate , 'yyyy-MM-dd') # #}#</td>
                      <td class="align-middle">#: community.data.getFormattedDate( creationDate , 'yyyy-MM-dd') #</td>
                    </tr>
	</script>
		
	<!-- issue comment template -->
	<script type="text/x-kendo-template" id="comment-template">
	<div class="social-talk p-xxs">
		<div class="media social-profile clearfix g-pa-15">
			<a class="pull-left">
				<img class="d-flex g-width-40 g-height-40 rounded-circle mr-2" width="40" height="40" src="#= community.data.getUserProfileImage( user ) #" alt="profile-picture">
			</a>
			<div class="media-body">
				<div class="g-mb-5">
                    <h5 class="h5 g-color-gray-dark-v1 mb-0 g-font-size-14">#= community.data.getUserDisplayName( user ) #</h5>
                    <span class="g-color-gray-dark-v4 g-font-size-12">#: kendo.toString( new Date(creationDate), "g") #</span>
                 </div> 
				<div class="g-py-10 g-font-size-14">
              	#= body #	
				</div> 						
				<ul class="list-inline d-sm-flex my-0 g-font-size-14">
					<li class="list-inline-item g-mr-20">
					<a class="u-link-v5 g-color-gray-dark-v4 g-color-primary--hover g-font-weight-400" href="\\#!"  data-kind="comment" data-action="list" data-object-id="#:objectId#" data-comment-id="#:commentId#" data-target="\\#message-#:objectId#-comment-#:commentId#-listview" aria-expanded="false" aria-controls="message-#:objectId#-comment-#:commentId#-listview"> <i class="icon-bubbles"></i> 답글보기 (<span>#: replyCount #</span>)</a>
					</li>
					<li class="list-inline-item g-mr-20">
					<a class="u-link-v5 g-color-gray-dark-v4 g-color-primary--hover g-font-weight-400" href="\\#!"  data-kind="comment" data-action="create" data-object-id="#: objectId #" data-parent-comment-id="#: commentId#" ><i class="icon-bubble"></i> 답글쓰기</a>	
					</li>
				</ul>
				<div class="collapse no-border comment-reply" id="message-#:objectId#-comment-#:commentId#-listview">
				</div>		
			</div>
		</div>
	</div>	
	</script>  
    <script type="text/x-kendo-template" id="attachment-template">   
	<tr>
		<td class="align-middle text-center" width="50">		
			#if ( contentType.match("^image") ) {#	
			<img class="g-width-50 g-height-50" src="#= community.data.getAttachmentThumbnailUrl( data, true) #" />
			# }else if( contentType === "application/pdf" || contentType === "application/vnd.openxmlformats-officedocument.presentationml.presentation" ){ #	
			<img class="g-brd-around g-brd-gray-light-v4 g-width-50 g-height-50" src="#= community.data.getAttachmentThumbnailUrl( data, true) #" />
			# } else { #			
				<i class="icon-svg icon-svg-sm icon-svg-dusk-attach m-t-xs"></i>
			# } #
		</td> 
		<td class="align-middle">
			<a class="btn btn-xs icon-svg-btn" href="#: community.data.getAttachmentUrl(data) #" target="_blank" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="첨부파일 다운로드">
				<i class="icon-svg icon-svg-xs m-t-xs icon-svg-dusk-desktop-download"></i>
			</a>
			#: name # 
		</td>
		<td class="align-middle text-right"><span class='text-muted'>#: formattedSize() #</span></td>
	</tr>            	        	        	
	</script>  
       		     		     		
</body>     		 
</html>
</#compress>
