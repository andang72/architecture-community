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
  	<link href="<@spring.url "/fonts/community-ui-admin-icons.css"/>" rel="stylesheet" type="text/css" />	    
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
	require([ "jquery", "bootstrap", "kendo.ui.core.min", "community.ui.core", "community.data", "jquery.metisMenu" , "jquery.slimscroll", "inspinia", "ace"], function($, kendo ) {
			
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
			renderTo.find(".nav-tabs").on( 'show.bs.tab', function (e) {		
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

<body class="skin-1">

    <div id="wrapper">
	    	<!--  SIDEBAR  -->
		<#include "includes/inspinia-admin-sidebar.ftl">
	 	<!--  ./SIDEBAR  -->
        <div id="page-wrapper" class="gray-bg">
        <div class="row border-bottom">
	    	<!--  TOP NAVBAR  -->
		<#include "includes/inspinia-admin-top-navbar.ftl">
	 	<!--  ./TOP NAVBAR  -->
        </div>
            <div class="row wrapper border-bottom white-bg page-heading">
                <div class="col-sm-4">
                    <h2>페이지 관리</h2>
                    <ol class="breadcrumb">
                        <li>
                            자원
                        </li>
                        <li class="active">
                            <strong>페이지 관리</strong>
                        </li>
                    </ol>
                </div>
                <div class="col-sm-8">
                    <div class="title-action"> 
                        <a href="javascript:void();" class="btn btn-primary" data-action="create" data-object-type="page"  data-object-id="0" >새로운 페이지 만들기</a>
                    </div>
                </div>
            </div>

            <div class="wrapper wrapper-content">
                <div class="">                 
							<div class="ibox float-e-margins">
                        			 <div class="ibox-content no-padding g-font-size-20"">	 
                        			 	<table class="table no-margins">
			                            <thead>
			                            <tr class="g-height-50">
			                                <th class="text-left align-middle">파일</th>
			                                <th class="align-middle" width="100">상태</th>
			                                <th class="align-middle" width="100">작성자</th>
			                                <th class="align-middle text-center" width="100">뎃글</th>
			                                <th class="align-middle text-center" width="100">페이지 뷰</th>
			                                <th class="align-middle text-center" width="150">마지막 수정일</th>
			                            </tr>
			                            </thead>
			                            <tbody id="pages-listview" class="no-border u-listview" >	
			                            </tbody>                            
			                        </table>          
                        			 </div>
                        			 <div class="ibox-footer no-padding g-brd-top-none">  
	                            		<div id="pages-listview-pager"></div>
	                             </div>  
                        		</div>
                        		                    
                </div>
            </div>
            <div class="footer">
                <!--<div class="pull-right">
                    10GB of <strong>250GB</strong> Free.
                </div>
                <div>
                    <strong>Copyright</strong> Example Company &copy; 2014-2017
                </div>-->
            </div> 
        </div>
    </div>
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
		      	   <form>
			        	  <div class="form-group">
			            <input type="text" class="form-control" placeholder="파일명을 입력하세요." data-bind="value: page.name">
			          </div> 			        	  
			        	  <div class="form-group">
			            <input type="text" class="form-control" placeholder="페이지 타이틀을 입력하세요." data-bind="value: page.title">
			          </div> 		
					  <div class="form-group">					    
					    <textarea class="form-control" rows="2" placeholder="간략하게 페이지에 대한 설명을 입력하세요." data-bind="value: page.summary"></textarea>
					  </div>	
					  <div class="row">
					  	<div class="col-sm-4">
					  		<h6 class="text-light-gray text-semibold">버전관리</h6>
					  		<div class="form-group">  
					            <input data-role="numerictextbox" placeholder="버전" data-min="0" data-max="100" data-bind="value: page.versionId" style="width: 180px">
					        </div> 
					  	</div>
					  	<div class="col-sm-4">
					  		<h6 class="text-light-gray text-semibold">상태</h6>
					  		<select class="form-control" data-bind="value: page.pageState" style="width: 180px">
							  <option value="INCOMPLETE">INCOMPLETE</option>
							  <option value="APPROVAL">APPROVAL</option>
							  <option value="PUBLISHED">PUBLISHED</option>
							  <option value="REJECTED">REJECTED</option>
							  <option value="ARCHIVED">ARCHIVED</option>
							  <option value="DELETED">DELETED</option>
							  <option value="NONE">NONE</option>
							</select>
					  	</div>
					  	<div class="col-sm-2">
					  		<h6 class="text-light-gray text-semibold">접근제어</h6>
							<input type="checkbox" name="secured-switcher" id="secured-switcher" class="k-checkbox"  data-bind="checked: page.secured" >		
							<label class="k-checkbox-label g-font-weight-100 g-mt-10" for="secured-switcher">사용</label>	  	
					  	</div>		
					  	<div class="col-sm-2">
					  		<h6 class="text-light-gray text-semibold">권한 및 속성 변경</h6>
							<button type="button" class="btn btn-sm u-btn-outline-bluegray g-ml-10" data-bind="click: showOptions">고급설정</button>					  	
					  	</div>					  				  	
					  </div>	
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
							<h6 class="text-light-gray text-semibold">에디터 줄바꿈 설정/해지</h6>
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
						<div class="tabs-container">
	                        <ul class="nav nav-tabs">
	                            <li><a data-toggle="tab" href="#page-options-tab-1" aria-expanded="true" data-kind="permissions" >권한설정</a></li>
	                            <li><a data-toggle="tab" href="#page-options-tab-2" aria-expanded="false" data-kind="properties">속성</a></li>
	                        </ul>
	                        <div class="tab-content">
	                            <div id="page-options-tab-1" class="tab-pane active">
	                                <div class="panel-body">
                                          <div data-bind="invisible: page.secured">
                                          <p class="text-danger">접근제어 사용여부를 체크 한 후에 부여된 권한에 따라 동작하게 됩니다.<p>
                                          <input type="checkbox" name="secured-switcher" id="secured-switcher2" class="k-checkbox"  data-bind="checked: page.secured" >		
										<label class="k-checkbox-label g-font-weight-100 g-mt-10" for="secured-switcher2">접근제어 사용하기</label>	
                                          </div>
					 					<!-- permission listview -->						
										<div class="table-responsive">
											<table class="table table-bordered u-table--v2">
												<thead class="text-uppercase g-letter-spacing-1">
													<tr>
													<th class="g-font-weight-300 g-color-black">유형</th>
													<th class="g-font-weight-300 g-color-black">대상</th>
													<th class="g-font-weight-300 g-color-black">권한</th>
													<th class="g-font-weight-300 g-color-black">&nbsp;</th>
													</tr>
												</thead>
												<tbody id="pages-editor-perms-listview" > 
												</tbody>
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
                            			</div>
                         		</div>
                         		<div id="page-options-tab-2" class="tab-pane">
	                                <div class="panel-body">
	                                    <p>속성값을 수정할 수 있습니다.</p>
	                                     <button class="btn u-btn-outline-bluegray g-mb-15" data-action="create">속성 추가</button>
	                                    <!-- properties listview -->						
										<div class="table-responsive">
											<table class="table table-bordered u-table--v2" >
												<thead class="">
													<tr>
													<th class="g-font-weight-300 g-color-black">이름</th>
													<th class="g-font-weight-300 g-color-black g-width-50x">값</th>
													<th class="g-font-weight-300 g-color-black g-width-120">&nbsp;</th>
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
		      	</div>		      	
		    </div>
		    <!-- /.modal-content -->
		</div>
	</div>	   
	<script type="text/x-kendo-template" id="perms-template">    	
	<tr>
		<td class="align-middle text-nowrap">
			#: grantedAuthority #
					<!--
					<div class="media">
					<img class="d-flex g-width-40 g-height-40 rounded-circle g-mr-10" src="../../assets/img-temp/100x100/img16.jpg" alt="Image Description">
					<div class="media-body align-self-center">
					<h5 class="h6 align-self-center g-font-weight-600 g-color-darkpurple mb-0">Amanda Low</h5>
					<span class="g-font-size-12">UI Design</span>
					</div>
					</div>-->
		</td>
		<td class="align-middle">#: grantedAuthorityOwner #</td>
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
		<h3 class="g-font-weight-100">
		#if (secured) { # <i class="icon-lock"></i>  # } else {# <i class="icon-lock-open"></i> #}#
		<u>#= name #</u> #= title # 	
		</h3>
		<div class="u-visible-on-select">
			<div class="btn-group">
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="edit" data-object-id="#= pageId#"  >수정</button>
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="preview" data-object-id="#= pageId#" >미리보기</button>
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="delete" data-object-id="#= pageId#" >삭제</button>
			</div>
	 	</div>
		</td>
		<td class="text-center">
			#: pageState #
		</td>
		<td>
			<a class="u-avatar u-avatar-sm btn-link" href="\\#">
			<img width="64" height="64" src="#= community.data.getUserProfileImage(user) #" class="u-avatar-img" alt="image">
			#: user.name # (#:user.username #)
			</a>
		</td>
		<td class="text-center"> #: commentCount # </td>
		<td class="text-center"> #: viewCount # </td>
		<td class="text-center">
 		 #: community.data.getFormattedDate( modifiedDate)  # 
		</td>
	</tr>				                      
    </script>          
</body>
</html>
</#compress>