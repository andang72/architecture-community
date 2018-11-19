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
   	<link href="<@spring.url "/css/bootstrap/4.1.3/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	
   	
	<!-- Professional Kendo UI --> 	 
	<link href="<@spring.url "/css/bootstrap.theme/unify-bootstrap-v4/all.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/kendo/2018.3.1017/kendo.bootstrap.mobile.min.css"/>" rel="stylesheet" type="text/css" />	
   
   	<!-- Fonts & Icons CSS -->
	<link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/fonts/nanumgothic.min.css"/>" rel="stylesheet" type="text/css" />		
	<link href="<@spring.url "/css/community.ui/community.ui.icons.min.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/animate/animate.min.css"/>" rel="stylesheet" type="text/css" />	
		
	<!-- Dzsparallaxer CSS -->
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/dzsparallaxer.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/dzsscroller/scroller.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/advancedscroller/plugin.css"/>" rel="stylesheet" type="text/css" />	
					
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
			"hs.hamburgers" : { "deps" :['jquery', 'hs.core'] },
			"hs.dropdown" : { "deps" :['jquery', 'hs.core'] },
	        "dzsparallaxer" : { "deps" :['jquery'] },
	        "dzsparallaxer.dzsscroller" : { "deps" :['jquery', 'dzsparallaxer' ] },
			"dzsparallaxer.advancedscroller" : { "deps" :['jquery', 'dzsparallaxer' ] }	
	    },
		paths : {
			"jquery"    				: "/js/jquery/jquery-3.3.1.min",
			"jquery.cookie"    			: "/js/jquery.cookie/1.4.1/jquery.cookie",
			"bootstrap" 				: "/js/bootstrap/4.1.3/bootstrap.bundle.min",
			<!-- Professional Kendo UI --> 
			"kendo.web.min"	 			: "/js/kendo/2018.3.1017/kendo.web.min",
			"kendo.culture.min"			: "/js/kendo/2018.3.1017/cultures/kendo.culture.ko-KR.min",	
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
			"hs.dropdown" 	   				: "/assets/js/components/hs.dropdown",
			<!-- Dzsparallaxer -->		
			"dzsparallaxer"           	: "/assets/vendor/dzsparallaxer/dzsparallaxer",
			"dzsparallaxer.dzsscroller"	: "/assets/vendor/dzsparallaxer/dzsscroller/scroller",
			"dzsparallaxer.advancedscroller"	: "/assets/vendor/dzsparallaxer/advancedscroller/plugin",
			"polyfills"							: "/js/polyfills/EventSource"
		}
	});
	
	require([ 
		"jquery", "bootstrap", 
		"community.data", "kendo.messages.min",
		"hs.header", "hs.hamburgers", 'hs.dropdown', 
		'dzsparallaxer.advancedscroller',
		'polyfills' ], function($, kendo ) {	

		// init header 
		$.HSCore.components.HSHeader.init($('#js-header'));	
		$.HSCore.helpers.HSHamburgers.init('.hamburger');
		
		// initialization of HSDropdown component
      	$.HSCore.components.HSDropdown.init($('[data-dropdown-target]')); 
      			
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
           		
		var observable = new community.ui.observable({ 
			currentUser : new community.model.User(),
			isDeveloper : false,
			enabled : false,
			visible : false,
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
				$this.set('isDeveloper', isDeveloper());
				$this.set('enabled', true);
				<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >	
				createNotification($this);				
				</#if>
			},
			notificationEnabled : false,
			requestPermission : function (){ 
				var $this = this;
				console.log('request permission..');
				Notification.requestPermission(function (result) { 
			        //요청을 거절하면,
			        if (result === 'denied') {
			       		$this.set('notificationEnabled' , false );
			            return;
			        }
			        //요청을 허용하면,
			        else {
			        	$this.set('notificationEnabled' , true );
			            return;
			        }
			    }); 
			},
			goStats : function () {
			
			},
			contractorDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/CONTRACTOR/list.json" />' , {} ),
			contractDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/PROJECT/list.json" />' , {} ),
			projectsDataSource : community.ui.datasource_v4( '<@spring.url "/data/api/v1/projects/list_v2.json"/>' , {
				schema: {
					total: "totalCount",
					data: "items",
					model: community.model.Project
				}
			} ),
			filter : {
				PROJECT_CONTRACTOR : null,
				PROJECT_CONTRACT : null,
				NAME : null,
				ID : null
			},
			clearFilters : function(){
				var $this = this ;
				$this.set('filter.PROJECT_CONTRACTOR' , null ) ;
				$this.set('filter.PROJECT_CONTRACT' , null ) ;
				$this.set('filter.NAME' , null ) ;
				$this.set('filter.ID' , null ) ;
				$this.dataSource.filter( [] );
			},
			applyFilters : function(){
				var $this = this , filters = [];
				if( $this.filter.PROJECT_CONTRACT != null ){
					filters.push({ field: "contractState", operator: "eq", value: $this.filter.PROJECT_CONTRACT });
				}else if ($this.filter.NAME != null ){
					filters.push({ field: "name", operator: "contains", value: $this.filter.NAME });
				}else if ($this.filter.ID != null ){
					filters.push({ field: "projectId", operator: "eq", value: $this.filter.ID });
				}else if ($this.filter.PROJECT_CONTRACTOR != null ){
					filters.push({ field: "contractor", operator: "eq", value: $this.filter.PROJECT_CONTRACTOR });
				}
				community.ui.listview($('#project-listview')).dataSource.filter( filters ); 
			},
			/** Issue Grid Filters */
			filter2 : {
				ASSIGNEE_TYPE : "1",
				TILL_THIS_WEEK : true,
				STATUS_ISNULL : false
			},
			doFilter2 : function(){ 
				var $this = this , filters = [];
				var grid = $('#issue-grid'); 
				if( observable.filter2.STATUS_ISNULL ){
					filters.push({ logic: "AND" , filters:[{ field: "ISSUE_STATUS", operator: "neq", value: "005" },{field: "ISSUE_STATUS", operator: "eq", logic: "OR" } ] } );
				}else{
					filters.push({ logic: "AND" , filters:[{ field: "ISSUE_STATUS", operator: "neq", value: "005" }]});
				}
				filters.push({ field: "assigneeType", operator: "eq", value: $this.filter2.ASSIGNEE_TYPE, logic: "AND" });
				community.ui.grid(grid).dataSource.filter( filters );
				return false;
			}
    	}); 
    	
    	
    	observable.bind("change", function(e) { 
    			if( e.field == 'filter.PROJECT_CONTRACT' || e.field == 'filter.NAME' || e.field == 'filter.ID' || e.field == 'filter.PROJECT_CONTRACTOR' ) {
    				observable.applyFilters();
    			}else if (e.field == 'filter2.ASSIGNEE_TYPE' || e.field == 'filter2.TILL_THIS_WEEK' || e.field == 'filter2.STATUS_ISNULL'){
    				observable.doFilter2();  				
    			}
    	});
    	
    	var renderTo = $('#page-top');	
    	
		renderTo.on("click", "button[data-action=create], a[data-action=create], a[data-action=view], a[data-action=view2], button[data-action=overviewstats]", function(e){			
			var $this = $(this);
			var actionType = $this.data("action");		
			var objectId = $this.data("object-id");		
			if( actionType == 'view'){
				community.ui.send("<@spring.url "/display/pages/issues.html" />", { 'projectId': objectId });
				return;	
			}else if( actionType == 'view2'){
				community.ui.send("<@spring.url "/display/pages/issue.html" />", { 'issueId': objectId , url : "${__page.name}"});
				return;	
			}else if( actionType == 'overviewstats'){
				community.ui.send("<@spring.url "/display/pages/issue-overviewstats.html" />");
				return;	
			}
			return false;		
		});	
		
    		
    	
    	renderTo.data('model', observable);
    	community.ui.bind(renderTo, observable );	
    	community.ui.tooltip(renderTo); 
    	 
    	createContentTabs(observable);		 
	});
	
	function createContentTabs(observable){  
		$('#nav-tabstrip a[data-toggle="tab"]').on('show.bs.tab', function (e) {
			var url = $(this).attr("href"); // the remote url for content
			var target = $(this).data("target"); // the target pane
			var tab = $(this); // this tab
			 
			if(url === '#nav-issues'){
				createIssueGrid(observable)
			}else if (url === '#nav-projects'){ 
				createProjectListView(observable);		
			} 
		}); 
		observable.set('visible', true );
		// Select first tab
		var index = 1 ;
		<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >	
		if (window.location.hash === '#nav-projects'){
			index = 2 ; 
		} 
		</#if>
		$('#nav-tabstrip a[data-toggle="tab"]:nth-child('+ index +')').tab('show');
	}

	var iconDataURI = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAKBJREFUeNpiYBjpgBFd4P///wJAaj0QO9DEQiAg5ID9tLIcmwMYsDgABhqoaTHMUHRxpsGYBv5TGqTIZsDkYWLo6gc8BEYdMOqAUQeMOoAqDgAWcgZAfB9EU63SIAGALH8PZb+H8v+jVz64KiOK6wIg+ADEArj4hOoCajiAqMpqtDIadcCoA0YdQIoDDtCqQ4KtBY3NAYG0csQowAYAAgwAgSqbls5coPEAAAAASUVORK5CYII=";

	function createNotification(observable){  	
		console.log('show notification... : ' + observable.get('notificationEnabled') );
		console.log("create notification..");
		if(window.Notification){
			if( Notification.permission == 'denied' ){
				observable.set('notificationEnabled', false);
			}else{
				observable.set('notificationEnabled', true);
			}	
		}	 
		var storage = {};
		if( localStorage.getItem('NotificationList') != null ){
			if( Object.keys( JSON.parse(localStorage.getItem('NotificationList')) ).length > 1000 ){
				localStorage.setItem('NotificationList', "{}");
			}else{
				storage = JSON.parse(localStorage.getItem('NotificationList'));
			}
		}else{
			localStorage.setItem('NotificationList', "{}");
		}
		
		var values = [];
		if (Object.values) {
			values = Object.values( storage ) ;		
		} else {
			values = Object.keys(storage).map(function(e) {
			  return storage[e];
			});
		}
		
		$.each( values , function( index , value ){
        	showNotification( value ); 
		}); 
		
		const eventSource = new EventSource('/data/api/v1/notifications/issue.json'); 
		eventSource.onmessage = function(e) { 
			var obj = JSON.parse(e.data);
			if(observable.get('notificationEnabled')){
				var _eventType = obj.eventType;
				var title = "";
				var template1 = kendo.template($("#notification-title-template").html());
				var template2 = kendo.template($("#notification-body-template").html());		
				var notification = new Notification( template1(obj), { body: template2(obj), icon: iconDataURI });	
				var url = 'issue.html?projectId=' + obj.source.objectId + '&issueId=' + obj.source.issueId;
				console.log( url );
	 			if( obj.eventType === 'ISSUE' ){		
		 			notification.onclick = function (){
		 				window.open(url);
		 			};
	 			} 
			}else{
				showNotification(obj); 
			}
	        return;			
		}  
	} 
	
	function showNotification(obj){
		var _eventType = obj.eventType;
		var _now = new Date();
		var template = kendo.template($("#notification-template").html());
		var title = "";
		if( obj.state == 'CREATED' ){
			title = "신규 이슈 알림";
		}else {
			title = "이슈 변경 알림";
		}  	 
		if( _eventType === 'EMAIL' ){
			title = "새로운 메일이 있습니다";
			_now = new Date( obj.source.sentDate );
			title = title + " : " + _now.toLocaleTimeString() ;
		}else{   
			title = title + " : " + _now.toLocaleTimeString() ;
		}  
		
		var storage = JSON.parse(localStorage.getItem('NotificationList'));
        storage[obj.timestamp] = obj;
		localStorage.setItem('NotificationList', JSON.stringify(storage));  
		
		community.ui.notification({ 
			autoHideAfter:0, 
			allowHideAfter: 0,
			width : 500,
			hide : function (e){	 
				var _timestamp = $(e.element).find('.notification-info').data('timestamp'); 
				if( community.data.storageAvailable ('localStorage') ){		
					var _storage = JSON.parse(localStorage.getItem('NotificationList'));
					delete _storage[_timestamp];
					//console.log( JSON.stringify(_storage) );
					localStorage.setItem('NotificationList', JSON.stringify( _storage )); 
				} 
			},
			templates : [{
				type : "alert",
				template : '<div class="notification-info g-font-size-13 g-pa-10" data-timestamp="#= timestamp #">#if(title){#<div class="notification-title g-font-weight-400">#= title #</div>#}#<div class="notification-message">#= message #</div></div>'
			}]
		}).show({ title:title, 'message': template(obj), time: _now.toLocaleTimeString(), timestamp : obj.timestamp },"alert");	
	}
 
	 
	function send ( data ) {
		community.ui.send("<@spring.url "/display/pages/issues.html" />", { projectId: data.projectId });
	}
 
 	/**
 	* 코드 값에 해당하는 계약자 이름을 리턴합니다.
 	*/
	function getContractorName(code){
		var name = "";
		if( code == null )
			return "";
		var renderTo = $('#page-top');
		$.each( renderTo.data("model").contractorDataSource.data(), function( index, value ){
			if( value.code == code )
			{
				name = value.name;
				return ;
			}
		} );
		return name;
	}
			
	function createProjectListView(observable){
		var renderTo = $('#project-listview');
		if( !community.ui.exists(renderTo) ){ 
			community.ui.listview( renderTo , {
				dataSource: community.ui.datasource('<@spring.url "/data/api/v1/projects/list.json"/>', {
					transport:{
						read:{
							contentType: "application/json; charset=utf-8"
						},
						parameterMap: function (options, operation){		
							options.data = options.data || {} ;
							options.data.enabled = true;
							return community.ui.stringify(options)
						} 			
					},	
					serverPaging:false,
					pageSize : 100,
					schema: {
						total: "totalCount",
						data: "items",
						model: community.model.Project
					}
				}),
				template: community.ui.template($("#template").html())
			}); 
		}	
	}

	function getFirstDayOfWeek(){
		var now = new Date();	
		var day = now.getDay(), diff = now.getDate() - day + (day == 0 ? -6 : 1 ); 
		return new Date(now.setDate(diff));
	}
	
	function getLastSaturday(){
		var now = getFirstDayOfWeek();
		return new Date(now.setDate(now.getDate() - 2));
	}
	
	function getThisFriday(){
		var now = new Date();	
		var day = now.getDay(), diff = now.getDate() - day + 5; 
		return new Date(now.setDate(diff));
	}
	
	function createIssueGrid(observable){
	
		var renderTo = $('#issue-grid');	 	
		if( !community.ui.exists(renderTo) ){
			console.log("create grid for issues.");
			var firstTime = true;
			var grid = community.ui.grid( renderTo , {	
				dataSource: community.ui.datasource('<@spring.url "/data/api/v1/issues/list.json"/>', {
					transport:{
						read:{ contentType: "application/json; charset=utf-8" },
						parameterMap: function (options, operation){	
							options.data = options.data || {} ;
							options.data.TILL_THIS_WEEK = observable.filter2.TILL_THIS_WEEK;
							return community.ui.stringify(options);
						} 			
					},
					serverPaging: true,
					serverSorting: true,
					serverFiltering:true,	
					filter: { filters: [
						{ field: "ISSUE_STATUS", operator: "neq", value: "005",logic: "AND" },
						{ field: "assigneeType", operator: "eq", value: "1",logic: "AND" } 
					] },	
					schema: {
						total: "totalCount",
						data: "items"
					}
				}),
				dataBound: function() {		
			    },
			    pageable: { refresh: true }, 
				sortable: true,
				filterable: true,
				columns: [
					{ field: "ISSUE_ID", title: "ID", filterable: false, sortable: true , width : 100 , template: 'ISSUE-#: data.issueId #', attributes:{ class:"text-center" }},
					{ field: "CONTRACTOR", title: "계약자", filterable: false, sortable: true , width : 110, media: "(min-width: 1200px)", template: '#:getContractorName(data.project.contractor)#', attributes:{ class:"text-center" }},  
					{ field: 'PROJECT_ID', title: "프로젝트", filterable: false, sortable: true , width: 250, media: "(min-width: 1200px)",template: $('#project-column-template').html() },
					{ field: 'ISSUE_TYPE', title: "유형", filterable: false, sortable: true , width : 100 , template: '#: data.issueTypeName #', attributes:{ class:"text-center" }},
					{ field: 'SUMMARY', title: "이슈", filterable: false, sortable: false , template: $('#summary-column-template').html() },
					{ field: 'PRIORITY', title: "우선순위", filterable: false, sortable: true , width : 80 , media: "(min-width: 1200px)", template: '#: data.priorityName #', attributes:{ class:"text-center" }}, 
					{ field: 'ISSUE_STATUS', title: "상태", filterable: false, sortable: true , width : 80 , media: "(min-width: 992px)", template: '#: data.statusName #', attributes:{ class:"text-center" }}, 
					{ field: 'REPOTER', title: "리포터", filterable: false, sortable: true , width : 80 , media: "(min-width: 1200px)", template: $('#repoter-column-template').html(), attributes:{ class:"text-center" }},
					{ field: 'ASSIGNEE', title: "담당자", filterable: false, sortable: true , width : 80 , media: "(min-width: 992px)", template: $('#assignee-column-template').html(), attributes:{ class:"text-center" }},
					{ field: 'T1.DUE_DATE', title: "예정일", filterable: false, sortable: true , width : 100 , media: "(min-width: 1200px)", template: '#if (data.dueDate != null){ # #: community.data.getFormattedDate( data.dueDate , "yyyy-MM-dd") # #}#', attributes:{ class:"text-center" }},
					{ field: 'T1.CREATION_DATE', title: "등록일", filterable: false, sortable: true , width : 100 , media: "(min-width: 992px)", template: '#if (data.creationDate != null){ # #: community.data.getFormattedDate( data.creationDate , "yyyy-MM-dd") # #}#', attributes:{ class:"text-center" }}, 
				]
			});
       	 	renderTo.removeClass('k-widget');  
		}		
	}
	
	
	function createOrOpenIssueEditor( data ){
		var renderTo = $('#issue-editor-modal');
		if( !renderTo.data("model") ){
			var observable = new community.ui.observable({ 
				isNew : false,	
				isDeveloper : false,
				issue : new community.model.Issue(),
				projectDataSource   : community.ui.listview($('#project-listview')).dataSource,
				issueTypeDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/ISSUE_TYPE/list.json" />' , {} ),
				priorityDataSource  : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/PRIORITY/list.json" />' , {} ),
			 	methodsDataSource   : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/SUPPORT_METHOD/list.json" />' , {} ),
			 	resolutionDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/RESOLUTION/list.json" />' , {} ),
			 	statusDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/ISSUE_STATUS/list.json" />' , {} ),
			 	setSource : function( data ){
			 		var $this = this;
					var orgIssueId = $this.issue.issueId ;
					data.copy( $this.issue ); 
					if(  $this.issue.issueId > 0 ){
						$this.set('isNew', false );
					}else{
						$this.set('isNew', true );	
					}
					$this.set('isDeveloper', isDeveloper());
			 	},
				saveOrUpdate : function(e){				
					var $this = this;
					if( !$this.get('isDeveloper') && $this.issue.repoter.userId <= 0 )
					{
						$this.issue.repoter = $('#page-top').data('model').currentUser ;					
					}
					community.ui.progress(renderTo.find('.modal-content'), true);	
					community.ui.ajax( '<@spring.url "/data/api/v1/issues/save-or-update.json" />', {
						data: community.ui.stringify($this.issue),
						contentType : "application/json",						
						success : function(response){
							
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
		}	
		if( community.ui.defined(data) ) 
			renderTo.data("model").setSource(data);
		renderTo.modal('show');
	}
 
	function isDeveloper(){ 
		return $('#page-top').data('model').currentUser.hasRole('ROLE_DEVELOPER') ;
	} 
 			
	</script>	
	<style>
	
	.w-100{
		width: 100%!important;
	}
	
	.no-border {
	    border: 0!important;
	    -webkit-box-shadow: none!important;
	    box-sizing: unset!important;
	}
		
	.forum-info {
	    text-align: center;
	}	
	
	.forum-item {
	    margin: 10px 0;
	    padding: 10px 0 20px;
	    border-bottom: 1px solid #f1f1f1;
	}

	.forum-item small {
	    color: #999;
	}
	
	.forum-icon {
	    float: left;
	    width: 30px;
	    margin-top: .5rem;
	    margin-right: 20px;
	    text-align: center;
	}		
	
	.views-number {
	    font-size: 1.71429rem !important;
	    line-height: 18px;
	    font-weight: 400;
	}

	@media (max-width: 992px){
	.forum-info {
	    margin: 15px 0 10px 0;
	    display: none;
	}
	}
	.card {
	    position: relative;
	    display: -webkit-box;
	    display: -ms-flexbox;
	    display: flex;
	    -webkit-box-orient: vertical;
	    -webkit-box-direction: normal;
	    -ms-flex-direction: column;
	    flex-direction: column;
	    min-width: 0;
	    word-wrap: break-word;
	    background-color: #fff;
	    background-clip: border-box;
	    border: 1px solid rgba(0,0,0,.125);
	    border-radius: .25rem;
	}

	.k-grid-content {
		min-height: 600px;
	}
	.g-brd-bottom-1 {
		border-bottom-width: 1px !important;
		font-weight : 400;
	}
	.g-brd-bottom-3 {
		border-bottom-width: 1px !important;
		font-weight : 400;
	}
 
	.g-brd-top-1 {
	    border-top-width: 1px !important;
	    font-weight : 400;
	}
	
	
	#nav-tabstrip .nav-item.active {
		font-weight:600;
	}
	
	// Small devices (landscape phones, 576px and up)
	@media (min-width: 0) {
	
		#nav-tabstrip button { right: 15px; }
		
	}
	
	</style>	
</head>
<body id="page-top" class="landing-page no-skin-config">
	<!-- NAVBAR START -->   
	<#include "/community/includes/header.ftl">
	<!-- NAVBAR END -->   
	<section class="u-bg-overlay g-bg-cover g-bg-size-cover g-bg-bluegray-opacity-0_1--after dzsparallaxer auto-init height-is-based-on-content use-loading mode-scroll loaded dzsprx-readyall" data-options='{direction: "reverse", settings_mode_oneelement_max_offset: "150"}' >      
		<#if (__page.getBooleanProperty( "header.image.random", false) ) >
		<div class="divimage dzsparallaxer--target w-100 g-bg-pos-bottom-center" style="height: 120%; background-image: url( '<@spring.url "/download/images/" />${ CommunityContextHelper.getCustomQueryService().queryForString("COMMUNITY_CS.SELECT_IMAGE_ID_RANDOMLY" ) }' );"></div>
		<#else>
		<div class="divimage dzsparallaxer--target w-100 g-bg-pos-bottom-center" style="height: 120%; background-image: url(  /images/bg/endless_streets_by_andreasrocha-d3fhbhg.jpg );"></div>	
		</#if> 
        <div class="container text-center g-bg-cover__inner g-pt-100">
        <div class="row justify-content-center">
			<div class="col-lg-9">
            <div class="mb-5">
              <h1 class="g-color-white h1 mb-4"><#if __page?? >${__page.title}</#if></h1>
              <h2 class="g-color-white g-font-weight-400 g-font-size-18 mb-0 text-left" style="line-height: 1.8;"><#if __page?? >${__page.summary}</#if></h2>
            </div>
          	</div>
			</div> 
		</div><!-- /.row -->
		</div><!-- /.container -->
	</section>
 	<!-- tabs -->
	 <div class="u-shadow-v19 g-bg-gray-light-v5">
		<section class="container g-py-30 g-pos-rel"  data-bind="visible: visible" style="display:none;">
			<#if currentUser.anonymous >
			로그인이 필요한 서비스입니다.
			<#else>
			 <nav id="nav-tabstrip" class="g-font-weight-400">
			  <div class="nav justify-content-center text-uppercase u-nav-v5-1 u-nav-dark g-line-height-1_4" id="nav-tab" role="tablist">
			  	<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >
			    <a class="nav-item nav-link g-px-25" id="nav-home-tab" data-toggle="tab" href="#nav-issues" role="tab" aria-controls="nav-home" aria-selected="true"><i class="icon-finance-222 u-line-icon-pro"></i> 금주 나에게 배정된 업무</a>
			    </#if>
			    <a class="nav-item nav-link g-px-25" id="nav-profile-tab" data-toggle="tab" href="#nav-projects" role="tab" aria-controls="nav-profile" aria-selected="false"><i class="icon-sport-155 u-line-icon-pro"></i> 프로젝트</a>
			    <#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") > 
			    <button class="btn btn-md u-btn-darkred g-pos-abs" style="right:0px;" data-action="overviewstats" data-toggle="tooltip" data-placement="top" data-original-title="이슈 관련 통계 데이터를 확인할 수 있습니다." style="">통계</button>
				</#if>  
			  </div>
			</nav>	
			</#if>
		</section>
	</div>
	<!-- /.tabs -->
<div class="tab-content g-min-height-600" id="nav-tabContent">
	<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >
	<div class="tab-pane fade" id="nav-issues" role="tabpanel" aria-labelledby="nav-issues-tab" >  
	<section data-bind="visible:isDeveloper">
		<div class="u-shadow-v19 g-bg-gray-light-v5">
	    <div class="container">
	        <div class="row g-pt-25">
	            <div class="col-lg-12">
		            <div class="u-heading-v2-4--bottom g-mb-40">
					  <h2 class="text-uppercase u-heading-v2__title g-mb-10">금주 나에게 배정된 업무</h2>
					  <h4 class="g-font-weight-200">금주에 처리해야할 업무입니다. <span class="g-color-red">담당자가 지정되지 않은 이슈는 협의하여 담당자를 지정해주세요.</span> </h4>
					</div>
	            </div>
	        </div>
			<div class="row align-items-center g-pt-10 g-pb-10">
	          <!-- Category -->
	          <div class="col-md-6 col-lg-6 g-mb-30">
	            <h3 class="h6 mb-3">Filters:</h3> 
				<div class="g-font-weight-400">
	              <label class="form-check-inline u-check u-link-v5 g-color-gray-dark-v4 g-color-primary--hover g-pl-25 mb-0 mr-2">
	                <input class="g-hidden-xs-up g-pos-abs g-top-0 g-left-0" type="checkbox" data-bind="checked: filter2.TILL_THIS_WEEK" checked>
	                <span class="d-block u-check-icon-checkbox-v4 g-absolute-centered--y g-left-0">
	                  <i class="fa" data-check-icon=""></i>
	                </span>
	                금주에 할일만 포함
	              </label>
	              <label class="form-check-inline u-check u-link-v5 g-color-gray-dark-v4 g-color-primary--hover g-pl-25 mb-0 mx-2">
	                <input class="g-hidden-xs-up g-pos-abs g-top-0 g-left-0" type="checkbox" data-bind="checked: filter2.STATUS_ISNULL">
	                <span class="d-block u-check-icon-checkbox-v4 g-absolute-centered--y g-left-0">
	                  <i class="fa" data-check-icon=""></i>
	                </span>
	                진행상태가 없는 이슈 포함
	              </label> 
	            </div> 
	          </div>
          	  <!-- End Category --> 
	          <!--  Assignee -->
	          <div class="col-md-6 col-lg-6 g-mb-30">
	            <h3 class="h6 mb-3">Assignee:</h3> 
				<div class="btn-group btn-group-toggle" data-toggle="buttons">
					<label class="btn btn-md btn-secondary u-btn-3d">
					  <input type="radio" name="issueAssigneeFilter" value="0" autocomplete="off"  data-bind="checked:filter2.ASSIGNEE_TYPE">전체
					</label>
					<label class="btn btn-md btn-secondary u-btn-3d active">
					  <input type="radio" name="issueAssigneeFilter" value="1" autocomplete="off" data-bind="checked:filter2.ASSIGNEE_TYPE">내가 담당
					</label>
					<label class="btn btn-md btn-secondary u-btn-3d">
					  <input type="radio" name="issueAssigneeFilter" value="2" autocomplete="off"  data-bind="checked:filter2.ASSIGNEE_TYPE">타인이 담당
					</label>
					<label class="btn btn-md btn-secondary u-btn-3d">
					  <input type="radio" name="issueAssigneeFilter" value="3" autocomplete="off"  data-bind="checked:filter2.ASSIGNEE_TYPE">미배정
					</label>
				</div>           
	          </div>
	          <!-- End Assignee --> 
        	</div>
        </div>
        </div>
		<div class="g-bg-white">	
			<div class="container-fluid">        
	        	<div class="row features-block">
	        		<div id="issue-grid" class="g-brd-0 g-brd-gray-dark-v4 g-brd-top-3 g-brd-style-solid g-min-height-500" >
	        	</div> 
	        </div>
	    </div>
	</section>	
	</div>
	</#if> 
	<div class="tab-pane fade" id="nav-projects" role="tabpanel" aria-labelledby="nav-projects-tab">
	<section class="services">
		<div class="u-shadow-v19 g-bg-gray-light-v5" >
		<div class="container" data-bind="visible:isDeveloper" >
			<div class="row g-pt-25">
	            <div class="col-lg-12">
		            <div class="u-heading-v2-4--bottom g-mb-40">
					  <h2 class="text-uppercase u-heading-v2__title g-mb-10">프로젝트 & 유지보수</h2>
					  <h4 class="g-font-weight-200">프로젝트 이름을 클릭하면 등록된 이슈들을 열람할 수 있습니다.</h4>
					</div>
	            </div>
	        </div>
	        		
		<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >	
		<!-- Filters -->		
        <!-- Contractor -->
        <div class="row align-items-center g-pt-10 g-pb-10">
          <!-- Category -->
          <div class="col-md-6 col-lg-4 g-mb-30">
            <h3 class="h6 mb-3">계약자:</h3>
            <div class="form-group">
				<input data-role="combobox" 
					data-option-label="계약자를 선택하세요."
					data-placeholder="프로젝트 계약자를 선택하세요."
					data-value-primitive="true"
					data-auto-bind="true"
					data-text-field="name"
					data-value-field="code"
					data-bind="value: filter.PROJECT_CONTRACTOR, source: contractorDataSource"
					style="width: 100%;" />             
            </div>
          </div>
          <!-- End Contractor -->
          <!-- Contract -->
          <div class="col-md-6 col-lg-4 g-mb-30">
            <h3 class="h6 mb-3">계약상태:</h3>
            <div class="form-group">
 				<input data-role="combobox" 
				data-option-label="계약상태를 선택하세요."
				data-placeholder="프로젝트 계약상태를 선택하세요."
				data-value-primitive="true"
				data-auto-bind="true"
				data-text-field="name"
				data-value-field="code"
				data-bind="value: filter.PROJECT_CONTRACT, source: contractDataSource"
				style="width: 100%;" />             
            </div>
          </div>
          <!-- End Contract -->
          <!-- Project -->
          <div class="col-md-6 col-lg-4 g-mb-30">
            <h3 class="h6 mb-3">프로젝트:</h3>
            <div class="form-group">
 				<input data-role="combobox" 
				data-option-label="프로젝트를 선택하세요."
				data-placeholder="프로젝트를 선택하세요."
				data-value-primitive="true"
				data-auto-bind="true"
				data-text-field="name"
				data-value-field="projectId"
				data-bind="value: filter.ID, source: projectsDataSource"
				style="width: 100%;" />             
            </div>
          </div>
          <!-- End Project -->
        </div>
        <!-- End Filters -->
		</#if>
        <!-- Filters -->
        <div class="g-brd-y g-brd-gray-light-v4 g-pt-10 g-pb-10">
          <div class="row align-items-center">
            <!-- Project Name  -->
            <div class="col-md-6 col-lg-4 g-mb-30">
              <h2 class="h6 mb-3">프로젝트:</h2>            
			  <div class="form-group">
				 <input type="text" class="form-control" placeholder="프로젝트 이름을 입력하세요." data-bind="value:filter.NAME">
			  </div>               
            </div>
            <!-- End Project Name  --> 
            <div class="col-md-6 col-lg-4 g-mb-30">
              <h3 class="h6 mb-3"></h3>
            </div> 
            <!-- Buttons -->
			<div class="col-md-6 col-lg-4 g-mb-30 text-right">
              <ul class="list-inline mb-0">
                <li class="list-inline-item">
                  <button class="btn u-btn-outline-darkgray btn-md" type="button" role="button" role="button" 
					data-toggle="tooltip" data-placement="bottom" data-original-title="적용된 필터 조건을 초기화합니다." 
					data-object-id="0" data-bind="click:clearFilters" >초기화</button>
                </li>
              </ul>
            </div>            
            <!-- End Buttons -->
          </div>
        </div>
        <!-- End Filters -->
      	</div> 
      	<div class="g-bg-white  g-min-height-500 g-py-15 g-brd-0 g-brd-gray-dark-v4 g-brd-top-3 g-brd-style-solid g-min-height-50">
			<div class="container">            
				<div class="row justify-content-center">
					<div class="col-lg-12">
	                <#if !currentUser.anonymous >
					<div id="project-listview" class="no-border"></div>                      
					</#if>
					</div>
				</div>
			</div>	
		</div>	
	</section>	  
  
  
  
  </div>
  <div class="tab-pane fade" id="nav-stats" role="tabpanel" aria-labelledby="nav-stats-tab">
  
  
  

  
  
  
  </div>
</div>           
    <!-- ANNOUNCES -->
    <#assign announces = CommunityContextHelper.getAnnounceService().getAnnounces(0,0) />	
    <#if ( announces?size > 0 ) && SecurityHelper.isUserInRole("ROLE_DEVELOPER") >
	<section class="g-pt-50">
		<div class="container"> 
			<div class="row justify-content-center">
				<div class="col-md-12 align-self-md-center">
				<p class="lead g-mb-30"><i class="fa fa-bullhorn"></i> 새로운 공지가 있습니다.</p> 
										
				<#list announces as announce >
				<!-- Announce -->
				<div class="g-brd-around g-brd-gray-light-v4 g-brd-left-4 g-brd-blue-left g-line-height-1_8 g-rounded-3 g-pa-20 g-mb-30" role="alert">
				  <h3 class="g-color-blue g-font-weight-600"> ${announce.subject}</h3>
				  <p class="mb-0 g-font-size-20"> 
				  ${announce.body}
				  </p>
				</div>
  				<!-- End Announce -->				
				</#list>
				</div>	
			</div>	
		 </div>
	</section>					
    </#if>
    <!-- END ANNOUNCES --> 

	<!-- FOOTER START -->   
	<#include "includes/user-footer.ftl">
	<!-- FOOTER END -->   
	<script type="text/x-kendo-template" id="notification-title-template">
	#if(eventType === 'EMAIL'){ #
		새로운 메일이 있습니다 (from : #: source.from[0].address # )		
	# }else if (eventType === 'ISSUE') { #
		#if (source.assignee != null && source.assignee.userId > 0) { # #: source.assignee.name # 님 담당하는# } else { # 담당자가 미지정된# } # #if( state == 'CREATED') {# 새로운 이슈가 있습니다. # }else{ # 변경된 이슈가 있습니다. #}#
	#}#	
	</script>
	<script type="text/x-kendo-template" id="notification-body-template">
	#if(eventType === 'EMAIL'){ #
		#: source.subject # 
		${ CommunityContextHelper.getConfigService().getApplicationProperty("website.contact.email", "") } 메일을 확인하고 이슈를 등록해주세요.
	# }else if (eventType === 'ISSUE') { #
	#: source.summary #"
	(담당자는 꼭 확인 해주세요)
	#}#	
	</script>		
	<script type="text/x-kendo-template" id="notification-template">
	#if(eventType === 'EMAIL'){ #
		보낸사람: #: source.from[0].address # <br/>
		제목: <span class="text-wrap g-font-weight-400 g-color-blue">#: source.subject #<span><br/>
		<span class="g-color-red"> ${ CommunityContextHelper.getConfigService().getApplicationProperty("website.contact.email", "") } 메일을 확인하고 이슈를 등록해주세요. </span>
	# }else if (eventType === 'ISSUE') { #
	#if( state == 'CREATED') {#   
		#if (source.assignee != null && source.assignee.userId > 0) { # #: source.assignee.name # 님에게 # } else { # 담당자가 지정되지 않은 # } # 
		새로운 이슈 <br/> <a class="btn-link text-wrap g-font-weight-400 g-color-blue" href="issue.html?projectId=#= source.objectId #&issueId=#= source.issueId #" target="_blank"> #: source.summary #</a> 가 등록되었습니다.
	# }else{ #
		#if (source.assignee != null && source.assignee.userId > 0) { # #: source.assignee.name # 님이 담당하는# } else { # 담당자가 지정되지 않은 # } #
		이슈 <br/> <a class="btn-link text-wrap g-font-weight-400 g-color-blue" href="issue.html?projectId=#= source.objectId #&issueId=#= source.issueId #" target="_blank"> #: source.summary #</a> 가 변경되었습니다. 
	#}#
	<br/><span class="g-color-red">담당자는 꼭 확인 해주세요.</span>	
	#}#	
	</script>

	<script type="text/x-kendo-template" id="assignee-column-template">
	#if ( data.assignee != null && data.assignee.userId > 0 ) {#
	#= community.data.getUserDisplayName( data.assignee ) #
	#} else {#
	<span class="text-muted">미지정</span>
	#}#
	</script>
	
	<script type="text/x-kendo-template" id="repoter-column-template">
	#if ( data.repoter != null && data.repoter.userId > 0 ) {#
	#= community.data.getUserDisplayName( data.repoter ) #
	#} else {#
	<span class="text-muted">--</span>
	#}#
	</script>				
	
	<script type="text/x-kendo-template" id="summary-column-template">
	# if ( new Date() >= new Date(data.dueDate) ) {# <i class="fa fa-exclamation-triangle g-color-red" aria-hidden="true"></i> #} else { # # } #
	<a class="u-link-v5 u-link-underline text-wrap g-font-weight-400 g-font-size-15 g-color-black g-color-primary--hover" href="issue.html?projectId=#= data.project.projectId #&issueId=#= data.issueId #" target="_blank">#: data.summary # </a>
	</script>
	
    <script type="text/x-kendo-template" id="project-column-template"> 
	<a href="\\#" class="u-link-v5 u-link-underline g-color-black g-color-primary--hover g-font-weight-400" data-action="view" data-object-id="#: data.project.projectId#" data-kind="project">
    	# if ( data.project.contractState == '002') { # <span class="text-info" >무상</span> # } else if (data.project.contractState == '001') { # <span class="text-info"> 유상 </span> # } # #: data.project.name #
    </a>
    </script>
    	
	<script type="text/x-kendo-template" id="template-issue">
	<tr>
		<td class="align-middle text-center g-width-100"> ISSUE-#: issueId # </td>
		<td class="align-middle g-width-100">
    		#= getContractorName(project.contractor) #
    	</td>		
    	<td class="align-middle">
    		<a href="\\#" class="u-link-v5 u-link-underline g-color-black g-color-primary--hover g-font-weight-400" data-action="view" data-object-id="#: project.projectId#" data-kind="project">
    		# if ( project.contractState == '002') { # <span class="text-info" >무상</span> # } else if (project.contractState == '001') { # <span class="text-info"> 유상 </span> # } # #: project.name #
    		</a>
    	</td>
    	<td class="align-middle">
    		# if ( new Date() >= new Date(dueDate) ) {# <i class="fa fa-exclamation-triangle g-color-red" aria-hidden="true"></i> #} else { #  # } # 
        	<!--<a class="btn-link text-wrap g-font-weight-200 g-font-size-20" href="\\#" data-action="view2" data-object-id="#= issueId #" data-kind="issue" >#: summary # </a> -->   
        	<a class="u-link-v5 u-link-underline text-wrap g-font-weight-400 g-font-size-15 g-color-black g-color-primary--hover" href="issue.html?projectId=#= project.projectId #&issueId=#= issueId #" target="_blank">#: summary # </a>     		
 		</td>
    	<td class="align-middle">#: issueTypeName #</td>
    	<td class="align-middle text-center">#: priorityName #</td>
    	<td class="align-middle text-center">#: statusName #</td>
    	<td class="align-middle">
		#if ( assignee != null && assignee.userId > 0 ) {#
		#= community.data.getUserDisplayName( assignee ) #
		#} else {#
			<span class="text-muted">미지정</span>
		#}#
		</td>
    	<td class="align-middle">#if (dueDate != null){ # #: community.data.getFormattedDate( creationDate , 'yyyy-MM-dd') # #}#</td>
    	<td class="align-middle">#if (dueDate != null){ # #: community.data.getFormattedDate( dueDate , 'yyyy-MM-dd') # #}#</td>
    </tr>	
	</script>	
	<script type="text/x-kendo-template" id="template">
			<div class="forum-item">
				<div class="row">
					<div class="col-md-9">
						<div class="forum-icon"> 
 							<i class="icon-svg icon-svg-md #if (contractState === '004' ) { # icon-svg-ios-project # } else if (contractState === '005') { # icon-svg-ios-technical-support # } else { # icon-svg-ios-customer-support #} # #if ( new Date() > endDate ) {#g-opacity-0_3#}#"></i>
						</div>						
						<h2 class="g-ml-60 g-font-weight-100">
						# if ( contractState == '002') { # <span class="text-info g-font-size-18 g-font-weight-500" >무상</span> # } else if (contractState == '001') { # <span class="text-info g-font-size-18 g-font-weight-500"> 유상 </span> # } # <a href="\\#" data-action="view" data-object-id="#=projectId#" data-kind="project" class="u-link-v5 u-link-underline g-color-black g-color-primary--hover g-font-size-18 g-font-weight-400"> #:name# </a></h4>						
						<div class="g-ml-60 g-mb-5 text-warning">
						#: community.data.getFormattedDate( startDate , 'yyyy-MM-dd')  # ~ #: community.data.getFormattedDate( endDate, 'yyyy-MM-dd' )  # # if ( new Date() > endDate ) {#  <span class="text-danger"> 계약만료 </span> #} #</div>
						#if( isDeveloper() ){ #
						<div class="g-ml-60">	
						<span class="u-label g-font-weight-500 g-font-size-12 g-bg-pink g-rounded-20 g-px-15 g-mr-10 g-mb-10">#= getContractorName(contractor) #</span>
						</div>	
						<div class="g-ml-60 g-mb-5"> 유지보수비용(월) : #: kendo.toString( maintenanceCost, 'c')  #</div>						
						<div class="g-ml-60 g-mb-5">#if(summary != null ){# #= community.data.replaceLineBreaksToBr(summary) # #}#</div>
						#}#
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> #= issueTypeStats.items[issueTypeStats.items.length - 1].value # </span>
						<div>
							<small>요청</small>
						</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> #= resolutionStats.items[resolutionStats.items.length - 1].value # </span>
						<div>
							<small>처리</small>
						</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number">#= issueTypeStats.items[issueTypeStats.items.length - 1].value -  resolutionStats.items[resolutionStats.items.length - 1].value # </span>
						<div>
							<small>미처리</small>
						</div>
					</div>
				</div>
			</div>
    </script> 
</body>
	<!-- issue editor modal -->
	<div class="modal fade" id="issue-editor-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
			        </button>
			        <h2 class="modal-title">기술지원요청</h2>
		      	</div><!-- /.modal-content -->
				<div class="modal-body">
				 <form>
				 
				 	<h6 class="text-light-gray text-semibold">프로젝트 <span class="text-danger">*</span></h6>
					<div class="form-group">
						<input name="projectSelect"
						   data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="projectId"
		                   data-bind="value:issue.objectId, source:projectDataSource"
		                   style="width: 100%;"/>			        	  
					</div>
									 
				 	<h6 class="text-light-gray text-semibold">요청구분 <span class="text-danger">*</span></h6>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="value:issue.issueType, source:issueTypeDataSource"
		                   style="width:100%;"/>	
		                   		        	  
					</div>	
					<h6 class="text-light-gray text-semibold">요약 <span class="text-danger">*</span></h6>				 	
				 	<div class="form-group">
			            <input type="text" class="form-control" placeholder="요약" data-bind="value: issue.summary">
			        </div> 	

					<h6 class="text-light-gray text-semibold">상세 내용 <span class="text-danger">*</span></h6>				 	
				 	<div class="form-group">
					<textarea class="form-control" placeholder="상세내용" data-bind="value:issue.description"></textarea>
	 				</div> 
	 				<h6 class="text-light-gray text-semibold g-mt-15" data-bind="visible: isDeveloper">예정일</h6>	
					<input data-role="datepicker" data-bind="value: issue.dueDate, visible: isDeveloper, enabled:editable" style="width: 100%">
					<h6 class="text-light-gray text-semibold">우선순위 <span class="text-danger">*</span></h6>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="value:issue.priority, source:priorityDataSource"
		                   style="width: 100%;"/>			        	  
					</div>
					<h6 class="text-light-gray text-semibold">지원방법</h6>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="source:methodsDataSource"
		                   style="width: 100%;"/>
					</div>	
					<h6 class="text-light-gray text-semibold">처리결과</h6>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="visible: isDeveloper,value:issue.resolution, source:resolutionDataSource"
		                   style="width: 100%;"/>
					</div>	
					
					<h6 class="text-light-gray text-semibold">상태</h6>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="visible: isDeveloper,value:issue.status, source:statusDataSource"
		                   style="width: 100%;"/>
					</div>																															
				</form>   
				<div class="text-editor"></div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" data-bind="click:saveOrUpdate">확인</button>
				</div>
			</div>
		</div>
	</div>	 
</html>
</#compress>