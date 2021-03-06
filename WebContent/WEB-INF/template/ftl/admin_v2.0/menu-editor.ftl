<#ftl encoding="UTF-8"/>
<#compress>
<!DOCTYPE html>
<html>
<head>	
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    
	<title>${ CommunityContextHelper.getConfigService().getApplicationProperty("website.title", "REPLICANT") } | ADMIN v2.0</title>
	
    <!-- Kendo UI with bootstrap theme CSS -->	
   	<!--
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.common-bootstrap.core.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	
	-->
	<!-- Professional Kendo UI --> 	
	<link href="<@spring.url "/css/kendo/2018.1.221/kendo.common.min.css"/>" rel="stylesheet" type="text/css" />	
	
	<link href="<@spring.url "/css/kendo/2018.1.221/kendo.bootstrap-v4.min.css"/>" rel="stylesheet" type="text/css" />	
	
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
	var __menuId = <#if RequestParameters.menuId?? >${RequestParameters.menuId}<#else>0</#if>;
	
	require.config({
		shim : {
			"jquery.cookie" 				: { "deps" :['jquery'] },
	        "bootstrap" 					: { "deps" :['jquery'] },
	        "kendo.web.min" 				: { "deps" :['jquery'] },
	        "kendo.culture.ko-KR.min" 	: { "deps" :['jquery', 'kendo.web.min'] },
	        "kendo.extension.min" 		: { "deps" :['jquery', 'kendo.web.min'] },
	        "community.ui.core" 			: { "deps" :['jquery', "kendo.web.min", 'kendo.culture.ko-KR.min', 'kendo.extension.min'] },
	        "community.data" 			: { "deps" :['jquery', 'community.ui.core'] },	 
	        "community.ui.professional" 	: { "deps" :['jquery', 'community.ui.core'] },
	        "community.ui.admin" 		: { "deps" :['jquery', 'community.ui.core', 'community.data'] }
		},
		paths : {
			"jquery"    				: "/js/jquery/jquery-3.1.1.min",
			"jquery.cookie"    			: "/js/jquery.cookie/1.4.1/jquery.cookie",
			"bootstrap" 				: "/js/bootstrap/4.0.0/bootstrap.bundle.min",
			/*"kendo.ui.core.min" 		: "/js/kendo.ui.core/kendo.ui.core.min",*/
			/*"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",*/
			"kendo.web.min"	 			: "/js/kendo/2018.1.221/kendo.web.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo/2018.1.221/cultures/kendo.culture.ko-KR.min",	
			"kendo.extension.min"		: "/js/kendo.extension/kendo.ko_KR",			
			"community.ui.core" 		: "/js/community.ui/community.ui.core",
			"community.ui.professional" : "/js/community.ui.components/community.ui.professional",
			"community.data" 			: "/js/community.ui/community.data",
			"community.ui.admin" 		: "/js/community.ui.components/community.ui.admin"
		}
	});
	require([ "jquery", "jquery.cookie", "kendo.web.min", "community.ui.core", "community.data", "community.ui.professional", "community.ui.admin"], function($, kendo ) { 
	
		community.ui.setup({
		  	features : {
				accounts: true
		  	},
		  	'features.accounts.authenticate' :function(e){
		  		observable.setUser(e.token);
		  	}
		});
		
		var usingTreeList = true;
		$.getScript( "/js/kendo.extension/kendo.messages.ko-KR.js" , function () {
			observable.loadMenu();
		});
		
		var observable = new community.ui.observable({ 
			currentUser : new community.model.User(),
			userAvatarSrc : "/images/no-avatar.png",
			userDisplayName : "",
			menu : new community.model.Menu(), 
			setUser : function( data ){
				var $this = this;				
				data.copy($this.currentUser);
				$this.set('userAvatarSrc', community.data.getUserProfileImage( $this.currentUser ) );
				$this.set('userDisplayName', community.data.getUserDisplayName( $this.currentUser ) );
			},
			back : function(){
				var $this = this;
				community.ui.send("<@spring.url "/secure/display/ftl/admin_v2.0/manage-menus" />");
				return false;
			},
			loadMenu : function(){
				var $this = this;		
				community.ui.ajax('<@spring.url "/data/api/mgmt/v1/ui/menus/"/>' + __menuId + '/get.json', {
					success: function(data){	
						var data = new community.model.Menu(data);
						data.copy( $this.menu ); 
						if( usingTreeList )
							createItemsTreeList();
						else
							createItemsListView();
					}	
				}); 		
			} 
		}); 
		community.ui.bind( $('#js-header') , observable );   
		// initialization of sidebar navigation component
	    community.ui.components.HSSideNav.init('.js-side-nav');
	   	// initialization of HSDropdown component
	    community.ui.components.HSDropdown.init($('[data-dropdown-target]'), {dropdownHideOnScroll: false});	   
		var renderTo = $('#features');
		community.ui.bind( renderTo , observable ); 
		
		renderTo.on("click", "button[data-object-type=menu], a[data-object-type=menu], a[data-kind=menu], .sorting[data-kind=menu]", function(e){			
			var $this = $(this);
			var actionType = $this.data("action");	 
			if( actionType == 'sort'){
				if( $this.data('dir') == 'asc' )
					$this.data('dir', 'desc' );
				else if 	( $this.data('dir') == 'desc' )
					$this.data('dir', 'asc' );
				community.ui.listview( $('#items-listview') ).dataSource.sort({ field:$this.data('field'), dir:$this.data('dir') });				
				return false;
			}else if (actionType == 'refresh'){
				if( usingTreeList ){
					community.ui.treelist($('#items-treelist')).dataSource.read();
				}
				return false;		
			} 
			var objectId = $this.data("object-id");		
			var targetObject = new community.model.MenuItem();
			if ( objectId > 0 ) {
				targetObject = community.ui.listview( $('#items-listview') ).dataSource.get( objectId );				
			}
			if( usingTreeList )
				community.ui.treelist($('#items-treelist')).addRow();				
 			else
 				openMenuEditor(targetObject); 
			return false;		
		});	
	});
	
	function createItemsTreeList(){
		var renderTo = $('#items-treelist');	
		if( !community.ui.exists(renderTo)){
			var treelist = community.ui.treelist(renderTo, {
                    dataSource: {
                        transport: {
                            read: {
                            	   	contentType: "application/json; charset=utf-8",
                            		url: '<@spring.url "/data/api/mgmt/v1/ui/menus/"/>' + __menuId + '/items/list.json?widget=treelist' ,
                                	type :'POST',
                                	dataType: 'json'                                
                             },
                             update: {
                                 url: '<@spring.url "/data/api/mgmt/v1/ui/menus/"/>' + __menuId + '/items/save-or-update.json' ,
                                 type :'POST',  
                                 contentType : "application/json", 
                             	dataType: 'json'    
                             },
                             destroy: {
                                 url: '<@spring.url "/data/api/mgmt/v1/ui/menus/"/>' + __menuId + '/items/delete.json' ,
                            		type :'POST',
                            		contentType : "application/json",
                            		dataType: 'json'    
                             },
                             create: {
                                 url: '<@spring.url "/data/api/mgmt/v1/ui/menus/"/>' + __menuId + '/items/save-or-update.json' ,
                             	type :'POST',
                             	contentType : "application/json",
                             	dataType: 'json'    
                             },
							parameterMap: function (options, operation){	 
								if (operation !== "read" && options.models) {
                                     return {models: kendo.stringify(options.models)};
                                 }else{
									return community.ui.stringify(options);
								}
							}
                        },
                        schema: {
							data:  "items",
							model: {
								id: "menuItemId",
								parentId: "parentMenuItemId",
								fields: { 		
									menuItemId: { type: "number", defaultValue: 0 },		
									menuId: { type: "number", defaultValue: 0 },	
									parentMenuItemId: { type: "number", defaultValue: null },	
									name: { type: "string", defaultValue: null },	
									roles: { type: "string", defaultValue: null },	
									sortOrder: { type: "number", defaultValue: 1 },	
									location: { type: "string", defaultValue: null },	
									description: { type: "string", defaultValue: null },
									creationDate:{ type: "date" },			
									modifiedDate:{ type: "date"}
								},	
								expanded: false
							}
 							
                        }
                    },
                    height: 600,
                    filterable: false,
                    sortable: true,
                    toolbar: [ "create" ],
                    /*
                    toolbar: kendo.template('
                    <div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" 
                    data-action="create" data-object-id="0">
                    <span class="btn-label icon fa fa-plus"></span> 메뉴 추가하기 </button>
                    <button class="btn btn-flat btn-outline btn-info pull-right" 
                    data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"> 새로고침 </button></div>'),
					*/
                    editable: {
                    		mode: "inline",
                    		move: true
                    },
                    columns: [
                        { field: "name", expandable: true, title: "메뉴", width: 200 },
                        { field: "description" , title: "설명", sortable: false, width: 250 },
                        { field: "sortOrder" , title: "정렬",  width: 100, attributes: { style: "text-align: center;"  }},
                        { field: "page" , title: "페이지" , sortable : false},
                        { field: "location" , title: "링크" , sortable : false},
                        { field: "roles", title: "권한" , width: 150, sortable : false},
                        { title: " ", command: [ "edit", "destroy" ], width: 200 }
                    ],
                    save: function(e){
				    	community.ui.treelist(renderTo).dataSource.read();
				    }
             });
             community.ui.treelist(renderTo).bind(
				"dragend", function(e){
					console.log("drag ended", community.ui.stringify(e.source), e.destination);
					this.dataSource.sync();
				}
             );   
        }    
	}

	function createItemsListView(){
		console.log("create menu items listview.");
		var renderTo = $('#items-listview');	
		var listview = community.ui.listview( renderTo , {
			dataSource: community.ui.datasource('<@spring.url "/data/api/mgmt/v1/ui/menus/"/>' + __menuId + "/items/list.json", {
				transport: { 
					read:{
						contentType: "application/json; charset=utf-8"
					},
					parameterMap: function (options, operation){	 
						return community.ui.stringify(options);
					}
				},
				serverPaging: false,
				serverSorting: true,
				schema: {
					total: "totalCount",
					data:  "items",
					model: community.model.MenuItem
				}
			}),
			dataBound: function() {
				//if( this.items().length == 0)
				//	renderTo.html('<tr class="g-height-50"><td colspan="6" class="align-middle g-font-weight-300 g-color-black text-center">조건에 해당하는 데이터가 없습니다.</td></tr>');
			},
			template: community.ui.template($("#template").html())
		}); 			
		
		community.ui.pager( $("#items-listview-pager"), {
            dataSource: listview.dataSource
        }); 	
	}
		
	function openMenuEditor( data ){	
		var renderTo = $('#menu-item-editor-modal');
		if( !renderTo.data("model") ){
			var observable = new community.ui.observable({ 
				isNew : false,			
				editable : true,	
				item : new community.model.MenuItem(),
				saveOrUpdate : function(e){			
					var $this = this;
					if( $this.editable ){
						community.ui.progress(renderTo.find('.modal-content'), true);	
						community.ui.ajax( '<@spring.url "/data/api/mgmt/v1/ui/menus/" />' + __menuId + '/items/save-or-update.json', {
							data: community.ui.stringify($this.item),
							contentType : "application/json",
							success : function(response){
								community.ui.listview( $('#items-listview') ).dataSource.read();
							}
						}).always( function () {
							community.ui.progress(renderTo.find('.modal-content'), false);
							renderTo.modal('hide');
						});			
					}else{
						renderTo.modal('hide');
					}			
				},
				setSource : function (data){
					var $this = this;
					data.copy( $this.item ); 
					if(  $this.item.menuItemId > 0 ){	
						$this.set('isNew', false );					
					}else{	
						$this.set('isNew', true ); 
					}																
				}
			});
			renderTo.data("model", observable );	
			community.ui.bind( renderTo, observable );				
			renderTo.on('show.bs.modal', function (e) {	});
		}
		renderTo.data("model").setSource(data);
		renderTo.modal('show');
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
						<span class="g-valign-middle">메뉴</span>
					</li>
				</ul>
			</div>
			<!-- End Breadcrumb-v1 -->
			<div class="g-pa-20">
				<h1 class="g-font-weight-300 g-font-size-28 g-color-black g-mb-30">메뉴 관리</h1>
				<!-- Content Body -->
				<div id="features" class="container-fluid">
					<div class="row g-bord-radias g-brd-gray-dark-v7 g-brd-top-0 g-brd-left-0 g-brd-right-0 g-brd-style-solid g-brd-3">
						<div class="col-12">
							<div class="media-md align-items-center g-mb-30">
		              			<div class="d-flex g-mb-15 g-mb-0--md">
									<header class="g-mb-10">
						            	<div class="u-heading-v6-2 text-uppercase" >
						              <h2 class="h4 u-heading-v6__title g-font-weight-300" data-bind="text:menu.name"></h2>
						            	</div>
						            	<div class="g-pl-90">
						              <p data-bind="text:menu.description"></p>
						            	</div>
						          	</header>		                				
		             	 		</div>	
								<div class="media d-md-flex align-items-center ml-auto">
					                <a class="d-flex align-items-center u-link-v5 g-color-lightblue-v3 g-color-primary--hover g-ml-15 g-ml-45--md" href="#!" data-bind="click:back">
					                  	<i class="community-admin-angle-left g-font-size-18"></i>
					                 	<span class="g-hidden-sm-down g-ml-10">뒤로가기</span>
					                </a>			
					                <a class="d-flex align-items-center u-link-v5 g-color-lightblue-v3 g-color-primary--hover g-ml-15 g-ml-45--md" href="#!" data-action="refresh" data-object-type="menu" data-object-id="0"  >
					                  	<i class="community-admin-reload g-font-size-18"></i>
					                 	<span class="g-hidden-sm-down g-ml-10">새로고침</span>
					                </a>
								</div>
		            			</div>
	                  	</div>
						<div class="alert alert-dismissible fade show g-bg-gray-dark-v2 g-color-white rounded-0" role="alert">
								<button type="button" class="close u-alert-close--light" data-dismiss="alert" aria-label="Close">
                          			<span class="g-color-white" aria-hidden="true">×</span>
                        			</button>
                        			<div class="media">
									<span class="d-flex g-mr-10 g-mt-5"><i class="icon-question g-font-size-25"></i></span>
                          			<span class="media-body align-self-center">
                            			이름을 클릭하면 세부적인 메뉴를 구성할 수 있습니다.
                          			</span>
                        			</div>
						</div> 
					</div>	
					<div class="row">
						<div id="items-treelist"></div>
						<!-- menu listview -->
						<div class="table-responsive g-mb-0" style="display:none;">						
						<table class="table u-table--v3 g-color-black">
							<thead>
								<tr class="g-bg-gray-light-v8">
									<th class="g-valign-middle g-width-100 g-px-30 sorting" data-kind="menu" data-action="sort" data-dir="asc" data-field="MENU_ITEM_ID" >
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
									<th class="g-valign-middle g-width-100" > 부모 ID </th>
									<th class="g-valign-middle g-px-30 g-width-300 sorting" data-kind="menu" data-action="sort" data-dir="asc" data-field="NAME">
										<div class="media">
											<div class="d-flex align-self-center">이름</div>
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
									<th class="g-valign-middle g-px-30" > 설명 </th>
									<th class="g-valign-middle g-px-30 g-width-150 sorting" data-kind="menu" data-action="sort" data-dir="asc" data-field="CREATION_DATE">
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
									<th class="g-valign-middle g-px-30 g-width-150 sorting" data-kind="menu" data-action="sort" data-dir="asc" data-field="MODIFIED_DATE">
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
									<th class="g-valign-middle g-px-30 g-width-100"></th>	
								</tr>	
							</thead>
							<tbody id="items-listview" class="u-listview g-brd-none">
							</tbody>
						</table>
						</div>					
						<div id="items-listview-pager" class="g-brd-top-none" style="width:100%;"></div>
            				<!-- menu listview end -->
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
	
	<!-- menu editor modal -->
	<div class="modal fade" id="menu-item-editor-modal" tabindex="-1" role="dialog" aria-labelledby="menu-item-editor-modal-labal" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				
				<!-- .modal-header -->
				<div class="modal-header">
					<h2 class="modal-title">MENU</h2>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
			        </button>			       
		      	</div>
			    <!-- /.modal-header -->
			    <!-- .modal-body -->
				<div class="modal-body">
					<div class="form-group g-mb-10">
						<div class="g-pos-rel">
							<span class="g-pos-abs g-top-0 g-right-0 d-block g-width-40 h-100 opacity-0 g-opacity-1--success">
							<i class="community-admin-check g-absolute-centered g-font-size-default g-color-lightblue-v3"></i>
							</span>
							<input class="form-control g-rounded-4" type="text" placeholder="파일명을 입력하세요" data-bind="value: item.name,enabled:editable">
							<small class="g-font-weight-300 g-font-size-12 g-color-gray-dark-v6 g-pt-5">메뉴를 구분하는 이름입니다.</small>
						</div>
					</div>
										
					<div class="form-group g-mb-10">
						<div class="g-pos-rel">
							<textarea class="form-control form-control-md g-resize-none g-rounded-4" rows="3" placeholder="간략하게 메뉴에 대한 설명을 입력하세요." data-bind="value: item.description, enabled:editable"></textarea>
						</div>
					</div>
					<div class="form-group g-mb-10">
						<div class="g-pos-rel">
							<span class="g-pos-abs g-top-0 g-right-0 d-block g-width-40 h-100 opacity-0 g-opacity-1--success">
							<i class="community-admin-check g-absolute-centered g-font-size-default g-color-lightblue-v3"></i>
							</span>
							<input class="form-control g-rounded-4" type="text" placeholder="링크" data-bind="value: item.location,enabled:editable">
							<small class="g-font-weight-300 g-font-size-12 g-color-gray-dark-v6 g-pt-5">메뉴를 클릭할 때 이동할 경로 정보입니다.</small>
						</div>
					</div>					
					<div class="g-brd-around g-brd-gray-light-v7 g-rounded-4 g-pa-15 g-pa-20--md g-mb-15">
					<div class="row">
						<div class="col-md-4">
							<h3 class="d-flex align-self-center text-uppercase g-font-size-12 g-font-size-default--md g-color-blackg-mb-15">부모 ID</h3>
							<div class="form-group">
							<input data-role="numerictextbox"
				                   data-format="n0"
				                   data-min="0"
				                   data-max="100"
				                   data-bind="value: item.parentMenuItemId">
							</div>
						</div>
						<div class="col-md-4">
							<h3 class="d-flex align-self-center text-uppercase g-font-size-12 g-font-size-default--md g-color-black mb-0">정렬순서</h3>
							<div class="form-group">
							<input data-role="numerictextbox"
				                   data-format="n0"
				                   data-min="0"
				                   data-max="100"
				                   data-bind="value: item.sortOrder">
							</div>
						</div>
						<div class="col-md-4" data-bind="visible:editable" style="">
							<header class="media g-mb-20">
							<h3 class="d-flex align-self-center text-uppercase g-font-size-12 g-font-size-default--md g-color-black mb-0">고급설정</h3>
								<div class="media-body d-flex justify-content-end">
								<a class="community-admin-panel u-link-v5 g-font-size-20 g-color-gray-light-v3 g-color-secondary--hover" href="#!" data-bind="click: showOptions"></a>
								</div>
							</header>
							</div>
						</div>
					</div>		
				</div>
		      	<!-- /.modal-body -->		
		      	<div class="modal-footer">
			        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
			        <button type="button" class="btn btn-primary" data-bind="click:saveOrUpdate">확인</button>
		      	</div><!-- /.modal-footer --> 				      			      	
				
	    		</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->	
	<script type="text/x-kendo-template" id="template">    	
	<tr>
		<td class="g-px-30">#: menuItemId # </td>
		<td class="g-px-30">#if( parentMenuItemId < 0 ) {# - #}else{# #:parentMenuItemId # #}#</td>
		<td class="g-px-30">
		<a class="d-flex align-items-center u-link-v5 g-color-black g-color-lightblue-v3--hover g-color-lightblue-v3--opened" href="\#!" data-object-id="#=menuId#" data-object-type="menu">#: name #</a>
		</td>
		<td class="g-px-30">#: description #</td>
		<td class="g-px-30">#: community.data.getFormattedDate( creationDate)  #</td>
		<td class="g-px-30">#: community.data.getFormattedDate( modifiedDate)  #</td>
		<td class="g-px-30">
			<div class="d-flex align-items-center g-line-height-1">
				<a class="u-link-v5 g-color-gray-light-v6 g-color-lightblue-v4--hover g-mr-15" href="\#!" data-action="edit" data-object-type="menu" data-object-id="#= menuId #" >
					<i class="community-admin-pencil g-font-size-18"></i>
                </a>
                <!--
                <a class="u-link-v5 g-color-gray-light-v6 g-color-lightblue-v4--hover" href="\#!" data-action="delete" data-object-type="menu" data-object-id="#= menuId #" >
                		<i class="community-admin-trash g-font-size-18"></i>
                </a>-->
			</div>
		</td>
	</tr>
	</script>			
</body>
</html>
</#compress>