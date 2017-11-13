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
	<link href="/fonts/font-awesome.css" rel="stylesheet" type="text/css" />
	<link href="/css/bootstrap/3.3.7/bootstrap.min.css" rel="stylesheet" type="text/css" />
	
	<link href="/css/bootstrap.theme/unify/unify-glogals.css" rel="stylesheet" type="text/css" />
	<link href="/css/bootstrap.theme/inspinia/style.css" rel="stylesheet" type="text/css" />
	
	<link href="/css/kendo.ui.core/web/kendo.common-bootstrap.core.css" rel="stylesheet" type="text/css" />
	<link href="/css/kendo.ui.core/web/kendo.bootstrap.min.css" rel="stylesheet" type="text/css" />
		
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
	        "podo.ui.core" : { "deps" :['kendo.culture.ko-KR.min'] },
	        "community.models" : { "deps" :['kendo.ui.core.min'] }
	    },
		paths : {
			"jquery"    					: "/js/jquery/jquery-2.2.4.min",
			"bootstrap" 					: "/js/bootstrap/3.3.7/bootstrap.min",
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"podo.ui.core" 				: "/js/podo.ui/podo.ui.core",
			"community.models" 			: "/js/community/community-models"	
		}
	});
	
	require([ "jquery", "kendo.ui.core.min", "podo.ui.core", "community.models", "kendo.culture.ko-KR.min", "bootstrap"], function($, kendo ) {
		console.log("hello");
		kendo.culture("ko-KR");
		var renderTo = $('#board-listview');

		var observable = new podo.ui.observable({ 
			boardId : ${boardId},
			displayName : "",
			totalMessage : 0
    		}); 
		
		
		podo.ui.ajax('/data/v1/boards/' + observable.get('boardId') + '/info.json', {
			success: function(data){
				observable.set('displayName', data.displayName );
				observable.set('totalMessage', data.totalMessage );
			}
		});
		
		podo.ui.bind($('#page-wrapper'), observable );

		podo.ui.listview( renderTo , {
			dataSource: podo.ui.datasource('/data/v1/boards/'+ observable.get('boardId') +'/threads/list.json', {
				schema: {
					total: "totalCount",
					data: "items",
					model: community.model.Thread
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
                                		<h5 data-bind="text:displayName"></h5>
									<div class="pull-right forum-desc">
										<samll>Total posts: <span data-bind="text:totalMessage"></span></samll>
									</div>                                		
                            		</div>
	                            <div class="ibox-content">
		                            <div class="ibox-tools">
		                                <a href="" class="btn btn-primary">새로운 글 게시하기</a>
		                            </div>
									<div id="board-listview" class="no-border" style="border-style:none;"></div>
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
					<div class="col-md-10">
						<div class="forum-icon">
							<a class="forum-avatar small" href="\\#"><img src="/images/no-avatar.png" class="Avatar" alt="image"></a>
						</div>
						<a href="/boards/${boardId}/threads/#=threadId#" class="forum-item-title">#: rootMessage.subject #</a>
						
						<ul class="forum-list-item-info">
                            <li><i class="icon fa fa-reply small"></i>  #: latestMessage.subject # , #: kendo.toString(latestMessage.modifiedDate, "g")  #</li>
                            <li>#: latestMessage.body #</li>                            
                        </ul>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> #: viewCount # </span>
						<div>
							<small>Views</small>
						</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> #: messageCount  # </span>
						<div>
							<small>Posts</small>
						</div>
					</div>
				</div>
			</div>
    </script>    	
</body>
</html>
