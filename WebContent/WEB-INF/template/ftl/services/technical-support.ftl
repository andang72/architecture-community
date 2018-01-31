<#ftl encoding="UTF-8"/>
<#compress>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title><#if __page?? >${__page.title}</#if></title>
 	
 	<!-- Kendoui with bootstrap theme CSS -->			 
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.common-bootstrap.core.min.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/kendo.ui.core/web/kendo.bootstrap.min.css"/>" rel="stylesheet" type="text/css" />	 
	
	<!-- Bootstrap core CSS -->
	<link href="<@spring.url "/css/bootstrap/3.3.7/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />
	<link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />	

	<!-- Bootstrap Theme CSS -->
	<link href="<@spring.url "/css/bootstrap.theme/inspinia/style.css"/>" rel="stylesheet" type="text/css" />	
 	<link href="<@spring.url "/css/bootstrap.theme/inspinia/custom.css"/>" rel="stylesheet" type="text/css" />	
		
	<!-- Community CSS -->
	<link href="<@spring.url "/css/community.ui/community.ui.globals.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/community.ui/community.ui.components.css"/>" rel="stylesheet" type="text/css" />
  	<link href="<@spring.url "/css/community.ui/community.ui.style.css"/>" rel="stylesheet" type="text/css" />	
  	
  	 <!-- Summernote Editor CSS -->
	<link href="<@spring.url "/js/summernote/summernote.css"/>" rel="stylesheet" type="text/css" />
		
	<!-- Page landing js -->	   	
	<script data-pace-options='{ "ajax": false }' src='<@spring.url "/js/pace/pace.min.js"/>'></script>   	
	<!-- Requirejs for js loading -->
	<script src="<@spring.url "/js/require.js/2.3.5/require.js"/>" type="text/javascript"></script>
	<!-- Application JavaScript
    		================================================== -->    
	<script>
	require.config({
		shim : {
	        "bootstrap" : { "deps" :['jquery'] },
	        "kendo.ui.core.min" : { "deps" :['jquery'] },
	        "kendo.culture.ko-KR.min" : { "deps" :['kendo.ui.core.min'] },
	        "community.ui.core" : { "deps" :['kendo.culture.ko-KR.min'] },
	        "community.data" : { "deps" :['community.ui.core'] },	        
	        "summernote-ko-KR" : { "deps" :['summernote.min'] }
	    },
		paths : {
			"jquery"    					: "/js/jquery/jquery-2.2.4.min",
			"bootstrap" 					: "/js/bootstrap/3.3.7/bootstrap.min",
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"community.ui.core" 			: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data",
			"summernote.min"             : "/js/summernote/summernote.min",
			"summernote-ko-KR"           : "/js/summernote/lang/summernote-ko-KR"		
		}
	});
	
	require([ "jquery", "kendo.ui.core.min",  "kendo.culture.ko-KR.min", "community.data", "community.ui.core", "bootstrap"], function($, kendo ) {	
		
		community.ui.setup({
		  	features : {
				accounts: true
		  	},
		  	'features.accounts.authenticate' :function(e){
		  		if( !e.token.anonymous ){
		  			observable.setUser(e.token);
		    		}
		  	}
		});	     
		
		
        // Topnav animation feature
 		var cbpAnimatedHeader = (function() {
        		var docElem = document.documentElement, header = document.querySelector( '.navbar-default' ), didScroll = false, changeHeaderOn = 200;
        		function init() {
            		window.addEventListener( 'scroll', function( event ) {
	                if( !didScroll ) {
	                    didScroll = true;
	                    setTimeout( scrollPage, 250 );
	                }
            		}, false );
        		}
        		function scrollPage() {
            		var sy = scrollY();
	            if ( sy >= changeHeaderOn ) {
	                $(header).addClass('navbar-scroll')
	            }
	            else {
	                $(header).removeClass('navbar-scroll')
	            }
            		didScroll = false;
        		}
	        function scrollY() {
	            return window.pageYOffset || docElem.scrollTop;
	        }
        		init();
		})();
           		
		var observable = new community.ui.observable({ 
			currentUser : new community.model.User(),
			isDeveloper : false,
			enabled : false,
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
				$this.set('isDeveloper', isDeveloper());
				$this.set('enabled', true);
				if($this.get('isDeveloper')){
					createIssueListView($this);
				}
			},
			dataSource: community.ui.datasource('<@spring.url "/data/api/v1/projects/list.json"/>', {
				transport:{
					read:{
						contentType: "application/json; charset=utf-8"
					},
					parameterMap: function (options, operation){		
						return community.ui.stringify(options)
					} 			
				},	
				serverPaging:false,
				pageSize : 100,
				schema: {
					total: "totalCount",
					data: "items",
					model: community.model.Project
				}
			}),
			contractDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/PROJECT/list.json" />' , {} ),
			filter : {
				PROJECT_CONTRACT : null,
				NAME : null
			},
			clearFilters : function(){
				var $this = this ;
				$this.set('filter.PROJECT_CONTRACT' , null ) ;
				$this.set('filter.NAME' , null ) ;
				$this.dataSource.filter( [] );
			},
			applyFilters : function(){
				var $this = this , filters = [];
				if( $this.filter.PROJECT_CONTRACT != null ){
					filters.push({ field: "contractState", operator: "eq", value: $this.filter.PROJECT_CONTRACT });
				}else if ($this.filter.NAME != null ){
					filters.push({ field: "name", operator: "contains", value: $this.filter.NAME });
				}
				$this.dataSource.filter( filters );
			},
			filter2 : {
				ASSIGNEE_TYPE : "1",
				TILL_THIS_WEEK : true,
				STATUS_ISNULL : false
			},
			doFilter2 : function(){ 
				var $this = this , filters = [];
				if( observable.filter2.STATUS_ISNULL ){
					filters.push({ logic: "AND" , filters:[{ field: "ISSUE_STATUS", operator: "neq", value: "005" },{field: "ISSUE_STATUS", operator: "eq", logic: "OR" } ] } );
				}else{
					filters.push({ logic: "AND" , filters:[{ field: "ISSUE_STATUS", operator: "neq", value: "005" }]});
				}				
				filters.push({ field: "assigneeType", operator: "eq", value: $this.filter2.ASSIGNEE_TYPE, logic: "AND" });
				community.ui.listview($('#issue-listview')).dataSource.filter( filters );
				return false;
			},
			showAllOpenIssue: function(e){
				$('html, body').stop().animate({ scrollTop: $("#worklist").offset().top - 50 }, 500);
				e.preventDefault();
				$("#navbar").collapse('hide');				
 			}
    		});
    		observable.bind("change", function(e) { 
    			if( e.field == 'filter.PROJECT_CONTRACT' || e.field == 'filter.NAME' ) {
    				observable.applyFilters();
    			}else if (e.field == 'filter2.ASSIGNEE_TYPE'){
    				observable.doFilter2();  				
    			}
    		});
    		var renderTo = $('#page-top');
    		renderTo.data('model', observable);
    		community.ui.bind(renderTo, observable );	
    		community.ui.tooltip(renderTo);
    		createProjectListView(observable);
    		
		renderTo.on("click", "button[data-action=create], a[data-action=create], a[data-action=view], a[data-action=view2], button[data-action=overviewstats]", function(e){			
			var $this = $(this);
			var actionType = $this.data("action");		
			var objectId = $this.data("object-id");		
			if( actionType == 'view'){
				community.ui.send("<@spring.url "/display/pages/issues.html" />", { 'projectId': objectId });
				return;	
			}else if( actionType == 'view2'){
				community.ui.send("<@spring.url "/display/pages/issue.html" />", { 'issueId': objectId , url : "${__page.name}"});
				return;	
			}else if( actionType == 'overviewstats'){
				community.ui.send("<@spring.url "/display/pages/issue-overviewstats.html" />");
				return;	
			} else if ( actionType == 'create' && !isDeveloper() ){
				if( observable.dataSource.total() == 1 ){
					community.ui.send("<@spring.url "/display/pages/issue.html" />", { 'projectId': observable.dataSource.at(0).projectId });
					return;
				}	
			}
			// only for developers and client who has many projects.	
			var targetObject = new community.model.Issue();	
			targetObject.set('objectType', 19 );
			if( observable.dataSource.total() == 1 ){
				targetObject.set('objectId', observable.dataSource.at(0).projectId);
			}						
 			createOrOpenIssueEditor (targetObject);		
			return false;		
		});		
	});

	function send ( data ) {
		community.ui.send("<@spring.url "/display/pages/issues.html" />", { projectId: data.projectId });
	}
 		
	function createProjectListView(observable){
		var renderTo = $('#project-listview');	    		
		community.ui.listview( renderTo , {
			dataSource: observable.dataSource,
			template: community.ui.template($("#template").html())
		}); 	
	}

	function getFirstDayOfWeek(){
		var now = new Date();	
		var day = now.getDay(), diff = now.getDate() - day + (day == 0 ? -6 : 1 ); 
		return new Date(now.setDate(diff));
	}
	
	function getLastSaturday(){
		var now = getFirstDayOfWeek();
		return new Date(now.setDate(now.getDate() - 2));
	}
	
	function getThisFriday(){
		var now = new Date();	
		var day = now.getDay(), diff = now.getDate() - day + 5; 
		return new Date(now.setDate(diff));
	}
	
			
	function createIssueListView(observable){
		var renderTo = $('#issue-listview');	 	
		if( !community.ui.exists(renderTo) ){
			console.log("create listview for issues.");
			var listview = community.ui.listview( renderTo , {	
				dataSource: community.ui.datasource('<@spring.url "/data/api/v1/issues/list.json"/>', {
					transport:{
						read:{ contentType: "application/json; charset=utf-8" },
						parameterMap: function (options, operation){	
							options.data = options.data || {} ;
							options.data.TILL_THIS_WEEK = observable.filter2.TILL_THIS_WEEK;
							return community.ui.stringify(options);
						} 			
					},	
					serverFiltering: true,
					serverPaging: true,		
					filter: { filters: [
						{ field: "ISSUE_STATUS", operator: "neq", value: "005",logic: "AND" },
						{ field: "assigneeType", operator: "eq", value: "1",logic: "AND" } 
					] },	
					schema: {
						total: "totalCount",
						data: "items"
					}
				}),
				template: community.ui.template($("#template-issue").html()),
				dataBound: function() {
					if( this.items().length == 0)
			        		renderTo.html('<tr class="g-height-50"><td colspan="7" class="align-middle g-font-weight-300 g-color-black text-center">조건에 해당하는 이슈가 없습니다.</td></tr>');
			    }
			});
			community.ui.pager( $("#issue-listview-pager"), {
            		dataSource: listview.dataSource
       	 	});  
		}		
	}
	
	function createOrOpenIssueEditor( data ){
		var renderTo = $('#issue-editor-modal');
		if( !renderTo.data("model") ){
			var observable = new community.ui.observable({ 
				isNew : false,	
				isDeveloper : false,
				issue : new community.model.Issue(),
				projectDataSource   : community.ui.listview($('#project-listview')).dataSource,
				issueTypeDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/ISSUE_TYPE/list.json" />' , {} ),
				priorityDataSource  : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/PRIORITY/list.json" />' , {} ),
			 	methodsDataSource   : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/SUPPORT_METHOD/list.json" />' , {} ),
			 	resolutionDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/RESOLUTION/list.json" />' , {} ),
			 	statusDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/ISSUE_STATUS/list.json" />' , {} ),
			 	setSource : function( data ){
			 		var $this = this;
					var orgIssueId = $this.issue.issueId ;
					data.copy( $this.issue ); 
					if(  $this.issue.issueId > 0 ){
						$this.set('isNew', false );
					}else{
						$this.set('isNew', true );	
					}
					$this.set('isDeveloper', isDeveloper());
			 	},
				saveOrUpdate : function(e){				
					var $this = this;
					if( !$this.get('isDeveloper') && $this.issue.repoter.userId <= 0 )
					{
						$this.issue.repoter = $('#page-top').data('model').currentUser ;					
					}
					community.ui.progress(renderTo.find('.modal-content'), true);	
					community.ui.ajax( '<@spring.url "/data/api/v1/issues/save-or-update.json" />', {
						data: community.ui.stringify($this.issue),
						contentType : "application/json",						
						success : function(response){
							
						}
					}).always( function () {
						community.ui.progress(renderTo.find('.modal-content'), false);
						renderTo.modal('hide');
					});						
				}
			});
			renderTo.data("model", observable );	
			community.ui.bind( renderTo, observable );				
			renderTo.on('show.bs.modal', function (e) {	});
		}	
		if( community.ui.defined(data) ) 
			renderTo.data("model").setSource(data);
		renderTo.modal('show');
	}
 
	function isDeveloper(){ 
		return $('#page-top').data('model').currentUser.hasRole('ROLE_DEVELOPER') ;
	} 
 			
	</script>		
</head>
<body id="page-top" class="landing-page no-skin-config">
	<!-- NAVBAR START -->   
	<#include "/includes/user-top-navbar.ftl">
	<!-- NAVBAR END -->   
	<section class="u-bg-overlay g-bg-cover g-bg-size-cover g-bg-bluegray-opacity-0_3--after" style="background: url(/images/bg/endless_streets_by_andreasrocha-d3fhbhg.jpg)">      
      <div class="container text-center g-bg-cover__inner g-py-150">
        <div class="row justify-content-center">
          <div class="col-lg-6">
            <div class="mb-5">
              <h1 class="g-color-white g-font-size-60 mb-4"><#if __page?? >${__page.title}</#if></h1>
              <h2 class="g-color-white g-font-weight-200 g-font-size-22 mb-0 text-left" style="line-height: 1.8;"><#if __page?? >${__page.summary}</#if></h2>
            </div>
            <!-- Promo Blocks - Input -->
			<p data-bind="invisible:currentUser.anonymous" style="display:none;">
				<a class="btn btn-lg u-btn-blue g-mr-10 g-mt-25 g-font-weight-200" href="#" role="button" role="button" data-toggle="tooltip" data-placement="bottom" data-original-title="새로운 이슈를 등록합니다." data-object-id="0" data-action="create" data-action-target="issue" data-bind="disabled:currentUser.anonymous, enabled: enabled" >기술지원요청하기</a>
			</p>            
            <!-- End Promo Blocks - Input -->
          </div>
        </div>
      </div>
    </section>

	<section id="features" class="container services">
		<div class="wrapper wrapper-content">
            		<div class="container">            
                		<div class="row">
                    		<div class="col-lg-12">
                        		<div class="ibox float-e-margins">
	                            	<div class="ibox-title"  data-bind="visible:currentUser.anonymous" style="display:none;">
	                            		<i class="icon-svg icon-svg-sm icon-svg-dusk-announcement"></i>
	                            		<p data-bind="visible:currentUser.anonymous"> <a href="/accounts/login">로그인</a>이 필요한 서비스 입니다. </p>
	                            	</div>                          		
                            		<div class="ibox-title" data-bind="invisible:currentUser.anonymous" style="display:none;">
                                		<h2>
                                		<i class="icon-svg icon-svg-sm icon-svg-dusk-client-base "></i>
                                		</h2>
                            		</div>   
                            		<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >
	                            	<div class="ibox-content ibox-heading" data-bind="visible:isDeveloper" sytle="display:none;">
								  	<div class="row">
	                            			<div class="col-sm-12">
	                            				<button class="btn btn-lg u-btn-outline-red g-mr-10 g-mb-15" type="button"  role="button" role="button" data-bind="click: showAllOpenIssue" >금주 나에게 배정된 업무 확인하기</button>
	                            				<button class="btn btn-lg u-btn-outline-purple g-mr-10 g-mb-15" type="button"  role="button" role="button" data-toggle="tooltip" data-placement="top" data-original-title="기간별 이슈 처리현황을 확인합니다." data-object-id="0" data-action="overviewstats">통계</button>
	                            				<a class="btn btn-lg u-btn-outline-blue g-mr-10 g-mb-15" href="#" role="button" data-object-id="0" data-action="create" >새로운 이슈 등록하기</a>
	                            			</div>
	                            	  	</div>		                            	
	                            		<hr class="g-brd-gray-light-v4 my-0">
	                            		<p class="g-color-red g-mb-15"> 계약상태 또는 프로젝트 이름으로 필터를 적용할 수 있습니다.</p>
	                            		<div class="row">
	                            			<div class="col-sm-4 g-mb-15">
	                            				<div class="form-group">					    
												<input data-role="combobox" 
													data-option-label="계약상태를 선택하세요."
													data-placeholder="프로젝트 계약상태를 선택하세요."
													data-value-primitive="true"
													data-auto-bind="true"
													data-text-field="name"
													data-value-field="code"
													data-bind="value: filter.PROJECT_CONTRACT, source: contractDataSource"
													style="width: 100%;" />
								  			</div>	
								  		</div>
								 		<div class="col-sm-4 g-mb-15">
										  	<div class="form-group">
												<input type="text" class="form-control" placeholder="프로젝트 이름을 입력하세요." data-bind="value:filter.NAME">
											</div>
								  		</div>	
								  		<div class="col-sm-4 g-mb-15">
								  			<button class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" type="button" role="button" role="button" data-toggle="tooltip" data-placement="bottom" data-original-title="적용된 필터를 제거합니다." data-object-id="0" data-bind="click:clearFilters" >초기화</button>
								  		</div>
								  	</div>
	                            	</div>
	                            	</#if> 
	                            	<#if !currentUser.anonymous >                      		                       		
	                            <div class="ibox-content">
	                            		<p>프로젝트 이름을 클릭하면 등록된 이슈들을 열람할 수 있습니다.</p>
	                                <div id="project-listview" class="no-border" ></div>
	                            </div>                            
	                            </#if>
                        		</div>
                    		</div>
                		</div>
            		</div>
        		</div>
	</section>	
	<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >
	<section id="worklist" class="gray-section" data-bind="visible:isDeveloper">
	    <div class="container">
	        <div class="row">
	            <div class="col-lg-12 text-center">
	                <div class="navy-line"></div>
	                <h1>금주 나에게 배정된 업무</h1>
	                <p class="g-mb-15">금주에 처리해야할 업무입니다.</p>
					<ul class="list-inline">
			            <li>
			              	<input type="checkbox" id="eq1" class="k-checkbox" data-bind="checked: filter2.TILL_THIS_WEEK" checked>
			          		<label class="k-checkbox-label" for="eq1">금주에 할일만 포함</label>
			            </li>
			            <li>
			              	<input type="checkbox" id="eq2" class="k-checkbox" data-bind="checked: filter2.STATUS_ISNULL" >
			          		<label class="k-checkbox-label" for="eq2">진행상태가 없는 이슈 포함</label>
			            </li>
			            <li>
			            		<button type="button" class="btn btn-sm u-btn-outline-bluegray g-ml-25 g-mr-10 g-mb-5" href="#" role="button" role="button" data-bind="click:doFilter2">새로고침</button>
			            </li>
			        </ul>	                
					<div class="btn-group" data-toggle="buttons">
					  <label class="btn btn-primary">
					    <input type="radio" name="issueAssigneeFilter" value="0" autocomplete="off"  data-bind="checked:filter2.ASSIGNEE_TYPE">전체
					  </label>
					  <label class="btn btn-primary active">
					    <input type="radio" name="issueAssigneeFilter" value="1" autocomplete="off" data-bind="checked:filter2.ASSIGNEE_TYPE">내가 담당
					  </label>
					  <label class="btn btn-primary">
					    <input type="radio" name="issueAssigneeFilter" value="2" autocomplete="off"  data-bind="checked:filter2.ASSIGNEE_TYPE">타인이 담당
					  </label>
					  <label class="btn btn-primary">
					    <input type="radio" name="issueAssigneeFilter" value="3" autocomplete="off"  data-bind="checked:filter2.ASSIGNEE_TYPE">미배정
					  </label>
					</div>
	            </div>
	        </div>
	        <div class="row features-block g-mb-50">
	        		<div class="table-responsive">
	        			<table class="table table-bordered u-table--v2 g-mb-0">
						<thead class="text-uppercase g-letter-spacing-1">
							<tr class="g-height-50">
								<th class="align-middle g-font-weight-300 g-color-black g-min-width-50">ID</th>
								<th class="align-middle g-font-weight-300 g-color-black g-min-width-80">프로젝트</th>
								<th class="align-middle g-font-weight-300 g-color-black g-min-width-300">요약</th>
								<th class="align-middle g-font-weight-300 g-color-black g-min-width-50">유형</th>
								<th class="align-middle g-font-weight-300 g-color-black g-min-width-50">우선순위</th>
								<th class="align-middle g-font-weight-300 g-color-black g-min-width-70 text-nowrap">담당자</th>
								<th class="align-middle g-font-weight-300 g-color-black g-min-width-70 text-nowrap">예정일</th>
							</tr>
						</thead>	
	        				<tbody id="issue-listview" ></tbody>
	        			</table>
	        		</div>
	        		<div id="issue-listview-pager" class="g-bg-transparent  g-brd-top-none"></div>
	        </div>
	    </div>
	</section>	
	</#if>
	<!-- FOOTER START -->   
	<#include "/includes/user-footer.ftl">
	<!-- FOOTER END -->  
	<script type="text/x-kendo-template" id="template-issue">
	<tr>
		<td class="align-middle text-center"> ISSUE-#: issueId # </td>
    		<td class="align-middle">
    		<a href="\\#" class="btn-link" data-action="view" data-object-id="#: project.projectId#" data-kind="project">
    		#: project.name #
    		</a>
    		</td>
    		<td class="align-middle">
    			# if ( new Date() >= new Date(dueDate) ) {# <i class="fa fa-exclamation-triangle g-color-red" aria-hidden="true"></i> #} else { #  # } # 
        		<a class="btn-link text-wrap g-font-weight-200 g-font-size-20" href="\\#" data-action="view2" data-object-id="#= issueId #" data-kind="issue" >#: summary # </a>        		
 		</td>
    		<td class="align-middle">#: issueTypeName #</td>
    		<td class="align-middle">#: priorityName #</td>
    		<td class="align-middle">
		#if ( assignee != null && assignee.userId > 0 ) {#
		#= community.data.getUserDisplayName( assignee ) #
		#} else {#
			미지정
		#}#
		</td>
    		<td class="align-middle">#if (dueDate != null){ # #: community.data.getFormattedDate( dueDate , 'yyyy-MM-dd') # #}#</td>
    	</tr>	
	</script>	
	<script type="text/x-kendo-template" id="template">
			<div class="forum-item">
				<div class="row">
					<div class="col-md-9">
						<div class="forum-icon">
 							<i class="icon-svg icon-svg-sm icon-svg-ios-customer-support #if ( new Date() > endDate ) {#g-opacity-0_3#}#"></i>
						</div>						
						<h2 class="g-ml-60 g-font-weight-100"># if ( contractState == '002') { # <span class="text-info" >무상</span> # } else if (contractState == '001') { # <span class="text-info"> 유상 </span> # } # <a href="\\#" data-action="view" data-object-id="#=projectId#" data-kind="project" class="btn-link"> #:name# </a></h4>						
						<div class="g-ml-60 g-mb-5 text-warning"> #: community.data.getFormattedDate( startDate , 'yyyy-MM-dd')  # ~ #: community.data.getFormattedDate( endDate, 'yyyy-MM-dd' )  # # if ( new Date() > endDate ) {#  <span class="text-danger"> 계약만료 </span> #} #</div>
						#if( isDeveloper() ){ #
						<div class="g-ml-60 g-mb-5"> 유지보수비용(월) : #: kendo.toString( maintenanceCost, 'c')  #</div>						
						<div class="g-ml-60 g-mb-5 text-muted">#if(summary != null ){# #:summary # #}#</div>
						#}#
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> #= issueTypeStats.items[issueTypeStats.items.length - 1].value # </span>
						<div>
							<small>요청</small>
						</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number"> #= resolutionStats.items[resolutionStats.items.length - 1].value # </span>
						<div>
							<small>처리</small>
						</div>
					</div>
					<div class="col-md-1 forum-info">
						<span class="views-number">#= issueTypeStats.items[issueTypeStats.items.length - 1].value -  resolutionStats.items[resolutionStats.items.length - 1].value # </span>
						<div>
							<small>미처리</small>
						</div>
					</div>
				</div>
			</div>
    </script> 
</body>
	<!-- issue editor modal -->
	<div class="modal fade" id="issue-editor-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          	<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
			        </button>
			        <h2 class="modal-title">기술지원요청</h2>
		      	</div><!-- /.modal-content -->
				<div class="modal-body">
				 <form>
				 
				 	<h6 class="text-light-gray text-semibold">프로젝트 <span class="text-danger">*</span></h6>
					<div class="form-group">
						<input name="projectSelect"
						   data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="projectId"
		                   data-bind="value:issue.objectId, source:projectDataSource"
		                   style="width: 100%;"/>			        	  
					</div>
									 
				 	<h6 class="text-light-gray text-semibold">요청구분 <span class="text-danger">*</span></h6>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="value:issue.issueType, source:issueTypeDataSource"
		                   style="width:100%;"/>	
		                   		        	  
					</div>	
					<h6 class="text-light-gray text-semibold">요약 <span class="text-danger">*</span></h6>				 	
				 	<div class="form-group">
			            <input type="text" class="form-control" placeholder="요약" data-bind="value: issue.summary">
			        </div> 	

					<h6 class="text-light-gray text-semibold">상세 내용 <span class="text-danger">*</span></h6>				 	
				 	<div class="form-group">
					<textarea class="form-control" placeholder="상세내용" data-bind="value:issue.description"></textarea>
	 				</div> 
	 				
	 				<h6 class="text-light-gray text-semibold g-mt-15" data-bind="visible: isDeveloper">예정일</h6>	
					<input data-role="datepicker" data-bind="value: issue.dueDate, visible: isDeveloper, enabled:editable" style="width: 100%">
					
					<h6 class="text-light-gray text-semibold">우선순위 <span class="text-danger">*</span></h6>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="value:issue.priority, source:priorityDataSource"
		                   style="width: 100%;"/>			        	  
					</div>
						
					<h6 class="text-light-gray text-semibold">지원방법</h6>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="source:methodsDataSource"
		                   style="width: 100%;"/>
					</div>	

					<h6 class="text-light-gray text-semibold">처리결과</h6>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="visible: isDeveloper,value:issue.resolution, source:resolutionDataSource"
		                   style="width: 100%;"/>
					</div>	
					
					<h6 class="text-light-gray text-semibold">상태</h6>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="visible: isDeveloper,value:issue.status, source:statusDataSource"
		                   style="width: 100%;"/>
					</div>	
																																						
				</form>   
				<div class="text-editor"></div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" data-bind="click:saveOrUpdate">확인</button>
				</div>
			</div>
		</div>
	</div>	 
</html>
</#compress>