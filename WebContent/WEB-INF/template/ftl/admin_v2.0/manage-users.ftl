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
    <link href="<@spring.url "/fonts/community-ui-admin-icons.css"/>" rel="stylesheet" type="text/css" />	
    
    <!-- Community CSS -->
    <link href="<@spring.url "/css/community.ui/community.ui.admin.css"/>" rel="stylesheet" type="text/css" />	
  	     
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
			"popper" 	   				: "/js/bootstrap/4.0.0/bootstrap.bundle",
			"bootstrap" 					: "/js/bootstrap/4.0.0/bootstrap.min",
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"community.ui.admin" 		: "/js/community.ui.components/community.ui.admin",
			"community.ui.core" 			: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data"
		}
	});
	require([ "jquery", "jquery.cookie", "popper", "kendo.ui.core.min", "community.ui.core", "community.data", "community.ui.admin"], function($, kendo ) { 
	
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
		
		createUserListView();
		
		renderTo.on("click", "button[data-object-type=user], a[data-object-type=user]", function(e){			
			var $this = $(this);
			var actionType = $this.data("action");		
			var objectId = $this.data("object-id");		
			var targetObject = new community.model.User();
			if ( objectId > 0 ) {
				targetObject = community.ui.listview( $('#users-listview') ).dataSource.get( objectId );				
			}				
 			openUserEditor(targetObject);			
			return false;		
		});	 	
	 	
	});
	
	function createUserListView(){
		console.log("create user listview.");
		var renderTo = $('#users-listview');	
		var listview = community.ui.listview( renderTo , {
			dataSource: community.ui.datasource('<@spring.url "/data/api/mgmt/v1/security/users/list.json"/>', {
				transport: { 
					read:{
						contentType: "application/json; charset=utf-8"
					},
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
	
	function openUserEditor( data ){
	
		var renderTo = $('#user-editor-modal');
		var renderTo2 = $('#user-editor-perms-listview');
		if( !renderTo.data("model") ){
			var userEditor = renderTo.find('.user-editor');
			var userOptions = renderTo.find('.user-options');
			var observable = new community.ui.observable({ 
				isNew : false,			
				editable : false,	
				user : new community.model.User(),
				showOptions : function(e){
					userEditor.hide();
					$("#user-options-tab-1").tab('show');	
					userOptions.show();
				},
				hideOptions : function(e){
					userOptions.hide();
					userEditor.show();
				},
				setSource : function (data){
					console.log("set source for editor :");
					var $this = this;
					var oldUserId = $this.user.userId ;
					data.set('password', '');
					data.copy( $this.user ); 
					if(  $this.user.userId > 0 ){
						$this.set('isNew', false );
						$this.set('editable' , true);
						$this.rolesDataSource.fetch(function (e){
							$this.setUserRoles();
						});						
					}else{
						$this.set('isNew', true ); 
						$this.set('editable' , false);
					}					
					if( !userEditor.is("visible" ) ){
						userEditor.show();
						userOptions.hide();
					}												
				},
				setUserRoles : function (e){
					console.log("set user roles.");
					var $this = this;					
					community.ui.ajax( '<@spring.url "/data/api/mgmt/v1/security/users/" />' + $this.user.userId + '/roles/list.json', {
						//data: community.ui.stringify($this.user),
						contentType : "application/json",
						success : function(response){
							var roles = $this.rolesDataSource.view();							
							$this.selectedUserRoleDataSource.data( response.items );
							$this.availableUserRoleDataSource.data(roles);
							$.each( response.items , function (index, value) {
								var data = $this.availableUserRoleDataSource.get( value.roleId );
								$this.availableUserRoleDataSource.remove( data);
							} );
						}
					}).always( function () { });		
				},
				updateUserRoles:function(e){
					var $this = this;
					community.ui.progress(renderTo.find('.modal-content'), true);	
					community.ui.ajax( '<@spring.url "/data/api/mgmt/v1/security/users/" />' + $this.user.userId + '/roles/save-or-update.json' , {
						data: community.ui.stringify($this.selectedUserRoleDataSource.data()),
						contentType : "application/json",
						success : function(response){
							$this.setUserRoles();
						}
					}).always( function () {
						community.ui.progress(renderTo.find('.modal-content'), false);
					});

				},
				saveOrUpdate : function(e){				
					var $this = this;
					community.ui.progress(renderTo.find('.modal-content'), true);	
					community.ui.ajax( '<@spring.url "/data/api/mgmt/v1/security/users/save-or-update.json" />', {
						data: community.ui.stringify($this.user),
						contentType : "application/json",
						success : function(response){
							community.ui.listview( $('#users-listview') ).dataSource.read();
						}
					}).always( function () {
						community.ui.progress(renderTo.find('.modal-content'), false);
						renderTo.modal('hide');
					});						
				},
				availableUserRoleDataSource : community.ui.datasource_v2({ data: [], schema:{ model:community.model.Role}}),
				selectedUserRoleDataSource : community.ui.datasource_v2({ data: [], schema:{ model:community.model.Role} }),
				rolesDataSource: community.ui.datasource( '<@spring.url "/data/api/mgmt/v1/security/roles/list.json" />' , {
					schema: {
						total: "totalCount",
						data: "items",
						model: community.model.Role
					}
				})
			});
			
			/*
 			renderTo.on("click", "button[data-subject=permission][data-action=delete], a[data-subject=permission][data-action=delete]", function(e){			
				var $this = $(this);
				var permissionId = $this.data("object-id");
				var data = community.ui.listview( renderTo2 ).dataSource.get(permissionId);	
				observable.removePermission(data);
				return false;		
			});	
			*/
			renderTo.data("model", observable );	
			community.ui.bind( renderTo, observable );				
			renderTo.on('show.bs.modal', function (e) {	});
		}
		renderTo.data("model").setSource(data);
		renderTo.modal('show');	
	
	}
	</script>
	<style>
    #user-options-content-2 .k-listbox {
        width: 236px;
        height: 310px;
    }

    #user-options-content-2 .k-listbox:first-of-type {
            width: 270px;
            margin-right: 1px;
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
						<a class="u-link-v5 g-color-gray-dark-v6 g-color-lightblue-v3--hover g-valign-middle" href="#!">보안</a> <i class="community-admin-angle-right g-font-size-12 g-color-gray-light-v6 g-valign-middle g-ml-10"></i>
					</li>
					<li class="list-inline-item">
						<span class="g-valign-middle">사용자</span>
					</li>
				</ul>
			</div>
			<!-- End Breadcrumb-v1 -->
			<div class="g-pa-20">
				<h1 class="g-font-weight-300 g-font-size-28 g-color-black g-mb-30">사용자 관리</h1>
				<!-- Content Body -->
				<div id="features" class="container-fluid">
					<div class="row text-center text-uppercase g-bord-radias g-brd-gray-dark-v7 g-brd-top-0 g-brd-left-0 g-brd-right-0 g-brd-style-solid g-brd-3">
						<div class="col-6 text-left">
						<p class="text-danger g-font-weight-100">게시판 정보입니다.</p>
						</div>
						<div class="col-6 text-right">
						<a href="javascript:void();" class="btn btn-xl u-btn-primary g-width-180--md g-mb-10 g-font-size-default g-ml-10" data-action="create" data-object-type="user"  data-object-id="0" >새로운 사용자 생성하기</a>
						</div>
					</div>
					<div class="row">
	                		<div class="table-responsive">
							<table class="table table-bordered js-editable-table u-table--v1 u-editable-table--v1 g-color-black g-mb-0">
								<thead class="g-hidden-sm-down g-color-gray-dark-v6">
									<tr class="g-height-50">
			                             <th class="g-valign-middle g-font-weight-300 g-width-50 g-bg-gray-light-v8 g-color-black" >#</th>
			                             <th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black">이름(ID)</th>
			                             <th class="g-valign-middle g-font-weight-300 g-width-200 g-bg-gray-light-v8 g-color-black">메일</th>
			                             <th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black text-center" width="100">상태</th>
			                             <th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black text-center" width="100">생성일</th>
			                             <th class="g-valign-middle g-font-weight-300 g-bg-gray-light-v8 g-color-black text-center" width="100">수정일</th>  										
									</tr>
								</thead>
								<tbody id="users-listview" class="u-listview"></tbody>
							</table>
						</div>
						<div id="users-listview-pager" class="g-brd-top-none" style="width:100%;"></div>
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
	<!-- user editor modal -->
	<div class="modal fade" id="user-editor-modal" tabindex="-1" role="dialog" aria-labelledby="user-editor-modal-labal" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="user-editor">	
				<!-- .modal-header -->
				<div class="modal-header">
					<h2 class="modal-title"><span data-bind="text:user.name"></span></h2>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
			          	<!--<span aria-hidden="true">&times;</span>-->
			        </button>
			       
		      	</div>
			    <!-- /.modal-header -->
			    <!-- .modal-body -->
		      	<div class="modal-body">
			        <form>
			        	 <h5 class="text-info"></h5>
			        	  <div class="form-group">
			        	  	<h6 class="text-light-gray g-font-weight-200  text-semibold">이름</h6>
			            <input type="text" class="form-control" placeholder="이름을 입력하세요" data-bind="value: user.name">			           
			          </div> 	
					 <div class="form-group">
					 	<h6 class="text-light-gray g-font-weight-200 text-semibold">메일</h6>
			            <input type="email" class="form-control" placeholder="메일를 입력하세요" data-bind="value: user.email">
			          </div>		
			           <div class="form-group">
			           	<h6 class="text-light-gray g-font-weight-200 text-semibold">아이디</h6>
			             <input type="text" class="form-control" placeholder="아이디를 입력하세요" data-bind="value: user.username">
			             <span class="g-font-weight-300 g-font-size-12 g-color-gray-dark-v6 g-pt-5" data-bind="visible:isNew">아이디를 입력하지 않는 경우 메일 주소를 아이디로 사용합니다.</span>
			          </div>		
			          <div class="form-group" data-bind="visible:isNew">
			           	<h6 class="text-light-gray text-semibold">비밀번호</h6>
			            <input type="password" class="form-control" placeholder="비밀번호를 입력하세요" data-bind="value: user.password">
			             <span class="g-font-weight-300 g-font-size-12 g-color-gray-dark-v6 g-pt-5" data-bind="visible:isNew">비밀번호를 입력하세요.</span>
			          </div>	
			          
					<div class="g-brd-around g-brd-gray-light-v7 g-rounded-4 g-pa-15 g-pa-20--md g-mb-15">
						<div class="row">
							<div class="col-md-4"> 
								<h3 class="d-flex align-self-center text-uppercase g-font-size-12 g-font-size-default--md g-color-black mb-0">정보 공개</h3>						
								<div class="form-group g-mb-10 g-mb-0--md">
								<small class="g-font-weight-300 g-font-size-12 g-color-gray-dark-v6 g-pt-5">체크하면 해당 정보를 누구나 볼수 있게 됩니다.</small>
								<label class="u-check g-pl-25">
									<input class="g-hidden-xs-up g-pos-abs g-top-0 g-left-0" type="checkbox" data-bind="checked:user.nameVisible">
									<div class="u-check-icon-checkbox-v4 g-absolute-centered--y g-left-0">
										<i class="fa" data-check-icon=""></i>
									</div>이름
								</label>
								</div>
								<div class="form-group g-mb-10 g-mb-0--md">							
									<label class="u-check g-pl-25">
										<input class="g-hidden-xs-up g-pos-abs g-top-0 g-left-0" type="checkbox" data-bind="checked:user.emailVisible">
											<div class="u-check-icon-checkbox-v4 g-absolute-centered--y g-left-0">
												<i class="fa" data-check-icon=""></i>
											</div>메일주소
									</label>
								</div>
							</div>
							<div class="col-md-4">
								<h3 class="d-flex align-self-center text-uppercase g-font-size-12 g-font-size-default--md g-color-black mb-0">상태</h3>		
								<select class="form-control" data-bind="value: user.status" style="width: 180px">
								  <option value="NONE">NONE</option>
								  <option value="APPROVED">APPROVED</option>
								  <option value="REJECTED">REJECTED</option>
								  <option value="VALIDATED">VALIDATED</option>
								  <option value="REGISTERED">REGISTERED</option>
								</select>
							</div>
							<div class="col-md-4" data-bind="visible:editable" style="">
								<header class="media g-mb-20">
									<h3 class="d-flex align-self-center text-uppercase g-font-size-12 g-font-size-default--md g-color-black mb-0">고급설정</h3>
									<div class="media-body d-flex justify-content-end">
										<a class="community-admin-panel u-link-v5 g-font-size-20 g-color-gray-light-v3 g-color-secondary--hover" href="#!" data-bind="click: showOptions"></a>
									</div>
								</header>
								<div class="form-group g-mb-10 g-mb-0--md">
									<small class="g-font-weight-300 g-font-size-12 g-color-gray-dark-v6 g-pt-5"></small>
									
							</div>
						</div>
					</div>
			        </form>
		      	</div><!-- /.modal-body -->		
		      	<div class="modal-footer">
			        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
			        <button type="button" class="btn btn-primary" data-bind="{ click: saveOrUpdate }">확인</button>
		      	</div><!-- /.modal-footer --> 				      			      	
			    <!-- /.modal-content -->					
				</div>
				<div class="user-options" style="display:none;">
					<!-- .modal-header -->
					<div class="modal-header">
						<h2 class="modal-title">고급 옵션</h2>
				        <button type="button" class="close u-close-v2" data-bind="click: hideOptions">
				          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close-pane m-t-xs"></i>
				        </button>
			      	</div>
			      	<!-- /.modal-header -->
			      	<!-- .modal-body -->
			      	<div class="modal-body">
			      	
			      		<ul class="nav nav-tabs" id="user-options-tab" role="tablist">
						  <li class="nav-item">
						    <a class="nav-link active" id="user-options-tab-1" data-toggle="tab" href="#user-options-content-1" role="tab" aria-controls="user-options-content-1" data-kind="avatar" aria-selected="true">이미지</a>
						  </li>
						  <li class="nav-item">
						    <a class="nav-link" id="user-options-tab-2" data-toggle="tab" href="#user-options-content-2" role="tab" aria-controls="user-options-content-2" data-kind="roles" aria-selected="false">롤</a>
						  </li>
						  <li class="nav-item">
						    <a class="nav-link" id="user-options-tab-3" data-toggle="tab" href="#user-options-content-3" role="tab" aria-controls="user-options-content-3" data-kind="properties" aria-selected="false">속성</a>
						  </li>
						</ul>
						<div class="tab-content" id="user-options-content">
						
						  	<div class="tab-pane fade show active g-pa-10" id="user-options-content-1" role="tabpanel" aria-labelledby="user-options-tab-1">
						  		<p>프로필 이미지를 수정할 수 있습니다.</p>
			      			</div>
			      			<div class="tab-pane fade g-pa-10" id="user-options-content-2" role="tabpanel" aria-labelledby="user-options-tab-2">
			      			 	<p>부여된 롤을 추가하거나 삭제할 수 있습니다.</p>
			      			 			
			      			 			<div class="k-content wide">
								        		<p class="text-danger">저장 버튼을 클릭해야 부여된 롤이 변경 됩니다.</p>
								            <select id="listbox1" data-role="listbox"
								            	   
								                data-text-field="name"
								                data-value-field="name" 
								                data-toolbar='{tools: [ "transferTo", "transferFrom", "transferAllTo", "transferAllFrom"]}'
								                data-connect-with="listbox2"
								                data-bind="source:availableUserRoleDataSource">
								            </select>
								
								            <select id="listbox2" data-role="listbox"
								            		 
								            		data-bind="source:selectedUserRoleDataSource"
								            		data-connect-with="listbox1"
								            		data-text-field="name"
								                data-value-field="name">
								            </select>
								            
								            <button type="button" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" data-bind="click:updateUserRoles">저장</button>			      			 	
			      			 			</div>
			      			</div>
			      			<div class="tab-pane fade g-pa-10" id="user-options-content-3" role="tabpanel" aria-labelledby="user-options-tab-3">
			      				 <p>속성을 추가하거나 삭제할 수 있습니다.</p>
			      			</div>
			      		</div>
			      					      	
			      	</div><!-- /.modal-body -->					
				</div>
	    		</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->		
	<script type="text/x-kendo-template" id="template">    	
	<tr class="u-listview-item">
		<td class="u-text-left"><img class="g-width-36 g-height-36 rounded-circle" src="#= community.data.getUserProfileImage(data) #""> </td>
		<td class="u-text-left">	
		<h5 class="g-font-weight-100">
			 #= name #	<span class="g-font-weight-300 g-color-gray-dark-v6 mb-0">(#: username #)</span>
		</h5>
		<div class="u-visible-on-select">
			<div class="btn-group">
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="edit" data-object-type="user" data-object-id="#= userId #">수정</button>
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="delete" data-object-type="user" data-object-id="#= userId #">삭제</button>
			</div>
	 	</div>		
		</td>		
		<td class="u-text-left"> #: email # </td>
		<td class="text-center"> #: status # </td>
		<td class="text-center">  #: community.data.getFormattedDate( creationDate)  #  </td>
		<td class="text-center">#: community.data.getFormattedDate( modifiedDate)  # </td>
	</tr>				                      
    </script>   	
</body>
</html>
</#compress>