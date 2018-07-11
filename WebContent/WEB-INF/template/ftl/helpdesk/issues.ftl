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
	
	var __projectId = <#if RequestParameters.projectId?? >${RequestParameters.projectId}<#else>0</#if>;
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
		"summernote-ko-KR", "dropzone", 		
		"https://www.gstatic.com/charts/loader.js"
	], function($, kendo ) {	

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
		        
		
		var __renderTo2 = $('#issues-grid'); /** grid render to */
		var __renderTo3 = $('#project-overviewstats') /** overviewstats render to */
		var observable = new community.ui.observable({ 
			currentUser : new community.model.User(),
			isDeveloper : false,
			projectId : __projectId,
			project : new community.model.Project(),
			projectPeriod : "",
			enabled : false,
			visible : false,
			totalIssueCount : 0,
			errorIssueCount: 0,
			closeIssueCount: 0,
			openIssueCount : 0,
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
				$this.set('isDeveloper', isDeveloper() ); 
				if( $this.currentUser.hasRole('ROLE_DEVELOPER') ){ 
					createNotification($this);				
				}
			},
			back : function(){
				var $this = this;
				//window.history.back();
				community.ui.send("<@spring.url "/display/pages/technical-support.html" />");
				return false;			
			},			
			load : function( objectId ){
				var $this = this;
				if( objectId > 0 ){  
					community.ui.progress($('#project-filters'), true);	
					community.ui.ajax('/data/api/v1/projects/'+ objectId +'/info.json/', {
						success: function(response){		
							$this.set('project', new community.model.Project(response) );		
							$this.set('project.summary', community.data.replaceLineBreaksToBr( $this.get('project.summary') ) );
							$this.set('projecPeriod' , community.data.getFormattedDate( $this.project.startDate , 'yyyy-MM-dd')  +' ~ '+  community.data.getFormattedDate( $this.project.endDate, 'yyyy-MM-dd' ) );
							$.each($this.project.issueTypeStats.items , function (index, item ){
								if( item.name == 'TOTAL' )
									$this.set('totalIssueCount', item.value );
								else if ( item.name == '001' )
									$this.set('errorIssueCount', item.value );	
							});
							$.each($this.project.resolutionStats.items , function (index, item ){
								if( item.name == 'TOTAL' )
									$this.set('closeIssueCount', item.value );
							});
							
							$this.set('openIssueCount', $this.get('totalIssueCount') - $this.get('closeIssueCount') ); 
							$this.set('enabled', true);
							$this.set('visible', true);   
							createIssueGrid($this);
						}	
					}).always( function () {
						community.ui.progress($('#project-filters'), false);
					});	 
				}
			},
			displayProjectInfo : function () {
				var $this = this ;
				createOrOpenProjectModal ( $this.project );
			},
			displayOverviewStats : function(){
				var $this = this ;
				if( !__renderTo3.data('load') ){
					console.log('create overview stats'); 
					//setTimeout(function(){
								var data = new google.visualization.DataTable();
								data.addColumn('string', '유형');
								data.addColumn('number', '건수');
								$.each( $this.project.issueTypeStats.items , function(index, item ){				
									switch (item.name) {
	  									case "001" :
									 		data.addRow(['오류', item['value'] ]);
									 	break;
									 	case "002" :
									 		data.addRow(['데이터작업', item.value ]);
									 	break;
									 	case "003" :
									 		data.addRow(['기능변경', item['value'] ]);
									 	break;
									 	case "004" :
									 		data.addRow(['추가개발', item['value'] ]);	
									 	break;
									 	case "005" :
									 		data.addRow(['기술지원', item['value'] ]);
									 	break;
									 	case "006" :
									 		data.addRow(['영업지원', item['value'] ]);
									 	break;
									 		default :
									    break;
									}
								} );
								google.charts.setOnLoadCallback(drawPieChart(data));										
					//}, 500);
												
					<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >	
						community.ui.progress($('#linechart_div'), true);			
						community.ui.ajax('/data/api/v1//issues/overviewstats/monthly/stats/list.json', {
				      		contentType : "application/json",	
				      		data: community.ui.stringify({
				      			data : { projectId : $this.project.projectId }
				      		}),
							success: function(response){	
								//setTimeout(function(){
								var data = new google.visualization.DataTable();
								data.addColumn('string', '월');
								data.addColumn('number', '오류');
								data.addColumn('number', '데이터작업');
								data.addColumn('number', '기능변경');
								data.addColumn('number', '추가개발');
								data.addColumn('number', '기술지원');
								data.addColumn('number', '영업지원');
					
								data.addColumn('number', '요청');
								data.addColumn('number', '완료');
								
								$.each(response.items, function( index, item ) {				
									data.addRow([ item.month + '월', item['aggregate']['001'],item['aggregate']['002'],item['aggregate']['003'],item['aggregate']['004'],item['aggregate']['005'],item['aggregate']['006'],
									item['aggregate']['001']+item['aggregate']['002']+item['aggregate']['003']+item['aggregate']['004']+item['aggregate']['005']+item['aggregate']['006'],
									item['aggregate']['000']
									]);
								});
								google.charts.setOnLoadCallback(drawLineChart(data));				
								//}, 1000);
							}	
						}).always( function () {
							community.ui.progress($('#linechart_div'), false);
						});		
					</#if>						
					__renderTo3.data('load', true);
				} 
				if( __renderTo3.is(':visible') ){
					__renderTo3.fadeOut();
				}else{
					__renderTo3.fadeIn();
				} 
			},
			search : function(){
				var $this = this;
				$this.filter.NO_CLOSED_ISSUE = false;
				community.ui.grid( __renderTo2 ).dataSource.read();
			},
			exportExcel : function(){
				var $this = this;			
				var data = $.extend( true, {}, $this.filters(), {});
				data.objectType = 19;
				data.objectId = $this.project.projectId;
				community.ui.send("<@spring.url "/data/api/v1/export/excel/PROJECT_ISSUES" />", { data : community.ui.stringify( data ) }, "POST");
			},
			findNotClosed : function(){
				var $this = this;
				$this.filter.NO_CLOSED_ISSUE = true;
				community.ui.grid( __renderTo2 ).dataSource.read();
			},
			filter : {
				SUMMARY : null,
				ISSUE_TYPE : null,
				ASSIGNEE : null,
				PRIORITY : null,
				RESOLUTION : null,
				ISSUE_STATUS : null,
				START_DATE : null,
				END_DATE : null,
				NO_CLOSED_ISSUE : false
			},
			filters :function(){
			
				var $this = this;
				var filter = {filter:{filters: [], logic: "AND" } };
				
				if( $this.filter.NO_CLOSED_ISSUE ){
					filter.filter.filters.push( {field: "RESOLUTION", operator: "eq", logic: "AND" } );
				}						
				if( $this.filter.SUMMARY != null && $this.filter.SUMMARY.length > 0 ){
					filter.filter.filters.push( {field: "SUMMARY", operator: "contains", value : $this.filter.SUMMARY, logic: "AND" } );
				} 
				if( $this.filter.ASSIGNEE != null && $this.filter.ASSIGNEE.userId > 0 ){
					filter.filter.filters.push( {field: "ASSIGNEE", operator: "eq", value : $this.filter.ASSIGNEE.userId, logic: "AND" } );
				}						
				if( $this.filter.ISSUE_TYPE != null && $this.filter.ISSUE_TYPE.length > 0 ){
					filter.filter.filters.push( {field: "ISSUE_TYPE", operator: "eq", value : $this.filter.ISSUE_TYPE, logic: "AND" } );
				}
				if( $this.filter.PRIORITY != null && $this.filter.PRIORITY.length > 0 ){
					filter.filter.filters.push( {field: "PRIORITY", operator: "eq", value : $this.filter.PRIORITY, logic: "AND" } );
				}
				if( $this.filter.RESOLUTION != null && $this.filter.RESOLUTION.length > 0 ){
					filter.filter.filters.push( {field: "RESOLUTION", operator: "eq", value : $this.filter.RESOLUTION, logic: "AND" } );
				}
				if( $this.filter.ISSUE_STATUS != null && $this.filter.ISSUE_STATUS.length > 0 ){
					filter.filter.filters.push( {field: "ISSUE_STATUS", operator: "eq", value : $this.filter.ISSUE_STATUS, logic: "AND" } );
				}
				if( $this.filter.START_DATE != null ){
					filter.filter.filters.push({ field: "START_DATE", operator: "gte", value : community.data.getFormattedDate( $this.filter.START_DATE, 'yyyyMMdd' ), logic: "AND" });
				}
				if( $this.filter.END_DATE != null ){
					filter.filter.filters.push({ field: "END_DATE", operator: "lte", value : community.data.getFormattedDate( $this.filter.END_DATE, 'yyyyMMdd' ), logic: "AND" });
				}
				return filter;			
			},
			issueTypeDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/ISSUE_TYPE/list.json" />' , {} ),
			priorityDataSource  : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/PRIORITY/list.json" />' , {} ),
			resolutionDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/RESOLUTION/list.json" />' , {} ),
			statusDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/ISSUE_STATUS/list.json" />' , {} ),
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
		   		
     	// google charts loading 
		google.charts.load('current', {'packages':['corechart']}); 
    	observable.load(__projectId); 
		var renderTo = $('#page-top');
		renderTo.data('model', observable);		
		community.ui.bind(renderTo, observable );	
		community.ui.tooltip(renderTo); 
		renderTo.on("click", "button[data-action=create], button[data-action=update], a[data-action=update], a[data-action=create], a[data-action=edit], a[data-action=view]", function(e){			
			var $this = $(this);
			var actionType = $this.data("action");		
			if( actionType == 'update'){
				var selected = [];
				$.each( $('#issues-grid input[type=checkbox]:checked'), function ( index, item ){
					selected.push( community.ui.grid( __renderTo2 ).dataSource.get($(item).data('object-id' )) );
				}); 	
				if( selected.length > 0 ){			
					createOrOpenIssueBatchEditor(observable, selected);
				}else{
					community.ui.alert("선택된 이슈가 없습니다.<br/> 원하시는 이슈를 체크한 다음 '이슈상태변경' 버튼을 다시 클릭해주세요.");
				}
				return false;	
			}	
			var objectId = $this.data("object-id");		
			var targetObject = new community.model.Issue();	
			if( objectId > 0 ){
				targetObject = community.ui.grid( __renderTo2 ).dataSource.get(objectId);
			}else{			
				targetObject = new community.model.Issue();	
				targetObject.set('issueId', 0);
				targetObject.set('objectType', 19);
				targetObject.set('objectId', __projectId);
			}			
			send(targetObject);	
			return false;		
		});
	});


	function createNotifications(observable){  
	 	var enabled = false;
	 	if(window.Notification){
			if( Notification.permission == 'denied' ){
				enabled = false;
			}else{
				enabled = true;
			}	
		}	 
		var storage = JSON.parse(localStorage.getItem('NotificationList'));
        if (!storage) {
        	storage = {};
         	localStorage.setItem('NotificationList', JSON.stringify(storage));
        } 
        const eventSource = new EventSource('<@spring.url "/data/api/v1/notifications/issue.json"/>'); 
		eventSource.onmessage = function(e) { 
			var obj = JSON.parse(e.data);
			if(!enabled){
				
				showNotification(obj); 
				
			}
	        return;			
		}  
	} 

	function saveNotification(obj){
		var storage = JSON.parse(localStorage.getItem('NotificationList'));
        storage[obj.timestamp]=obj;
		localStorage.setItem('NotificationList', JSON.stringify(storage));
	} 		

	/**
	 * Drawing Charting .
	 */
	function drawPieChart(data) {
        var options = {
          title: '이슈 유형',
          subtitle: '금일까지 요청된 이슈들에 대한 유형입니다.'
        };
        var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
        chart.draw(data, options);
    }
    	
	/**
	 * Drawing Charting .
	 */
	function drawLineChart(data) {
        var options = {
          title: '누적 월별 현황',
          subtitle: '완료건은 해당기간에 요청된 이슈들에 대한 완료 건입니다.',
          series : {
          	0: {lineDashStyle: [10,2], lineWidth: 2  },
          	1: {lineDashStyle: [10,2], lineWidth: 2  },
          	2: {lineDashStyle: [10,2], lineWidth: 2  },
          	3: {lineDashStyle: [10,2], lineWidth: 2  },
          	4: {lineDashStyle: [10,2], lineWidth: 2  },
          	5: {lineDashStyle: [10,2], lineWidth: 2  },
          	6: { lineWidth: 4  },
          	7: { lineWidth: 4  }
          },
         axes: {
          x: {
            0: {side: 'top'}
          }
        	 }
        };
        var chart = new google.visualization.LineChart(document.getElementById('linechart_div'));
        chart.draw(data, options);
    }
        	
	function send ( issue ) {
		community.ui.send("<@spring.url "/display/pages/issue.html" />", { projectId: issue.objectId, issueId: issue.issueId });
	}

	function createIssueGrid( observable ){
		var renderTo = $('#issues-grid');
		var listview = community.ui.grid( renderTo , {
			dataSource: community.ui.datasource('<@spring.url "/data/api/v1/projects/"/>'+ observable.get('projectId') +'/issues/list.json', {
				transport:{
					read:{
						contentType: "application/json; charset=utf-8"
					},
					parameterMap: function (options, operation){							
						var filter = observable.filters(); //{filter:{filters: [], logic: "AND" } };
						/**
						if( observable.filter.NO_CLOSED_ISSUE ){
							filter.filter.filters.push( {field: "RESOLUTION", operator: "eq", logic: "AND" } );
						}						
						if( observable.filter.SUMMARY != null && observable.filter.SUMMARY.length > 0 ){
							filter.filter.filters.push( {field: "SUMMARY", operator: "contains", value : observable.filter.SUMMARY, logic: "AND" } );
						} 
						if( observable.filter.ASSIGNEE != null && observable.filter.ASSIGNEE.userId > 0 ){
							filter.filter.filters.push( {field: "ASSIGNEE", operator: "eq", value : observable.filter.ASSIGNEE.userId, logic: "AND" } );
						}						
						if( observable.filter.ISSUE_TYPE != null && observable.filter.ISSUE_TYPE.length > 0 ){
							filter.filter.filters.push( {field: "ISSUE_TYPE", operator: "eq", value : observable.filter.ISSUE_TYPE, logic: "AND" } );
						}
						if( observable.filter.PRIORITY != null && observable.filter.PRIORITY.length > 0 ){
							filter.filter.filters.push( {field: "PRIORITY", operator: "eq", value : observable.filter.PRIORITY, logic: "AND" } );
						}
						if( observable.filter.RESOLUTION != null && observable.filter.RESOLUTION.length > 0 ){
							filter.filter.filters.push( {field: "RESOLUTION", operator: "eq", value : observable.filter.RESOLUTION, logic: "AND" } );
						}
						if( observable.filter.ISSUE_STATUS != null && observable.filter.ISSUE_STATUS.length > 0 ){
							filter.filter.filters.push( {field: "ISSUE_STATUS", operator: "eq", value : observable.filter.ISSUE_STATUS, logic: "AND" } );
						}
						if( observable.filter.START_DATE != null ){
							filter.filter.filters.push({ field: "START_DATE", operator: "gte", value : community.data.getFormattedDate( observable.filter.START_DATE, 'yyyyMMdd' ), logic: "AND" });
						}
						if( observable.filter.END_DATE != null ){
							filter.filter.filters.push({ field: "END_DATE", operator: "lte", value : community.data.getFormattedDate( observable.filter.END_DATE, 'yyyyMMdd' ), logic: "AND" });
						}
						**/
						if( filter.filter.filters.length > 0 ){
							options = $.extend( true, {}, filter, options );
						}						
						return community.ui.stringify(options)
					} 				
				},
				schema: {
					total: "totalCount",
					data: "items",
					model : community.model.Issue
				},
				serverPaging: true,
				serverSorting: true,
				serverFiltering:true,
				pageSize: 15				
			}),
			pageable: true, 
			sortable: true,
			filterable: false,
			dataBound : function(e){
				//$('[data-toggle="tooltip"]').tooltip();
			},	
			columns: [
			<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >
				{ title: "", filterable: false, sortable: false , width : 50 , template : $('#checkbox-column-template').html() , attributes:{ class:"text-center" }}, 
			</#if>	
				{ field: "ISSUE_ID", title: "ID", filterable: false, sortable: true , width : 100 , template: 'ISSUE-#: issueId #', attributes:{ class:"text-center" }},  
				{ field: "SUMMARY", title: "요약", filterable: false, sortable: true , template: $('#summary-column-template').html() },
				{ field: "ISSUE_TYPE", title: "유형", filterable: false, sortable: true , template: '#:issueTypeName#', width: 90, attributes:{ class:"text-center" }},  
				{ field: "PRIORITY", title: "중요도", filterable: false, sortable: true , template: '#:priorityName#', width: 80, attributes:{ class:"text-center" }},
				{ field: "REPOTER", title: "리포터", filterable: false, sortable: true , template: '#if ( repoter.userId > 0 ) {##= community.data.getUserDisplayName( repoter ) # #}#', width: 80, attributes:{ class:"text-center" }},
				{ field: "ASSIGNEE", title: "담당자", filterable: false, sortable: true , template: '#if ( assignee.userId > 0 ) {##= community.data.getUserDisplayName( assignee ) ##}#', width: 80, attributes:{ class:"text-center" }},
				{ field: "RESOLUTION", title: "결과", filterable: false, sortable: true , template: '#if(resolutionName!=null){##:resolutionName##}#', width: 80, attributes:{ class:"text-center" }},  
				{ field: "ISSUE_STATUS", title: "상태", filterable: false, sortable: true , template: '#:statusName#', width: 80, attributes:{ class:"text-center" }},  
				{ field: "DUE_DATE", title: "예정일", filterable: false, sortable: true , width : 100 , template:'#if(dueDate!=null){##= community.data.getFormattedDate( dueDate, "yyyy.MM.dd") ##}#' ,attributes:{ class:"text-center" } },
				{ field: "RESOLUTION_DATE", title: "완료일", filterable: false, sortable: true , width : 100 , template:'#if(resolutionDate!=null){##= community.data.getFormattedDate( resolutionDate, "yyyy.MM.dd") ##}#' ,attributes:{ class:"text-center" } },
				{ field: "CREATION_DATE", title: "등록일", filterable: false, sortable: true , width : 100 , template:'#= community.data.getFormattedDate( creationDate, "yyyy.MM.dd") #' ,attributes:{ class:"text-center g-font-size-14" } },
				{ field: "MODIFIED_DATE", title: "수정일", filterable: false, sortable: true , width : 100 , template:'#= community.data.getFormattedDate( modifiedDate, "yyyy.MM.dd") #' ,attributes:{ class:"text-center g-font-size-14" } }
			]	
		});	 
	} 
		 
 	<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >		
 	function createOrOpenProjectModal( project ){
 		var renderTo = $('#project-view-modal');
 		
 		if( !community.ui.exists( renderTo ) ){		 
 			var grid = community.ui.grid( renderTo.find('.grid') , {
				dataSource: community.ui.datasource('/data/api/v1/attachments/list.json', {
					transport : {
						parameterMap :  function (options, operation){
							return { startIndex: options.skip, pageSize: options.pageSize, objectType : 19 , objectId : project.projectId }
						}
					},
					pageSize: 10,
					schema: {
						total: "totalCount",
						data: "items",
						model : community.model.Attachment
					}
				}),
				pageable: false, 
				sortable: false,
				filterable: false,
				height: 300,
				columns: [
					{ field: "name", title: "&nbsp;", width: 70, filterable: false, sortable: false , template : $('#thumbnail-column-template').html(), attributes:{ class:"text-center" }},
					{ field: "name", title: "파일", filterable: false, sortable: true , template : $('#filename-column-template').html(), attributes:{ class:"g-font-size-14" } },
					{ field: "size", title: "크기(Byte)", filterable: false, sortable: true, width: 150,  template:'#= community.data.getFormattedNumber(data.size) #', attributes:{ class:"text-right" } }
				]		
			}); 	
 			community.ui.bind( renderTo, project );	 
 		}
 		renderTo.modal('show');
 		
 	}
 	
 	function createOrOpenIssueBatchEditor (parent, data){ 	
 		var renderTo = $('#isses-update-modal');
 		if( !renderTo.data("model") ){ 
 			var observable = new community.ui.observable({ 
 				issueStatus : null,
 				resolution : null,
 				resolutionDate : null,
 				setSource : function( data ){
					$this = this;
					$this.set('issueStatus', null);
					$this.set('resolution', null);
					$this.set('resolutionDate', new Date());
					$this.issues.data(data);
 				},
 				statusDataSource : parent.statusDataSource,
 				resolutionDataSource : parent.resolutionDataSource,
 				issues: community.ui.datasource_v2({
 				    data:[]
		        }),
		        batchUpdate : function(){
					var $this = this;
					community.ui.progress(renderTo.find('.modal-content'), true);	
					community.ui.ajax( '<@spring.url "/data/api/v1/issues/batch-save-or-update.json" />', {
						data: community.ui.stringify({ 
							issues : $this.issues.data(),
							status : $this.issueStatus,
							resolution : $this.resolution,
							resolutionDate : $this.resolutionDate
						}),
						contentType : "application/json",						
						success : function(response){
							community.ui.grid( $('#issues-grid') ).dataSource.read();
						}
					}).always( function () {
						community.ui.progress(renderTo.find('.modal-content'), false);
						$('#issues-grid input[type=checkbox]:checked').click();
						renderTo.modal('hide');
					});	
		        }    
 			});
 			
 			renderTo.data("model", observable );	
			community.ui.bind( renderTo, observable );				
				renderTo.on('show.bs.modal', function (e) {	 
			});
			
			renderTo.on('hide.bs.modal', function (e) {	 
			});	
 		} 		
 		if( community.ui.defined(data) ) 
			renderTo.data("model").setSource(data); 
 		renderTo.modal('show');
 	}
 	</#if> 
 	
	function isDeveloper(){ 
		return $('#page-top').data('model').currentUser.hasRole('ROLE_DEVELOPER') ;
	} 
 			
	</script>
	<style>
	.k-checkbox-label, .k-radio-label {
    	padding-left: 16px;
    }	
    .k-alert .k-window-titlebar {
    	display:none;
    }
	.k-grid thead .k-header {
	    text-align: center;
		font-weight : 500;
	}
	
	.k-grid-pager {
		font-size : .9em;
	}	

	.k-grid-content {
	    min-height: 600px;
	} 
	   
	.g-brd-bottom-1 {
	    border-bottom-width: 1px !important;
	    font-weight : 400;
	}
	
	.g-brd-bottom-3 {
	    border-bottom-width: 3px !important;
	    font-weight : 400;
	}
			
	.modal-body .k-grid-content {
	    min-height: auto;
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
				<div data-bind="visible: visible" style="display:none;" class="animated fadeIn"> 
				<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >	 
				<div class="btn-group">
					<a class="btn btn-md u-btn-3d u-btn-darkpurple g-px-25 g-py-13" href="#!" style="display:none;" role="button" 
					data-toggle="tooltip" data-placement="top" data-original-title="프로젝트 관련 정보를 확인할 수 있습니다." data-bind="click:displayProjectInfo,visible:isDeveloper">정보보기</a>
					<a href="#!" class="btn btn-md u-btn-3d u-btn-purple g-px-25 g-py-13" 
					data-toggle="tooltip" data-placement="top" data-original-title="프로젝트 이슈 누적 통계를 확인할 수 있습니다." data-bind="click: displayOverviewStats">통계보기</a> 
				</div>
				</#if>	
				<!--
				<p class="g-font-size-16 g-font-weight-400" ><#if __project?? >${ __project.summary?html?replace("\n", "<br>")}</#if></p> 
				<a class="btn btn-md u-btn-3d u-btn-lightred g-px-25 g-py-13" href="#" role="button" data-toggle="tooltip" data-placement="bottom" data-original-title="새로운 이슈를 등록합니다." data-object-id="0" data-action="create" data-action-target="issue">기술지원요청하기</a>	
				-->
				</div>
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
	<section id="features">
	
      	<section class="g-bg-white g-py-15 " id="project-overviewstats" style="display:none;" >
		<div class="container">
			<!-- Start Stats -->
			<div class="u-shadow-v11 g-rounded-7 g-bg-white g-pa-20" >
				<div class="u-heading-v2-4--bottom g-mb-10">
					<!--<h2 class="text-uppercase u-heading-v2__title g-mb-10">프로젝트 이슈요약</h2>-->
					<h4 class="g-font-weight-200"><span class="g-color-primary g-font-weight-400"><#if __project?? > ${__project.name} </#if></span> 에 대한 누적 이슈처리 현황입니다.</h4>
				</div>
				<div class="row">
					<div class="col-lg-6">
						<div id="chart_div" style="width: 100%; height:200px;"></div>
					</div>
					<div class="col-lg-6">			
						<div class="d-inline-block g-px-15 g-mx-15 g-mb-30 text-center">
							<div class="g-font-size-45 g-font-weight-300 g-line-height-1 mb-0" data-bind="text:totalIssueCount">0</div>
							<span>전체</span>
							</div>
							<div class="d-inline-block g-px-15 g-mx-15 g-mb-30 text-center">
							<div class="g-font-size-45 g-font-weight-300 g-color-red g-line-height-1 mb-0" data-bind="text:errorIssueCount">0</div>
							<span>오류</span>
							</div>
							<div class="d-inline-block g-px-15 g-mx-15 g-mb-30 text-center">
							<div class="g-font-size-45 g-font-weight-300 g-line-height-1 mb-0" data-bind="text:closeIssueCount">0</div>
							<span>종결</span>
							</div>
							<div class="d-inline-block g-px-15 g-mx-15 g-mb-30 text-center">
							<div class="g-font-size-45 g-font-weight-300 g-line-height-1 mb-0" data-bind="text:openIssueCount">0</div>
							<span>미처리</span>
							</div>			
						</div>
					</div>            		
					<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >		
					<div class="row">
						<div class="col-sm-12">
							<div id="linechart_div" style="width: 100%; height:300px;"></div>
						</div>
					</div>	
					</#if>    
			</div> 	
			<!-- End Stats -->	
		</div>
		</section>	
		
      <!-- Filter -->
      <div class="u-shadow-v19 g-bg-gray-light-v5" id="project-filters" >
        <div class="container g-py-30 ">
          <h2 class="mb-5">Show Results For:</h2> 
          <div class="row g-mb-0 g-mb-30--md g-font-weight-400 animated fadeIn" style="display:none;" data-bind="visible:visible">
            <div class="col-sm-6 col-lg-4 g-mb-15 g-mb-15--sm"> 
              <!-- 요청구분 --> 
				<input data-role="combobox"  
					data-placeholder="요청구분"
					data-auto-bind="true"
					data-value-primitive="true"
					data-text-field="name"
					data-value-field="code"
					data-bind="source:issueTypeDataSource, value:filter.ISSUE_TYPE, visible:visible"
					style="width:100%; display:none;"/>	
              <!-- End 요청구분 --> 
            </div> 
            <div class="col-sm-6 col-lg-4 g-mb-15 g-mb-15--sm">
              <!-- 우선순위 --> 
			  <input data-role="combobox"  
					data-placeholder="우선순위"
					data-auto-bind="true"
					data-value-primitive="true"
					data-text-field="name"
					data-value-field="code"
					data-bind="source: priorityDataSource, value:filter.PRIORITY, visible:visible"
					style="width:100%; display:none;"/>	
              
              <!-- End 우선순위 -->
            </div>
            
            <div class="col-sm-6 col-lg-4 g-mb-15 g-mb-15--sm">
              <!-- 처리결과 --> 
				<input data-role="combobox"  
					data-placeholder="처리결과"
					data-auto-bind="true"
					data-value-primitive="true"
					data-text-field="name"
					data-value-field="code"
					data-bind="source:resolutionDataSource, value:filter.RESOLUTION, visible:visible"
					style="width:100%; display:none;"/>	
              
              <!-- End 처리결과 -->
            </div>
            <div class="col-sm-6 col-lg-4 g-mb-15 g-mb-15--sm">
              <!-- 시작일 --> 
			  <input data-role="datepicker" style="width: 100%" data-bind="value:filter.START_DATE" placeholder="시작일">
	          <span class="help-block g-color-red g-font-size-14">시작일이 등록일 또는 예정일 이전이거나 같은 조건에 해당하는 이슈가 조회됩니다.</span>
              <!-- End 시작일 -->
            </div>
            <div class="col-sm-6 col-lg-4 g-mb-15 g-mb-15--sm"  >
              <!-- 종료일 --> 
			  <input data-role="datepicker" style="width: 100%;" data-bind="value:filter.END_DATE, visible:visible" placeholder="종료일">
	          <span class="help-block g-color-red g-font-size-14">종료일이 등록일 또는 예정일 이전이거나 같은 조건에 해당하는 이슈가 조회됩니다</span>  
              <!-- End 종료일 -->
            </div>             
            <div class="col-sm-6 col-lg-4 g-mb-15 g-mb-15--sm">
              <!-- 상태 --> 
				<input data-role="combobox"  
					data-placeholder="상태"
					data-auto-bind="true"
					data-value-primitive="true"
					data-text-field="name"
					data-value-field="code"
					data-bind="source:statusDataSource, value:filter.ISSUE_STATUS, visible:visible"
					style="width: 100%; display:none;"/>
              <!-- End 상태 -->
            </div>
                                   
            <div class="col-sm-6 col-lg-4">
              <!-- 담당자 -->
				<input data-role="combobox"
					data-placeholder="담당자 이름을 입력하세요."
					data-filter="contains"
					data-text-field="name"
					data-value-field="username"
					data-autoBind: false,
					data-bind="value:filter.ASSIGNEE, 
					source: userDataSource,
					visible:visible"
					style="width: 100%;display:none;"/>
              <!-- End 담당자 -->
            </div>

            <div class="col-sm-6 col-lg-8">
              <!-- 검색어 -->
			  <div class="form-group" >
				<input type="text" name="issue-summary" class="form-control" placeholder="검색어를 입력해여 주세요." 
					data-bind="value: filter.SUMMARY" >
			  </div>
              <!-- End 검색어 -->
            </div>
          </div> 
			<!-- Toolbar -->
			<div class="d-flex g-pos-rel justify-content-center align-items-center g-brd-gray-light-v4 g-pt-20 g-pb-20" style="min-height: 110px;"> 
	            <div class="g-mr-0">
	            	<a href="#!" class="btn btn-md u-btn-3d u-btn-darkgray g-px-25 g-py-9" data-bind="click: back">이전</a> 
					<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >	 
					<div class="btn-group">
					<a class="btn btn-md u-btn-3d u-btn-outline-blue g-px-25 g-py-9" href="#!" style="display:none;" role="button" data-object-id="0" data-action="update" data-action-target="issue" 
					data-toggle="tooltip" data-placement="bottom" data-original-title="체크된 이슈들의 상태를 한꺼번에 변경할 수 있습니다." data-bind="visible:isDeveloper">이슈상태변경</a>
					<a class="btn btn-md u-btn-3d u-btn-outline-blue g-px-25 g-py-9" href="#!" style="display:none;" role="button" 
					data-toggle="tooltip" data-placement="top" data-original-title="미완료된 모든 건들을 불러옵니다."  data-bind="{click:findNotClosed, visible:enabled}">미완료건보기</a>
					<a class="btn btn-md u-btn-3d u-btn-outline-blue g-px-25 g-py-9" href="#!" style="display:none;" role="button"  data-bind="click: exportExcel, visible:enabled">엑셀 다운로드</a> 
					</div>
					</#if>	 	
					<button type="button" class="btn btn-md u-btn-3d u-btn-darkgray g-px-25 g-py-9 g-font-weight-600" style="display:none;"
						data-toggle="tooltip" data-placement="top" data-original-title="조건에 해당하는 이슈들을 검색합니다." 
						data-bind="{click:search, visible:enabled}">검색</button>		
	            	<a class="btn btn-md u-btn-3d u-btn-lightred g-px-25 g-py-9" href="#" style="display:none;" role="button" data-object-id="0" data-action="create" data-action-target="issue" data-bind="visible:enabled">새로운이슈등록하기</a>
	            </div> 
            </div> 
        	<!-- Ent Toolbar --> 
        </div>
      </div>
      <!-- End Filter -->	 
      <section class="g-bg-white g-py-15 " >
		<div class="container">
			<!-- Start Stats -->
			<div class="u-shadow-v11 g-rounded-7 g-bg-white g-pa-20 g-mb-30" id="project-overviewstats" style="display:none;">
				<div class="u-heading-v2-4--bottom g-mb-10">
					<!--<h2 class="text-uppercase u-heading-v2__title g-mb-10">프로젝트 이슈요약</h2>-->
					<h4 class="g-font-weight-200"><span class="g-color-primary g-font-weight-400"><#if __project?? > ${__project.name} </#if></span> 에 대한 누적 이슈처리 현황입니다.</h4>
				</div>
				<div class="row">
					<div class="col-lg-6">
						<div id="chart_div" style="width: 100%; height:200px;"></div>
					</div>
					<div class="col-lg-6">			
						<div class="d-inline-block g-px-15 g-mx-15 g-mb-30 text-center">
							<div class="g-font-size-45 g-font-weight-300 g-line-height-1 mb-0" data-bind="text:totalIssueCount">0</div>
							<span>전체</span>
							</div>
							<div class="d-inline-block g-px-15 g-mx-15 g-mb-30 text-center">
							<div class="g-font-size-45 g-font-weight-300 g-color-red g-line-height-1 mb-0" data-bind="text:errorIssueCount">0</div>
							<span>오류</span>
							</div>
							<div class="d-inline-block g-px-15 g-mx-15 g-mb-30 text-center">
							<div class="g-font-size-45 g-font-weight-300 g-line-height-1 mb-0" data-bind="text:closeIssueCount">0</div>
							<span>종결</span>
							</div>
							<div class="d-inline-block g-px-15 g-mx-15 g-mb-30 text-center">
							<div class="g-font-size-45 g-font-weight-300 g-line-height-1 mb-0" data-bind="text:openIssueCount">0</div>
							<span>미처리</span>
							</div>			
						</div>
					</div>            		
					<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >		
					<div class="row">
						<div class="col-sm-12">
							<div id="linechart_div" style="width: 100%; height:300px;"></div>
						</div>
					</div>	
					</#if>    
			</div> 	
			<!-- End Stats -->	
		</div>
		<div class="container-fluid ">	
			<div class="table-responsive">
				<div id="issues-grid" class="g-brd-0 g-brd-gray-dark-v4 g-brd-top-3 g-brd-style-solid g-min-height-500 g-brd-bottom-3" ></div>
			</div>				
        </div>
        </section>
	</section>			
	<!-- FOOTER START -->   
	<#include "includes/user-footer.ftl">
	<!-- FOOTER END -->  			
	
	<script type="text/x-kendo-template" id="checkbox-column-template">
		<input type="checkbox" id="selected-#= issueId #" class="k-checkbox" data-object-kind="issue" data-object-id="#= issueId #">
		<label class="k-checkbox-label" for="selected-#= issueId #"></label>		
	</script>
	<script type="text/x-kendo-template" id="summary-column-template">
	# if ( status != '005' && new Date() >= dueDate ) {# <i class="fa fa-exclamation-triangle g-color-red" aria-hidden="true"></i> #} else { #  # } # 
	<a class="u-link-v5 u-link-underline g-color-primary--hover g-font-size-16 g-font-weight-400 #if(status != '005'){# g-color-red #}else{# g-color-bluegray #}#" href="\\#" data-action="view" data-object-id="#= issueId #" data-action-target="issue" > #: summary # </a>
    </script>	
    
    <script type="text/x-kendo-template" id="thumbnail-column-template">
	<a class="g-text-underline--none--hover" href="#: community.data.getAttachmentUrl(data) #" title="" data-toggle="tooltip" data-placement="top" data-original-title="PC 저장">
	#if ( contentType.match("^image") ) {#	
	<img class="g-width-50 g-height-50" src="#= community.data.getAttachmentThumbnailUrl( data, true) #" />
	# }else if( contentType === "application/pdf" || contentType === "application/vnd.openxmlformats-officedocument.presentationml.presentation" ){ #		
	<img class="g-brd-around g-brd-gray-light-v4 g-width-50 g-height-50" src="#= community.data.getAttachmentThumbnailUrl( data, true) #" />
	# } else { #			
	<i class="icon-svg icon-svg-sm icon-svg-dusk-attach m-t-xs"></i>
	# } #  
    </a>
    </script>	
    
    <script type="text/x-kendo-template" id="filename-column-template"> 
	#if( contentType === "application/pdf" ) { #
		<a href="pdf-viewer.html?file=#= community.data.getAttachmentUrl(data) #" target="_blank;">
		#: name #  
		</a>
	# } else { # 
		#: name #  
	#}#   
    </script>
 			
	<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >	 	
	<!-- project detail modal -->
	<div class="modal fade" id="project-view-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h2 class="modal-title"> <#if __project?? >${__project.name}<#else>프로젝트 상세</#if>  </h2> 
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
			        </button> 
		      	</div>
				<div class="modal-body g-pa-25 g-font-size-15">	
					
				<div class="row">
                <div class="col-md-8 g-mb-30 g-brd-2 g-brd-blue">
                  <p class="g-font-size-16 g-font-weight-400" ><#if __project?? >${ __project.summary?html?replace("\n", "<br>")}</#if></p>
                </div>
                <div class="col-md-4 g-mb-30">
                  <!-- List -->
                  <ul class="list-unstyled g-color-text g-font-weight-400">
					<li class="g-brd-bottom--dashed g-brd-gray-light-v3 pt-1 mb-3">
                      <span>계약자:</span>
                      <span class="float-right g-color-black" ><#if __project?? >${ CommunityContextHelper.getCodeSetService().getCodeSetByCode("CONTRACTOR", __project.contractor).name }</#if></span>
                    </li>
					<li class="g-brd-bottom--dashed g-brd-gray-light-v3 pt-1 mb-3">
                      <span>계약상태:</span>
                      <span class="float-right g-color-black" ><#if ( __project??  &&  __project.contractState?? ) >${ CommunityContextHelper.getCodeSetService().getCodeSetByCode("PROJECT", __project.contractState).name }</#if></span>
                    </li>                    
					<li class="g-brd-bottom--dashed g-brd-gray-light-v3 pt-1 mb-3">
                      <span>비용(월):</span>
                      <span class="float-right g-color-black" ><#if __project?? >${__project.maintenanceCost?string.currency}</#if></span>
                    </li>
                    <li class="g-brd-bottom--dashed g-brd-gray-light-v3 pt-1 mb-3">
                      <span>시작일:</span>
                      <span class="float-right g-color-black" ><#if __project?? >${__project.startDate?string["yyyy.MM.dd"]}</#if></span>
                    </li>
                     <li class="g-brd-bottom--dashed g-brd-gray-light-v3 pt-1 mb-3">
                      <span>종료일:</span>
                      <span class="float-right g-color-black"><#if __project?? >${__project.endDate?string["yyyy.MM.dd"]}</#if></span>
                    </li>                   
                  </ul>
                  <!-- End List -->
                </div>
              </div>					
					<h2 class="h4 mb-3">관련자료</h2>
					<div class="grid"></div>
								
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-md u-btn-bluegray g-mr-10" data-dismiss="modal">닫기</button>
					<!--<button type="button" class="btn btn-md u-btn-primary g-mr-10" data-bind="click:batchUpdate">확인</button>-->
				</div>
			</div><!-- /.modal-content -->
		</div>
	</div>	
		
	<!-- issue state modify modal -->
	<div class="modal fade" id="isses-update-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h2 class="modal-title"> 이슈상태변경 </h2> 
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
			        </button> 
		      	</div>
				<div class="modal-body g-pa-25 g-font-size-15">	
				
					<div data-role="grid" data-height="300" 
						 data-columns="[ { 'field': 'issueId', 'title': 'ID' , width: 100, template: 'ISSUE-#: issueId #', attributes:{ class:'text-center' } }, { 'field': 'summary', 'title': '이슈' } ]" 
						 data-bind="source:issues" 
						 class="g-font-size-14 g-mb-5" ></div>  
						 
					<form class="g-brd-around g-brd-gray-light-v4 g-pa-30 g-bg-gray-light-v5">
                			<div class="form-group g-mb-20">
		                    <label class="g-mb-10">상태</label>
		                  	<input data-role="combobox"  
							   data-placeholder="진행상태를 선택하여 주세요."
			                   data-auto-bind="true"
			                   data-value-primitive="true"
			                   data-text-field="name"
			                   data-value-field="code"
			                   data-bind="value:issueStatus, source:statusDataSource"
			                   style="width: 100%;"/>
							<small class="form-text text-muted g-font-size-default g-mt-10">작업 진행 상태 변경이 있는 경우 선택하여 주세요.</small>
                			</div>
                			<hr class="g-brd-gray-light-v4 g-mx-minus-30">
                			
                			<div class="form-group g-mb-20">
		                    <label class="g-mb-10">결과</label>
		                    <input id="input-update-resolution"
								data-role="combobox"	
								data-placeholder="처리결과를 선택하여 주세요"
							    data-auto-bind="true"
							    data-value-primitive="true"
							    data-text-field="name"
						        data-value-field="code"
						        data-bind="value:resolution, source:resolutionDataSource"
						        style="width: 100%;" />
							<small class="form-text text-muted g-font-size-default g-mt-10">작업이 완료된 경우 결과를 선택하여 주세요.</small>
                			</div>
                			<div class="form-group g-mb-20">
		                    <label class="g-mb-10">처리일자</label>
		                  	<input id="input-update-resolutionDate" data-role="datepicker" data-bind="value: resolutionDate" style="width: 100%">
							<small class="form-text text-muted g-font-size-default g-mt-10">작업이 완료된 경우 처리일자를 입력하여 주세요.</small>
                			</div>
              		</form>					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-md u-btn-bluegray g-mr-10" data-dismiss="modal">취소</button>
					<button type="button" class="btn btn-md u-btn-primary g-mr-10" data-bind="click:batchUpdate">확인</button>
				</div>
			</div><!-- /.modal-content -->
		</div>
	</div>			
	</#if>
</body>	 
</html>
</#compress>
