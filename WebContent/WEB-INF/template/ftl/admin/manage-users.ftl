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
				user : new community.model.User(),
				showOptions : function(e){
					userEditor.hide();
					renderTo.find(".nav-tabs a:first").tab('show');	
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
						$this.rolesDataSource.fetch(function (e){
							$this.setUserRoles();
						});						
					}else{
						$this.set('isNew', true ); 
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
	
     #user-options-tab-2 .demo-section {
        max-width: none;
        width: 515px;
    }

    #user-options-tab-2 .k-listbox {
        width: 236px;
        height: 310px;
    }

    #user-options-tab-2 .k-listbox:first-of-type {
            width: 270px;
            margin-right: 1px;
    }
        	
	</style>
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
                        <a href="javascript:void();" class="btn btn-primary" data-action="create" data-object-type="user"  data-object-id="0" >새로운 사용자 생성하기</a>
                    </div>	
                </div>
            </div>

            <div class="wrapper wrapper-content">
                <div class="">
  					<div class="ibox float-e-margins">
                        			 <div class="ibox-content no-padding g-font-size-20">	 
                        			 	<table class="table no-margins">
			                            <thead>
			                            <tr class="g-height-50">
			                                <th class="g-valign-middle text-center">이름</th>
			                                <th class="g-valign-middle text-center" width="100">상태</th>
			                                <th class="g-valign-middle text-center" width="150">생성일</th>
			                                <th class="g-valign-middle text-center" width="150">수정일</th>
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
		#if (enabled ) { # <i class="icon-user"></i>  # } else {# <i class="icon-user"></i> #}#  #= name # ( #= username # )		
		</h3>
		<div class="u-visible-on-select">
			<div class="btn-group">
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="edit" data-object-type="user" data-object-id="#= userId #">수정</button>
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="delete" data-object-type="user" data-object-id="#= userId #">삭제</button>
			</div>
	 	</div>		
		</td>
		
		<td class="text-center"> #: status # </td>
		<td class="text-center">  #: community.data.getFormattedDate( creationDate)  #  </td>
		<td class="text-center">#: community.data.getFormattedDate( modifiedDate)  # </td>
	</tr>				                      
    </script>   
	<!-- board editor modal -->
	<div class="modal fade" id="user-editor-modal" tabindex="-1" role="dialog" aria-labelledby="user-editor-modal-labal" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="user-editor">	
				<!-- .modal-header -->
				<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
			          	<!--<span aria-hidden="true">&times;</span>-->
			        </button>
			        <h2 class="modal-title"><span data-bind="text:user.name"></span></h2>
		      	</div>
			    <!-- /.modal-header -->
			    <!-- .modal-body -->
		      	<div class="modal-body">
			        <form>
			        	 <h5 class="text-info"></h5>
			        	  <div class="form-group">
			        	  	<h6 class="text-light-gray text-semibold">이름</h6>
			            <input type="text" class="form-control" placeholder="이름을 입력하세요" data-bind="value: user.name">			           
			          </div> 	
					 <div class="form-group">
					 	<h6 class="text-light-gray text-semibold">메일</h6>
			            <input type="email" class="form-control" placeholder="메일를 입력하세요" data-bind="value: user.email">
			          </div>		
			           <div class="form-group">
			           	<h6 class="text-light-gray text-semibold">아이디</h6>
			            <input type="text" class="form-control" placeholder="아이디를 입력하세요" data-bind="value: user.username">
			             <span class="help-block m-b-none" data-bind="visible:isNew">아이디를 입력하지 않는 경우 메일 주소를 아이디로 사용합니다.</span>
			          </div>		
			          <div class="form-group" data-bind="visible:isNew">
			           	<h6 class="text-light-gray text-semibold">비밀번호</h6>
			            <input type="password" class="form-control" placeholder="비밀번호를 입력하세요" data-bind="value: user.password">
			             <span class="help-block m-b-none" data-bind="visible:isNew">비밀번호를 입력하세요.</span>
			          </div>	
			          <div class="form-group">
				          <div class="row">
				          	<div class="col-sm-4">
					          	<input type="checkbox" name="nameVisible" id="nameVisible" value="true" class="k-checkbox" data-bind="checked:user.nameVisible">
								<label class="k-checkbox-label g-font-weight-100" for="nameVisible">이름 공개</label>
				          	</div>
				          	<div class="col-sm-4">
								<input type="checkbox" name="emailVisible" id="emailVisible" value="true" class="k-checkbox" data-bind="checked:user.emailVisible">
								<label class="k-checkbox-label g-font-weight-100" for="emailVisible">메일주소 공개</label>			          	
				          	</div>
				          </div>
	  		          </div>	          	            	  		          	          
			        	  <div class="row" data-bind="invisible:isNew">
				      	<div class="col-sm-6">
				      		<h6 class="text-light-gray text-semibold">상태</h6>
 							<select class="form-control" data-bind="value: user.status" style="width: 180px">
							  <option value="NONE">NONE</option>
							  <option value="APPROVED">APPROVED</option>
							  <option value="REJECTED">REJECTED</option>
							  <option value="VALIDATED">VALIDATED</option>
							  <option value="REGISTERED">REGISTERED</option>
							</select>
				      	</div>
				      	<div class="col-sm-6 text-right">
 		          			<h6 class="text-light-gray text-semibold">권한 및 속성 변경</h6>
							<button type="button" class="btn btn-sm u-btn-outline-red g-ml-10" data-bind="click: showOptions">고급설정</button>								
				       	</div>
				      </div>
			        </form>
		      	</div><!-- /.modal-body -->		
		      	<div class="modal-footer">
			        <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
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
						<div class="tabs-container">
	                        <ul class="nav nav-tabs">
	                        	   <li><a data-toggle="tab" href="#user-options-tab-1" aria-expanded="true" data-kind="avatar" >프로필 이미지</a></li>
	                            <li><a data-toggle="tab" href="#user-options-tab-2" aria-expanded="true" data-kind="roles" >롤</a></li>
	                            <li><a data-toggle="tab" href="#user-options-tab-3" aria-expanded="false" data-kind="properties">속성</a></li>
	                        </ul>
	                        <div class="tab-content">
	                            <div id="user-options-tab-1" class="tab-pane active">
	                            		<div class="panel-body">
	                                    <p>프로필 이미지를 수정할 수 있습니다.</p>
	                                    
	                                </div>   	                            
	                            </div>
	                            <div id="user-options-tab-2" class="tab-pane">
	                            	    <div class="panel-body">
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
								            
								        </div><!-- /.k-content  -->
								    </div><!-- /.panel-body -->	                                	                                    	                                    
	                            </div><!-- /.tab-pane -->   	                            
	                    		</div><!-- /.tabs-content --> 	                            
	                    </div><!-- /.tabs-container -->    			      	
			      	</div><!-- /.modal-body -->					
				</div>
	    		</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->	        
</html>
</#compress>