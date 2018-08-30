<#ftl encoding="UTF-8"/>
<#compress>
<#if  RequestParameters.path?? >
<#assign __path = RequestParameters.path /> 
<#else>
<#assign __path = "" /> 
</#if>
<#if __scm?? && __scm.objectType == 19 >
<#assign __project = CommunityContextHelper.getProjectService().getProject( __scm.objectId ) />
</#if>
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
    var __observable; 
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
			"ace" 						: "/js/ace/ace",
			<!-- Unify -->
	    	"hs.core" 	   					: "/js/bootstrap.theme/unify/hs.core",
			"hs.header" 	   				: "/js/bootstrap.theme/unify/components/hs.header",
			"hs.tabs" 	   					: "/js/bootstrap.theme/unify/components/hs.tabs",
			"hs.hamburgers"   				: "/js/bootstrap.theme/unify/helpers/hs.hamburgers",
			<!-- Dzsparallaxer -->		
			"dzsparallaxer"           			: "/assets/vendor/dzsparallaxer/dzsparallaxer",
			"dzsparallaxer.dzsscroller"			: "/assets/vendor/dzsparallaxer/dzsscroller/scroller",
			"dzsparallaxer.advancedscroller"	: "/assets/vendor/dzsparallaxer/advancedscroller/plugin"
		}
	});
	
	require([ 
		"jquery", "bootstrap", 
		"community.data", "kendo.messages.min", "ace",
		"hs.header", "hs.tabs", "hs.hamburgers", 'dzsparallaxer.advancedscroller'	
	], function($, kendo ) {	

		// init header 
		$.HSCore.components.HSHeader.init($('#js-header'));	
		$.HSCore.components.HSTabs.init('[role="tablist"]');
		$.HSCore.helpers.HSHamburgers.init('.hamburger');
		
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
		  			__observable.setUser(e.token);
		    	}
		  	}
		});	        
		
        var featuresTo = $('#features');    
		__observable = new community.ui.observable({ 
			currentUser : new community.model.User(),		 
			setUser : function( data ){
				var $this = this;				
				data.copy($this.currentUser);
			},
			back : function(){
				var $this = this;
				window.history.back();
				return false;			
			},	
    	}); 
		community.ui.bind(featuresTo, __observable );
		
		var renderTo = $('#code-highlighter') ;
		crateCodeHighlighter(renderTo);
			 
	});  
	
	function crateCodeHighlighter(renderTo){
		if( renderTo.length == 1 ){
			var editor = ace.edit(renderTo.attr('id'));
			editor.setTheme("ace/theme/chrome");
	    	//editor.session.setMode("ace/mode/javascript"); 
	    	community.ui.progress(renderTo, true);	
	    	$.ajax({
	    		type : 'POST',
	    		url : '/display/scm/${__scm.scmId}/download?path=${__path?remove_beginning("/")?url_path('utf-8')}', 
				success: function(response){	
					editor.setValue( response ) ;
					community.ui.progress(renderTo, false);	
				}	
			});	
    	}
	}
								
	</script>	
	<style>
	#code-highlighter {
		min-height:600px;
		height: 100%;
	}	
	</style>	
</head>
<body id="page-top" class="landing-page no-skin-config">
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
				<h3 class="h5 g-font-weight-300 g-mb-5">${__scm.description!""}</h3>
				<h2 class="h4 g-font-weight-400 text-uppercase" >
			    <#if __scm?? >${__scm.name}</#if>
		        </h2>
			</header> 
			<div class="d-flex justify-content-end g-font-size-11">
            <ul class="u-list-inline g-bg-gray-dark-v1 g-font-weight-300 g-rounded-50 g-py-5 g-px-20">          
              <#if __project?? >
              <li class="list-inline-item g-mr-5">
                <a class="u-link-v5 g-color-white g-color-primary--hover" href="#">${ __project.name }</a>
                <i class="g-color-white-opacity-0_5 g-ml-5">/</i>
              </li> 
              </#if>
              <#if __scm?? >
              <li class="list-inline-item g-color-primary g-font-weight-400">
                <span>${__scm.name}</span>
              </li>
              </#if>              
            </ul>
          	</div>
		</div>
    </section>
    <!-- End Promo Block -->
	<section id="features" class="services">
		<div class="container g-py-15">
			<#if __scm?? >  
			<#assign __svn = CommunityContextHelper.getScmService().getSVNRepository( __scm ) /> 
			<#assign __info = __svn.info( __path?remove_beginning("/") , -1) /> 
			<#if __info.kind.ID == 0 > 
			<table class="table table-bordered u-table--v2 g-font-size-14 g-font-weight-400">
                  <thead class="text-uppercase g-letter-spacing-1">
                    <tr class="g-bg-gray-light-v3">
                      <th class="g-font-weight-300 g-color-black">FILE</th> 
                      <th class="g-font-weight-300 g-color-black g-width-150 text-center">REVISION</th>
                      <th class="g-font-weight-300 g-color-black text-nowrap text-center g-width-150">AUTHOR</th>
                      <th class="g-font-weight-300 g-color-black text-center g-width-150">DATE</th>
                    </tr>
                  </thead> 
                  <tbody> 
                  <#if __path != "" >
					<tr>
					<td class="align-middle text-nowrap" colspan="4">
					 <a class="g-color-gray-dark-v5 g-color-primary--hover g-font-size-default g-text-underline--none--hover" 
					 	href="<@spring.url "/display/pages/scm/"/>${__scm.scmId}/${__page.name}?path=${__path?ensure_starts_with("/")?keep_before_last("/")}">..</a></td>
					</tr>         
				  </#if>	           
                  <#list CommunityContextHelper.getScmService().listEntries( __svn, __path?remove_beginning("/") ) as item >
					<tr>
                      <td class="align-middle text-nowrap">
                      <#if item.kind.ID == 0 > <i class="fa fa-folder-o"></i> <#else> <i class="fa fa-file"></i> </#if>
                      
                      <a class="g-color-gray-dark-v5 g-color-primary--hover g-font-size-16 g-text-underline--none--hover" 
                      	href="<@spring.url "/display/pages/scm/"/>${__scm.scmId}/${__page.name}?path=<#if __info.kind.ID == 0 && __path != "" >${__path?ensure_starts_with("/")}</#if>${item.name?ensure_starts_with("/") }" >${item.name}</a>
                      </td>  
                      <td class="align-middle text-center">
                      <#if item.commitMessage?? >
                      ${item.commitMessage}
                      </#if>
                      ${item.revision?c}
                      </td>
                      <td class="align-middle text-center g-width-150">
                      ${item.author}
                      </td>
                      <td class="align-middle text-nowrap text-center g-width-150">
                      ${item.date?string('yyyy.MM.dd HH:mm:ss')} <br>
                      </td>
                    </tr> 
                  </#list> 
                  </tbody>
                </table>	
                <#else>  
 			<!-- Default Outline Panel-->
			<div class="card rounded-0">
			  <h3 class="card-header h5 rounded-0"> 
			    	<a class="u-link-v5 g-color-gray-dark-v1 g-color-primary--hover" href="#!">${ __info.name }</a>
			    	<ul class="list-inline g-color-gray-dark-v4 g-font-size-12 g-mt-5">
                      <li class="list-inline-item">
                        <a class="u-link-v5 g-color-gray-dark-v4 g-color-primary--hover" href="#!">${ __info.author }</a>
                      </li>
                      
                      <li class="list-inline-item">/</li>
                      <li class="list-inline-item">${__info.date?string('yyyy.MM.dd HH:mm:ss')}</li>
                      
                      <li class="list-inline-item">/</li>
                      <li class="list-inline-item"> revision ${__info.getRevision()?c }</li>
                      
                      <li class="list-inline-item">/</li>
                      <li class="list-inline-item">${__info.getSize() } bytes</li>
                      
                    </ul>
                    <#if __info.getCommitMessage()?? > 
                    <h4 class="g-font-size-16 g-color-gray-dark-v1">
                        <small class="g-color-gray-dark-v4">${ __info.getCommitMessage() }</small>
                    </h4>
                    </#if>
                    
			    <div class="text-right">
			    <a href="/display/pages/scm/${__scm.scmId}/scm-viewer.html?${__path?ensure_starts_with("/")?keep_before_last("/")}" class="btn u-btn-outline-darkgray g-mr-5" >이전</a>
			    <a href="/display/scm/${__scm.scmId}/download?path=${__path?url_path('utf-8')}" class="btn u-btn-outline-darkgray g-mr-5" target="_blank;">다운로드</a>
			    </div>
			  </h3> 
			  	<#if  CommunityContextHelper.getScmService().getMineType( __svn, __path )?? >
				<#assign __minetype = CommunityContextHelper.getScmService().getMineType( __svn, __path ) /> 
				<#if  __minetype?starts_with("text") >
			 	<div class="card-block g-pa-0"> 	
 				<div id="code-highlighter" ></div>
 				</div>	
 				<#else>
 				<div class="card-block"> 
 				<#if __info.name?ends_with(".png") || __info.name?ends_with(".gif") || __info.name?ends_with(".jpg")>
 				<img src="/display/scm/${__scm.scmId}/download?path=${__path?url_path('utf-8')}" style="max-width:100%;"/>
 				</#if>
 				</div>
				</#if> 
				<#else>
				<div class="card-block g-pa-0 g-min-height-300"> 	
 					<div id="code-highlighter" ></div>
 				</div>	    
			    </#if> 
			</div>
			<!-- End Default Outline Panel-->               
                </#if>
			</#if> 
        </div>
	</section>			
	<!-- FOOTER START -->   
	<#include "includes/user-footer.ftl">
	<!-- FOOTER END -->      		
</body>     		 
</html>
</#compress>
