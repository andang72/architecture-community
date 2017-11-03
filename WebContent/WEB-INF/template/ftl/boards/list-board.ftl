<#ftl encoding="UTF-8"/>
<#assign user = SecurityHelper.getUser() />
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title></title>
    
	<!-- Bootstrap core CSS -->
	<link href="/css/kendo.ui.core/web/kendo.common.core.css" rel="stylesheet" type="text/css" />
	
	<link href="/css/bootstrap/3.3.7/bootstrap-theme.min.css" rel="stylesheet" type="text/css" />
	<link href="/css/bootstrap/3.3.7/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<link href="/css/bootstrap.theme/inspinia/style.css" rel="stylesheet" type="text/css" />
	
	<link href="/fonts/font-awesome.css" rel="stylesheet" type="text/css" />	
	
	<!-- Requirejs for js loading -->
	<script src="/js/require.js/2.3.5/require.js" type="text/javascript"></script>
	
	<!-- Application JavaScript
    		================================================== -->    
	<script>
	require.config({
		shim : {
	        "bootstrap" : { "deps" :['jquery'] },
	        "kendo.ui.core.min" : { "deps" :['jquery'] },
	        "kendo.culture.ko-KR.min" : { "deps" :['kendo.ui.core.min'] },
	        "podo.ui.core" : { "deps" :['kendo.culture.ko-KR.min'] }
	    },
		paths : {
			"jquery"    					: "/js/jquery/jquery-2.2.4.min",
			"bootstrap" 					: "/js/bootstrap/3.3.7/bootstrap.min",
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"podo.ui.core" 				: "/js/podo.ui/podo.ui.core"
		}
	});
	
	require([ "jquery", "kendo.ui.core.min", "podo.ui.core", "kendo.culture.ko-KR.min", "bootstrap"], function($, kendo ) {
 
		kendo.culture("ko-KR");		
		var renderTo = $('#thread-listview');		
		podo.ui.listview( renderTo , {
			dataSource: podo.ui.datasource('/data/v1/boards/list.json', {
				schema: {
					total: "totalCount",
					data: "items"
				}
			}),
			template: podo.ui.template($("#template").html())
		}); 
	});
	
	</script>	
</head>
<body class="top-navigation">
    <div id="wrapper">
        <div id="page-wrapper" class="gray-bg">
        		<div class="row border-bottom white-bg">
        		<!-- NAVBAR START -->     			
        		<#include "/common/inspinia-top-navbar-ftl">
        		<!-- NAVBAR END -->        		
        		<div class="wrapper wrapper-content">
            		<div class="container">            
                		<div class="row">
                    		<div class="col-lg-12">
                        		<div class="ibox float-e-margins">
                            		<div class="ibox-title">
                                		<h5> 게시판 </h5>
                            		</div>
	                            <div class="ibox-content">
	                                <div id="thread-listview" class="no-border" ></div>
	                            </div>
                        		</div>
                    		</div>
                		</div>
            		</div>
        		</div>
        		<!-- FOOTER START -->
	        <div class="footer">
	            <div class="pull-right">
	                10GB of <strong>250GB</strong> Free.
	            </div>
	            <div>
	                <strong>Copyright</strong> Example Company &copy; 2014-2017
	            </div>
	        </div>
	        <!-- FOOTER END -->
		</div>
	</div>
	<script type="text/x-kendo-template" id="template">
			<div class="forum-item">
				<div class="row">
					<div class="col-md-9">
						<div class="forum-icon">
							<i class="fa fa-ambulance"></i>
						</div>
						<a href="/boards/#=boardId#/list" class="forum-item-title">#:displayName#</a>
						<div class="forum-sub-title">#if(description != null ){# #:description # #}#</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> 0 </span>
						<div>
							<small>Views</small>
						</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> #: totalThreadCount # </span>
						<div>
							<small>Topics</small>
						</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> #: totalMessage # </span>
						<div>
							<small>Posts</small>
						</div>
					</div>
				</div>
			</div>
    </script>	
</body>
</html>