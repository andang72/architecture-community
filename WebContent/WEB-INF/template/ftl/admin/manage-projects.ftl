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
	<link href="/css/kendo.ui.core/web/kendo.common-bootstrap.core.css" rel="stylesheet" type="text/css" />
	<link href="/css/kendo.ui.core/web/kendo.bootstrap.min.css" rel="stylesheet" type="text/css" />
	
	<!-- Bootstrap CSS -->
    <link href="/css/bootstrap/3.3.7/bootstrap.min.css" rel="stylesheet">
    <link href="/fonts/font-awesome.css" rel="stylesheet">
    
    <!-- Bootstrap Theme Inspinia CSS -->
    <link href="/css/animate/animate.css" rel="stylesheet"> 
    <link href="/css/bootstrap.theme/inspinia/style.css" rel="stylesheet">
     
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
		community.ui.bind( renderTo , observable );
		
		createProjectListView();
		
		renderTo.on("click", "button[data-object-type=project], a[data-object-type=project]", function(e){			
			var $this = $(this);
			var actionType = $this.data("action");		
			var objectId = $this.data("object-id");		
			var targetObject = new community.model.Project();
			if ( objectId > 0 ) {
				targetObject = community.ui.listview( $('#project-listview') ).dataSource.get( objectId );				
			}				
 			openProjectEditorModal(targetObject);			
			return false;		
		});				
		                
	});
	
	function createProjectListView(){
		var renderTo = $('#project-listview');		
		var listview = community.ui.listview( renderTo , {
			dataSource: community.ui.datasource('/data/api/mgmt/v1/projects/list.json', {
				schema: {
					total: "totalCount",
					data:  "items",
					model: community.model.Project
				},
				pageSize : 15,
				serverPaging : false,
			}),
			
			template: community.ui.template($("#template").html())
		}); 	
		community.ui.pager( $("#project-listview-pager"), {
            dataSource: listview.dataSource
        });  	
	}
	
		
	function openProjectEditorModal (data){ 
		//console.log( community.ui.stringify(data) );
		var renderTo = $('#project-editor-modal');
		var renderTo2 = $('#project-editor-perms-listview');
		if( !renderTo.data("model") ){
			var observable = new community.ui.observable({ 
				isNew : false,				
				permissionToType : "",  
				permissionToDisabled	: true,					
				enabledSelectRole : false,
				accessControlEntry: new community.model.ObjectAccessControlEntry(),
				project : new community.model.Project(),
				setSource : function (data){
					var $this = this;
					var orgProjectId = $this.project.projectId ;
					data.copy( $this.project ); 
					if(  $this.project.projectId > 0 ){
						$this.set('isNew', false );
						if( $this.project.projectId != orgProjectId ){
							if( community.ui.exists(renderTo2) ){
								community.ui.listview(renderTo2).destroy();	
							}					
							community.ui.listview( renderTo2, {
								dataSource: community.ui.datasource( '/data/api/mgmt/v1/security/permissions/19/'+ $this.project.get('projectId') +'/list.json' , {
									schema: {
										total: "totalCount",
										data: "items",
										model: community.model.ObjectAccessControlEntry
									}
								}),
								template: community.ui.template($("#perms-template").html())
							});
						}
					}else{
						$this.set('isNew', true ); 
					}
					$this.resetAccessControlEntry();								
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
					$this.accessControlEntry.set('domainObjectId' , $this.project.projectId);					
				},
				addPermission : function (e){
					var $this = this;
					if( $this.accessControlEntry.get('grantedAuthorityOwner').length > 0  && $this.accessControlEntry.get('permission').length > 0 ){
						community.ui.progress(renderTo, true);	
						community.ui.ajax( '<@spring.url "/data/api/mgmt/v1/security/permissions/19/" />' + $this.project.get('projectId') +'/add.json' , {
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
					community.ui.ajax( '<@spring.url "/data/api/mgmt/v1/security/permissions/19/" />' + $this.project.get('projectId') +'/remove.json', {
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
					community.ui.progress(renderTo, true);	
					community.ui.ajax( '<@spring.url "/data/api/mgmt/v1/projects/save-or-update.json" />', {
						data: community.ui.stringify($this.project),
						contentType : "application/json",
						success : function(response){
							community.ui.listview( $('#project-listview') ).dataSource.read();
						}
					}).always( function () {
						community.ui.progress(renderTo, false);
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
				contractDataSource : community.ui.datasource( '<@spring.url "/data/api/mgmt/v1/codeset/PROJECT/list.json" />' , {} )
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
        		
 			renderTo.on("click", "button[data-subject=permission][data-action=delete], a[data-subject=permission][data-action=delete]", function(e){			
				var $this = $(this);
				var permissionId = $this.data("object-id");
				var data = community.ui.listview( renderTo2 ).dataSource.get(permissionId);	
				observable.removePermission(data);
				return false;		
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
                    <h2>프로젝트 관리</h2>
                    <ol class="breadcrumb">
                        <li>
                            커뮤니티
                        </li>
                        <li class="active">
                            <strong>게시판관리</strong>
                        </li>
                    </ol>
                </div>
                <div class="col-sm-8">
                    <div class="title-action">
                        <a href="javascript:void();" class="btn btn-primary" data-action="create" data-object-type="project"  data-object-id="0" >새로운 프로젝트 만들기</a>
                    </div>
                </div>
            </div>

            <div class="wrapper wrapper-content">
            		<div class="container">            
                		<div class="row">
                    		<div class="col-lg-12">
                        		<div class="ibox float-e-margins">
                        			 <div class="ibox-content no-padding">	 
                        			 	<table class="table no-margins">
			                            <thead>
			                            <tr> 
			                                <th>프로젝트</th>
			                                <th class="text-center" width="150">비용(월)</th> 
			                                <th class="text-center" width="200">기간</th> 
			                                <th class="text-center" width="150">수정일</th>
			                            </tr>
			                            </thead>
			                            <tbody id="project-listview" class="no-border " >	
			                            </tbody>                            
			                        </table>          
                        			 </div>
                        			 <div class="ibox-footer no-padding">  
	                            		<div id="project-listview-pager" class="k-pager-wrap no-border"></div>
	                             </div>  
                        		</div>
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
    
	<!-- board editor modal -->
	<div class="modal fade" id="project-editor-modal" tabindex="-1" role="dialog" aria-labelledby="project-editor-modal-labal" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
		      	<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
			          	<!--<span aria-hidden="true">&times;</span>-->
			        </button>
			        <h2 class="modal-title"><span data-bind="text:project.name"></span></h2>
		      	</div><!-- /.modal-content -->
		      	<div class="modal-body">
			        <form>
			        	 <h5 class="text-info"></h5>
			        	  <div class="form-group">
			            <input type="text" class="form-control" placeholder="프로젝트 이름" data-bind="value: project.name">
			            <span class="help-block m-b-none">프로젝트 이름을 입력하세요.</span>
			          </div> 	
					 <div class="form-group">					    
					    <textarea class="form-control" rows="3" placeholder="프로젝트 소개  .." data-bind="value: project.summary"></textarea>
					  </div>	
					 <div class="form-group">					    
						<input data-role="dropdownlist"
							data-option-label="계약상태를 선택하세요."
							data-auto-bind="false"
							data-text-field="name"
							data-value-field="code"
							data-bind="value: project.contractState, source: contractDataSource"
							style="width: 100%;" />
					  </div>			
					 <div class="form-group"> 
					 	<h6 class="text-light-gray text-semibold">비용(월)</h6>	
					 	<input data-role="numerictextbox" data-format="c" data-bind="value: project.maintenanceCost" style="width: 180px">
					 </div>	 			  			  
					 <div class="form-group">			
						<div class="row">
						  	<div class="col-sm-6">
						  		<h6 class="text-light-gray text-semibold">시작일</h6>		
						  		 <input data-role="datepicker" data-bind="value: project.startDate" style="width: 100%">
						  	</div>
						    <div class="col-sm-6">
						    <h6 class="text-light-gray text-semibold">종료일</h6>		
						     	<input data-role="datepicker" data-bind="value: project.endDate" style="width: 100%">
						  	</div>
					  	</div>   
					   
					  </div>						  		          	          
			        </form>
		      	</div><!-- /.modal-body -->
		      	

				<div class="modal-body" data-bind="invisible:isNew"><h2 class="m-t-n">고급설정</h2>													
					<div class="tabs-container">
                        <ul class="nav nav-tabs">
                            <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">권한설정</a></li>
                            <li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">속성</a></li>
                        </ul>
                        <div class="tab-content">
                            <div id="tab-1" class="tab-pane active">
                                <div class="panel-body">
                                
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
							<tbody id="project-editor-perms-listview" > 
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
                         <div id="tab-2" class="tab-pane">
                                <div class="panel-body">
                                    <p>속성값을 수정할 수 있습니다.</p>
                                </div>
                            </div>
                        </div>
                    </div>    
				</div>	
		      	<div class="modal-footer">
			        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
			        <button type="button" class="btn btn-primary" data-bind="{ click: saveOrUpdate }">확인</button>
		      	</div><!-- /.modal-footer -->
	    		</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->	

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
    	    	    
    	<script type="text/x-kendo-template" id="template">    	
	<tr class="u-listview-item">
		<td class="u-text-left">		
		<h3 class="g-font-weight-100">
		# if ( new Date() > endDate ) {#  <span class="text-danger"><i class="icon-ban"></i> </span> #} #	
		#= name # 
		# if ( contractState == '002') { # <span class="text-info" >무상</span> # } else if (contractState == '001') { # <span class="text-info"> 유상 </span> # } #
		# if ( new Date() > endDate ) {#  <span class="text-danger"> 계약만료 </span> #} #		
		</h3>
		<div class="u-visible-on-select">
			<div class="btn-group">
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="edit" data-object-type="project" data-object-id="#= projectId#"  >수정</button>
			<button class="btn btn-sm u-btn-outline-lightgray g-mt-5" data-action="delete" data-object-type="project" data-object-id="#= projectId#" >삭제</button>
			</div>
	 	</div>
		</td>
		<td class="text-right align-middle"> #: kendo.toString( maintenanceCost, 'c')  # </td>
		<td class="text-center align-middle"> #: community.data.getFormattedDate( startDate , 'yyyy-MM-dd')  # ~ #: community.data.getFormattedDate( endDate, 'yyyy-MM-dd' )  # </td>
		<td class="text-center align-middle"> #: community.data.getFormattedDate( modifiedDate)  # </td>
	</tr>				                      
    </script>    
</body>
</html>
</#compress>