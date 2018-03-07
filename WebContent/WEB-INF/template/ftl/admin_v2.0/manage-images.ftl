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
    <link href="<@spring.url "/css/bootstrap/4.0.0/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	
    
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
	        "community.ui.admin" 		: { "deps" :['jquery', 'jquery.cookie', 'community.ui.core', 'community.data'] }
		},
		paths : {
			"jquery"    					: "/js/jquery/jquery-3.1.1.min",
			"jquery.cookie"    			: "/js/jquery.cookie/1.4.1/jquery.cookie",
			"bootstrap" 					: "/js/bootstrap/4.0.0/bootstrap.bundle.min",
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"community.ui.admin" 		: "/js/community.ui.components/community.ui.admin",
			"community.ui.core" 			: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data"
		}
	});
	require([ "jquery", "jquery.cookie", "bootstrap", "kendo.ui.core.min", "community.ui.core", "community.data", "community.ui.admin"], function($, kendo ) { 
	
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
		
		community.ui.bind( $('#js-header') , observable );        
		
		// initialization of sidebar navigation component
	    community.ui.components.HSSideNav.init('.js-side-nav');
	   	// initialization of HSDropdown component
	    community.ui.components.HSDropdown.init($('[data-dropdown-target]'), {dropdownHideOnScroll: false});	   
	 	
	 	var renderTo = $('#features');
		community.ui.bind( renderTo , observable );
		createImageListView();
		
	});
	
	function createImageListView(){
		console.log("create image listview.");
		var renderTo = $('#images-listview');	
		var listview = community.ui.listview( renderTo , {
			dataSource: community.ui.datasource('<@spring.url "/data/api/mgmt/v1/images/list.json"/>', {
				transport: { 
					read:{
						contentType: "application/json; charset=utf-8"
					},
					parameterMap: function (options, operation){	 
						return community.ui.stringify(options);
					}
				},
				serverFiltering:true,
				serverSorting: true,
				schema: {
					total: "totalCount",
					data:  "items",
					model: community.model.Image
				}
			}),
			dataBound: function() {
				if( this.items().length == 0)
					renderTo.html('<tr class="g-height-50"><td colspan="7" class="align-middle g-font-weight-300 g-color-black text-center">조건에 해당하는 데이터가 없습니다.</td></tr>');
			},
			template: community.ui.template($("#template").html())
		}); 			
		
		community.ui.pager( $("#images-listview-pager"), {
            dataSource: listview.dataSource
        }); 	
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
						<a class="u-link-v5 g-color-gray-dark-v6 g-color-lightblue-v3--hover g-valign-middle" href="#!">리소스</a> <i class="community-admin-angle-right g-font-size-12 g-color-gray-light-v6 g-valign-middle g-ml-10"></i>
					</li>
					<li class="list-inline-item">
						<span class="g-valign-middle">이미지</span>
					</li>
				</ul>
			</div>
			<!-- End Breadcrumb-v1 -->
			<div class="g-pa-20">
				<h1 class="g-font-weight-300 g-font-size-28 g-color-black g-mb-30">이미지 관리</h1>
				<!-- Content Body -->
				<div class="container-fluid">
					<div class="row text-center">
						<div class="col-6 text-left">
							<p class="text-danger g-font-weight-100">사용자를 관리합니다.</p>
						</div>
						<div class="col-6 text-right">
							<a href="#!" class="btn btn-xl u-btn-primary g-width-180--md g-mb-10 g-font-size-default g-ml-10" data-action="create" data-object-type="user" data-object-id="0">이미지 업로드</a>
						</div>
					</div>				
					<div class="row text-center text-uppercase g-bord-radias g-brd-gray-dark-v7 g-brd-top-0 g-brd-left-0 g-brd-right-0 g-brd-style-solid g-brd-3">
					</div>
					<div class="row">
	                		<div class="table-responsive">
							<table class="table w-100 g-mb-0">
								<thead class="g-hidden-sm-down g-color-gray-dark-v6">
									<tr class="g-height-50">
			                             <th class="g-bg-gray-light-v8 g-font-weight-400 g-valign-middle g-brd-bottom-none g-py-15 g-width-100 sorting" data-kind="image" data-action="sort" data-dir="asc" data-field="IMAGE_ID" >
											<div class="media">
												<div class="d-flex align-self-center">ID.</div>
												<div class="d-flex align-self-center ml-auto">
													<span class="d-inline-block g-width-10 g-line-height-1 g-font-size-10">
													<a class="g-color-gray-light-v6 g-color-lightblue-v3--hover g-text-underline--none--hover" href="#!">
													<i class="community-admin-angle-up"></i>
													</a>
													<a class="g-color-gray-light-v6 g-color-lightblue-v3--hover g-text-underline--none--hover" href="#!">
													<i class="community-admin-angle-down"></i>
													</a>
													</span>
												</div>
											</div>	
										</th>
			                             <th class="g-bg-gray-light-v8 g-font-weight-400 g-valign-middle g-brd-bottom-none g-py-15 sorting" data-kind="image" data-action="sort" data-dir="asc" data-field="FILE_NAME">
			                             	<div class="media">
												<div class="d-flex align-self-center">파일</div>
												<div class="d-flex align-self-center ml-auto">
													<span class="d-inline-block g-width-10 g-line-height-1 g-font-size-10">
													<a class="g-color-gray-light-v6 g-color-lightblue-v3--hover g-text-underline--none--hover" href="#!">
													<i class="community-admin-angle-up"></i>
													</a>
													<a class="g-color-gray-light-v6 g-color-lightblue-v3--hover g-text-underline--none--hover" href="#!">
													<i class="community-admin-angle-down"></i>
													</a>
													</span>
												</div>
											</div>	
			                             </th>
			                             <th class="g-bg-gray-light-v8 g-font-weight-400 g-valign-middle g-brd-bottom-none g-py-15">크기</th>			                             
			                             <th class="g-bg-gray-light-v8 g-font-weight-400 g-valign-middle g-brd-bottom-none g-py-15" width="100">생성자</th>
			                             
										<th class="g-bg-gray-light-v8 g-font-weight-400 g-valign-middle g-brd-bottom-none g-py-15 g-width-100 sorting" data-kind="image" data-action="sort" data-dir="asc" data-field="CREATION_DATE">
											<div class="media">
												<div class="d-flex align-self-center">생성일</div>
												<div class="d-flex align-self-center ml-auto">
													<span class="d-inline-block g-width-10 g-line-height-1 g-font-size-10">
														<a class="g-color-gray-light-v6 g-color-lightblue-v3--hover g-text-underline--none--hover" href="#!">
															<i class="community-admin-angle-up"></i>
														</a>
														<a class="g-color-gray-light-v6 g-color-lightblue-v3--hover g-text-underline--none--hover" href="#!">
															<i class="community-admin-angle-down"></i>
														</a>
													</span>
												</div>
											</div>
										</th>			                             
			                             <th class="g-bg-gray-light-v8 g-font-weight-400 g-valign-middle g-brd-bottom-none g-py-15 g-width-100 sorting" data-kind="image" data-action="sort" data-dir="asc" data-field="MODIFIED_DATE">
											<div class="media">
												<div class="d-flex align-self-center">수정일</div>
												<div class="d-flex align-self-center ml-auto">
													<span class="d-inline-block g-width-10 g-line-height-1 g-font-size-10">
														<a class="g-color-gray-light-v6 g-color-lightblue-v3--hover g-text-underline--none--hover" href="#!">
															<i class="community-admin-angle-up"></i>
														</a>
														<a class="g-color-gray-light-v6 g-color-lightblue-v3--hover g-text-underline--none--hover" href="#!">
															<i class="community-admin-angle-down"></i>
														</a>
													</span>
												</div>
											</div>
										</th> 		
			                             <th class="g-bg-gray-light-v8 g-font-weight-400 g-valign-middle g-brd-bottom-none g-py-15 g-pr-25 g-width-100"></th>								
									</tr>
								</thead>
								<tbody id="images-listview" class="u-listview g-brd-none">
								</tbody>
							</table>
						</div>
						<div id="images-listview-pager" class="g-brd-top-none g-brd-left-none g-brd-right-none" style="width:100%;"></div>
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
	<script type="text/x-kendo-template" id="template">   
	<tr class="u-listview-item">
	<td class="g-hidden-sm-down g-valign-middle g-brd-top-none g-brd-bottom g-brd-gray-light-v7 g-pl-25">
	#: imageId #
	</td>
	<td class="g-valign-middle g-brd-top-none g-brd-bottom g-brd-gray-light-v7 g-px-5 g-px-10--sm">
		<img class="g-width-100 g-width-100--md g-height-100 g-height-100--md g-brd-2 g-brd-transparent g-brd-lightblue-v3--parent-opened g-mr-20--sm" 
		src="#= community.data.getImageUrl(data, {thumbnail:true}) #" 
		alt="Image Description">
		<span class="g-hidden-sm-down">#: name #</span>
	</td>
	<td class="g-valign-middle g-brd-top-none g-brd-bottom g-brd-gray-light-v7 g-py-15 g-py-30--md"> 
	#= community.data.bytesToSize(size	) # 
	</td>
		<td class="g-hidden-sm-down g-valign-middle g-brd-top-none g-brd-bottom g-brd-gray-light-v7 g-py-15 g-py-30--md g-px-5 g-px-10--sm">
			#if( !user.anonymous ){  #
			<div class="media">
            		<div class="d-flex align-self-center">
                    <img class="g-width-36 g-height-36 rounded-circle g-mr-15" src="#= community.data.getUserProfileImage(user) #" >
                </div>
				<div class="media-body align-self-center text-left">#: user.name #</div>
            </div>
            #}#
		</td>
	<td class="g-hidden-sm-down g-valign-middle g-brd-top-none g-brd-bottom g-brd-gray-light-v7 g-py-15 g-py-30--md g-px-5 g-px-10--sm"> #: community.data.getFormattedDate( creationDate)  # </td>
	<td class="g-hidden-sm-down g-valign-middle g-brd-top-none g-brd-bottom g-brd-gray-light-v7 g-py-15 g-py-30--md g-px-5 g-px-10--sm">#: community.data.getFormattedDate( modifiedDate)  #</td>
	<td class="g-valign-middle g-brd-top-none g-brd-bottom g-brd-gray-light-v7 g-py-15 g-py-30--md g-px-5 g-px-10--sm">
	<div class="d-flex align-items-center g-line-height-1">
	<a class="u-link-v5 g-color-gray-light-v6 g-color-lightblue-v4--hover g-mr-15" href="\#!" data-action="edit" data-object-type="image" data-object-id="#= imageId #">
	<i class="community-admin-pencil g-font-size-18"></i>
	</a>
	<a class="u-link-v5 g-color-gray-light-v6 g-color-lightblue-v4--hover" href="\#!" data-action="delete" data-object-type="image" data-object-id="#= imageId #">
	<i class="community-admin-trash g-font-size-18"></i>
	</a>
	</div>
	</td>
	</tr>
	</script>	
</body>
</html>
</#compress>