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
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.common-bootstrap.core.css"/>" rel="stylesheet" type="text/css" />
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	 
	
	<!-- Bootstrap core CSS -->
	<link href="<@spring.url "/css/bootstrap/3.3.7/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />
	<link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />	

	<!-- Bootstrap Theme CSS -->
	<link href="<@spring.url "/css/bootstrap.theme/inspinia/style.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/bootstrap.theme/inspinia/custom.css"/>" rel="stylesheet" type="text/css" />	
		
	<!-- Community CSS -->
	<link href="<@spring.url "/css/community.ui/community.ui.globals.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/community.ui/community.ui.components.css"/>" rel="stylesheet" type="text/css" />
  	<link href="<@spring.url "/css/community.ui/community.ui.style.css"/>" rel="stylesheet" type="text/css" />	
  		
	<!-- Page landing js -->	   	
	<script data-pace-options='{ "ajax": false }' src='<@spring.url "/js/pace/pace.min.js"/>'></script>   	
	<!-- Requirejs for js loading -->
	<script src="<@spring.url "/js/require.js/2.3.5/require.js"/>" type="text/javascript"></script>
		
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
	
	require([ "jquery", "kendo.ui.core.min",  "kendo.culture.ko-KR.min", "community.data", "community.ui.core", "bootstrap", 
	"https://www.gstatic.com/charts/loader.js"], function($, kendo ) {		
	
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
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser);
			},
			startDate: getLastSaturday(),
			endDate : getThisFriday(),			
			search : function(){
				community.ui.listview( $('#summary-listview') ).dataSource.read(); 
			},
			exportExcel : function(){
				var $this = this, data = {};
				data.startDate = community.data.getFormattedDate($this.get("startDate"), "yyyyMMdd" )	;
				data.endDate = community.data.getFormattedDate($this.get("endDate"), "yyyyMMdd" )	;				
				community.ui.send("<@spring.url "/data/api/v1/export/excel/ISSUE_OVERVIEWSTATS" />", { data : community.ui.stringify(data) }, "POST");
			},
			back : function(){
				community.ui.send("<@spring.url "/display/pages/technical-support.html" />" );
				return false;
			},
			withinPeriodIssueCount : 0,
			resolutionCount : 0,
			unclosedTotalCount : 0
    		});     	
    		
    		
		// google charts loading 
		google.charts.load('current', {'packages':['corechart']});
		
      	
      	community.ui.ajax('/data/api/v1//issues/overviewstats/monthly/stats/list.json', {
      		contentType : "application/json",	
      		data: community.ui.stringify({}),
			success: function(response){	
				
				setTimeout(function(){
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
				google.charts.setOnLoadCallback(drawChart(data));				
				}, 500);
			}	
		});
			
     	var renderTo = $('#page-top');
    		renderTo.data('model', observable);
    		community.ui.bind(renderTo, observable );	    		
    		createSummaryListView(observable);
    		
	});				
	
	/**
	 * Drawing Charting .
	 */
	function drawChart(data) {
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
        var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
        chart.draw(data, options);
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
			dataSource: community.ui.datasource( '<@spring.url "/data/api/v1/issues/overviewstats/list.json" />' , {
	    			transport:{
					read:{
						contentType: "application/json; charset=utf-8"
					},
					parameterMap: function (options, operation){		
						options.startDate = community.data.getFormattedDate(observable.get("startDate"), "yyyyMMdd" )	;
						options.endDate = community.data.getFormattedDate(observable.get("endDate"), "yyyyMMdd" )	;
						return community.ui.stringify( options );
					}
				},
				serverPaging : false,
				pageSize : 0,
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
				if( this.items().length == 0)
			    		renderTo.html('<div class="forum-item">결과가 없습니다.</div>');
			    observable.set('withinPeriodIssueCount', listview.dataSource.aggregates().withinPeriodIssueCount.sum );	
			    observable.set('resolutionCount', listview.dataSource.aggregates().resolutionCount.sum );	
			    observable.set('unclosedTotalCount', listview.dataSource.aggregates().unclosedTotalCount.sum );	
			}
		});
	}	
	</script>		
</head>
<body id="page-top" class="landing-page no-skin-config">
	<!-- NAVBAR START -->   
	<#include "/includes/user-top-navbar.ftl">
	<!-- NAVBAR END -->  
	<section class="g-brd-bottom g-brd-gray-light-v4 u-bg-overlay g-bg-cover g-bg-size-cover g-bg-bluegray-opacity-0_3--after" style="background: url(/images/bg/black_panther.jpg)">
      <div class="container g-py-150">
        <div class="row">
          <div class="col-lg-6">
            <div class="d-inline-block g-width-80 g-height-4 g-bg-black mb-3"></div>
            <h2 class="g-color-white g-font-size-60 g-line-height-1 mb-4"><#if __page?? >${__page.title}</#if></h2>
            <p class="mb-0 g-color-white" ><#if __page.summary ?? >${__page.summary}</#if></p>
          </div>
        </div>
      </div>
    </section>
	<section class="container g-py-100">
		<div class="row">
			<div class="col-lg-12 g-mb-15">
				<div class="ibox float-e-margins">
					<div class="ibox-title g-pl-0 g-pb-0">
						<a href="#" class="back" data-bind="click:back">
							<i class="icon-svg icon-svg-sm icon-svg-ios-back"></i>
						</a>
					</div>				
					<div class="ibox-content ibox-heading">
						<div class="row">
							<div class="col-sm-4 g-mb-15">
								<h5 class="text-light-gray text-semibold"> 시작일 </h5>	
								<input data-role="datepicker" style="width: 100%" data-bind="value:startDate" placeholder="시작일">
							</div>
							<div class="col-sm-4 g-mb-15">
								<h5 class="text-light-gray text-semibold">종료일  </h5>	
								<input data-role="datepicker" style="width: 100%" data-bind="value:endDate" placeholder="종료일">
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12 text-right">
							
							<button type="button" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" data-bind="{click:search}">검색</button>
							<button type="button" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" data-bind="{click:exportExcel}">엑셀 다운로드</button>
							</div>
						</div>		
					</div>
				</div>			
			</div>
		</div>
		
		

        <div class="u-shadow-v11 g-rounded-7 g-pa-20 g-mb-50" >                 
                <div class="u-heading-v2-4--bottom g-mb-10">
                      <h2 class="text-uppercase u-heading-v2__title g-mb-10">년간처리현황</h2>
                      <h4 class="g-font-weight-200">년간 전체 프로젝트 이슈처리 현황입니다.</h4>
                    	</div>    			
			 <div id="chart_div" style="width: 100%; height: 500px;"></div>
		</div>	
		
		<div class="row text-center text-uppercase g-brd-gray g-brd-top-0 g-brd-left-0 g-brd-right-0  g-brd-style-solid  g-brd-3">
			<div class="col-lg-3 col-sm-6 g-brd-right g-brd-white-opacity-0_2 g-mb-25">
				<div class="js-counter g-font-size-35 g-font-weight-300 g-mb-7" data-bind="text:withinPeriodIssueCount">9</div>
				<h4 class="h5 g-color-gray-dark-v4 g-mb-5">요청</h4>
			</div>
			<div class="col-lg-3 col-sm-6 g-brd-right--lg g-brd-white-opacity-0_2 g-mb-25">
				<div class="js-counter g-font-size-35 g-font-weight-300 g-mb-7" data-bind="text:resolutionCount">9</div>
				<h4 class="h5 g-color-gray-dark-v4 g-mb-5">처리</h4>
			</div>
			<div class="col-lg-3 col-sm-6 g-brd-right g-brd-white-opacity-0_2 g-mb-25">
				<div class="js-counter g-font-size-35 g-font-weight-300 g-mb-7">미지원</div>
				<h4 class="h5 g-color-gray-dark-v4 g-mb-5">작업시간</h4>
			</div>
			<div class="col-lg-3 col-sm-6 g-mb-25">
				<div class="js-counter g-font-size-35 g-font-weight-300 g-mb-7" data-bind="text:unclosedTotalCount">2</div>
				<h4 class="h5 g-color-gray-dark-v4 g-mb-5">누적 미처리</h4>
			</div>
		</div>		
		<div class="row">	
			<div class="col-12">
				<div id="summary-listview" class="no-border"></div>			
			</div>
		</div>	
  	</section>    	
	<!-- FOOTER START -->   
	<#include "/includes/user-footer.ftl">
	<!-- FOOTER END -->  
	<script type="text/x-kendo-template" id="template">
	<div class="forum-item">
		<div class="row">
			<div class="col-md-9">
				<div class="forum-icon">
				<i class="icon-svg #if(unclosedTotalCount > 3 && unclosedTotalCount < 10 ){# icon-svg-md #}else if (unclosedTotalCount >= 10) {# icon-svg-lg #}else{# icon-svg-sm #}# #if( unclosedTotalCount > 0 ){# icon-svg-ios-angry #}else{# icon-svg-ios-smile #}# g-opacity-0_9"></i>				
				</div>
				<h2 class="g-ml-60 g-font-weight-100">#: project.name #</h2>
				<div class="g-ml-60 g-mb-5">
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