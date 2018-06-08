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
	
	var __boardId = <#if RequestParameters.boardId?? >${RequestParameters.boardId}<#else>0</#if>;
	
	require.config({
		shim : {
			"bootstrap" : { "deps" :['jquery'] },
			<!-- kendo -->
			"kendo.ui.core.min" : { "deps" :['jquery'] },
	        "kendo.culture.ko-KR.min" : { "deps" :[ 'jquery', 'kendo.ui.core.min'] },
	        "community.ui.core" : { "deps" :['jquery', 'kendo.ui.core.min'] },
	        "community.data" : { "deps" :['jquery', 'kendo.ui.core.min','community.ui.core'] },	 
	        			
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
	require([ "jquery", "bootstrap", "kendo.culture.ko-KR.min", "community.data", "hs.header", "hs.hamburgers",  'dzsparallaxer.advancedscroller' ], function($) { 
		
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
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
			},
			setSource : function (data ){
				var $this = this;		 
				data.copy($this.board);
			},
			filter : {
				SUBJECT : null
			},
			search : function(e){
				var $this = this , filters = [];
				console.log( $this.filter.SUBJECT ) ;
				
				if( $this.filter.SUBJECT != null ){
					filters.push({ field: "SUBJECT", operator: "contains", value: $this.filter.SUBJECT, logic : "AND" });
				}
				community.ui.listview( $('#thread-listview') ).dataSource.filter( filters );				
				
				return false;
			},
			load : function(objectId){
				var $this = this;		 
				community.ui.ajax('/data/api/v1/boards/' + objectId + '/info.json', {
					success: function(data){				
						$this.setSource( new community.model.Board(data) );			
						if($this.board.readable)	
							createThreadListView(observable);
					}
				});	
			}
    	});

		var renderTo = $('#features');
		community.ui.bind( renderTo , observable );
    	observable.load( __boardId );
    	
    	renderTo.on("click", "button[data-action=create], a[data-action=create], a[data-action=view]", function(e){			
			var $this = $(this);
			var actionType = $this.data("action");		
			var objectId = $this.data("object-id");		
			if( actionType == 'view' ){
				community.ui.send("<@spring.url "/display/pages/community-article-viewer.html" />", { 'boardId': __boardId , 'threadId': objectId });
				return;	
			}else if ( actionType == 'create' ){
				community.ui.send("<@spring.url "/display/pages/community-article-viewer.html" />", { 'boardId': __boardId });
				return;	
			}
			return false;		
		});		
		
	});

	
		    	
   	function createThreadListView( observable ) {
		var renderTo = $("#thread-listview");
		var listview = community.ui.listview( renderTo , {
			dataSource: community.ui.datasource('<@spring.url "/data/api/v1/boards/"/>'+ observable.get('board.boardId') +'/threads/list_v2.json', {
				transport: { 
					read:{
						contentType: "application/json; charset=utf-8"
					},
					parameterMap: function (options, operation){	 
						return community.ui.stringify(options);
					}
				},
				schema: {
					total: "totalCount",
					data: "items",
					model: community.model.Thread
				},
				pageSize : 15,
				serverPaging : true,
				serverFiltering:true,
				serverSorting: true
			}),
			dataBound : function(e){
				$('[data-toggle="tooltip"]').tooltip();
				if( this.items().length == 0)
					renderTo.html('<tr class="g-height-150"><td colspan="3" class="align-middle g-font-weight-300 g-color-black text-center">조건에 해당하는 데이터가 없습니다.</td></tr>');
			
			},
			template: community.ui.template($("#template").html())
		});	
		
		community.ui.pager( $("#thread-listview-pager"), {
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
	<section class="g-py-60">
		<div class="container" id="features">
             
			<div class="d-flex g-pos-rel justify-content-end align-items-center g-brd-bottom g-brd-gray-light-v4 g-pt-40 g-pb-20">
				<!-- Back Button -->
				<div class="g-mr-60 g-pos-abs g-left-0 g-pb-30" >
					<a href="/display/pages/community.html" class="back" data-toggle="tooltip" data-placement="top" title="" data-original-title="뒤로가기"><i class="icon-svg icon-svg-sm icon-svg-ios-back"></i></a>
				</div>
				<!-- End Back Button -->
            </div>  
        			
			<div class="g-mt-25 mb-0">
          		<h2 class="h3 g-color-black mb-0" data-bind="text:board.displayName"></h2>
          		<div class="d-inline-block g-width-50 g-height-1 g-bg-black"></div>
          		<p class="" data-bind="text:board.description"></p>
          	</div>
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
	            	<a href="#!" class="btn u-btn-primary g-font-size-14 g-px-25 g-py-13" data-bind="{visible:board.createThread}" data-action="create" data-object-id="0" >새로운 글 게시하기</a>
	            </div> 
            </div> 
        	<!-- Ent Toolbar -->
        	<div class="table-responsive">
	            <table class="table table-bordered u-table--v2 g-col-border-side-0 g-mb-0 g-brd-gray-dark-v6 g-brd-top-3 g-brd-style-solid">
	                <thead class="text-uppercase g-letter-spacing-1 g-bg-gray-light-v5 g-font-size-14">
	                   <tr>
	                       <th class="g-font-weight-300 g-color-black g-width-50">&nbsp;</th>
	                       <th class="g-font-weight-300 g-color-black g-min-width-200">제목</th>
	                       <th class="g-font-weight-300 g-color-black g-width-100"> </th> 
	                       <th class="g-font-weight-300 g-color-black g-width-100"> </th> 
	                   </tr>
	                </thead> 
	            	<tbody id="thread-listview" class="g-brd-0 u-listview" >
	            		<tr class="g-height-150"><td colspan="3" class="align-middle g-font-weight-300 g-color-black text-center"></td></tr>	            	
	            	</tbody>
	            </table>
           	</div>
           	<div id="thread-listview-pager" class="g-brd-top-0 g-brd-right-0 g-brd-left-0 g-font-size-14"  ></div>
		</div>   
	</section>
	<script type="text/x-kendo-template" id="template">
	<tr class="u-listview-item">
		<td class="align-top g-width-50 text-nowrap">
			<div class="media">
				<a href="\\#!" data-toggle="tooltip" data-placement="right" title="" data-original-title="#= community.data.getUserDisplayName( rootMessage.user ) # 님이 #= community.data.getFormattedDate(rootMessage.creationDate, 'yyyy.MM.dd') # 에 게시함." >
				<img class="d-flex g-width-40 g-height-40 rounded-circle g-mr-10" src="#= community.data.getUserProfileImage( rootMessage.user ) #" alt="Image Description" >
				</a>
				<!--
				<div class="media-body align-self-center">
					<h5 class="h6 align-self-center g-font-weight-600 g-color-darkpurple mb-0">#: community.data.getUserDisplayName( rootMessage.user ) #</h5>
					<span class="g-font-size-12">#= community.data.getFormattedDate(rootMessage.creationDate, 'yyyy.MM.dd') #</span>
				</div>
				-->
			</div>        
		</td>
		<td class="align-middle"> 
			<a class="d-flex align-items-center u-link-v5 u-link-underline g-color-black g-color-lightblue-v3--hover g-color-lightblue-v3--opened" href="\#!" data-action="view" data-object-id="#= threadId #" data-object-type="article">
			<h5 class="g-font-weight-400">
			#: rootMessage.subject #
			</h5>
			</a>
			#if ( messageCount > 1) {#
			<ul class="list-inline d-sm-flex g-color-gray-dark-v4 g-font-size-12 g-mb-10 ">
				<li class="list-inline-item"><i class="icon fa fa-reply small"></i></li>
				<li class="list-inline-item g-font-weight-600">#= community.data.getUserDisplayName( latestMessage.user ) # </li>
				<li class="list-inline-item g-mx-10">작성일 :  #= community.data.getFormattedDate(latestMessage.modifiedDate) #</li>
			</ul>
			#}#
	        <button class="btn btn-xs u-btn-outline-darkgray g-rounded-50 g-mt-0 g-mr-10 collapsed" type="button" data-toggle="collapse" data-target="\\#last-message-for-#:threadId#" aria-expanded="false" aria-controls="last-message-for-#:threadId#">
		    	마지막글 보기 <i class="icon fa fa-angle-down"></i>
		    </button>
		    <div class="collapse" id="last-message-for-#:threadId#">
				<div class="card rounded-10 g-mt-15">
					<div class="card-block g-font-size-16">#= latestMessage.body #</div>
				</div>
		    </div>          
		</td>
		<td class="align-top text-center">
			<span class="g-font-size-24 g-font-weight-400 g-line-height-18">#: viewCount #</span>
			<div class="g-font-size-14 g-font-weight-100 g-color-gray-light-v2">
				<small>Views</small>
			</div>
		</td>
		<td class=" text-center">
			<span class="g-font-size-24 g-font-weight-400 g-line-height-18">#= messageCount -1 #</span>
			<div class="g-font-size-14 g-font-weight-100 g-color-gray-light-v2">
				<small>Posts</small>
			</div>
		</td>		
	</tr>		
	</div>	
</main>
</body>
</html>
</#compress>