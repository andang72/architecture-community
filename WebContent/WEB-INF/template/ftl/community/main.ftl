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
    		 
	
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-core.css"/>">
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-components.css"/>">
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-globals.css"/>">
	
	<link rel="stylesheet" href="<@spring.url "/css/community.ui/community.ui.style_v2.css"/>">
  	
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
			<!-- kendo -->
			"kendo.ui.core.min" : { "deps" :['jquery'] },
	        "kendo.culture.ko-KR.min" : { "deps" :[ 'jquery', 'kendo.ui.core.min'] },
	        "community.ui.core" : { "deps" :['jquery', 'kendo.ui.core.min'] },
	        "community.data" : { "deps" :['jquery', 'kendo.ui.core.min','community.ui.core'] },	  
	        <!-- unify -->
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
	require([ "jquery", "bootstrap",  "kendo.culture.ko-KR.min", "community.data", "hs.header", "hs.hamburgers",  'dzsparallaxer.advancedscroller' ], function($, kendo) { 
		
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
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
			}
    	});
		
		createBoardListView(); 
		
		var renderTo = $("#features");
		renderTo.on("click", "button[data-object-type=article], .sorting[data-kind=article], a[data-object-type=article]", function(e){			
			var $this = $(this);
			var actionType = $this.data("action");	
			if( actionType == 'sort'){
				return false;				
			}else if (actionType == 'view' ){
				community.ui.send("<@spring.url "/display/pages/community-article-list.html" />", { boardId: $this.data("object-id") });
				return false;
			}	
			return false;		
		});	
		
	});
	
	function createBoardListView(){
		
		var renderTo = $('#board-listview');	    		
		var listview = community.ui.listview( renderTo , {
			dataSource: community.ui.datasource('<@spring.url "/data/api/v1/boards/list.json"/>', {
				schema: {
					total: "totalCount",
					data: "items",
					model: community.model.Board
				}
			}),
			template: community.ui.template($("#template").html())
		}); 
		
		community.ui.pager( $("#board-listview-pager"), {
            dataSource: listview.dataSource
        }); 
		
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
    


	<section class="g-py-100">
		<div class="container" id="features">
			
			<#if __page.bodyText?? >${__page.bodyText}</#if>
			
			<!-- Toolbar -->
			<div class="d-flex g-pos-rel justify-content-end align-items-center g-brd-bottom g-brd-gray-light-v4 g-pt-40 g-pb-20" style="min-height: 110px;"> 
				<div class="g-mr-60 g-pos-abs g-left-0" > 
	                  <h2 class="h6 align-middle d-inline-block g-font-weight-400 text-uppercase g-pos-rel g-top-1 mb-0">검색:</h2>	
	                  <!-- Search Button -->
	                  <div class="d-inline-block btn-group g-line-height-1_2 g-font-size-14 g-mr-20">
	                    <div class="input-group g-pos-rel g-max-width-380 float-right">
						<input class="form-control g-font-size-default g-brd-gray-light-v7 g-brd-lightblue-v3--focus g-rounded-20 g-pl-20 g-pr-50 g-py-10" type="text" placeholder="제목" data-bind="value:filter.SUBJECT">
						<button class="btn g-pos-abs g-top-0 g-right-0 g-z-index-2 g-width-60 h-100 g-bg-transparent g-font-size-16 g-color-lightred-v2 g-color-lightblue-v3--hover rounded-0" type="button" data-bind="click:search">
						<i class="icon-magnifier g-pos-rel g-top-3"></i>
						</button>
						</div>
	                  </div>
	                  <!-- End Search Button --> 
				</div>  
	            <div class="g-mr-0">
	            	
	            </div> 
            </div> 
        	<!-- Ent Toolbar -->
        			
			<div class="table-responsive ">
                <table class="table table-bordered u-table--v2 g-col-border-side-0 g-mb-0 g-brd-gray-dark-v6 g-brd-top-3 g-brd-style-solid">
                  <thead class="text-uppercase g-letter-spacing-1 g-bg-gray-light-v5 g-font-size-14">
                    <tr>
                      <th class="g-font-weight-300 g-color-black g-width-50">Id.</th>
                      <th class="g-font-weight-300 g-color-black g-min-width-200">게시판</th>  
                      <th class="g-font-weight-300 g-color-black g-width-100">조회수</th>
                      <th class="g-font-weight-300 g-color-black g-width-100">게시물</th>
                    </tr>
                  </thead>
                  <tbody id="board-listview" class="g-brd-0 u-listview" ></tbody>
              </table>
            </div>
            <div id="board-listview-pager" class="g-brd-top-0 g-brd-right-0 g-brd-left-0 g-font-size-14"  ></div>
            <!-- pagenator  -->
            <!-- 
            <nav class="g-mb-0" aria-label="Page Navigation">
	          <ul class="list-inline mb-0">
	            <li class="list-inline-item hidden-down">
	              <a class="active u-pagination-v1__item g-width-30 g-height-30 g-brd-gray-light-v3 g-brd-primary--active g-color-white g-bg-primary--active g-font-size-12 rounded-circle g-pa-5" href="#!">1</a>
	            </li>
	            <li class="list-inline-item hidden-down">
	              <a class="u-pagination-v1__item g-width-30 g-height-30 g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5" href="#!">2</a>
	            </li>
	            <li class="list-inline-item g-hidden-xs-down">
	              <a class="u-pagination-v1__item g-width-30 g-height-30 g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5" href="#!">3</a>
	            </li>
	            <li class="list-inline-item hidden-down">
	              <span class="g-width-30 g-height-30 g-color-gray-dark-v5 g-font-size-12 rounded-circle g-pa-5">...</span>
	            </li>
	            <li class="list-inline-item g-hidden-xs-down">
	              <a class="u-pagination-v1__item g-width-30 g-height-30 g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5" href="#!">15</a>
	            </li>
	            <li class="list-inline-item">
	              <a class="u-pagination-v1__item g-width-30 g-height-30 g-brd-gray-light-v3 g-brd-primary--hover g-color-gray-dark-v5 g-color-primary--hover g-font-size-12 rounded-circle g-pa-5 g-ml-15" href="#!" aria-label="Next">
	                <span aria-hidden="true">
	                  <i class="fa fa-angle-right"></i>
	                </span>
	                <span class="sr-only">Next</span>
	              </a>
	            </li>
	            <li class="list-inline-item float-right">
	              <span class="u-pagination-v1__item-info g-color-gray-dark-v4 g-font-size-12 g-pa-5">Page 1 of 15</span>
	            </li>
	          </ul>
	        </nav>	
	         -->	
    	</div>
	</section>    
	<script type="text/x-kendo-template" id="template">
	<tr class="u-listview-item">
		<td class="align-middle text-center">
			#= boardId #            
		</td>
		<td class="align-middle"> 
		<a class="d-flex align-items-center u-link-v5 u-link-underline g-color-black g-color-lightblue-v3--hover g-color-lightblue-v3--opened" href="\#!" data-action="view" data-object-id="#=boardId#" data-object-type="article">
		<h5 class="g-font-weight-400">
		#:displayName#	
		</h5>
		</a>
		# if (description != null) { # 
		<p class="g-font-weight-300 g-color-gray-dark-v6 g-mt-5 g-ml-0 g-mb-0" > 
		<small>#: description # </small>
		</p>
		# } #
		</td>
		<td class="align-middle text-center">
			<span class="u-label g-bg-darkpurple g-rounded-20 g-px-10">#= totalViewCount #</span>
		</td>
		<td class="align-middle text-center">
			<span class="u-label g-bg-darkpurple g-rounded-20 g-px-10">#= totalMessage #</span>
		</td>
	</tr>
	</script>
</main>
</body>
</html>
</#compress>