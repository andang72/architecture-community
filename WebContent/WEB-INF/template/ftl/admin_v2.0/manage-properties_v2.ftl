<#ftl encoding="UTF-8"/>
<#compress>
<!DOCTYPE html>
<html>
<head>	
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    
	<title>${ CommunityContextHelper.getConfigService().getApplicationProperty("website.title", "REPLICANT") } | ADMIN v2.0</title>

	<!-- Bootstrap CSS -->
   	<link href="<@spring.url "/css/bootstrap/4.0.0/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	
   			
    <!-- Kendoui with bootstrap theme CSS -->			
	<!-- <link href="<@spring.url "/css/kendo/2018.1.221/kendo.common.min.css"/>" rel="stylesheet" type="text/css" />-->
	<link href="<@spring.url "/css/kendo/2018.1.221/kendo.bootstrap-v4.min.css"/>" rel="stylesheet" type="text/css" />	
	

    
    <!-- Bootstrap Theme CSS -->
    
    <link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />
    <link href="<@spring.url "/fonts/nanumgothic.min.css"/>" rel="stylesheet" type="text/css" />	 
    <link href="<@spring.url "/css/animate/animate.css"/>" rel="stylesheet" type="text/css" />	
    
    <!-- Community Admin CSS -->
    <link href="<@spring.url "/css/community.ui.admin/community-ui-admin-icons.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/css/community.ui.admin/community.ui.admin.css"/>" rel="stylesheet" type="text/css" />	
  	     
 	<script data-pace-options='{ "ajax": false }' src='<@spring.url "/js/pace/pace.min.js'"/>></script>
 	<script src="<@spring.url "/js/require.js/2.3.5/require.js"/>" type="text/javascript"></script>

 	<!-- Application JavaScript
    		================================================== -->    	
	<script>
	require.config({
		shim : {
			"bootstrap" 				: { "deps" :['jquery'] }, 
	        "kendo.core" 				: { "deps" :['jquery' ] },	 
	        "kendo.web.min" 			: { "deps" :['jquery'] },
	        "kendo.culture.min" 		: { "deps" :['jquery', 'kendo.web.min'] },	   
	        "kendo.messages.min" 		: { "deps" :['jquery', 'kendo.web.min'] },	 
	        "community.ui.core"			: { "deps" :['jquery', 'kendo.web.min', 'kendo.culture.min' ] },
	        "community.data" 			: { "deps" :['jquery', 'kendo.web.min', 'community.ui.core' ] },
	        "community.ui.admin" 		: { "deps" :['jquery', 'jquery.cookie', 'community.ui.core', 'community.data'] }	   
		},
		paths : {
			"jquery"    				: "/js/jquery/jquery-3.1.1.min",
			"jquery.cookie"    			: "/js/jquery.cookie/1.4.1/jquery.cookie",
			<!-- bootstrap -->			
			"bootstrap" 	   			: "/js/bootstrap/4.0.0/bootstrap.bundle.min",
						
			<!-- kendoui -->
			"kendo.core"	 			: "/js/kendo/2018.1.221/kendo.core.min",
			"kendo.web.min"	 			: "/js/kendo/2018.1.221/kendo.web.min",
			"kendo.culture.min"			: "/js/kendo/2018.1.221/cultures/kendo.culture.ko-KR.min",	
			"kendo.messages.min"		: "/js/kendo.extension/kendo.messages.ko-KR",	
			<!-- community -- >
			"community.ui.core" 		: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data", 
			"community.ui.admin" 		: "/js/community.ui.components/community.ui.admin"
		}
	});
	require([ "jquery","jquery.cookie",  "bootstrap", "community.data", "community.ui.admin", "kendo.messages.min" ], function($, kendo ) { 

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
				community.ui.grid($('#properties-grid')).addRow(); 
				return false;
    		}
		});
		
		// This is only for Admin   
		// 1. initialization of sidebar navigation component
	    community.ui.components.HSSideNav.init('.js-side-nav');
	   	// 2. initialization of HSDropdown component
	    community.ui.components.HSDropdown.init($('[data-dropdown-target]'), {dropdownHideOnScroll: false});	   
	    				
		community.ui.bind( $('#js-header') , observable ); 
		var renderTo = $('#features');
		community.ui.bind( renderTo , observable );
		createPropertiesGrid();
	 	
	});

		
	
	function createPropertiesGrid(observable){
		
		var renderTo = $('#properties-grid');  
		if( !community.ui.exists(renderTo) ){  
			community.ui.grid(renderTo, {
				dataSource: {
					transport: { 
						read : 		{ url:'<@spring.url "/data/api/mgmt/v1/properties/list.json"/>', type:'post', contentType: "application/json; charset=utf-8"},
						create : 	{ url:'<@spring.url "/data/api/mgmt/v1/properties/update.json"/>', type:'post', contentType: "application/json; charset=utf-8" },
						update : 	{ url:'<@spring.url "/data/api/mgmt/v1/properties/update.json"/>', type:'post', contentType: "application/json; charset=utf-8" },
						destroy : 	{ url:'<@spring.url "/data/api/mgmt/v1/properties/delete.json"/>', type:'post', contentType: "application/json; charset=utf-8" },       
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
				},
				height : 550,
				sortable: true,
				filterable: false,
				pageable: false, 
				editable: "inline",
				columns: [
					{ field: "name", title: "이름", width: 250 , validation: { required: true} },  
					{ field: "value", title: "값" , validation: { required: true} },
					{ command: ["edit", "destroy"], title: "&nbsp;", width: "250px"}
				],
				save : function(){
					console.log('ss');	
				}
			});						
		}		
	}
 
	</script>
</head>
    
<body class="">
	<!-- Header -->
	<#include "includes/admin-header.ftl">
	<!-- End Header -->
	
	<section class="container-fluid px-0 g-pt-65">	
	<div class="row no-gutters g-pos-rel g-overflow-x-hidden">
		<!-- Sidebar Nav -->
		<#include "includes/admin-sidebar.ftl">
		<!-- End Sidebar Nav -->		
		<div class="col g-ml-45 g-ml-0--lg g-pb-65--md">
			<!-- Breadcrumb-v1 -->
			<div class="g-hidden-sm-down g-bg-gray-light-v8 g-pa-20">
				<ul class="u-list-inline g-color-gray-dark-v6">
					<li class="list-inline-item g-mr-10">
						<a class="u-link-v5 g-color-gray-dark-v6 g-color-lightblue-v3--hover g-valign-middle" href="#!">설정</a> 
						<i class="community-admin-angle-right g-font-size-12 g-color-gray-light-v6 g-valign-middle g-ml-10"></i>
					</li>
					<li class="list-inline-item">
						<span class="g-valign-middle">시스템 프로퍼티</span>
					</li>
				</ul>
			</div>
			<!-- End Breadcrumb-v1 -->
			<div class="g-pa-20">
				<h1 class="g-font-weight-300 g-font-size-28 g-color-black g-mb-30">시스템 프로퍼티</h1>
				<!-- Content Body -->
				<div id="features" class="container-fluid">

					<div class="row text-center text-uppercase g-bord-radias g-brd-gray-dark-v7 g-brd-top-0 g-brd-left-0 g-brd-right-0 g-brd-style-solid g-brd-3">
						<div class="col-6">
							<div class="alert alert-dismissible fade show g-bg-gray-dark-v2 g-color-white rounded-0" role="alert">
								<button type="button" class="close u-alert-close--light" data-dismiss="alert" aria-label="Close">
                          			<span class="g-color-white" aria-hidden="true">×</span>
                        			</button>
                        			<div class="media">
									<span class="d-flex g-mr-10 g-mt-5"><i class="icon-question g-font-size-25"></i></span>
                          			<span class="media-body align-self-center">
                          			<strong>주의!</strong>
                            			 속성값은 임의로 수정하거나 추가하는 경우 오류의 원인이 될 수 있습니다.
                          			</span>
                        			</div>
							</div>  
						</div>
						<div class="col-6 text-right">
						<a href="javascript:void();" class="btn btn-xl u-btn-3d u-btn-primary g-width-200--md g-mb-15 g-font-size-default g-ml-10" data-bind="click:createNewProperty" >새로운 프로퍼티 만들기</a>
						</div>
					</div>			
					<div class="row"> 
						<div id="properties-grid" class="g-brd-gray-dark-v7 g-brd-top-0 g-brd-left-0 g-brd-right-0 g-brd-style-solid g-brd-3"></div> 
					</div> 
				</div>
				<!-- End Content Body -->
			</div>
			<!-- Footer -->
			<#include "includes/admin-footer.ftl">
			<!-- End Footer -->
		</div>
	</div>
	</section>
		
</body>
</html>
</#compress>