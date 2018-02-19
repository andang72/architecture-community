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
    
    <link href="<@spring.url "/fonts/font-awesome.min.css"/>" rel="stylesheet" type="text/css" />	
    <link href="<@spring.url "/fonts/community-ui-admin-icons.css"/>" rel="stylesheet" type="text/css" />	
    
    <link href="<@spring.url "/css/animate/animate.min.css"/>" rel="stylesheet" type="text/css" />	
     
    <!-- Community CSS -->
    <link href="<@spring.url "/css/community.ui/community.ui.admin.css"/>" rel="stylesheet" type="text/css" />	
  	     
 	<script data-pace-options='{ "ajax": false }' src='<@spring.url "/js/pace/pace.min.js'"/>></script>
 	<script src="<@spring.url "/js/require.js/2.3.5/require.js"/>" type="text/javascript"></script>

 	<!-- Application JavaScript
    		================================================== -->    	
	<script>
	require.config({
		shim : {
			"bootstrap" 					: { "deps" :['jquery', 'popper'] },
			"jquery.cookie" 				: { "deps" :['jquery'] },
	        "kendo.ui.core.min" 			: { "deps" :['jquery'] },
	        "kendo.culture.ko-KR.min" 	: { "deps" :['jquery', 'kendo.ui.core.min'] },
	        "community.ui.core" 			: { "deps" :['jquery', 'kendo.culture.ko-KR.min'] },
	        "community.data" 			: { "deps" :['jquery', 'community.ui.core'] },	 
	        "community.ui.admin" 		: { "deps" :['jquery', 'jquery.cookie', 'community.ui.core' ] }
		},
		paths : {
			"jquery"    					: "/js/jquery/jquery-3.1.1.min",
			"jquery.cookie"    			: "/js/jquery.cookie/1.4.1/jquery.cookie",
			"popper" 	   				: "/js/bootstrap/4.0.0/bootstrap.bundle",
			"bootstrap" 					: "/js/bootstrap/4.0.0/bootstrap.min",
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"community.ui.admin" 		: "/js/community.ui.components/community.ui.admin",
			"community.ui.core" 			: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data",
			"ace" 						: "/js/ace/ace"
		}
	});
	require([ "jquery", "popper", "kendo.ui.core.min", "community.ui.core", "community.data", "community.ui.admin", "ace" ], function($, kendo ) { 
	
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
		 
		// initialization of sidebar navigation component
	    community.ui.components.HSSideNav.init('.js-side-nav');
	   	// initialization of HSDropdown component
	    community.ui.components.HSDropdown.init($('[data-dropdown-target]'), {dropdownHideOnScroll: false});	   
	 	
	 	community.ui.bind( $('#js-header') , observable );       
		var renderTo = $('#features');
		community.ui.bind( renderTo , observable );
		
	 	createPagesListView(renderTo); 
                
		renderTo.on("click","[data-action=create],[data-action=edit],[data-action=delete]", function(e){		
			var $this = $(this);		
			if( community.ui.defined($this.data("object-id")) ){
				var objectId = $this.data("object-id");						
				if( objectId > 0 ){
					var listview = community.ui.listview( $('#pages-listview') );
					openPageEditor( listview.dataSource.get(objectId) );
				}else{
					var newObj = new community.model.Page ();
					newObj.set("properties", {});							
					openPageEditor(newObj);
				}
			}
		});	
		
	});

	function createPagesListView(){		
		var renderTo = $('#pages-listview');	
		var listview = community.ui.listview( renderTo , {
			dataSource: community.ui.datasource('/data/api/mgmt/v1/pages/list.json', {
				schema: {
					total: "totalCount",
					data:  "items",
					model: community.model.Page
				}
			}),
			template: community.ui.template($("#template").html())
		}); 			
		community.ui.pager( $("#pages-listview-pager"), {
            dataSource: listview.dataSource
        }); 
				        
	}
	
	function createPropertiesDataSource( page ){
		console.log("create properties datasource.");
		return community.ui.datasource( null , {
			transport: { 
				read : 		{ url:'<@spring.url "/data/api/mgmt/v1/pages/"/>'+  page.get('pageId') + '/properties/list.json', type:'post', contentType : "application/json" },
				create : 	{ url:'<@spring.url "/data/api/mgmt/v1/pages/"/>'+  page.get('pageId') + '/properties/update.json', type:'post', contentType : "application/json" },
				update : 	{ url:'<@spring.url "/data/api/mgmt/v1/pages/"/>'+  page.get('pageId') + '/properties/update.json', type:'post', contentType : "application/json" },
				destroy : 	{ url:'<@spring.url "/data/api/mgmt/v1/pages/"/>'+  page.get('pageId') + '/properties/delete.json', type:'post', contentType : "application/json" },
				parameterMap: function (options, operation){	 
					console.log( community.ui.stringify(options) );
					if (operation !== "read" && options.models) { 
						return community.ui.stringify(options.models);
					}
				}
			},
			batch: true, 
			schema: {
				model: community.model.Property
			}
		});
	}
	
	function createPermissionsListView( parentRendorTo, renderTo, observable ){
		if( !community.ui.exists(renderTo) ){		
			console.log("create permissions listview.");
			var listview = community.ui.listview( renderTo, {
				template: community.ui.template($("#perms-template").html())
			}); 
 			parentRendorTo.on("click", "button[data-subject=permission][data-action=delete], a[data-subject=permission][data-action=delete]", function(e){			
				var $this = $(this);
				var permissionId = $this.data("object-id");
				var data = community.ui.listview( renderTo ).dataSource.get(permissionId);	
				observable.removePermission(data);
				return false;		
			});	 
			observable.bind("change", function(e){						
				if( e.field == "permissionToType" ){
					if( this.get(e.field) == 'anonymous'){
						observable.set('permissionToDisabled', true);
						observable.set('enabledSelectRole', false);
						observable.accessControlEntry.set('grantedAuthority', "USER");
						observable.accessControlEntry.set('grantedAuthorityOwner', "ANONYMOUS");
					}else if (this.get(e.field) == 'role'){
						observable.set('permissionToDisabled', false);
						observable.set('enabledSelectRole', true);						
						observable.accessControlEntry.set('grantedAuthority', "ROLE");
						observable.accessControlEntry.set('grantedAuthorityOwner', "");
					}else{
						observable.set('enabledSelectRole', false);
					 	observable.set('permissionToDisabled', false);	
					 	observable.accessControlEntry.set('grantedAuthority', "USER");
						observable.accessControlEntry.set('grantedAuthorityOwner', "");
					}					
				}
        		}); 					
		}
		if ( renderTo.data("object-id") != observable.page.get('pageId') ) {
			renderTo.data("object-id", observable.page.get('pageId') );
			community.ui.listview(renderTo).setDataSource(
				community.ui.datasource( '<@spring.url "/data/api/mgmt/v1/security/permissions/14/"/>'+ observable.page.get('pageId') +'/list.json' , {
					schema: {
						total: "totalCount",
						data: "items",
						model: community.model.ObjectAccessControlEntry
					}
				})			
			)
		}	
	}
	
	function createPropertiesListView ( parentRendorTo, renderTo, page ){ 
		if( !community.ui.exists(renderTo) ){		
			console.log("create properties listview.");
			var listview = community.ui.listview( renderTo, {
				template: community.ui.template($("#property-template").html()),
				editTemplate: community.ui.template($("#property-edit-template").html())
			});		
				
			parentRendorTo.on("click", "button[data-action=create], a[data-action=create]", function(e){			
				listview.add();
                e.preventDefault();
			});
			
		}
		if ( renderTo.data("object-id") != page.get('pageId') ) {
			renderTo.data("object-id", page.get('pageId') );
			community.ui.listview(renderTo).setDataSource(createPropertiesDataSource(page))
		}
	}
	
	function openPageEditor( data ){
		var renderTo = $("#pages-editor-modal");
		var renderTo2 = $('#pages-editor-perms-listview');
		if( !renderTo.data("model") ){		
			var htmlEditorRenderTo = $("#htmleditor");
			var pageEditor = renderTo.find('.page-editor');
			var pageOptions = renderTo.find('.page-options');
			
			var pageOptionsProps = $('#pages-editor-props-listview');			
			if( htmlEditorRenderTo.contents().length == 0 ){ 
				var editor = ace.edit(htmlEditorRenderTo.attr("id"));		
				editor.getSession().setMode("ace/mode/ftl");
				editor.getSession().setUseWrapMode(true);
			}			
			
			var switcher = renderTo.parent().find("input[name='warp-switcher']");
			if( switcher.length > 0 ){
				$(switcher).switcher();
				$(switcher).change(function(){
					editor.getSession().setUseWrapMode($(this).is(":checked"));
				});		
			}
			
			renderTo.find('a[data-toggle="tab"]').on( 'show.bs.tab', function (e) {		
				var show_bs_tab = $(e.target);
				switch( show_bs_tab.data("kind") ){
					case "permissions" :							
						createPermissionsListView($(show_bs_tab.attr("href")), renderTo2, observable);
						break;
					case "properties" :
						console.log( show_bs_tab.attr("href") );
						createPropertiesListView($(show_bs_tab.attr("href")), pageOptionsProps, observable.page);
						break;	
				}	
			});																							
			
			var observable = new community.ui.observable({ 	
				page : new community.model.Page(),		
				permissionToType : "",  
				permissionToDisabled	: true,					
				enabledSelectRole : false,
				accessControlEntry: new community.model.ObjectAccessControlEntry(),
				editable : false,
				path : "",
				showOptions : function(e){
					pageEditor.hide();
					renderTo.find(".nav-tabs a:first").tab('show');	
					pageOptions.show();
				},
				hideOptions : function(e){
					pageOptions.hide();
					pageEditor.show();
				},
				getPageContents : function(e){
					var $this = this;
					ace.edit(htmlEditorRenderTo.attr("id")).setValue( $this.page.bodyContent.bodyText || "");
				},
				getTemplateContents : function(e){
					var $this = this;
					if($this.page.template != null && $this.page.template.length > 1 ){
						community.ui.progress(renderTo.find('.modal-content'), true);	
						community.ui.ajax( "<@spring.url "/data/api/mgmt/v1/pages/get_template_content.json" />" , 
						{
							data : { path: $this.page.template , pageId : $this.page.pageId },
							success : function(response){
								data.set("fileContent", response.fileContent )
								ace.edit(htmlEditorRenderTo.attr("id")).setValue( data.get("fileContent") );
							}
						}).always( function () {
							community.ui.progress(renderTo.find('.modal-content'), false);
						});
					}
				},
				resetAccessControlEntry : function(e){
					var $this = this;
					$this.set('permissionToType', 'user');
					$this.set('permissionToDisabled' , false);
					$this.set('enabledSelectRole', false);
					$this.accessControlEntry.set('id' , 0);	
					$this.accessControlEntry.set('grantedAuthority' , "USER");					
					$this.accessControlEntry.set('grantedAuthorityOwner' , "");			
					$this.accessControlEntry.set('permission' , "");		
					$this.accessControlEntry.set('domainObjectId' , $this.page.pageId);					
				},
				addPermission : function (e){
					var $this = this;
					if( $this.accessControlEntry.get('grantedAuthorityOwner').length > 0  && $this.accessControlEntry.get('permission').length > 0 ){
						community.ui.progress(renderTo, true);	
						community.ui.ajax( '<@spring.url "/data/api/mgmt/v1/security/permissions/14/" />' + $this.page.get('pageId') +'/add.json' , {
							data: community.ui.stringify($this.accessControlEntry),
							contentType : "application/json",
							success : function(response){
								community.ui.listview( renderTo2 ).dataSource.read();
							}
						}).always( function () {
							community.ui.progress(renderTo, false);
						});							
						$this.resetAccessControlEntry();
					}
					return false;
				},
				removePermission : function (data) {
					var $this = this;
					community.ui.progress(renderTo, true);	
					community.ui.ajax( '<@spring.url "/data/api/mgmt/v1/security/permissions/14/" />' + $this.page.get('pageId') +'/remove.json', {
						data:community.ui.stringify(data),
						contentType : "application/json",
						success : function(response){
							community.ui.listview( renderTo2 ).dataSource.read();
						}
					}).always( function () {
						community.ui.progress(renderTo, false);
					});	
					return false;	
				},
				saveOrUpdate : function(e){ 
					var $this = this;
					community.ui.progress(renderTo.find('.modal-content'), true);	
					community.ui.ajax( '<@spring.url "/data/api/mgmt/v1/pages/save-or-update.json" />', {
						data: community.ui.stringify($this.page),
						contentType : "application/json",
						success : function(response){
							community.ui.listview( $('#pages-listview') ).dataSource.read();
						}
					}).always( function () {
						community.ui.progress(renderTo.find('.modal-content'), false);
						renderTo.modal('hide');
					});							
				},
				rolesDataSource: community.ui.datasource( '<@spring.url "/data/api/mgmt/v1/security/roles/list.json" />' , {
					schema: {
						total: "totalCount",
						data: "items"
					}
				}),
				permsDataSource: community.ui.datasource( '<@spring.url "/data/api/mgmt/v1/security/permissions/list.json" />' , {
					schema: {
						total: "totalCount",
						data: "items"
					}
				}),
				setSource: function( source ){				
					var $this = this;
					source.copy( $this.page );							
					if(  $this.page.pageId > 0 ){
						$this.set('editable', true );
					}else{
						$this.set('editable', false );
					}
					
					if( !pageEditor.is("visible" ) ){
						pageEditor.show();
						pageOptions.hide();
					}	
					ace.edit(htmlEditorRenderTo.attr("id")).setValue( $this.page.bodyContent.bodyText || "");
				}
			}); 			
			renderTo.data("model", observable );
			community.ui.bind(renderTo, observable );
		}
		renderTo.data("model").setSource( data );			 	
		renderTo.modal('show');
	}
					
	</script>
	<style>
	#htmleditor {
		min-height:577px;
	}
	</style>
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
						<span class="g-valign-middle">페이지</span>
					</li>
				</ul>
			</div>
			<!-- End Breadcrumb-v1 -->
			<div class="g-pa-20">
				<h1 class="g-font-weight-300 g-font-size-28 g-color-black g-mb-30">페이지 관리</h1>
				<!-- Content Body -->
				<div id="features" class="container-fluid">
					<div class="row text-center text-uppercase g-bord-radias g-brd-gray-dark-v7 g-brd-top-0 g-brd-left-0 g-brd-right-0 g-brd-style-solid g-brd-3">
						<div class="col-6 text-left">
						<p class="text-danger g-font-weight-100">웹 페이지를 관리합니다.</p>
						</div>
						<div class="col-6 text-right">
						<a href="javascript:void();" class="btn btn-xl u-btn-primary g-width-180--md g-mb-10 g-font-size-default g-ml-10" data-action="create" data-object-type="page"  data-object-id="0" >새로운 페이지 만들기</a>
						</div>
					</div>				
					<div class="row">
	                		<div class="table-responsive">
							<table class="table table-bordered js-editable-table u-table--v1 u-editable-table--v1 g-color-black g-mb-0">
								<thead class="g-hidden-sm-down g-color-gray-dark-v6">
									<tr class="g-height-50">
			                             <th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black">파일</th>
			                             <th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black text-center" width="100">상태</th> 
			                             <th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black text-center" width="150">작성자</th> 
			                             <th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black text-center" width="150">뎃글</th> 
			                             <th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black text-center" width="150">페이지 뷰</th>   	
			                             <th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black text-center" width="150">마지막 수정일</th>   										
									</tr>
								</thead>    
								<tbody id="pages-listview" class=" u-listview"></tbody>
							</table>
						</div>
						<div id="pages-listview-pager" class="g-brd-top-none" style="width:100%;"></div>
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
	<!-- editor modal -->
	<div class="modal fade" id="pages-editor-modal" tabindex="-1" role="dialog" aria-labelledby="pages-editor-modal-labal" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="page-editor">		
		      	<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
			          	<!--<span aria-hidden="true">&times;</span>-->
			        </button>
		      	</div><!-- /.modal-header -->
		      	<div class="modal-body">
		      		
						<div class="form-group g-mb-10">
			                	<div class="g-pos-rel">
			                		<span class="g-pos-abs g-top-0 g-right-0 d-block g-width-40 h-100 opacity-0 g-opacity-1--success">
				                		<i class="community-admin-check g-absolute-centered g-font-size-default g-color-lightblue-v3"></i>
				                	</span>
		                      	<input class="form-control g-brd-gray-light-v7 g-brd-gray-light-v3--focus g-rounded-4" type="text" placeholder="파일명을 입력하세요" data-bind="value: page.name">
		                      	<small class="g-font-weight-300 g-font-size-12 g-color-gray-dark-v6 g-pt-5">외부에서 페이지를 호출할때 사용되는 이름입니다.</small>
		                    </div>
	                  	</div>
						<div class="form-group g-mb-10">
			                	<div class="g-pos-rel">
			                		<span class="g-pos-abs g-top-0 g-right-0 d-block g-width-40 h-100 opacity-0 g-opacity-1--success">
				                		<i class="community-admin-check g-absolute-centered g-font-size-default g-color-lightblue-v3"></i>
				                	</span>
		                      	<input class="form-control g-brd-gray-light-v7 g-brd-gray-light-v3--focus g-rounded-4" type="text" placeholder="페이지 타이틀을 입력하세요." data-bind="value: page.title">
		                      	<small class="g-font-weight-300 g-font-size-12 g-color-gray-dark-v6 g-pt-5">페이지를 제목으로 사용되는 이름입니다.</small>
		                    </div>
	                  	</div>                  	
						<div class="form-group g-mb-10">
			                	<div class="g-pos-rel">
			                		<span class="g-pos-abs g-top-0 g-right-0 d-block g-width-40 h-100 opacity-0 g-opacity-1--success">
				                		<i class="community-admin-check g-absolute-centered g-font-size-default g-color-lightblue-v3"></i>
				                	</span>
		                      	<textarea class="form-control form-control-md g-resize-none g-brd-gray-light-v7 g-brd-gray-light-v3--focus g-rounded-4" rows="3" placeholder="간략하게 페이지에 대한 설명을 입력하세요."data-bind="value: board.summary"></textarea>
		                    </div>
						</div>
					
					<div class="g-brd-around g-brd-gray-light-v7 g-rounded-4 g-pa-15 g-pa-20--md g-mb-15">
					<div class="row" >
		            		<div class="col-md-4">
		            			<label class="g-mb-10">버전</label>		
		            			<div class="form-group">  
					            <input data-role="numerictextbox" placeholder="버전" data-min="0" data-max="100" data-bind="value: page.versionId" style="width: 180px">
					        </div>
		            		</div>
		            		<div class="col-md-4">
		            			<label class="g-mb-10">상태</label>	
		            			<select class="form-control g-brd-gray-light-v7 g-pos-rel" data-bind="value: page.pageState" style="width: 180px">
							  <option value="INCOMPLETE">INCOMPLETE</option>
							  <option value="APPROVAL">APPROVAL</option>
							  <option value="PUBLISHED">PUBLISHED</option>
							  <option value="REJECTED">REJECTED</option>
							  <option value="ARCHIVED">ARCHIVED</option>
							  <option value="DELETED">DELETED</option>
							  <option value="NONE">NONE</option>
							</select>
		            		</div>
		            		<div class="col-md-4" data-bind="visible:editable" style="display:none;">
		            			<header class="media g-mb-20">
			                		<h3 class="d-flex align-self-center text-uppercase g-font-size-12 g-font-size-default--md g-color-black mb-0">고급설정</h3>
								<div class="media-body d-flex justify-content-end">
			                    		<a class="community-admin-panel u-link-v5 g-font-size-20 g-color-gray-light-v3 g-color-secondary--hover" href="#!" data-bind="click: showOptions"></a>
			                    	</div>
			                	</header>
		            			<div class="form-group g-mb-10 g-mb-0--md">
		            			<small class="g-font-weight-300 g-font-size-12 g-color-gray-dark-v6 g-pt-5">고급설정에서 권한설정이 필요한 옵션입니다.</small>
	                         <label class="u-check g-pl-25">
	                        		<input class="g-hidden-xs-up g-pos-abs g-top-0 g-left-0" type="checkbox" data-bind="checked: page.secured">
	                          	<div class="u-check-icon-checkbox-v4 g-absolute-centered--y g-left-0">
	                            		<i class="fa" data-check-icon=""></i>
	                          	</div>
	                          	접근제어 활성화
	                       	</label>
	                      	</div>
		            		</div>
		            	</div>		
		            	</div>		
		            	<form>
			        	  <div class="row">
					  	<div class="col-sm-10">
					  	<h6 class="text-light-gray text-semibold">템플릿 설정</h6>
					  		<div class="form-inline">
					  		 	
								<div class="form-group g-pb-10">
									<input type="text" class="form-control g-width-300" placeholder="템플릿 파일 위치" data-bind="value: page.template" >			
									<div class="btn-group">
									<button type="button" class="btn btn-sm u-btn-outline-bluegray g-ml-10" data-bind="click:getTemplateContents">템플릿 보기</button>	
									<button type="button" class="btn btn-sm u-btn-outline-bluegray" data-bind="click:getPageContents">콘텐츠 보기</button>	
									</div>													
								</div>	
				  		
					  		</div>	
					  	</div>
					  	<div class="col-sm-2">
							<h6 class="g-font-weight-200 g-font-size-12 g-color-black">에디터 줄바꿈 설정/해지</h6>
							<input type="checkbox" name="warp-switcher" data-class="switcher-primary" role="switcher" checked="checked">											  	
					  	</div>					  						  					  	
					  </div>
					<div id="htmleditor"></div>	
					<div class="text-right g-pa-5 g-brd-top--sm g-brd-gray-light-v1-top">				  		          	          
						<button type="button" class="btn u-btn-outline-darkgray g-mr-10 g-mt-10" data-bind="click:saveOrUpdate">확인</button>					  				  		          	          					  				  		          	          
					</div>				  		          	          					  				  		          	          					  				  		          	          					  				  		          	          
			       </form>
		      	</div>
		      	<!-- /.modal-body -->
		      	</div>
		      	<div class="page-options" style="display:none;">
					<div class="modal-header">
						<h2 class="modal-title">고급 옵션</h2>
				        <button type="button" class="close u-close-v2" data-bind="click: hideOptions">
				          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close-pane m-t-xs"></i>
				        </button>
			      	</div><!-- /.modal-content -->
		    			<div class="modal-body">		    			
						<ul class="nav nav-tabs" id="pages-options-tab" role="tablist">
						  <li class="nav-item">
						    <a class="nav-link active" id="pages-options-tab-1" data-toggle="tab" href="#pages-options-content-1" role="tab" aria-controls="pages-options-content-1" data-kind="permissions" aria-selected="true">권한설정</a>
						  </li>
						  <li class="nav-item">
						    <a class="nav-link" id="pages-options-tab-2" data-toggle="tab" href="#pages-options-content-2" role="tab" aria-controls="pages-options-content-2" data-kind="properties" aria-selected="false">속성</a>
						  </li>
						</ul>
						<div class="tab-content" id="pages-options-content">
						  <div class="tab-pane fade show active g-pa-10" id="pages-options-content-1" role="tabpanel" aria-labelledby="pages-options-tab-1">
						  	<!-- tab 1 -->
						  	<div data-bind="invisible: page.secured">
                                          <p class="text-danger">접근제어 사용여부를 체크 한 후에 부여된 권한에 따라 동작하게 됩니다.<p>
                                          <input type="checkbox" name="secured-switcher" id="secured-switcher2" class="k-checkbox"  data-bind="checked: page.secured" >		
										<label class="k-checkbox-label g-font-weight-100 g-mt-10" for="secured-switcher2">접근제어 사용하기</label>	
                                          </div>
					 					<!-- permission listview -->						
										<div class="table-responsive">
											<table class="table w-100 g-mb-25">
												<thead class="g-hidden-sm-down g-color-gray-dark-v6">
													<tr>
													<th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black">유형</th>
													<th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black">대상</th>
													<th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black">권한</th>
													<th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black">&nbsp;</th>
													</tr>
												</thead>
												<tbody id="pages-editor-perms-listview" class="g-font-size-default g-color-black g-brd-0"></tbody>
											</table>
										</div>
										<!-- ./permission listview -->	                               
                                
		                                	<p>익명사용자, 특정회원 또는 롤에 게시판에 대한 권한을 부여할 수 있습니다. 먼저 권한를 부여할 대상을 선택하세요.</p>
		                                 <div class="form-group">
											<div class="col-sm-10">         
												<ul class="list-unstyled">
										          <li>
										              <input type="radio" name="permissionToType" id="permissionToType1" value="anonymous" class="k-radio" data-type="text" data-bind="checked: permissionToType" >
										              <label class="k-radio-label" for="permissionToType1">익명</label>
										          </li>
										          <li>
										              <input type="radio" name="permissionToType" id="permissionToType2" value="user" class="k-radio" data-type="text" data-bind="checked: permissionToType" >
										              <label class="k-radio-label" for="permissionToType2">회원</label>
										          </li>
										          <li>
										              <input type="radio" name="permissionToType" id="permissionToType3" value="role" class="k-radio" data-type="text" data-bind="checked: permissionToType" >
										              <label class="k-radio-label" for="permissionToType3">롤</label>
										          </li>								             
											</div>
		                                </div>
										<div class="form-group row">
											<div class="col-sm-6">
												<input data-role="dropdownlist"
												 data-option-label="롤을 선택하세요."
								                 data-auto-bind="false"
								                 data-text-field="name"
								                 data-value-field="name"
								                 data-bind="value: accessControlEntry.grantedAuthorityOwner, source: rolesDataSource, enabled: enabledSelectRole, visible:enabledSelectRole"
								                 style="width: 100%;" />
								               <input type="text" class="form-control" placeholder="권한을 부여할 사용자 아이디(username)을 입력하세요" data-bind="value: accessControlEntry.grantedAuthorityOwner , disabled: permissionToDisabled, invisible:enabledSelectRole">  
											</div>
											<div class="col-sm-6">
											</div>
										</div>
										<div class="form-group row">
											<div class="col-sm-6">
												<input data-role="dropdownlist"
												 data-option-label="권한을 선택하세요."
								                 data-auto-bind="false"
								                 data-text-field="name"
								                 data-value-field="name"
								                 data-bind="value: accessControlEntry.permission, source: permsDataSource"
								                 style="width: 100%;" />
											</div>
										</div>  
										<div class="form-group">            
											<a href="javascript:void();" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" data-bind="click:addPermission" >권한 추가</a>
										</div> 
						  <!-- /. tab 2 -->
						  </div>
						  <div class="tab-pane fade g-mt-15" id="pages-options-content-2" role="tabpanel" aria-labelledby="pages-options-tab-2">
						  <p>속성값을 수정할 수 있습니다.</p>
	                                     <button class="btn btn-sm u-btn-outline-bluegray g-mb-15"   data-action="create">속성 추가</button>
	                                    <!-- properties listview -->						
										<div class="table-responsive">
											<table class="table w-100 g-mb-25">
												<thead class="g-hidden-sm-down g-color-gray-dark-v6">
													<tr>
													<th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black">이름</th>
													<th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black">값</th>
													<th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black g-color-black g-width-120">&nbsp;</th>
													</tr>
												</thead>
												<tbody id="pages-editor-props-listview" data-object-id="0">
												</tbody>
											</table>
										</div>
										<!-- ./properties listview -->	 	
						  </div>
						</div> 						
		    			</div>		      	
		      	</div>		      	
		    </div>
		    <!-- /.modal-content -->
		</div>
	</div>		
	<script type="text/x-kendo-template" id="perms-template">    	
	<tr>
		<td class="align-middle text-nowrap">
			#: grantedAuthority #
		</td>
		<td class="align-middle">
			<div class="d-inline-block">
				<span class="d-flex align-items-center justify-content-center u-tags-v1 g-brd-around g-bg-gray-light-v8 g-brd-gray-light-v8 g-font-size-default g-color-gray-dark-v6 g-rounded-50 g-py-4 g-px-15">
					<span class="u-badge-v2--md g-pos-stc g-transform-origin--top-left g-bg-lightblue-v3 g-mr-8"></span>
					#: grantedAuthorityOwner #
				</span>
            </div>		
		</td>
		<td class="align-middle">
			#: permission #
		</td>
		<td class="align-middle text-nowrap text-center">
			<a class="g-color-gray-dark-v5 g-text-underline--none--hover g-pa-5" href="\\#!" data-toggle="tooltip" data-placement="top" data-original-title="Delete" data-subject="permission" data-action="delete" data-object-id="#= id #">
			<i class="icon-trash g-font-size-18 g-mr-7"></i>
			</a>
		</td>
	</tr>			                      
    </script>    	        
	<script type="text/x-kendo-template" id="property-template">   
	<tr>
		<td class="align-middle">#: name # </td>
		<td class="align-middle">#: value #</td>
		<td class="align-middle text-center">
			<div class="btn-group">
                <a class="btn btn-sm u-btn-outline-bluegray k-edit-button" href="\\#">수정</a>
                <a class="btn btn-sm u-btn-outline-bluegray k-delete-button" href="\\#">삭제</a>
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
                <a class="btn btn-sm u-btn-outline-bluegray k-update-button" href="\\#">확인</a>
                <a class="btn btn-sm u-btn-outline-bluegray k-cancel-button" href="\\#">취소</a>
            </div>
		</td>
	</td>
	</script>	
	<script type="text/x-kendo-template" id="template">    	
	<tr class="u-listview-item">
		<td class="u-text-left">		
		<h5 class="g-font-weight-100">
		#if (secured) { # <i class="icon-lock"></i>  # } else {# <i class="icon-lock-open"></i> #}#
		#= title # 	<span class="g-font-weight-300 g-color-gray-dark-v6 mb-0">#= name #</span>
		</h5> 
		<!--
		<div class="u-visible-on-select">
			<div class="btn-group">
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="edit" data-object-id="#= pageId#"  >수정</button>
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="preview" data-object-id="#= pageId#" >미리보기</button>
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="delete" data-object-id="#= pageId#" >삭제</button>
			</div>
	 	</div>
	 	-->
	 	
	 	<div class="u-visible-on-select g-pa-5">
			<div class="d-flex">
				<a class="u-link-v5 d-flex g-font-size-15 g-color-gray-light-v6 g-color-lightblue-v3--hover g-ml-10" href="\#!" data-action="edit" data-object-id="#= pageId#" >
					<i class="community-admin-pencil-alt g-font-size-16"></i>
					<span class="g-ml-8">수정</span>
				</a>
				<a class="u-link-v5 d-flex g-font-size-15 g-color-gray-light-v6 g-color-lightblue-v3--hover g-ml-30" href="\#!" data-action="preview" data-object-id="#= pageId#" >
                     <i class="community-admin-new-window g-font-size-16"></i>
					<span class="g-ml-15">미리보기</span>
				</a>	
				<a class="u-link-v5 d-flex g-font-size-15 g-color-gray-light-v6 g-color-lightblue-v3--hover g-ml-30" href="\#!" data-action="delete" data-object-id="#= pageId#" >
                     <i class="community-admin-trash g-font-size-16"></i>
					<span class="g-ml-15">삭제</span>
				</a>				
			</div>
		</div>	 	
		</td>
		<td class="text-center align-middle" >
			#: pageState #
		</td>
		<td class="text-right align-middle" >
			<div class="media">
            		<div class="d-flex align-self-center">
                    <img class="g-width-36 g-height-36 rounded-circle g-mr-15" src="#= community.data.getUserProfileImage(user) #" >
                </div>
				<div class="media-body align-self-center text-left">#: user.name #</div>
            </div>
		</td>
		<td class="text-center align-middle"> #: commentCount # </td>
		<td class="text-center align-middle"> #: viewCount # </td>
		<td class="text-center align-middle">
 		 #: community.data.getFormattedDate( modifiedDate)  # 
		</td>
	</tr>				                      
    </script>  	
</body>
</html>
</#compress>