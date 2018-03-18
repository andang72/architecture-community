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
	<!--<link href="/css/kendo.ui.core/web/kendo.common-bootstrap.core.css" rel="stylesheet" type="text/css" />-->
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
	
	require([ "jquery", "kendo.ui.core.min",  "kendo.culture.ko-KR.min", "community.data", "community.ui.core", "bootstrap"], function($, kendo ) {		
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
			}
    		});
     	
     	var renderTo = $('#page-top');
    		renderTo.data('model', observable);
    		community.ui.bind(renderTo, observable );	
    		
	});
	</script>		
</head>
<body id="page-top" class="landing-page skin-5">
	<!-- NAVBAR START -->   
	<#include "../includes/user-top-navbar.ftl">
	<!-- NAVBAR END -->  
	<section class="g-brd-bottom g-brd-gray-light-v4">
      <div class="container g-py-150">
        <div class="row">
          <div class="col-lg-6">
            <div class="d-inline-block g-width-80 g-height-4 g-bg-black mb-3"></div>
            <h2 class="g-color-black g-font-weight-700 g-font-size-50 g-line-height-1 mb-4"><#if __page?? >${__page.title}</#if></h2>
            <p class="mb-0"><#if __page.summary ?? >${__page.summary}</#if></p>
          </div>
        </div>
      </div>
    </section>
	<section class="container g-py-100">
      <div class="g-mb-50">
        <h2 class="h3 g-color-black g-font-weight-600 mb-3">License</h2>
        <div class="mb-4">
          <p><span class="g-font-weight-700">1.</span> This is where we sit down, grab a cup of coffee and dial in the details. Understanding the task at hand and ironing out the wrinkles is key. Now that we've aligned the details, it's time to get things
            mapped out and organized. This part is really crucial in keeping the project in line to completion.</p>
          <p><span class="g-font-weight-700">2.</span> Whether through commerce or just an experience to tell your brand's story, the time has come to start using development languages that fit your projects needs. Now that your brand is all dressed up and
            ready to party, it's time to release it to the world. By the way, let's celebrate already. We get it, you're busy and it's important that someone keeps up with marketing and driving people to your brand. We've got you covered.</p>
        </div>
        <div class="g-bg-gray-light-v5 u-ns-bg-v2-top g-bg-gray-light-v5 g-pa-20">
          <p class="mb-0">This section will help you understand license an item you have purchased.</p>
        </div>
      </div>

      <div class="g-mb-50">
        <h3 class="g-color-black g-font-weight-600 mb-3">Ownership</h3>
        <p>This is where we sit down, grab a cup of coffee and dial in the details. Understanding the task at hand and ironing out the wrinkles is key. Now that we've aligned the details, it's time to get things mapped out and organized. This part is really
          crucial in keeping the project in line to completion.</p>
        <p>Whether through commerce or just an experience to tell your brand's story, the time has come to start using development languages that fit your projects needs. Now that your brand is all dressed up and ready to party, it's time to release it to
          the world. By the way, let's celebrate already. We get it, you're busy and it's important that someone keeps up with marketing and driving people to your brand. We've got you covered.</p>
        <ul>
          <li class="mb-3">
            Jacks of all. Experts in all.
          </li>
          <li class="mb-3">
            It's good to virtually meet you.
          </li>
          <li class="mb-3">
            A crew of creative doers.
          </li>
          <li class="mb-3">
            Let's create something great.
          </li>
        </ul>
      </div>

      <div class="g-mb-50">
        <h3 class="g-color-black g-font-weight-600 mb-3">Usage</h3>
        <p>This is where we sit down, grab a cup of coffee and dial in the details. Understanding the task at hand and ironing out the wrinkles is key. Now that we've aligned the details, it's time to get things mapped out and organized. This part is really
          crucial in keeping the project in line to completion.</p>
        <p>Whether through commerce or just an experience to tell your brand's story, the time has come to start using development languages that fit your projects needs. Now that your brand is all dressed up and ready to party, it's time to release it to
          the world. By the way, let's celebrate already. We get it, you're busy and it's important that someone keeps up with marketing and driving people to your brand. We've got you covered.</p>
      </div>

      <h3 class="g-color-black g-font-weight-600 mb-3">Refunds</h3>
      <p>This is where we sit down, grab a cup of coffee and dial in the details. Understanding the task at hand and ironing out the wrinkles is key. Now that we've aligned the details, it's time to get things mapped out and organized. This part is really
        crucial in keeping the project in line to completion.</p>
      <p>Whether through commerce or just an experience to tell your brand's story, the time has come to start using development languages that fit your projects needs. Now that your brand is all dressed up and ready to party, it's time to release it to
        the world. By the way, let's celebrate already. We get it, you're busy and it's important that someone keeps up with marketing and driving people to your brand. We've got you covered.</p>
    </section>    	
	<!-- FOOTER START -->   
	<#include "../includes/user-footer.ftl">
	<!-- FOOTER END -->  
</body>
</html>	
</#compress>