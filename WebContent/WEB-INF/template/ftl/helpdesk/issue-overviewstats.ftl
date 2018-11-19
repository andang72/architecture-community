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
	<link href="<@spring.url "/css/kendo/2018.3.1017/kendo.common.min.css"/>" rel="stylesheet" type="text/css" />
	<link href="<@spring.url "/css/kendo/2018.3.1017/kendo.bootstrap-v4.min.css"/>" rel="stylesheet" type="text/css" />
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
	<link rel="stylesheet" href="<@spring.url "/css/pace/pace-theme-flash.css"/>">
	<script data-pace-options='{ "ajax": false }' src='<@spring.url "/js/pace/pace.min.js"/>'></script>   	
	
	<!-- Yepnope for js loading -->
	<script src="<@spring.url "/js/yepnope/1.5.4/yepnope.min.js"/>" type="text/javascript"></script>
	
	<!-- Application JavaScript
    		================================================== -->    
	<script>
	yepnope([{
		load: [			 
			'<@spring.url "/js/jquery/jquery-3.3.1.min.js"/>', 
			'<@spring.url "/js/bootstrap/4.1.3/bootstrap.bundle.min.js"/>', 
				 
			'<@spring.url "/js/kendo/2018.3.1017/kendo.all.min.js"/>',
			'<@spring.url "/js/kendo/2018.3.1017/cultures/kendo.culture.ko-KR.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.messages.ko-KR.js"/>',	 
			
			'<@spring.url "/js/community.ui/community.ui.core.js"/>',
			'<@spring.url "/js/community.ui/community.data.js"/>',
			
			'<@spring.url "/js/bootstrap.theme/unify/hs.core.js"/>',
			'<@spring.url "/js/bootstrap.theme/unify/components/hs.header.js"/>',
			'<@spring.url "/js/bootstrap.theme/unify/helpers/hs.hamburgers.js"/>',
			'<@spring.url "/assets/js/components/hs.dropdown.js"/>',
			
			'<@spring.url "/assets/vendor/dzsparallaxer/dzsparallaxer.js"/>',
			'<@spring.url "/assets/vendor/dzsparallaxer/dzsscroller/scroller.js"/>',
			'<@spring.url "/assets/vendor/dzsparallaxer/advancedscroller/plugin.js"/>'
		],
		complete: function() { 

		community.ui.setup({
		  	features:{
				accounts:true,
				unify:{
					header:true,
					hamburgers : true,
					dorpdown : true
				}
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
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser);
			},
			visible: false,
			contractor : null,
			startDate: getLastSaturday(),
			endDate : getThisFriday(),			
			search : function(){
				var $this = this;	
				$this.filters( community.ui.listview( $('#summary-listview') ).dataSource ); 
			},
			change: function (e) {
            	console.log("event: change");
        	},
			reorder: function (e) {
            	console.log("event: reorder");
	        },
	        remove: function (e) {
	            console.log("event: remove");
	        },
	        projectsData : [
			<#list CommunityContextHelper.getCustomQueryService().list ("COMMUNITY_CS.SELECT_PROJECT_ID_AND_NAME") as item >
			{ projectId : ${ item.PROJECT_ID }, name : '${ item.PROJECT_NAME }' }<#if !item?is_last>,</#if>
			</#list>], 
			filters : function(dataSource){
				var $this = this , filters = [];
				
				if($this.get("contractor"))
					filters.push({ logic: 'AND', field: 'CONTRACTOR', operator: "eq", value: $this.get("contractor")  });			
				
				if( dataSource != null )
					dataSource.filter( filters ); 
					
				return filters;
			},		
			selectedProjects : function () {
				var listbox = $("#listbox2").data('kendoListBox');
				if( listbox!= null && listbox.dataSource.data().length > 0 ){
					console.log("items  :" + community.ui.stringify( listbox.dataSource.data() ) );
					return listbox.dataSource.data() ; 
				}else {
					return [];
				}
			},		
			exportExcel : function(){
				var $this = this;			
				community.ui.send("<@spring.url "/data/api/v1/export/excel/ISSUE_OVERVIEWSTATS" />", { data : community.ui.stringify({
					data : {
						contractor : observable.get("contractor"),
						startDate : community.data.getFormattedDate($this.get("startDate"), "yyyyMMdd" ),
						endDate : community.data.getFormattedDate($this.get("endDate"), "yyyyMMdd" )	
					}
				}) }, "POST");
			},
			back : function(){
				//window.history.back();
				community.ui.send("<@spring.url "/display/pages/technical-support.html" />" );
				return false;
			},
			contractorData : [
			<#list CommunityContextHelper.getCodeSetService().getCodeSets("CONTRACTOR", "") as item >{ code:'${item.code}', name:'${item.name}' }<#if !item?is_last>,</#if>
			</#list>],
			contractData : [
			<#list CommunityContextHelper.getCodeSetService().getCodeSets("PROJECT", "") as item >{ code:'${item.code}', name:'${item.name}' }<#if !item?is_last>,</#if>
			</#list>],
			contractDataSource : community.ui.datasource( '<@spring.url "/data/api/mgmt/v1/codeset/PROJECT/list.json" />' , {} ),
			contractorDataSource : community.ui.datasource( '<@spring.url "/data/api/mgmt/v1/codeset/CONTRACTOR/list.json" />' , {} ),
			withinPeriodIssueCount : 0,
			resolutionCount : 0,
			unclosedTotalCount : 0
    		});     			
      	
	      	var renderTo = $('#page-top');
	    	renderTo.data('model', observable);
	   		community.ui.bind(renderTo, observable ); 
	    	createContentTabs(observable);
			}
	}]); 		
	 
	function createContentTabs(observable){  
		$('#nav-tabstrip a[data-toggle="tab"]').on('show.bs.tab', function (e) {
			console.log('clicked');
			var url = $(this).attr("href"); // the remote url for content
			var target = $(this).data("target"); // the target pane
			var tab = $(this); // this tab 
			console.log( url ) ;
			if(url === '#nav-stats-year' ){ 
				createProjectIssueStateAsChart(observable);
				window.location.hash = '#nav-stats-year';
			}else if (url === '#nav-stats-project'){ 
				createProjectStatsGrid( url, observable ).dataSource.read();
				window.location.hash = '#nav-stats-project';
			}else if (url === '#nav-stats-assinee'){ 
				createAssineeGrid( url, observable ).dataSource.read();
				window.location.hash = '#nav-stats-assinee';
			}else if (url === '#nav-stats-terms'){ 
				createSummaryListView(observable); 
				window.location.hash = '#nav-stats-terms';
			}
			community.ui.send("<@spring.url "" />"+ url );
		});
		observable.set('visible', true );
		// Select first tab 
		if (window.location.hash === '#nav-stats-terms'){
			$('#nav-tabstrip a[data-toggle="tab"]:last').tab('show'); 
		}else{
			$('#nav-tabstrip a[data-toggle="tab"]:first').tab('show'); 
		} 
	}  

        
	function createProjectAssineeGrid ( renderTo , observable ){ 
		if( !community.ui.exists( renderTo ) ){	 
			
 			var grid = community.ui.grid( renderTo , {
				dataSource: {
					transport: { 
						read : { url:'<@spring.url "/data/apis/stats_by_assinee.json"/>', type:'post', contentType: "application/json; charset=utf-8"},
						parameterMap: function (options, operation){	 
							if (operation !== "read" && options.models) { 
								return community.ui.stringify(options.models);
							}
							return community.ui.stringify(options);
						}
					},   
					serverPaging: false,
					serverFiltering : true,
					schema: {
						total: "totalCount",
						data: "items"
					}
				},   
				height: 400,
				pageable: false, 
				sortable: true,
				filterable: true, 
				autoBind : false,
				dataBound: function (){
					var $this = this;
				},
				columns: [
					{ field: "user.name", title: "담당자", width: 120, filterable: false, sortable: true , template : '#= user.name #', attributes:{ class:"text-center" }},
					{ field: "total", title: "이슈", filterable: false, sortable: false , template : $('#issue-column-template').html(), attributes:{ class:"g-font-size-14" } },
					{ field: "closedCount", title: "완료", filterable: false, sortable: true, width: 150,  template:'#= community.data.getFormattedNumber(closedCount) #', attributes:{ class:"text-right" } },
					{ field: "totalCount", title: "전체", filterable: false, sortable: true, width: 150,  template:'#= community.data.getFormattedNumber(totalCount) #', attributes:{ class:"text-right" } }
				]		
			});
			
		}
		return community.ui.grid( renderTo );
	}

	function createProjectMonthlyGrid ( renderTo , observable ){
		if( !community.ui.exists( renderTo ) ){	 
			console.log("createAssineeMonthlyGrid") ;
 			var grid = community.ui.grid( renderTo , {
				dataSource: {
					transport: { 
						read : { url:'<@spring.url "/data/apis/stats_assinee_by_monthly.json"/>', type:'post', contentType: "application/json; charset=utf-8"},
						parameterMap: function (options, operation){	 
							return community.ui.stringify(options);
						}
					},  
					serverFiltering : true,
					serverPaging: false,
					schema: {
						total: "totalCount",
						data: "items"
					},
					sort: { field: "month", dir: "asc" },
					aggregate: [ { field: "closedCount", aggregate: "average" }, { field: "closedCount", aggregate: "sum" }, { field: "totalCount", aggregate: "average" }, { field: "totalCount", aggregate: "sum" }]
				},  
				height: 400,
				selectable: "row",
				pageable: false, 
				sortable: true,
				filterable: false, 
				autoBind : false,
				dataBound: function (){
					var $this = this;
				},
				columns: [
					{ field: "month", title: "월", width: 120, filterable: false, sortable: true , template : '#= month #', attributes:{ class:"text-center" }},
					{ field: "total", title: "이슈", filterable: false, sortable: false , template : $('#issue-column-template').html(), attributes:{ class:"g-font-size-14" } },
					{ field: "closedCount", title: "완료", filterable: false, sortable: true, width: 150,  template:'#= community.data.getFormattedNumber(closedCount) #', attributes:{ class:"text-right" }
					  , aggregates: ["average", "sum"], footerTemplate: "<div>sum : #= sum #</div> <div>average : #= average #</div>"
					},
					{ field: "totalCount", title: "전체", filterable: false, sortable: true, width: 150,  template:'#= community.data.getFormattedNumber(totalCount) #', attributes:{ class:"text-right" }
					  , aggregates: ["average", "sum"], footerTemplate: "<div>sum : #= sum #</div> <div>average : #= average #</div>"
					}
				]		
			});
			
		}
		return community.ui.grid( renderTo );
	}
					
	function createProjectStatsGrid ( url , observable ){
		var renderTo =  $(url + ' .grid');
		if( !community.ui.exists( renderTo ) ){	 
 			var grid = community.ui.grid( renderTo , {
				dataSource: {
					transport: { 
						read : { url:'<@spring.url "/data/apis/stats_by_project.json"/>', type:'post', contentType: "application/json; charset=utf-8"},
						parameterMap: function (options, operation){	 
							if (operation !== "read" && options.models) { 
								return community.ui.stringify(options.models);
							}
							return community.ui.stringify(options);
						}
					},   
					serverPaging: false,
					pageSize: -1,
					schema: {
						total: "totalCount",
						data: "items"
					}
				},  
				height: 500,
                scrollable: true,
				selectable: "row",
				pageable: false, 
				sortable: true,
				filterable: true, 
				autoBind : false,
				change : function() {
					var selectedRows = this.dataItem(this.select()); 
					createProjectAssineeGrid( $(url + ' .assinee-grid'), observable ).dataSource.filter( [{ logic: 'AND', field: "T1.OBJECT_ID", operator: "eq", value: selectedRows.project.projectId  }]);
					createProjectMonthlyGrid( $(url + ' .monthly-grid'), observable ).dataSource.filter( [{ logic: 'AND', field: "T1.OBJECT_ID", operator: "eq", value: selectedRows.project.projectId  }]);
				},
				dataBound: function (){
					var $this = this;
				},
				columns: [
					{ field: "project.projectId", title: "프로젝트", width: 280, filterable: false, sortable: true , template : $('#project-column-template').html() },
					{ field: "total", title: "이슈", filterable: false, sortable: false , template : $('#issue-column-template').html(), attributes:{ class:"g-font-size-14" } },
					{ field: "closedCount", title: "완료", filterable: false, sortable: true, width: 150,  template:'#= community.data.getFormattedNumber(closedCount) #', attributes:{ class:"text-right" } },
					{ field: "totalCount", title: "전체", filterable: false, sortable: true, width: 150,  template:'#= community.data.getFormattedNumber(totalCount) #', attributes:{ class:"text-right" } }
				]		
			}); 
		}
		return community.ui.grid( renderTo );
	}
		
	function createBarChart(renderTo , title, data, observable){
		if( !community.ui.exists( renderTo ) ){	 
			renderTo.kendoChart({
                title: {
                    text: title
                },
                legend: {
                    position: "top"
                },
                seriesDefaults: {
                    type: "bar"
                },
                series: [{
                    field: "totalCount",
                    categoryField: "user.name",
                    name: "요청건수",
                    data: data
                },{
                    field: "closedCount",
                    categoryField: "user.name",
                    name: "완료건수",
                    data: data
                }],
                categoryAxis: {
                    majorGridLines: {
                        visible: false
                    }
                },
                valueAxis: {
                    labels: {
                        format: "N0"
                    },
                    majorUnit: 50,
                    line: {
                        visible: false
                    }
                },
                tooltip: {
                    visible: true,
                    format: "N0"
                }
            });		
		}
	}	
			
	function createAssineeGrid ( url , observable ){
		var renderTo =  $(url + ' .grid');
		var renderTo2 =  $(url + ' .barchart');
		
		if( !community.ui.exists( renderTo ) ){	 
 			var grid = community.ui.grid( renderTo , {
				dataSource: {
					transport: { 
						read : { url:'<@spring.url "/data/apis/stats_by_assinee.json"/>', type:'post', contentType: "application/json; charset=utf-8"},
						parameterMap: function (options, operation){	 
							if (operation !== "read" && options.models) { 
								return community.ui.stringify(options.models);
							}
							return community.ui.stringify(options);
						}
					},   
					serverPaging: false,
					schema: {
						total: "totalCount",
						data: "items"
					}
				},  
				selectable: "row",
				pageable: false, 
				sortable: true,
				filterable: true, 
				autoBind : false,
				change : function() {
					var selectedRows = this.dataItem(this.select());
					console.log( url + '.monthly-grid' ); 
					createAssineeMonthlyGrid( $(url + ' .monthly-grid'), observable ).dataSource.filter( [{ logic: 'AND', field: "T1.ASSIGNEE", operator: "eq", value: selectedRows.user.userId  }]);
				},
				dataBound: function (){
					var $this = this;
					createBarChart(renderTo2, "담당자별 처리현황", $this.dataSource.data(), observable);
				},
				columns: [
					{ field: "user.userId", title: "담당자", width: 120, filterable: false, sortable: true , template : '#= user.name #', attributes:{ class:"text-center" }},
					{ field: "total", title: "이슈", filterable: false, sortable: false , template : $('#issue-column-template').html(), attributes:{ class:"g-font-size-14" } },
					{ field: "closedCount", title: "완료", filterable: false, sortable: true, width: 150,  template:'#= community.data.getFormattedNumber(closedCount) #', attributes:{ class:"text-right" } },
					{ field: "totalCount", title: "전체", filterable: false, sortable: true, width: 150,  template:'#= community.data.getFormattedNumber(totalCount) #', attributes:{ class:"text-right" } }
				]		
			}); 
		}
		return community.ui.grid( renderTo );
	}
	
	function createAssineeMonthlyGrid ( renderTo , observable ){
		if( !community.ui.exists( renderTo ) ){	 
			console.log("createAssineeMonthlyGrid") ;
 			var grid = community.ui.grid( renderTo , {
				dataSource: {
					transport: { 
						read : { url:'<@spring.url "/data/apis/stats_assinee_by_monthly.json"/>', type:'post', contentType: "application/json; charset=utf-8"},
						parameterMap: function (options, operation){	 
							return community.ui.stringify(options);
						}
					},  
					serverFiltering : true,
					serverPaging: false,
					schema: {
						total: "totalCount",
						data: "items"
					},
					sort: { field: "month", dir: "asc" },
					aggregate: [ { field: "closedCount", aggregate: "average" }, { field: "closedCount", aggregate: "sum" }, { field: "totalCount", aggregate: "average" }, { field: "totalCount", aggregate: "sum" }]
				},  
				selectable: "row",
				pageable: false, 
				sortable: true,
				filterable: false, 
				autoBind : false,
				dataBound: function (){
					var $this = this;
				},
				columns: [
					{ field: "month", title: "월", width: 120, filterable: false, sortable: true , template : '#= month #', attributes:{ class:"text-center" }},
					{ field: "total", title: "이슈", filterable: false, sortable: false , template : $('#issue-column-template').html(), attributes:{ class:"g-font-size-14" } },
					{ field: "closedCount", title: "완료", filterable: false, sortable: true, width: 150,  template:'#= community.data.getFormattedNumber(closedCount) #', attributes:{ class:"text-right" }
					  , aggregates: ["average", "sum"], footerTemplate: "<div>sum : #= sum #</div> <div>average : #= average #</div>"
					},
					{ field: "totalCount", title: "전체", filterable: false, sortable: true, width: 150,  template:'#= community.data.getFormattedNumber(totalCount) #', attributes:{ class:"text-right" }
					  , aggregates: ["average", "sum"], footerTemplate: "<div>sum : #= sum #</div> <div>average : #= average #</div>"
					}
				]		
			});
			
		}
		return community.ui.grid( renderTo );
	}
	
	 	 
	function createProjectIssueStateAsChart(observable){  
 		var renderTo = $("#chart_div");
 		if( !community.ui.exists( renderTo ) ){		 
			var chart = renderTo.kendoChart({
                dataSource: {
                    transport: {
                        read: {
                            url: '<@spring.url "/data/apis/stats_issue_by_year.json"/>', 
                            type:'post', 
                            contentType: "application/json; charset=utf-8", 
                            dataType: 'json'
                        },
                        parameterMap : function (options, operation){		
							return community.ui.stringify(options);
						}
                    }, 
					filter : { filters : [ 
						{ logic: 'AND', field: "T1.OBJECT_ID", operator: "doesnotcontain", value: 28 }
					]}, 
                    sort: {
                        field: "month",
                        dir: "asc"
                    },
                    serverFiltering : true,
                    schema: {
						total: "totalCount",
						data:  "items"
					}
                }, 
                title: {
                    text: "월별 이슈 현황"
                },
                legend: {
                    position: "top"
                },
                seriesDefaults: {
                    type: "line"
                },
                series: [{
                	type: "line",
                	style: "smooth", 
                	color: "red",
                	axis: "open",
                    field: "aggregate['001'].value",
                    categoryField: "month",
                    name: "오류"
                },
                {
                	type: "line",
                	style: "smooth", 
                	axis: "open",
                    field: "aggregate['002'].value",
                    categoryField: "month",
                    name: "데이터작업"
                },
                {
                	type: "line",
                	style: "smooth", 
                	axis: "open",
                    field: "aggregate['003'].value",
                    categoryField: "month",
                    name: "기능변경"
                },
                {
                	type: "line",
                	style: "smooth", 
                	axis: "open",
                    field: "aggregate['004'].value",
                    categoryField: "month",
                    name: "추가개발"
                },
                {
                	type: "line",
                	style: "smooth", 
                	axis: "open",
                    field: "aggregate['005'].value",
                    categoryField: "month",
                    name: "기술지원"
                },
                {
                	type: "line",
                	style: "smooth", 
                	axis: "open",
                    field: "aggregate['006'].value",
                    categoryField: "month", 
                    name: "영업지원"
                },
                {
                	type: "area",
                	axis: "open",
                	style: "smooth", 
                    field: "totalCount",
                    categoryField: "month",
                    name: "OPEN"
                },
                {
                	type: "area",
                	axis: "closed",
                	style: "smooth", 
                	color: "#ccc",
                    field: "closedCount",
                    categoryField: "month",
                    name: "CLOSED"
                }],
                categoryAxis: {
                    labels: {
                        rotation: -90
                    },
                    crosshair: {
                        visible: true
                    }
                },
                valueAxis: [{
                	name : "open",
                	title: { text: "OPEN" },
                    labels: {
                        format: "N0"
                    },
                    majorUnit: 5
                },
                {
                	name : "closed",
                	title: { text: "CLOSED" },
                    labels: {
                        format: "N0"
                    },
                    color: "#ccc",
                    majorUnit: 5
                }],
                tooltip: {
                    visible: true,
                    shared: true,
                    format: "N0"
                }
            }); 

            
            $('#year-stats-summary a[data-action=export]').click(function(){
				kendo.drawing.drawDOM($("#year-stats-summary"))
		        .then(function(group) {
		            // Render the result as a PDF file
		            return kendo.drawing.exportPDF(group, {
		                paperSize: "auto",
		                margin: { left: "1cm", top: "1cm", right: "1cm", bottom: "1cm" }
		            });
		        })
		        .done(function(data) {
		            // Save the PDF file
		            kendo.saveAs({
		                dataURI: data,
		                fileName: "년간누적이슈처리현황.pdf",
		                proxyURL: "<@spring.url "/download/proxy"/>"
		            });
		        });
            });
		}
 	}
 		 

	function getContractorName(code){
		var name = "";
		if( code == null )
			return "";
		console.log( code );
		var renderTo = $('#page-top');
		$.each( renderTo.data("model").contractorData , function( index, value ){
			if( value.code == code )
			{
				name = value.name;
				return ;
			}
		} );
		return name;
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
		
	function createSummaryListView( observable ){
		console.log("create listview.");
		var renderTo = $('#summary-listview');
		var listview = community.ui.listview( renderTo , {
			autoBind : false,
			dataSource: community.ui.datasource( '<@spring.url "/data/api/v1/issues/overviewstats/list.json" />' , {
	   		transport:{
				read:{
					contentType: "application/json; charset=utf-8"
				},
				parameterMap: function (options, operation){
					options.startDate = community.data.getFormattedDate(observable.get("startDate"), "yyyyMMdd" )	;
					options.endDate = community.data.getFormattedDate(observable.get("endDate"), "yyyyMMdd" )	;
					if( observable.selectedProjects().length > 0 )
						options.projectIds = observable.selectedProjects();
						
					console.log( "items<1> : " + community.ui.stringify( options ) ) ;	
					console.log( "send..." );
					return community.ui.stringify( options );
				}
			},
			serverPaging : false,
			serverFiltering: true,	
			pageSize : 100,
			filter: {},
			schema: {
				total: "totalCount",
				data: "items"
			},
			aggregate : [					
				{ field: "withinPeriodIssueCount", aggregate: "sum" },
				{ field: "resolutionCount", aggregate: "sum" },
				{ field: "unclosedTotalCount", aggregate: "sum" }
			]	
	   		}),
			template: community.ui.template($("#template").html()),
			dataBound: function() {
				//if( this.items().length == 0)
			    //renderTo.html('<div class="forum-item">결과가 없습니다.</div>');
			    
			    observable.set('withinPeriodIssueCount', listview.dataSource.aggregates().withinPeriodIssueCount.sum );	
			    observable.set('resolutionCount', listview.dataSource.aggregates().resolutionCount.sum );	
			    observable.set('unclosedTotalCount', listview.dataSource.aggregates().unclosedTotalCount.sum );	
			}
		});
		renderTo.removeClass('k-widget');  
		observable.filters(listview.dataSource);
	}	
	
	
	</script>	
	<style>
	
	@font-face {
	  font-family: "DejaVu Sans";
	  font-style: normal;
	  font-weight: 300;
	  src: url(<@spring.url "/fonts/nanumgothic/v3/"/>NanumGothic-Regular.eot);
	  src: url(<@spring.url "/fonts/nanumgothic/v3/"/>NanumGothic-Regular.eot?#iefix) format('embedded-opentype'),
	       url(<@spring.url "/fonts/nanumgothic/v3/"/>NanumGothic-Regular.woff) format('woff'),
	       url(<@spring.url "/fonts/nanumgothic/v3/"/>NanumGothic-Regular.ttf) format('truetype');
	}
	/*
            Use the DejaVu Sans font for display and embedding in the PDF file.
            The standard PDF fonts have no support for Unicode characters.
	*/
    .k-chart {font-family: "DejaVu Sans", "Arial", sans-serif;}	
	.w-100{
		width: 100%!important;
	}
	
	.k-grid .k-state-selected td[role=gridcell]{
		font-weight : 500;
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
	    font-size:11.5px;
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
	.list-inline {
	    padding-left: 0;
	    margin-left: -5px;
	    list-style: none;
	}
	.list-inline>li {
	    display: inline-block;
	    padding-right: 5px;
	    padding-left: 5px;
	}	
	
	#nav-tabstrip .nav-item.active {
		font-weight:600;
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
        <div class="container g-bg-cover__inner g-pt-100">
        <div class="row justify-content-center">
          <div class="col-lg-9">
            <div class="mb-5">
              <h1 class="g-color-white h1 mb-4"><#if __page?? >${__page.title}</#if></h1>
              <h2 class="g-color-white g-font-weight-400 g-font-size-18 mb-0 text-left" style="line-height: 1.8;"><#if __page?? >${__page.summary}</#if></h2>
            </div>
          </div>
        </div>
		</div>
      </div>
    </section>
    <div class="u-shadow-v19 g-bg-gray-light-v5" >
	<section class="container g-py-30 g-pos-rel">
	<!-- tabs -->
	<nav id="nav-tabstrip" class="g-font-weight-400" >
	<ul class="nav justify-content-center u-nav-v5-1 u-nav-dark " id="myTab" role="tablist" >
	  <li class="nav-item">
	    <a class="nav-link g-px-25" data-toggle="tab" href="#nav-stats-year" role="tab" aria-controls="nav-stats-year" aria-selected="false"><i class="icon-finance-242 u-line-icon-pro"></i> 요약</a>
	  </li>
 	  <li class="nav-item">
	    <a class="nav-link g-px-25" data-toggle="tab" href="#nav-stats-assinee" role="tab" aria-controls="nav-stats-assinee" aria-selected="false"><i class="icon-finance-252 u-line-icon-pro"></i> 담당자별 현황</a>
	  </li>	  
 	  <li class="nav-item">
	    <a class="nav-link g-px-25" data-toggle="tab" href="#nav-stats-project" role="tab" aria-controls="nav-stats-project" aria-selected="false"><i class="icon-finance-252 u-line-icon-pro"></i> 프로젝트별 현황</a>
	  </li>	  	  
	  <li class="nav-item">
	    <a class="nav-link g-px-25" data-toggle="tab" href="#nav-stats-terms" role="tab" aria-controls="nav-stats-terms" aria-selected="false"><i class="icon-finance-252 u-line-icon-pro"></i> 기간별 현황</a>
	  </li>
	  <button class="btn u-btn-outline-darkgray btn-md g-pos-abs" style="right:0px;" type="button" role="button" data-bind="{click:back}" data-toggle="tooltip" data-placement="bottom" data-original-title="이전 페이지로 이동합니다.">이전</button>
	</ul>
	</nav> 
	<!-- /.tabs --> 
	</section> 
	
			<div data-bind="invisible: visible" class="text-center">
				<img src="<@spring.url ""/>${__page.getProperty("preloader.image", "/images/preloaders/loader_holiday.gif") }" class="animated zoomIn img-fluid" />
			</div>	
		
	</div>
	<div class="tab-content g-bg-gray-light-v5 g-min-height-500" id="myTabContent">
		<div class="tab-pane fade" id="nav-stats-year" role="tabpanel" aria-labelledby="home-tab"> 
		<div class="u-shadow-v19 g-bg-gray-light-v5">
			<div class="container g-py-30" id="year-stats-summary" >   
				<!-- heading -->
				<div class="u-heading-v2-4--bottom g-mb-10">
		           	<h2 class="text-uppercase u-heading-v2__title g-mb-10">년간 누적 이슈처리 현황</h2>
		           	<h4 class="g-font-weight-200">년간 전체 프로젝트 이슈처리 현황입니다.</h4>
				</div>  
				<!-- /.heading -->		
				<div class="row">
				<a class="u-link-v5 g-color-gray-dark-v4 g-color-gray-light-v6 g-color-secondary--hover g-mr-15 g-font-weight-300" href="#!" data-action="export">
					<i class="icon-share-alt g-font-size-18"></i> SAVE AS PDF
				</a>
				<div id="chart_div" style="width: 100%; min-height: 500px;"></div> 
				</div>
			</div>
		</div>
		</div>
		<div class="tab-pane fade" id="nav-stats-assinee" role="tabpanel" aria-labelledby="assinee-tab"> 
			<div class="barchart"></div>
			<div class="grid"></div>
			<div class="monthly-grid"></div>
		</div>
		<div class="tab-pane fade" id="nav-stats-project" role="tabpanel" aria-labelledby="project-tab"> 
			<div class="grid"></div>
			<div class="assinee-grid"></div>				
			<div class="monthly-grid"></div>
		</div>		
		<div class="tab-pane fade" id="nav-stats-terms" role="tabpanel" aria-labelledby="profile-tab">
		<div class="u-shadow-v19 g-bg-gray-light-v5">
		<section class="container g-py-30">
			<!-- heading -->
			<!--
			<div class="u-heading-v2-4--bottom g-mb-10">
	           	<h2 class="text-uppercase u-heading-v2__title g-mb-10">기간별 이슈처리 현황</h2>
	           	<h4 class="g-font-weight-200">기간에 따른 이슈처리 현황입니다.</h4>
			</div>  -->
			<!-- /.heading -->	
			<!-- search condition -->
			<div class="row align-items-center g-pb-10">
				<div class="col-md-6 col-lg-4 g-mb-30">
					<h3 class="h6 mb-3"> 계약자 </h3>	
					<input data-role="dropdownlist"
						data-value-primitive="true" 
						data-option-label="계약자를 선택하세요."
						data-auto-bind="true"
						data-text-field="name"
						data-value-field="code"
						data-bind="value:contractor, source: contractorData"
						style="width: 100%;" /> 
				</div>
				<div class="col-md-6 col-lg-4 g-mb-30">
					<h3 class="h6 mb-3"> 시작일 </h3>	
					<input data-role="datepicker" style="width: 100%" data-bind="value:startDate" placeholder="시작일">
				</div>
				<div class="col-md-6 col-lg-4 g-mb-30">
					<h3 class="h6 mb-3">종료일  </h3>	
					<input data-role="datepicker" style="width: 100%" data-bind="value:endDate" placeholder="종료일">
				</div>		 
			</div>
			<h3 class="h6 mb-3"> 제외할 프로젝트를 선택하세요  </h3>	
			<div class="row">
				<div class="col-md-6 col-lg-4 g-mb-30">
					<select id="listbox1" data-role="listbox" class="g-height-150" style="min-width: 100%;"
		                data-text-field="name"
		                data-value-field="projectId" 
		                data-toolbar='{
		                tools: ["transferTo", "transferFrom"]
		            }'
		                data-connect-with="listbox2"
		                data-bind="source: projectsData,
		                    events: {
		                        change: change, 
		                        reorder: reorder,
		                        remove: remove
		                    }">
		       		</select> 	
		       	</div>				
				<div class="col-md-12 col-lg-4 g-mb-30">
		        	<select id="listbox2" data-role="listbox" class="g-height-150 g-brd-red g-brd-1" style="min-width: 100%;"
		                data-connect-with="listbox1"
		                data-text-field="name"
		                data-value-field="projectId">
		        	</select>				
				</div> 
				<div class="col-md-6 col-lg-4 text-right">
					<button type="button" class="btn btn-md u-btn-3d u-btn-darkgray g-px-25 g-py-13" data-bind="{click:search}">검색</button>
					<button type="button" class="btn btn-lg u-btn-3d u-btn-lightred g-px-25 g-py-11" data-bind="{click:exportExcel}">엑셀 다운로드</button>
				</div>
			</div> 		 	
			<!-- search condition -->
		</section>
		<div class="u-shadow-v19 g-color-white g-bg-black-opacity-0_7">
		<section class="container g-max-width-800 g-pt-15">	 
		<div class="js-countdown text-center text-uppercase u-countdown-v4" >
            <div class="d-inline-block g-font-size-12 g-px-10 g-px-50--md g-py-15">
              <div class="js-cd-days g-font-size-20 g-font-size-40--md g-font-weight-700 g-line-height-1 g-mb-5" data-bind="text:withinPeriodIssueCount">0</div>
              <span>요청</span>
            </div> 
            <div class="d-inline-block g-font-size-12 g-brd-left g-brd-white-opacity-0_4 g-px-10 g-px-60--md g-py-15">
              <div class="js-cd-hours g-font-size-20 g-font-size-40--md g-font-weight-700 g-line-height-1 g-mb-5" data-bind="text:resolutionCount">0</div>
              <span>처리</span>
            </div>

            <div class="d-inline-block g-font-size-12 g-brd-left g-brd-white-opacity-0_4 g-px-10 g-px-60--md g-py-15">
              <div class="js-cd-minutes g-font-size-20 g-font-size-40--md g-font-weight-700 g-line-height-1 g-mb-5">미지원</div>
              <span>작업시간</span>
            </div>

            <div class="d-inline-block g-font-size-12 g-brd-left g-brd-white-opacity-0_4 g-px-10 g-px-50--md g-py-15">
              <div class="js-cd-seconds g-font-size-20 g-font-size-40--md g-font-weight-700 g-line-height-1 g-mb-5" data-bind="text:unclosedTotalCount">0</div>
              <span>누적 미처리</span>
            </div>
          </div>
		</section>	 
		</div>
		<div class="u-shadow-v19 g-bg-white">
		<section class="container g-py-15">		
			<div class="row">	
				<div class="col-12">
					<div id="summary-listview" class="no-border"></div>			
				</div>
			</div>			
	  	</section>  
	  	</div>  		
	</div>

	</div>
	
	<!-- FOOTER START -->   
	<#include "includes/user-footer.ftl">
	<!-- FOOTER END -->  
 
	
	<script type="text/x-kendo-template" id="project-column-template">
	
	# if (project.contractState == '003') { # <del>#: project.name #</del> # } else { # #: project.name # # } #
	<p class="g-font-weight-300 g-color-gray-dark-v6 g-mt-5 g-ml-10 g-mb-0" > 
		# if ( project.contractState == '002') { # <span class="u-label u-label-default g-rounded-20 g-mr-10 g-mb-0">무상</span> 
		# } else if (project.contractState == '001') { # <span class="u-label u-label-primary g-rounded-20 g-mr-10 g-mb-0">유상</span> # } #		
		# if ( new Date() > new Date(project.endDate) ) {#  <span class="u-label u-label-danger g-rounded-20 g-mr-10 g-mb-0">계약만료</span> #} #	
	</p>	
	</script>
	<script type="text/x-kendo-template" id="issue-column-template">
	#:aggregate["001"].name # : #= aggregate["001"].value # #if( typeof closedAggregate["001"] !== "undefined" ){# <span class="u-label u-label--sm g-bg-gray-light-v4 g-color-main g-rounded-20 g-px-10"> #= closedAggregate["001"].value # </span> #}# ,
	#:aggregate["002"].name # : #= aggregate["002"].value # #if( typeof closedAggregate["002"] !== "undefined" ){# <span class="u-label u-label--sm g-bg-gray-light-v4 g-color-main g-rounded-20 g-px-10"> #= closedAggregate["002"].value # </span> #}# ,
	#:aggregate["003"].name # : #= aggregate["003"].value # #if( typeof closedAggregate["003"] !== "undefined" ){# <span class="u-label u-label--sm g-bg-gray-light-v4 g-color-main g-rounded-20 g-px-10"> #= closedAggregate["003"].value # </span> #}# ,
	#:aggregate["004"].name # : #= aggregate["004"].value # #if( typeof closedAggregate["004"] !== "undefined" ){# <span class="u-label u-label--sm g-bg-gray-light-v4 g-color-main g-rounded-20 g-px-10"> #= closedAggregate["004"].value # </span> #}# ,
	#:aggregate["005"].name # : #= aggregate["005"].value # #if( typeof closedAggregate["005"] !== "undefined" ){# <span class="u-label u-label--sm g-bg-gray-light-v4 g-color-main g-rounded-20 g-px-10"> #= closedAggregate["005"].value # </span> #}# ,
	#:aggregate["006"].name # : #= aggregate["006"].value # #if( typeof closedAggregate["006"] !== "undefined" ){# <span class="u-label u-label--sm g-bg-gray-light-v4 g-color-main g-rounded-20 g-px-10"> #= closedAggregate["006"].value # </span> #}#
	</script>
			
	<script type="text/x-kendo-template" id="template">
	<div class="forum-item">
		<div class="row">
			<div class="col-md-9">
				<div class="forum-icon">
				<i class="icon-svg #if(unclosedTotalCount > 3 && unclosedTotalCount < 10 ){# icon-svg-md #}else if (unclosedTotalCount >= 10) {# icon-svg-lg #}else{# icon-svg-sm #}# #if( unclosedTotalCount > 0 ){# icon-svg-ios-angry #}else{# icon-svg-ios-smile #}# g-opacity-0_9"></i>				
				</div>
				<h2 class="g-ml-60 g-font-weight-100">#: project.name #</h2>
				<div class="g-ml-60 g-mb-5 g-font-size-15">
					<ul class="list-inline">
						<li>오류: #= aggregate["001"] #</li>
						<li>데이터작업 : #= aggregate["002"] #</li>						
						<li>기능변경 : #= aggregate["003"] #</li>
						<li>추가개발 : #= aggregate["004"] #</li>
						<li>기술지원 : #= aggregate["005"] #</li>
						<li>영업지원 : #= aggregate["006"] #</li>						
					</ul>
				</div>
			</div>
			<div class="col-md-1 forum-info">
				<span class="views-number">#: withinPeriodIssueCount #</span>
				<div>
					<small>기간내 요청건</small>
				</div>
			</div>
			<div class="col-md-1 forum-info">
				<span class="views-number">#: resolutionCount #</span>
				<div>
					<small>기간내 처리건</small>
				</div>
			</div>
			<div class="col-md-1 forum-info">
				<span class="views-number g-color-red">#: unclosedTotalCount #</span>
				<div>
					<small class="g-color-red">누적 미처리건</small>
				</div>
			</div>
		</div>
	</div>
	</script>
</body>
</html>	
</#compress>