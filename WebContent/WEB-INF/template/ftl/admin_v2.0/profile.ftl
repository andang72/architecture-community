<#ftl encoding="UTF-8"/>
<#compress>
<!DOCTYPE html>
<html>
<head>	
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    
	<title>${ CommunityContextHelper.getConfigService().getApplicationProperty("website.title", "REPLICANT") } | ADMIN v2.0</title>
	
    <!-- Kendoui with bootstrap theme CSS -->			
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.common-bootstrap.core.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	
	
	<!-- Bootstrap CSS -->
    <link href="<@spring.url "/css/bootstrap/4.0.0-beta.2/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	
    
    <!-- Bootstrap Theme CSS -->
    
    <link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />	
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
			"jquery.cookie" 				: { "deps" :['jquery'] },
	        "bootstrap" 					: { "deps" :['jquery'] },
	        "kendo.ui.core.min" 			: { "deps" :['jquery'] },
	        "kendo.culture.ko-KR.min" 	: { "deps" :['jquery', 'kendo.ui.core.min'] },
	        "community.ui.core" 			: { "deps" :['jquery', 'kendo.culture.ko-KR.min'] },
	        "community.data" 			: { "deps" :['jquery', 'community.ui.core'] },	 
	        "community.ui.admin" 		: { "deps" :['jquery', 'community.ui.core'] }
		},
		paths : {
			"jquery"    					: "/js/jquery/jquery-3.1.1.min",
			"jquery.cookie"    			: "/js/jquery.cookie/1.4.1/jquery.cookie",
			"bootstrap" 					: "/js/bootstrap/3.3.7/bootstrap.min",
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"community.ui.admin" 		: "/js/community.ui.components/community.ui.admin",
			"community.ui.core" 			: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data",
			"dropzone"					: "/js/dropzone/dropzone"
		}
	});
	require([ "jquery", "jquery.cookie", "bootstrap", "dropzone", "kendo.ui.core.min", "community.ui.core", "community.data", "community.ui.admin"], function($, kendo ) { 
		
		if( community.data.storageAvailable ('localStorage') ){
			localStorage.setItem('selected_current_page', 'none' );
		}
							
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
			refresh : function (){
				var $this = this;	
				$this.set('userAvatarSrc', community.data.getUserProfileImage( $this.currentUser ) );
			}
		});
		
		community.ui.bind( $('#js-header') , observable );   
		// initialization of sidebar navigation component
	    community.ui.components.HSSideNav.init('.js-side-nav');
	   	// initialization of HSDropdown component
	    community.ui.components.HSDropdown.init($('[data-dropdown-target]'), {dropdownHideOnScroll: false});	   
	 	
	 	var renderTo = $('#features');
		community.ui.bind( renderTo , observable );
		
		var myDropzone = new Dropzone('#dropzoneForm', {
			url: '<@spring.url "/data/v1/me/upload_avatar_image.json"/>',
			paramName: 'file',
			maxFilesize: 1,
			acceptedFiles: 'image/*'	,
			previewsContainer: '#dropzoneForm .dropzone-previews'	,
			previewTemplate: '<div class="dz-preview dz-file-preview"><div class="dz-progress"><span class="dz-upload" data-dz-uploadprogress></span></div></div>'
		});
		
		myDropzone.on("addedfile", function(file) {
		  console.log('start');
		  community.ui.progress($('#dropzoneForm'), true);
		});
		
		myDropzone.on("complete", function() {
		  community.ui.progress($('#dropzoneForm'), false);
		  console.log('done');
		  observable.refresh();
		});
		
	});
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
			<div class="g-pa-20">
				<!-- Content Body -->
	            <div id="features" class="row">
	              <div class="col-md-3 g-mb-30 g-mb-0--md">
	                <div class="h-100 g-brd-around g-brd-gray-light-v7 g-rounded-4 g-pa-15 g-pa-20--md">
	                  <!-- User Information -->
	                  <section class="text-center g-mb-30 g-mb-50--md">
	                    <div class="d-inline-block g-pos-rel g-mb-20">
	                      <a class="u-badge-v2--lg u-badge--bottom-right g-width-32 g-height-32 g-bg-lightblue-v3 g-bg-primary--hover g-mb-20 g-mr-20" href="#!">
	                        <i class="community-admin-pencil g-absolute-centered g-font-size-16 g-color-white"></i>
	                      </a>
	                      <img class="rounded-circle" data-bind="attr:{ src: userAvatarSrc }" src="/images/no-avatar.png" alt="Image description" width="130" height="130">
	                      <form action="" method="post" enctype="multipart/form-data" id="dropzoneForm" class="u-dropzone">
	                       	 <div class="dz-default dz-message">
	                       	 	<a class="u-badge-v2--lg u-badge--bottom-right g-width-32 g-height-32 g-bg-lightblue-v3 g-bg-primary--hover g-mb-20 g-mr-20" href="#!">
			                        <i class="community-admin-upload g-absolute-centered g-font-size-16 g-color-white"></i>
			                      </a>
	                       	 </div>       
                       	 	<div class="dropzone-previews"></div>                 
							 <div class="fallback">
							     <input name="file" type="file" multiple style="display:none;"/>
							 </div>
						</form> 
	                    </div>	
	                    <h3 class="g-font-weight-300 g-font-size-20 g-color-black mb-0" data-bind="text:currentUser.name"></h3>
	                    <p data-bind="text:currentUser.username"></p>
	                  </section>
	                  <!-- User Information -->
	                </div>
	              </div>	
	              <div class="col-md-9">
	                <div class="h-100 g-brd-around g-brd-gray-light-v7 g-rounded-4 g-pa-15 g-pa-20--md">
	                  
	                </div>
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