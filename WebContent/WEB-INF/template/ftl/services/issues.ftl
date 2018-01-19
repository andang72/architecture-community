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
	
	var __projectId = <#if RequestParameters.projectId?? >${RequestParameters.projectId}<#else>0</#if>;
	
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
	
	require([ "jquery", "kendo.ui.core.min",  "kendo.culture.ko-KR.min", "community.data", "community.ui.core", "bootstrap", "summernote.min", "summernote-ko-KR"], function($, kendo ) {	
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
			projectId : __projectId,
			project : new community.model.Project(),
			projectPeriod : "",
			totalIssueCount : 0,
			errorIssueCount: 0,
			closeIssueCount: 0,
			openIssueCount : 0,
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
				$this.set('isDeveloper', isDeveloper() );
			},
			loadProjectInfo : function( ){
				var $this = this;
				community.ui.ajax('/data/api/v1/projects/'+ observable.get('projectId') +'/info.json/', {
					success: function(data){		
						$this.set('project', new community.model.Project(data) );		
						$this.set('projecPeriod' , community.data.getFormattedDate( $this.project.startDate , 'yyyy-MM-dd')  +' ~ '+  community.data.getFormattedDate( $this.project.endDate, 'yyyy-MM-dd' ) );
						$.each($this.project.issueTypeStats.items , function (index, item ){
							if( item.name == 'TOTAL' )
								$this.set('totalIssueCount', item.value );
							else if ( item.name == '001' )
								$this.set('errorIssueCount', item.value );	
						});
						$.each($this.project.resolutionStats.items , function (index, item ){
							if( item.name == 'TOTAL' )
								$this.set('closeIssueCount', item.value );
						});
						$this.set('openIssueCount', $this.get('totalIssueCount') - $this.get('closeIssueCount') );
					}	
				});
			},
			search : function(){
				community.ui.listview( $('#issue-listview') ).dataSource.read();
			},
			filter : {
				ISSUE_TYPE : null,
				PRIORITY : null,
				RESOLUTION : null,
				ISSUE_STATUS : null,
				START_DATE : null,
				END_DATE : null
			},
			issueTypeDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/ISSUE_TYPE/list.json" />' , {} ),
			priorityDataSource  : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/PRIORITY/list.json" />' , {} ),
			resolutionDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/RESOLUTION/list.json" />' , {} ),
			statusDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/ISSUE_STATUS/list.json" />' , {} )			
    		});
		observable.loadProjectInfo();
		createIssueListView(observable);		
		var renderTo = $('#page-top');
		renderTo.data('model', observable);		
		community.ui.bind(renderTo, observable );	
		
		renderTo.on("click", "button[data-action=create], a[data-action=create], a[data-action=edit], a[data-action=view]", function(e){			
			var $this = $(this);
			var actionType = $this.data("action");		
			var objectId = $this.data("object-id");		
			var targetObject = new community.model.Issue();
				
			if( objectId > 0 ){
				targetObject = community.ui.listview($('#issue-listview')).dataSource.get(objectId);
			}else{			
				targetObject = new community.model.Issue();	
				targetObject.set('issueId', 0);
				targetObject.set('objectType', 19);
				targetObject.set('objectId', __projectId);
			}	
			/**
			if( actionType == 'view'){
				send(targetObject);	
				return false;	
			}
			
			if( isDeveloper() )
 				createOrOpenIssueEditor (targetObject);
			else
			*/			
			send(targetObject);	
			return false;		
		});
	});
	
	function send ( issue ) {
		community.ui.send("<@spring.url "/display/pages/issue.html" />", { projectId: issue.objectId, issueId: issue.issueId });
	}
	
	function getPageModel(){
		var renderTo = $('#page-top');
		return renderTo.data('model');
	}
	
	function createIssueListView( observable ){
		var renderTo = $('#issue-listview');
		var listview = community.ui.listview( renderTo , {
			dataSource: community.ui.datasource('<@spring.url "/data/api/v1/projects/"/>'+ observable.get('projectId') +'/issues/list.json', {
				transport:{
					read:{
						contentType: "application/json; charset=utf-8"
					},
					parameterMap: function (options, operation){		
					
						var filter = {filter:{filters: [], logic: "AND" } };
						if( observable.filter.ISSUE_TYPE != null && observable.filter.ISSUE_TYPE.length > 0 ){
							filter.filter.filters.push( {field: "ISSUE_TYPE", operator: "eq", value : observable.filter.ISSUE_TYPE, logic: "AND" } );
						}
						if( observable.filter.PRIORITY != null && observable.filter.PRIORITY.length > 0 ){
							filter.filter.filters.push( {field: "PRIORITY", operator: "eq", value : observable.filter.PRIORITY, logic: "AND" } );
						}
						if( observable.filter.RESOLUTION != null && observable.filter.RESOLUTION.length > 0 ){
							filter.filter.filters.push( {field: "RESOLUTION", operator: "eq", value : observable.filter.RESOLUTION, logic: "AND" } );
						}
						if( observable.filter.ISSUE_STATUS != null && observable.filter.ISSUE_STATUS.length > 0 ){
							filter.filter.filters.push( {field: "ISSUE_STATUS", operator: "eq", value : observable.filter.ISSUE_STATUS, logic: "AND" } );
						}
						if( observable.filter.START_DATE != null ){
							filter.filter.filters.push({ field: "START_DATE", operator: "gte", value : community.data.getFormattedDate( observable.filter.START_DATE, 'yyyyMMdd' ), logic: "AND" });
						}
						if( observable.filter.END_DATE != null ){
							filter.filter.filters.push({ field: "END_DATE", operator: "lte", value : community.data.getFormattedDate( observable.filter.END_DATE, 'yyyyMMdd' ), logic: "AND" });
						}
						if( filter.filter.filters.length > 0 ){
							options = $.extend( true, {}, filter, options );
						}
						
						return community.ui.stringify(options)
					} 				
				},
				schema: {
					total: "totalCount",
					data: "items",
					model : community.model.Issue
				}
			}),
			template: community.ui.template($("#template").html())
		});	
		community.ui.pager( $("#issue-listview-pager"), {
            dataSource: listview.dataSource
        });   
	} 
 
	function createOrOpenIssueEditor( data ){ 
		var renderTo = $('#issue-editor-modal');
		var editorTo = renderTo.find('.text-editor');
		if( !renderTo.data("model") ){
			var observable = new community.ui.observable({ 
				isNew : false,	
				editable : false, 
				isDeveloper : false,
				isOpen : false,
				isClosed : false,
				issue : new community.model.Issue(),
				issueTypeDataSource : getPageModel().issueTypeDataSource ,
				priorityDataSource  : getPageModel().priorityDataSource,
			 	methodsDataSource   : community.ui.datasource( '<@spring.url "/data/api/v1/codeset/SUPPORT_METHOD/list.json" />' , {} ),
			 	resolutionDataSource : getPageModel().resolutionDataSource,
			 	statusDataSource : getPageModel().statusDataSource,
			 	userDataSource : community.ui.datasource( '<@spring.url "/data/api/v1/users/find.json" />' , {
			 		serverFiltering: true,
			 		transport: {
				 		parameterMap: function (options, operation){
	                        	if (community.ui.defined(options.filter)) {
									return { nameOrEmail: options.filter.filters[0].value };
								}else{
									return { };
								}
						}
					},
			 	 	schema: {
						total: "totalCount",
						data: "items",
						model: community.model.User
					}
			 	}),
			 	setSource : function( data ){
			 		var $this = this;
					var orgIssueId = $this.issue.issueId ;
					data.copy( $this.issue ); 
					if(  $this.issue.issueId > 0 ){
						$this.set('isNew', false );
						$this.set('editable', false );
					}else{
						$this.set('isNew', true );	
						$this.edit();
						//$this.set('editable', true );
					}
					if($this.issue.status == '001' || $this.issue.status == '002' || $this.issue.status == '003' || $this.issue.status == '004' ){
			 			$this.set('isOpen', true);
			 			$this.set('isClosed', false);
			 		}else if($this.issue.status == '005' ){
			 			$this.set('isOpen', false);
			 			$this.set('isClosed', true);
			 		}else{
			 			$this.set('isOpen', false);
			 			$this.set('isClosed', false);
			 		}
					$this.set('isDeveloper', isDeveloper());
					
					$.each(renderTo.find('input[data-role=combobox]'), function( index, value ) {
					  	$(value).data('kendoComboBox').refresh();
					});
			 	},
			 	edit : function(e){
			 		var $this = this;
			 		$this.set('editable', true );
			 		console.log('summernote create.');
			 		editorTo.summernote({
						placeholder: '자세하게 기술하여 주세요.',
						dialogsInBody: true,
						height: 300
					});			 	
					editorTo.summernote('code', $this.issue.get('description'));	
			 	},
				saveOrUpdate : function(e){				
					var $this = this;
					community.ui.progress(renderTo.find('.modal-content'), true);	
					$this.issue.set('description', editorTo.summernote('code') );	
					community.ui.ajax( '<@spring.url "/data/api/v1/issues/save-or-update.json" />', {
						data: community.ui.stringify($this.issue),
						contentType : "application/json",						
						success : function(response){
							community.ui.listview( $('#issue-listview') ).dataSource.read();
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
			renderTo.on('hide.bs.modal', function (e) {	
				if(observable.get('editable') == true ){
					console.log('summernote destory.');
					editorTo.summernote('destroy');
					editorTo.html('');
				}
			});
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
	<section class="u-bg-overlay g-bg-cover g-bg-size-cover g-bg-bluegray-opacity-0_3--after" style="background: url(/images/bg/endless_streets_by_andreasrocha-d3fhbhg.jpg	)">      
      <div class="container text-center g-bg-cover__inner g-py-50">
        <div class="row justify-content-center">
          <div class="col-lg-6">
            <div class="mb-5">
              <h1 class="g-color-white g-font-size-60 mb-4"><#if __page?? >${__page.title}</#if></h1>
              <!--<h2 class="g-color-darkgray g-font-weight-400 g-font-size-22 mb-0 text-left" style="line-height: 1.8;"><#if __page?? ><#if __page.summary?? >${__page.summary}</#if></#if></h2>-->
            </div>
            <!-- Promo Blocks - Input -->
			<p>
				<a class="btn btn-lg u-btn-blue g-mr-10 g-mt-25 g-font-weight-200" href="#" role="button" data-object-id="0" data-action="create" data-action-target="issue">기술지원요청하기</a>
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
							<div class="ibox-title g-pl-0">
	                            	<a href="<@spring.url "/display/pages/technical-support.html" />" class="back">
									<i class="icon-svg icon-svg-sm icon-svg-ios-back"></i>
								</a>
                                	<h2 class="g-pl-55">
                                		<span data-bind="text:project.name"></span>
                                		<div class="g-pt-15 g-pb-15 g-font-size-20 g-font-weight-200" data-bind="html: project.summary"></div>
                                		<div class="g-font-size-20 g-font-weight-200"><span class="text-warning" data-bind="text:projectPeriod"/></div>
                                	</h2>
                            		
                            		<div class="text-center">
                            			<p class="text-warning g-font-weight-100">현제까지 모든 요청사항에 대한 처리 현황입니다.</p>
					                <div class="d-inline-block g-px-40 g-mx-15 g-mb-30">
					                  <div class="g-font-size-45 g-font-weight-300 g-line-height-1 mb-0" data-bind="text:totalIssueCount"> </div>
					                  <span>전체</span>
					                </div>
					
					                <div class="d-inline-block g-px-40 g-mx-15 g-mb-30">
					                  <div class="g-font-size-45 g-font-weight-300 g-color-red g-line-height-1 mb-0" data-bind="text:errorIssueCount"> </div>
					                  <span>오류</span>
					                </div>
					
					                <div class="d-inline-block g-px-40 g-mx-15 g-mb-30" ">
					                  <div class="g-font-size-45 g-font-weight-300 g-line-height-1 mb-0" data-bind="text:closeIssueCount"></div>
					                  <span>종결</span>
					                </div>
					
					                <div class="d-inline-block g-px-40 g-mx-15 g-mb-30">
					                  <div class="g-font-size-45 g-font-weight-300 g-line-height-1 mb-0" data-bind="text:openIssueCount"></div>
					                  <span>미처리</span>
					                </div>
					              </div>
                            		</div>
                            		<div class="ibox-content ibox-heading">
									<div class="row">
	                            			<div class="col-sm-4 g-mb-15">
	                            			<input data-role="combobox"  
										  	data-placeholder="요청구분"
						                   	data-auto-bind="true"
						                   	data-value-primitive="true"
						                   	data-text-field="name"
						                   	data-value-field="code"
						                   	data-bind="source:issueTypeDataSource, value:filter.ISSUE_TYPE "
						                   	style="width:100%;"/>	
	                            			</div>
	                            			<div class="col-sm-4 g-mb-15">
	                            			<input data-role="combobox"  
										   	data-placeholder="우선순위"
						                   	data-auto-bind="true"
						                   	data-value-primitive="true"
						                   	data-text-field="name"
						                   	data-value-field="code"
						                   	data-bind="source: priorityDataSource, value:filter.PRIORITY"
						                   	style="width:100%;"/>
	                            			</div>
	                            		</div>
	                            		<div class="row">
	                            			<div class="col-sm-4 g-mb-15">
	                            			<input data-role="combobox"  
											   data-placeholder="처리결과"
							                   data-auto-bind="true"
							                   data-value-primitive="true"
							                   data-text-field="name"
							                   data-value-field="code"
							                   data-bind="source:resolutionDataSource, value:filter.RESOLUTION"
							                   style="width: 100%;"/>
	                            			</div>
	                            			<div class="col-sm-4 g-mb-15">
	                            			<input data-role="combobox"  
											   data-placeholder="상태"
							                   data-auto-bind="true"
							                   data-value-primitive="true"
							                   data-text-field="name"
							                   data-value-field="code"
							                   data-bind="source:statusDataSource, value:filter.ISSUE_STATUS"
							                   style="width: 100%;"/>
	                            			</div>
	                            	    </div>		
	                            		<div class="row">
	                            				<div class="col-sm-4 g-mb-15">
	                            					<h5 class="text-light-gray text-semibold"> 시작일 > = 예정일 또는 생성일 </h5>	
	                            					<input data-role="datepicker" style="width: 100%" data-bind="value:filter.START_DATE" placeholder="시작일">
	                            				</div>
	                            				<div class="col-sm-4 g-mb-15">
	                            					<h5 class="text-light-gray text-semibold">종료일 <= 예정일 또는 생성일 </h5>	
	                            					<input data-role="datepicker" style="width: 100%" data-bind="value:filter.END_DATE" placeholder="종료일">
	                            				</div>
	                            				<div class="col-sm-4 g-mb-15 text-center">
												<button type="button" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" data-bind="{click:search ">검색</button>
												<a class="btn u-btn-outline-blue g-mr-10 g-mb-15" href="#" role="button" data-object-id="0" data-action="create" data-action-target="issue">기술지원요청하기</a>
	                            				</div>
	                            		</div>
								</div>
	                             <div class="ibox-content">					                  
						              <!--Issue ListView-->
						              <div class="table-responsive">
						                <table class="table table-bordered u-table--v2">
						                  <thead class="text-uppercase g-letter-spacing-1">
						                    <tr class="g-height-50">
						                    	 <th class="align-middle g-font-weight-300 g-color-black g-min-width-50">ID</th>	
						                      <th class="align-middle g-font-weight-300 g-color-black g-min-width-300">요약</th>
						                      <th class="align-middle g-font-weight-300 g-color-black g-min-width-50">유형</th>
						                      <th class="align-middle g-font-weight-300 g-color-black g-min-width-40">중요도</th>
						                      <th class="align-middle g-font-weight-300 g-color-black g-min-width-40">리포터</th>
						                      <th class="align-middle g-font-weight-300 g-color-black g-min-width-40">담당자</th>
						                      <th class="align-middle g-font-weight-300 g-color-black g-min-width-40">상태</th>
						                      <th class="align-middle g-font-weight-300 g-color-black g-min-width-50">결과</th>
						                      <th class="align-middle g-font-weight-300 g-color-black g-min-width-70 text-nowrap">예정일</th>
						                      <th class="align-middle g-font-weight-300 g-color-black g-min-width-70 text-nowrap">생성일</th>
						                    </tr>
						                  </thead>
						                  <tbody id="issue-listview" ></tbody>
						                </table>
						                <div id="issue-listview-pager" class="g-bg-transparent g-brd-none"></div>
						              </div>
						              <!--End Issue ListView -->
	                            </div>
                        		</div>
                    		</div>
                		</div>
            		</div>
        		</div>
	</section>			
	<!-- FOOTER START -->   
	<#include "/includes/user-footer.ftl">
	<!-- FOOTER END -->  				
	<script type="text/x-kendo-template" id="template">
                    <tr>
                      <td class="align-middle text-center">
                      ISSUE-#: issueId # 	
                      </td>
                      <td class="align-middle">
                     <a class="btn-link text-wrap g-font-weight-200 g-font-size-20" href="\\#" data-action="view" data-object-id="#= issueId #" data-action-target="issue" > #: summary # </a>
                      </td>
                      <td class="align-middle">#: issueTypeName #</td>
                      <td class="align-middle">#: priorityName #</td>
                      <td class="align-middle">
                      	#if ( repoter.userId > 0 ) {#
                      	#= community.data.getUserDisplayName( repoter ) #
                      	#} else {#
                      		
                      	#}#
                      </td>
                      <td class="align-middle">
                      	#if ( assignee.userId > 0 ) {#
                      	#= community.data.getUserDisplayName( assignee ) #
                      	#} else {#
                      	미지정
                      	#}#
                      </td>
                      <td class="align-middle">
                       #if ( statusName != null ){# 
                       #: statusName #
                       #}#
                      </td>
                      <td class="align-middle">
                      #if( resolutionName != null){#
                      #: resolutionName #
                      #}#
                      </td>
                      <td class="align-middle">#if (dueDate != null){ # #: community.data.getFormattedDate( dueDate , 'yyyy-MM-dd') # #}#</td>
                      <td class="align-middle">#: community.data.getFormattedDate( creationDate , 'yyyy-MM-dd') #</td>
                    </tr>
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
			        <h2 class="modal-title">
			        		<i class="icon-svg icon-svg-sm icon-svg-dusk-close-sign" data-bind="visible:isClosed"></i>
			        		<i class="icon-svg icon-svg-sm icon-svg-dusk-open-sign" data-bind="visible:isOpen"></i> 
			        		기술지원요청
			        	</h2>
		      	</div><!-- /.modal-content -->
				<div class="modal-body">				
				 <form>
				 	<h4 class="text-light-gray text-semibold">요청구분 <span class="text-danger" data-bind="visible:editable" >*</span></h4>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="value:issue.issueType, source:issueTypeDataSource, enabled:editable"
		                   style="width:100%;"/>	
		                   		        	  
					</div>	
					
					<!-- issue summary start -->
					<h4 class="text-light-gray text-semibold">요약 <span class="text-danger" data-bind="visible:editable">*</span></h4>		
					<div data-bind="text:issue.summary, invisible:editable" class="g-mb-15 g-brd-2 g-brd-bluegray g-rounded-5 g-brd-around--lg g-pa-15"></div>	
					
				 	<div class="form-group" data-bind="visible:editable">
			            <input type="text" class="form-control" placeholder="요약" data-bind="value: issue.summary">
			        </div> 	
					<!-- issue summary start -->

					<div class="form-group">			
						<div class="row">
						  	<div class="col-sm-6">
						  		<h4 class="text-light-gray text-semibold">리포터</h4>		
						  		<div data-bind="text:issue.repoter.name"></div>
						  	</div>
						    <div class="col-sm-6">
						    		<span class="help-block m-b-none">이름으로 검색하고 선택하면 리포터가 지정됩니다.</span>
						    		<input data-role="combobox"
		                   		 data-placeholder="리포터 이름을 입력하세요."
								 data-filter="contains" 
		                   		 data-text-field="name"
		                   	 	 data-value-field="username"
		                   		 data-bind="value: issue.repoter,
	                              source: userDataSource,
	                              visible: isDeveloper,
	                              enabled: editable"
	                   			 style="width: 100%"/>
						  	</div>
					  	</div>   
					</div>	

					<div class="form-group">			
						<div class="row">
						  	<div class="col-sm-6">
						  		<h4 class="text-light-gray text-semibold">담당자</h4>		
						  		<div data-bind="text:issue.assignee.name"></div>
						  	</div>
						    <div class="col-sm-6">
						    		<span class="help-block m-b-none">이름으로 검색하고 선택하면 담당자가 지정됩니다.</span>
						    		<input data-role="combobox"
		                   		 data-placeholder="담당자 이름을 입력하세요."
								 data-filter="contains"
		                   		 data-text-field="name"
		                   	 	 data-value-field="username"
		                   		 data-bind="value: issue.assignee,
	                              source: userDataSource,
	                              visible: isDeveloper,
	                              enabled: editable"
	                   			 style="width: 100%"/>
						  	</div>
					  	</div>   
					</div>						

					<!-- issue descripton start -->
					<h4 class="text-light-gray text-semibold">상세 내용 <span class="text-danger" data-bind="visible:editable">*</span></h4>	
					<div data-bind="html:issue.description, invisible:editable" class="g-mb-15 g-brd-2 g-brd-blue g-rounded-5 g-brd-around--lg g-pa-15"></div>
					
					<div class="text-editor" class="hide"></div>
					
	 				<!-- issue descripton end -->	
	 				
	 				<h4 class="text-light-gray text-semibold g-mt-20" data-bind="visible: isDeveloper">예정일</h4>	
					<input data-role="datepicker" data-bind="value: issue.dueDate, visible: isDeveloper, enabled: editable" style="width: 100%">
						  		 
	 										
					<h4 class="text-light-gray text-semibold g-mt-15">우선순위 <span class="text-danger" data-bind="visible:editable">*</span></h4>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="value:issue.priority, source:priorityDataSource, enabled:editable"
		                   style="width: 100%;"/>			        	  
					</div>
					 					
					<h4 class="text-light-gray text-semibold">지원방법</h4>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="source:methodsDataSource, visible: isDeveloper, enabled:editable"
		                   style="width: 100%;"/>
					</div>	

						
					<div class="row" >
						<div class="col-sm-6">
							<h4 class="text-light-gray text-semibold">처리결과</h4>
							<div class="form-group">
								<input data-role="dropdownlist"  
								   data-placeholder="선택"
				                   data-auto-bind="true"
				                   data-value-primitive="true"
				                   data-text-field="name"
				                   data-value-field="code"
				                   data-bind="visible: isDeveloper,value:issue.resolution, source:resolutionDataSource, enabled:editable"
				                   style="width: 100%;"/>
							</div>
						</div>
						<div class="col-sm-6">				
							<h4 class="text-light-gray text-semibold">처리일자</h4>
							<input data-role="datepicker" data-bind="value: issue.resolutionDate, visible: isDeveloper, enabled: editable" style="width: 100%">
						</div>
					</div>	
					<h4 class="text-light-gray text-semibold">상태</h4>
					<div class="form-group">
						<input data-role="dropdownlist"  
						   data-placeholder="선택"
		                   data-auto-bind="true"
		                   data-value-primitive="true"
		                   data-text-field="name"
		                   data-value-field="code"
		                   data-bind="visible: isDeveloper,value:issue.status, source:statusDataSource, enabled:editable"
		                   style="width: 100%;"/>
					</div>																													
				</form>   
				
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal" data-bind="visible:editable" >취소</button>
					<button type="button" class="btn btn-primary" data-bind="click:saveOrUpdate, visible:editable">확인</button>
					
					<button type="button" class="btn btn-default" data-dismiss="modal" data-bind="invisible:editable">취소</button>		
					<button type="button" class="btn btn-primary" data-bind="invisible:editable,click:edit">수정</button>			
				</div>
			</div>
		</div>
	</div>	 
</html>
</#compress>
