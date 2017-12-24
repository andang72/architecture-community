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
	
	<!-- Community CSS -->
	<link href="<@spring.url "/css/community.ui/community.ui.globals.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/community.ui/community.ui.components.min.css"/>" rel="stylesheet" type="text/css" />
  	<link href="<@spring.url "/css/community.ui/community.ui.style.css"/>" rel="stylesheet" type="text/css" />	
  	
  	 <!-- Summernote Editor CSS -->
	<link href="<@spring.url "/js/summernote/summernote.css"/>" rel="stylesheet" type="text/css" />
		
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
	        "summernote-ko-KR" : { "deps" :['summernote.min'] }
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
				data.copy($this.currentUser)
			},
			dataSource: community.ui.datasource('<@spring.url "/data/api/v1/projects/list.json"/>', {
				schema: {
					total: "totalCount",
					data: "items",
					model: community.model.Project
				}
			})
    		});
    		
    		var renderTo = $('#project-listview');	    		
			community.ui.listview( renderTo , {
			dataSource: observable.dataSource,
			template: community.ui.template($("#template").html())
		}); 
	});
	</script>		
</head>
<body id="page-top" class="landing-page no-skin-config">
	<!-- NAVBAR START -->   
	<#include "/includes/user-top-navbar.ftl">
	<!-- NAVBAR END -->   
	<section class="u-bg-overlay g-bg-cover g-bg-size-cover g-bg-bluegray-opacity-0_3--after" style="background: url(https://htmlstream.com/preview/unify-v2.4/assets/img-temp/1920x800/img8.jpg)">      
      <div class="container text-center g-bg-cover__inner g-py-150">
        <div class="row justify-content-center">
          <div class="col-lg-6">
            <div class="mb-5">
              <h1 class="g-color-darkgray g-font-size-60 mb-4"><#if __page?? >${__page.title}</#if></h1>
              <h2 class="g-color-darkgray g-font-weight-300 g-font-size-22 mb-0 text-left g-color-blue" style="line-height: 1.8;"><#if __page?? >${__page.summary}</#if></h2>
            </div>
            <!-- Promo Blocks - Input -->
			<p>
				<a class="btn btn-lg u-btn-blue g-mr-10 g-mt-25" href="#" role="button">기술지원요청</a>
			</p>            
            <!-- End Promo Blocks - Input -->
          </div>
        </div>
      </div>
    </section>

	<section id="features" class="container services">
		<div class="wrapper wrapper-content">
            		<div class="container">            
                		<div class="row">
                    		<div class="col-lg-12">
                        		<div class="ibox float-e-margins">
                            		<div class="ibox-title">
                                		<h5>프로젝트</h5>
                            		</div>
	                            <div class="ibox-content">
	                                <div id="project-listview" class="no-border" ></div>
	                            </div>
                        		</div>
                    		</div>
                		</div>
            		</div>
        		</div>
	</section>
	
	<script type="text/x-kendo-template" id="template">
			<div class="forum-item">
				<div class="row">
					<div class="col-md-9">
						<div class="forum-icon">
 							<i class="icon-svg icon-svg-sm icon-svg-ios-customer-support"></i>
						</div>
						
						<h2 class="g-ml-60 g-font-weight-100"># if ( contractState == '002') { # <span class="text-info" >무상</span> # } else if (contractState == '001') { # <span class="text-info"> 유상 </span> # } # #:name#</h4>						
						<div class="g-ml-60 text-warning"> #: community.data.getFormattedDate( startDate , 'yyyy-MM-dd')  # ~ #: community.data.getFormattedDate( endDate, 'yyyy-MM-dd' )  # # if ( new Date() > endDate ) {#  <span class="text-danger"> 계약만료 </span> #} #</div>
						<div class="g-ml-60"> 유지보수비용(월) : #: kendo.toString( maintenanceCost, 'c')  #</div>						
						<div class="g-ml-60 text-muted">#if(summary != null ){# #:summary # #}#</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> 0 </span>
						<div>
							<small>Defact</small>
						</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> 0  </span>
						<div>
							<small>Fixed</small>
						</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number">0 </span>
						<div>
							<small>Remain</small>
						</div>
					</div>
				</div>
			</div>
    </script>	
    
</body>
</html>
</#compress>
