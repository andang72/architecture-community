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
   	 	
 	<!-- Kendo UI Core with bootstrap theme CSS -->			 
	<!--
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.common.core.min.css"/>" rel="stylesheet" type="text/css" />
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.common-bootstrap.core.min.css"/>" rel="stylesheet" type="text/css" /> 
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	 
	-->
	
	<!-- Professional Kendo UI --> 	
	<!--<link href="<@spring.url "/css/kendo/2018.1.221/kendo.default-v2.min.css"/>" rel="stylesheet" type="text/css" />-->
	<!--<link href="<@spring.url "/css/kendo/2018.1.221/kendo.bootstrap-v4.min.css"/>" rel="stylesheet" type="text/css" />-->
	<link href="<@spring.url "/css/bootstrap.theme/unify-bootstrap-v4/all.css"/>" rel="stylesheet" type="text/css" />	
		
   	<!-- Fonts & Icons CSS -->
	<link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/fonts/nanumgothic.min.css"/>" rel="stylesheet" type="text/css" />		
	<link href="<@spring.url "/css/community.ui/community.ui.icons.min.css"/>" rel="stylesheet" type="text/css" />	
	
	<!-- Dzsparallaxer CSS -->
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/dzsparallaxer.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/dzsscroller/scroller.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/assets/vendor/dzsparallaxer/advancedscroller/plugin.css"/>" rel="stylesheet" type="text/css" />	
			
			
	<!-- CSS Bootstrap Theme Unify -->		    
    <link href="<@spring.url "/assets/vendor/icon-hs/style.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/assets/vendor/hs-megamenu/src/hs.megamenu.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/assets/vendor/hamburgers/hamburgers.min.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/assets/vendor/icon-line/css/simple-line-icons.css"/>" rel="stylesheet" type="text/css" />	
    		 
	
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-core.css"/>">
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-components.css"/>">
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/unify-globals.css"/>"> 
	
	
	<link rel="stylesheet" href="<@spring.url "/css/bootstrap.theme/unify/custom.css"/>">
	<!--
	<link rel="stylesheet" href="<@spring.url "/css/community.ui/community.ui.style_v2.css"/>">
	-->
  	
  	<!-- Page landing js -->	   	
	<script data-pace-options='{ "ajax": false }' src='<@spring.url "/js/pace/pace.min.js"/>'></script>   	
	
	<!-- Requirejs for js loading -->
	<script src="<@spring.url "/js/require.js/2.3.5/require.js"/>" type="text/javascript"></script>
	<!-- Application JavaScript
    		================================================== -->    
	<script>
	
	var __boardId = <#if RequestParameters.boardId?? >${RequestParameters.boardId}<#else>0</#if>;
	
	<#if CommunityContextHelper.getBoardService().getBoardById( ServletUtils.getStringAsLong( RequestParameters.boardId ) )?? >
	<#assign __board = CommunityContextHelper.getBoardService().getBoardById( ServletUtils.getStringAsLong( RequestParameters.boardId ) ) />
	</#if>
	
	<#if __board?? && CommunityContextHelper.getCategoryService().getCategory(__board)?? >
	<#assign __category = CommunityContextHelper.getCategoryService().getCategory(__board) />
	</#if>
	
	require.config({
		shim : {
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
			"jquery"    				: "/js/jquery/jquery-3.1.1.min",
			"jquery.cookie"    			: "/js/jquery.cookie/1.4.1/jquery.cookie",
			"bootstrap" 				: "/js/bootstrap/4.0.0/bootstrap.bundle.min",
			<!-- Professional Kendo UI --> 
			"kendo.web.min"	 			: "/js/kendo/2018.1.221/kendo.web.min",
			"kendo.culture.min"			: "/js/kendo/2018.1.221/cultures/kendo.culture.ko-KR.min",	
			"kendo.messages.min"		: "/js/kendo.extension/kendo.messages.ko-KR",	
			<!-- community -- >
			"community.ui.core" 		: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data",   
			<!-- Unify -->
	    	"hs.core" 	   					: "/js/bootstrap.theme/unify/hs.core",
			"hs.header" 	   				: "/js/bootstrap.theme/unify/components/hs.header",
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
		"hs.header", "hs.hamburgers", "hs.dropdown", 'dzsparallaxer.advancedscroller'
		], function($) { 
		
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
		
		var observable = new community.ui.observable({ 
			back : function(){
				var $this = this;
				window.history.back();
				return false;			
			},
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
			resetKeywordsFilters : function(){
				var $this = this, cnt = 0 ;		
				
				$.each ( $('#filter-keywords input[data-kind=keywords]:checked') , function (index, value) {
					console.log( $(value).parent().html() );
					$(value).prop('checked', false );
					cnt ++ ;
				});
				
				if( cnt > 0 )
					$this.search();		
			},				
			setKeywordsFilters : function( filters ){
				$.each ( $('#filter-keywords input[data-kind=keywords]:checked') , function (index, value) {
					if( index > 0 ){
						filters.push({ field: "KEYWORDS", operator: "contains", value: $(value).data('object-value') , logic : "OR" });
					}else{
						filters.push({ field: "KEYWORDS", operator: "contains", value: $(value).data('object-value') });
					}
				}) ;
			},			
			search : function(e){
				var $this = this , filters = []; 
				$this.setKeywordsFilters(filters);  
				if( $this.filter.SUBJECT != null ){
					if( filters.length > 0 )
						filters.push({ field: "SUBJECT", operator: "contains", value: $this.filter.SUBJECT, logic : "AND" });
					else
						filters.push({ field: "SUBJECT", operator: "contains", value: $this.filter.SUBJECT });
				}
				community.ui.grid( $('#thread-grid') ).dataSource.filter( filters );		 
				return false;
			},
			load : function(objectId){
				var $this = this;		 
				community.ui.ajax('/data/api/v1/boards/' + objectId + '/info.json', {
					success: function(data){				
						$this.setSource( new community.model.Board(data) );			
						if($this.board.readable)	
							createThreadGrid(observable);
					}
				});	
			}
    	});

		var renderTo = $('#features');
		community.ui.bind( renderTo , observable );
    	observable.load( __boardId );
    	
    	renderTo.on("click", "input[data-kind=keywords]", function(e){
    		var $this = $(this);
    		observable.search(); 
    	});
    	    	
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
   	
		    	
   	function createThreadGrid( observable ) {
		var renderTo = $("#thread-grid");
		var listview = community.ui.grid( renderTo , {
			dataSource: community.ui.datasource_v2({
				transport:{
					read:{
						contentType : "application/json; charset=utf-8",
						url : '<@spring.url "/data/api/v1/boards/"/>'+ observable.get('board.boardId') +'/threads/list_v2.json',
						type : 'POST',
						dataType : 'json'
					},
					parameterMap : function (options, operation){		
						return community.ui.stringify(options);
					} 				
				},		
				schema: {					
					data:  "items",
					total: "totalCount",
					model: community.model.Thread
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
				{ field: "T2.MESSAGE_ID", title: "ID", filterable: false, sortable: true , width : 100 , template : '#: rootMessage.messageId #', attributes:{ class:"text-center" }}, 
				{ field: "T2.SUBJECT", title: "제목", filterable: false, sortable: true , template : $('#template-grid-subject').html()	
				}, 
				{ field: "T2.USER_ID", title: "작성자", filterable: false, sortable: true , width : 100 ,
					template : $('#template-grid-user').html()	
				},  
				{ field: "T1.MODIFIED_DATE", title: "일자", filterable: false, sortable: true , width : 100 , template:'#= community.data.getFormattedDate( modifiedDate, "yyyy.MM.dd") #' ,attributes:{ class:"text-center" } } , 
				{ field: "viewCount", title: "읽음", filterable: false, sortable: false, width : 80 , template: $('#readcount-column-template').html(), attributes:{ class:"text-center" } }
			]	
		});	
	}
	
				   						   			
	</script>
	<style>
	
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
	    border-bottom-width: 1px !important;
	    font-weight : 400;
	}	
			
	</style>			
	</head>
<body>
<main id="features">
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
				<p class="g-font-size-18 g-font-weight-300" data-bind="text:board.description"><#if __board?? >${__board.description!""}</#if></p>
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
	<section class="g-py-60">
		<div class="container" > 
 		<#if __category??>
        <#assign __tagDelegator = CommunityContextHelper.getTagService().getTagDelegator(__category) />		
        <div class="row align-items-center g-pt-40 g-pb-10">
          <!-- Category -->
          <div class="col-md-6 col-lg-12">
            <h3 class="h6 mb-3">키워드:</h3> 
			<ul class="list-inline g-font-size-15 g-font-weight-400" id="filter-keywords">
             		<#list __tagDelegator.getTags() as item >
	                   	<li class="my-2 list-inline-item">
	                    <label class="form-check-inline u-check d-block u-link-v5 g-color-gray-dark-v4 g-color-primary--hover g-pl-30">
	                      <input class="g-hidden-xs-up g-pos-abs g-top-0 g-left-0" type="checkbox" data-object-id="${item.tagId}" data-object-value="${item.name}" data-kind="keywords"  >
	                      <span class="d-block u-check-icon-checkbox-v4 g-absolute-centered--y g-left-0">
	                        <i class="fa" data-check-icon=""></i>
	                      </span>
	                      ${item.name}  
	                    </label>
	                  	</li>            		
             		</#list>
			</ul>
          </div>
          <!-- End Category -->
       </div>
       </#if>
			<!-- Toolbar -->
			<div class="d-flex g-pos-rel justify-content-end align-items-center g-brd-bottom g-brd-gray-light-v4 g-pt-40 g-pb-20" style="min-height: 110px;"> 
				<div class="g-mr-60 g-pos-abs g-left-0" > 
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
	            	<a href="#!" class="btn btn-md u-btn-3d u-btn-darkgray g-px-25 g-py-13" data-bind="click: back">이전</a>
	            	<a href="#!" class="btn btn-md u-btn-3d u-btn-lightred g-px-25 g-py-13" style="display:none;" data-bind="{visible:board.createThread}" data-action="create" data-object-id="0" >새로운 글 게시하기</a> 
	            </div> 
            </div> 
        	<!-- Ent Toolbar --> 
 			<div class="row g-mb-0">
				<div id="thread-grid" class="g-brd-0 g-brd-gray-dark-v4 g-brd-top-3 g-brd-style-solid g-min-height-500 g-brd-bottom-3" ></div>
			</div> 
		</div>   
	</section>
 	<script type="text/x-kendo-template" id="readcount-column-template">
	<span class="g-font-size-24 g-font-weight-400 g-line-height-18">#= viewCount #</span>
	<!--
	<div class="g-font-size-14 g-font-weight-100 g-color-gray-light-v2">
		<small>Views</small>
	</div>
	-->
	</script>  
	<script type="text/x-kendo-template" id="template-grid-user">
	<div class="media">
		<a href="\\#!" data-toggle="tooltip" data-placement="right" title="" data-original-title="#= community.data.getUserDisplayName( rootMessage.user ) # 님이 #= community.data.getFormattedDate(rootMessage.creationDate, 'yyyy.MM.dd') # 에 게시함." >
			<img class="d-flex g-width-26 g-height-26 rounded-circle g-mr-10" src="#= community.data.getUserProfileImage( rootMessage.user ) #" alt="Image Description" >
		</a>
	 	<div class="media-body align-self-center">
			<h5 class="h6 align-self-center g-font-weight-300 mb-0">#: community.data.getUserDisplayName( rootMessage.user ) #</h5>
		</div>
	</div>   
	</div>     
	</script>
	<script type="text/x-kendo-template" id="template-grid-subject">
	<a class="u-link-v5 g-font-size-16 g-font-weight-400 g-color-black" href="\#!" data-action="view" data-object-id="#= threadId #" data-object-type="article">
		#: rootMessage.subject #
	</a>
	</div>     
   </script>
     	
	<script type="text/x-kendo-template" id="template">
	<tr class="u-listview-item">
		<td class="align-top g-width-50 text-nowrap">
			<div class="media">
				<a href="\\#!" data-toggle="tooltip" data-placement="right" title="" data-original-title="#= community.data.getUserDisplayName( rootMessage.user ) # 님이 #= community.data.getFormattedDate(rootMessage.creationDate, 'yyyy.MM.dd') # 에 게시함." >
				<img class="d-flex g-width-24 g-height-24 rounded-circle g-mr-10" src="#= community.data.getUserProfileImage( rootMessage.user ) #" alt="Image Description" >
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