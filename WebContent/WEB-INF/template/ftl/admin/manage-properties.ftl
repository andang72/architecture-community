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
 	<script data-pace-options='{ "ajax": false }' src='/js/pace/pace.min.js'></script>
 	<script src="/js/require.js/2.3.5/require.js" type="text/javascript"></script>
 	
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
			"community.data" 			: "/js/community.ui/community.data",
			"ace" 						: "/js/ace/ace"
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
			},
			createNewProperty: function(e){
				//var $this = this;			
				community.ui.listview($('#properties-listview')).add();
             	e.preventDefault();
    			}
		});
		
		var renderTo = $('#wrapper');
		console.log( community.ui.stringify(observable.currentUser) );
		community.ui.bind( renderTo , observable );
		createPropertiesListView();
		
		
	});
	
	function createPropertiesListView(){
		var renderTo = $('#properties-listview');	
		var listview = community.ui.listview( renderTo , {
			dataSource: community.ui.datasource( null, {
				transport: { 
					read : 		{ url:'<@spring.url "/data/api/mgmt/v1/properties/list.json"/>', type:'post', contentType : "application/json" },
					create : 	{ url:'<@spring.url "/data/api/mgmt/v1/properties/update.json"/>', type:'post', contentType : "application/json" },
					update : 	{ url:'<@spring.url "/data/api/mgmt/v1/properties/update.json"/>', type:'post', contentType : "application/json" },
					destroy : 	{ url:'<@spring.url "/data/api/mgmt/v1/properties/remove.json"/>', type:'post', contentType : "application/json" },
					parameterMap: function (options, operation){	 
						if (operation !== "read" && options.models) { 
							return community.ui.stringify(options.models);
						}
						return community.ui.stringify(options);
					}
				},
				batch: true, 
				schema: {
					model: community.model.Property
				}
			}),
			editTemplate: community.ui.template($("#property-edit-template").html()),
			template: community.ui.template($("#property-template").html())
		}); 			
		community.ui.pager( $("#properties-listview-pager"), {
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
                    <h2>설정</h2>
                    <ol class="breadcrumb">
                        <li class="active">
                            설정
                        </li>
                    </ol>
                </div>
                <div class="col-sm-8">
                    <div class="title-action">
                        <button type="button" class="btn btn-primary g-font-weight-200" data-bind="click:createNewProperty" >새로운 속성 추가하기</button>
                    </div>	
                </div>
            </div>

            <div class="wrapper wrapper-content">
                <div class="ibox float-e-margins">
                		<div class="ibox-content no-padding">	
                		 
                		<div class="table-responsive">
						<table class="table table-bordered u-table--v2 g-mb-0 g-brd-bottom-none">
							<thead class="">
								<tr>
									<th class="g-font-weight-300 g-color-black">속성</th>
									<th class="g-font-weight-300 g-color-black g-width-50x">값</th>
									<th class="g-font-weight-300 g-color-black g-width-120">&nbsp;</th>
								</tr>
							</thead>
							<tbody id="properties-listview"></tbody>
						</table>
					</div>
					</div>
					<div class="ibox-footer no-padding g-brd-top-none">
						<div id="properties-listview-pager"/>
					</div>  
                </div>        			 
            </div>
            <div class="footer"><!--
                <div class="pull-right">
                    10GB of <strong>250GB</strong> Free.
                </div>
                <div>
                    <strong>Copyright</strong> Example Company &copy; 2014-2017
                </div>-->
            </div>

        </div>
    </div>
    
	<script type="text/x-kendo-template" id="property-template">   
	<tr>
		<td class="align-middle">#: name # </td>
		<td class="align-middle">#: value #</td>
		<td class="align-middle text-center">
			<div class="btn-group">
                <a class="btn btn-sm u-btn-outline-bluegray k-edit-button g-mb-0" href="\\#">수정</a>
                <a class="btn btn-sm u-btn-outline-bluegray k-delete-button g-mb-0" href="\\#">삭제</a>
            </div>
		</td>
	</td>
	</script>   
	
	<script type="text/x-kendo-template" id="property-edit-template">   
	<tr>
		<td class="align-middle">
			<input type="text" class="k-textbox form-control" data-bind="value:name" name="name" required="required" validationMessage="필수 입력 항목입니다." />
			<span data-for="name" class="k-invalid-msg"></span>
		</td>
		<td class="align-middle">
			<input type="text" class="k-textbox form-control" data-bind="value:value" name="value" required="required" validationMessage="필수 입력 항목입니다." />
			<span data-for="value" class="k-invalid-msg"></span>		
		</td>
		<td class="align-middle text-center">
			<div class="btn-group">
                <a class="btn btn-sm u-btn-outline-bluegray k-update-button g-mb-0" href="\\#">확인</a>
                <a class="btn btn-sm u-btn-outline-bluegray k-cancel-button g-mb-0" href="\\#">취소</a>
            </div>
		</td>
	</td>
	</script>	
		  
</body>
</html>
</#compress>