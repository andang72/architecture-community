<#ftl encoding="UTF-8"/>
<#assign user = SecurityHelper.getUser() />	
<#compress>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>INSPINIA | Empty Page</title> 
	<!-- Kendoui with bootstrap theme CSS -->			
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.common-bootstrap.core.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	
	
	<!-- Bootstrap CSS -->
    <link href="<@spring.url "/css/bootstrap/3.3.7/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/css/animate/animate.css"/>" rel="stylesheet" type="text/css" />	
    
    <!-- Bootstrap Theme Inspinia CSS -->
    <link href="<@spring.url "/css/bootstrap.theme/inspinia/style.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/css/bootstrap.theme/inspinia/custom.css"/>" rel="stylesheet" type="text/css" />	
            
    <!-- Community CSS -->
	<link href="<@spring.url "/css/community.ui/community.ui.globals.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/community.ui/community.ui.components.css"/>" rel="stylesheet" type="text/css" />
  	<link href="<@spring.url "/css/community.ui/community.ui.style.css"/>" rel="stylesheet" type="text/css" />	
  	    
 	<script data-pace-options='{ "ajax": false }' src='<@spring.url "/js/pace/pace.min.js'"/>></script>
 	<script src="<@spring.url "/js/require.js/2.3.5/require.js"/>" type="text/javascript"></script>
 	
	<!-- Application JavaScript
    		================================================== -->    	
	<script>
	require.config({
		shim : {
	        "bootstrap" 					: { "deps" :['jquery'] },
	        "kendo.ui.core.min" 			: { "deps" :['jquery' ] },
	        "kendo.culture.ko-KR.min" 	: { "deps" :['jquery', 'kendo.ui.core.min'] },
	        "community.ui.core" 			: { "deps" :['jquery', 'kendo.culture.ko-KR.min'] },
	        "community.data" 			: { "deps" :['jquery', 'community.ui.core'] },	 
	        "jquery.slimscroll" 			: { "deps" :['jquery'] },
	        "jquery.metisMenu" 			: { "deps" :['jquery'] }, 
	        "inspinia"					: { "deps" :['jquery', 'jquery.metisMenu', 'jquery.slimscroll'] }
		},
		paths : {
			"jquery"    					: "/js/jquery/jquery-3.1.1.min",
			"bootstrap" 					: "/js/bootstrap/3.3.7/bootstrap.min",
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"jquery.metisMenu"			: "/js/jquery.metisMenu/metisMenu.min",
			"jquery.slimscroll"			: "/js/jquery.slimscroll/1.3.8/jquery.slimscroll.min", 
			"inspinia" 					: "/js/bootstrap.theme/inspinia/inspinia",
			"community.ui.core" 			: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data"
		}
	});
	require([ "jquery", "bootstrap", "kendo.ui.core.min", "community.ui.core", "community.data", "jquery.metisMenu" , "jquery.slimscroll", "inspinia"], function($, kendo ) { 
	
		community.ui.setup({
		  	features : {
				accounts: true
		  	},
		  	'features.accounts.authenticate' :function(e){
		  		observable.setUser(e.token);
		  	}
		});
		
		var observable = new community.ui.observable({ 
			currentUser : new community.model.User(),
			userAvatarSrc : "/images/no-avatar.png",
			userDisplayName : "",
			setUser : function( data ){
				var $this = this;				
				data.copy($this.currentUser);
				$this.set('userAvatarSrc', community.data.getUserProfileImage( $this.currentUser ) );
				$this.set('userDisplayName', community.data.getUserDisplayName( $this.currentUser ) );
			}
		});
		
		var renderTo = $('#wrapper');
		console.log( community.ui.stringify(observable.currentUser) );
		community.ui.bind( renderTo , observable ); 
		createUserListView();
		
	});
	
	function createUserListView(){
		var renderTo = $('#users-listview');	
		var listview = community.ui.listview( renderTo , {
			dataSource: community.ui.datasource('/data/api/mgmt/v1/users/list.json', {
				transport: { 
					parameterMap: function (options, operation){	 
						return community.ui.stringify(options);
					}
				},
				schema: {
					total: "totalCount",
					data:  "items",
					model: community.model.User
				}
			}),
			template: community.ui.template($("#template").html())
		}); 			
		
		community.ui.pager( $("#users-listview-pager"), {
            dataSource: listview.dataSource
        }); 	
	}
	
	</script>
</head>

<body class="skin-1">

    <div id="wrapper">
	    	<!--  SIDEBAR  -->
		<#include "/common/inspinia-admin-sidebar.ftl">
	 	<!--  ./SIDEBAR  -->
        <div id="page-wrapper" class="gray-bg">
        <div class="row border-bottom">
	    	<!--  TOP NAVBAR  -->
		<#include "/common/inspinia-admin-top-navbar.ftl">
	 	<!--  ./TOP NAVBAR  -->
        </div>
            <div class="row wrapper border-bottom white-bg page-heading">
                <div class="col-sm-4">
                    <h2>사용자관리</h2>
                    <ol class="breadcrumb">
                        <li>
                            보안
                        </li>
                        <li class="active">
                            <strong>사용자관리</strong>
                        </li>
                    </ol>
                </div>
                <div class="col-sm-8">
                    <div class="title-action">
                        <a href="" class="btn btn-primary">This is action area</a>
                    </div>	
                </div>
            </div>

            <div class="wrapper wrapper-content">
                <div class="text-center">
  					<div class="ibox float-e-margins">
                        			 <div class="ibox-content no-padding">	 
                        			 	<table class="table no-margins">
			                            <thead>
			                            <tr>
			                                <th class="text-center">ID</th>
			                                <th class="text-center" width="100">이름</th>
			                                <th class="text-center" width="100">상태</th>
			                                <th class="text-center" width="100">생성일</th>
			                                <th class="text-center" width="150">수정일</th>
			                            </tr>
			                            </thead>
			                            <tbody id="users-listview" class="no-border u-listview" >	
			                            </tbody>                            
			                        </table>          
                        			 </div>
                        			 <div class="ibox-footer no-padding">  
	                            		<div id="users-listview-pager" class="k-pager-wrap no-border" ></div>
	                             </div>  
					</div>
                </div>
            </div>
            <div class="footer">
                <div class="pull-right">
                    10GB of <strong>250GB</strong> Free.
                </div>
                <div>
                    <strong>Copyright</strong> Example Company &copy; 2014-2017
                </div>
            </div>

        </div>
    </div>
	</body>
	<script type="text/x-kendo-template" id="template">    	
	<tr class="u-listview-item">
		<td class="u-text-left">		
		<h3 class="g-font-weight-100">
		#if (enaled ) { # <i class="icon-lock"></i>  # } else {# <i class="icon-lock-open"></i> #}#
		<u>#= name #</u> #= title # 
		<div class="pull-right">		
		<span class="u-label u-label-default g-mr-10 g-mb-15 g-font-weight-100">#: pageState #</span>
		</div>	
		</h3>
		<div class="u-visible-on-select">
			<div class="btn-group">
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="edit" data-object-id="#= pageId#">수정</button>
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="delete" data-object-id="#= pageId#">삭제</button>
			</div>
	 	</div>
		</td>
		<td class="text-center"> #: status # </td>
		<td class="text-center">  #: community.data.getFormattedDate( creationDate)  #  </td>
		<td class="text-center">#: community.data.getFormattedDate( modifiedDate)  # </td>
	</tr>				                      
    </script>       
</html>
</#compress>