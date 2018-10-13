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
			"ace" 						: "/js/ace/ace",
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
			<!-- Dzsparallaxer -->		
			"dzsparallaxer"           			: "/assets/vendor/dzsparallaxer/dzsparallaxer",
			"dzsparallaxer.dzsscroller"			: "/assets/vendor/dzsparallaxer/dzsscroller/scroller",
			"dzsparallaxer.advancedscroller"	: "/assets/vendor/dzsparallaxer/advancedscroller/plugin"
		}
	});
	
	require([ 
		"jquery", "bootstrap", 
		"community.data", "kendo.messages.min",
		"ace",
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
       
		__observable = new community.ui.observable({ 
			currentUser : new community.model.User(),			
			isDeveloper : false ,
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
 		var featuresTo = $('#features');  
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
	    		url : '/display/scm/${__scm.scmId}/download?path=${__path?url_path('utf-8')}', 
				success: function(response){	
					editor.setValue( response ) ;
					community.ui.progress(renderTo, false);	
				}	
			});	
    	}
	}
	
	function isDeveloper( user ){ 
		return user.hasRole('ROLE_DEVELOPER') || <#if __project?? >${ CommunityContextHelper.getCommunityAclService().getPermissionBundle(__project).admin?string } </#if> ;
	} 
 			
	</script>	
	<style>
		#code-highlighter {
			min-height:600px;
			height : auto;
		}	 
	</style>	
</head>
<body id="page-top" class="landing-page no-skin-config">
	<#include "/community/includes/header.ftl">
    <!-- Promo Block -->
    <section class="dzsparallaxer auto-init height-is-based-on-content use-loading mode-scroll loaded dzsprx-readyall g-bg-cover g-color-white" data-options='{direction: "reverse", settings_mode_oneelement_max_offset: "150"}'>
		<div class="divimage dzsparallaxer--target w-100 g-bg-pos-top-center" style="height: 120%; background-image: url( '<@spring.url "/download/images/" />${ CommunityContextHelper.getCustomQueryService().queryForString("COMMUNITY_CS.SELECT_IMAGE_ID_RANDOMLY" ) }' );"></div>
		<div class="container g-bg-cover__inner g-py-50 g-mt-50 g-mb-0">
			<header class="g-mb-20">
				<h2 class="h4 g-font-weight-400 text-uppercase" >
			    <#if __scm?? >${__scm.name}<span class="g-color-primary">${__scm.description!""}</span></#if>
		        </h2>
			</header> 
			<div class="d-flex justify-content-end g-font-size-11">
            <ul class="u-list-inline g-bg-gray-dark-v1 g-font-weight-300 g-rounded-50 g-py-5 g-px-20">
              <li class="list-inline-item g-mr-5">
                <a class="u-link-v5 g-color-white g-color-primary--hover" href="/">Home</a>
                <i class="g-color-white-opacity-0_5 g-ml-5">/</i>
              </li>            
              <#if __project?? >
              <li class="list-inline-item g-mr-5">
                <a class="u-link-v5 g-color-white g-color-primary--hover" href="<@spring.url "/display/pages"/>${ CommunityContextHelper.getPageService().getPage(  7  ).getName() }">${ CommunityContextHelper.getPageService().getPage(  7  ).getTitle() }</a>
                <i class="g-color-white-opacity-0_5 g-ml-5">/</i>
              </li> 
              <li class="list-inline-item g-mr-5">
                <a class="u-link-v5 g-color-white g-color-primary--hover" href="<@spring.url "/display/pages"/>issues.html?projectId=${__project.projectId}">${ __project.name }</a>
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
			<#assign __svn = CommunityContextHelper.getScmService().getSVNRepository(__scm) /> 
			<#assign __info = __svn.info(__path, -1) /> 
			<!-- Toolbar -->
			<div class="g-brd-gray-dark-v4 g-brd-bottom g-brd-bottom-3 g-pt-20 g-pb-20">  
			<#if __info.kind.ID == 0 >
			<h4 class="h5 g-color-black g-mb-5"><i class="fa fa-folder-o"></i> ${__path?ensure_starts_with("/")} </h4> 	
			<#else>
			<h4 class="h5 g-color-black g-mb-5"><i class="fa fa-file"></i> ${__path} </h4>
			</#if> 
            </div>
            <!-- /. End Toolbar -->			
			<#if __info.kind.ID == 0 > 
			<table class="table table-bordered u-table--v2 g-font-size-16 g-font-weight-400">
                  <thead class="text-uppercase g-letter-spacing-1" style="display:none;">
                    <tr class="g-bg-gray-light-v3" >
                      <th class="g-font-weight-300 g-color-black">FILE</th> 
                      <th class="g-font-weight-300 g-color-black g-width-150">REVISION</th>
                      <th class="g-font-weight-300 g-color-black text-nowrap g-width-150">AUTHOR</th>
                      <th class="g-font-weight-300 g-color-black g-width-150">DATE</th>
                    </tr>
                  </thead> 
                  <tbody> 
                  <#if __path != "" >
					<tr>
					<td class="align-middle text-nowrap" colspan="4">
					 <a class="g-color-gray-dark-v5 g-color-primary--hover g-font-size-default g-text-underline--none--hover" href="/display/scm/${__scm.scmId}/tree/${__path?ensure_starts_with("/")?keep_before_last("/")}">..</a></td>
					</tr>         
				  </#if>	           
                  <#list CommunityContextHelper.getScmService().listEntries(__svn, __path ) as item >
					<tr>
                      <td class="align-middle text-nowrap">
                      <#if item.kind.ID == 0 > <i class="fa fa-folder-o"></i> <#else> <i class="fa fa-file"></i> </#if><a class="g-color-gray-dark-v5 g-color-primary--hover g-font-size-16 g-text-underline--none--hover" 
                      	href="<@spring.url "/display/scm/"/>${__scm.scmId}/tree<#if __info.kind.ID == 0 && __path != "" >${__path?ensure_starts_with("/")}</#if>${item.name?ensure_starts_with("/") }" > ${item.name}  </a>
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
			    ${__info.name } ${__info.getRevision()?c } ${__info.getSize() } Bytes
			    <div class="text-right">
			    <a href="/display/scm/${__scm.scmId}/tree/${__path?ensure_starts_with("/")?keep_before_last("/")}" class="btn u-btn-outline-darkgray g-mr-5" >이전</a>
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
				<div class="card-block g-pa-0"> 	
 				<div id="code-highlighter" ></div>
 				</div>	    
			    </#if> 
			</div>
			<!-- End Default Outline Panel-->
			</#if> 
			</#if> 
			<div class="g-mb-30" >
				<!--
				<div class="u-divider u-divider-solid g-brd-gray-light-v3 g-brd-3 g-mb-30">
					<i class="fa fa-circle u-divider__icon g-bg-white g-color-gray-light-v3"></i>
				</div>	
				-->
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
 	 
									<p class="g-font-size-14">아직 지원하지 않는 기능입니다.</p>
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
			
        </div><!-- /.container -->
	</section>			
	<!-- FOOTER START -->   
	<#include "includes/user-footer.ftl">
	<!-- FOOTER END -->      		
</body>     		 
</html>
</#compress>
