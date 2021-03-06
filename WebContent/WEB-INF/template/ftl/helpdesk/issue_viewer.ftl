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
	
	var __scmId = <#if RequestParameters.issueId?? >${RequestParameters.scmId}<#else>0</#if>;
	var __projectId = <#if RequestParameters.projectId?? >${RequestParameters.projectId}<#else>0</#if>;
	var __observable ;
	
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
			"summernote-ko-KR"           : "/js/summernote/lang/summernote-ko-KR",
			"dropzone"					: "/js/dropzone/dropzone"
		}
	});
	
	require([ "jquery", "kendo.ui.core.min",  "kendo.culture.ko-KR.min", "community.data", "community.ui.core", "bootstrap", "summernote.min", "summernote-ko-KR", "dropzone"], function($, kendo ) {	
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
           		
        var featuresTo = $('#features');   	
       
		__observable = new community.ui.observable({ 
			currentUser : new community.model.User(),			
			isDeveloper : false,
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser)
				$this.set('isDeveloper', isDeveloper());
			}
    	}); 
    		
		//createIssueListView(observable);		
		var renderTo = $('#page-top');
		renderTo.data('model', observable);		
		community.ui.bind(renderTo, observable );	 
		 
	});


	function isDeveloper(){ 
		return __observable.currentUser.hasRole('ROLE_DEVELOPER') ;
	} 
 			
	</script>	
	<style>
	.k-widget.k-tooltip-validation {
		background-color: transparent;
	    border: 0;
	    color: red;
	    font-weight: 100;
	    padding-top: 5px;	
	}
	</style>	
</head>
<body id="page-top" class="landing-page no-skin-config">
	<!-- NAVBAR START -->   
	<#include "includes/user-top-navbar.ftl">
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
				<a class="btn btn-lg u-btn-blue g-mr-10 g-mt-25 g-font-weight-200" href="#" role="button" data-object-id="0" data-action="create" data-kind="issue">기술지원요청하기</a>
			</p>            
            <!-- End Promo Blocks - Input -->
          </div>
        </div>
      </div>
    </section>
	<section id="features" class="services">
		<div class="wrapper wrapper-content">
            		<div class="container">            
                		<div class="row">
                    		<div class="col-lg-12">
                        		<div class="ibox g-mb-0">
                            		<div class="ibox-title g-pl-0 g-pb-0">
	                            		<a href="#" class="back" data-bind="click:back" data-toggle="tooltip" data-placement="bottom" data-original-title="목록으로 이동합니다.">
									<i class="icon-svg icon-svg-sm icon-svg-ios-back"></i>
									</a>
									<div class="text-right">
										<i class="icon-svg icon-svg-sm icon-svg-dusk-close-sign" data-bind="visible:isClosed" style="display: none;"></i>
										<i class="icon-svg icon-svg-sm icon-svg-dusk-open-sign" data-bind="visible:isOpen" style="display: none;"></i>		
										<i class="icon-svg icon-svg-sm icon-svg-dusk-warn" data-bind="visible:isHurry" style="display: none;"></i>									
									</div>
                            		</div>	                            
                        		</div>
                    		</div>
                		</div>
					<div class="row justify-content-between">
						<div class="col-lg-9 g-mb-80">
							<div class="g-pr-20--lg">
								<!-- Issue Blocks -->
								<article class="g-mb-100" id="issue-edit-form">
									<div class="g-mb-30">
										<hr class="g-brd-gray-light-v4 g-mt-0 mb-0">
										<span data-bind="text:project.name"></span> 
										<span class="text-warning g-ml-15 g-mb-10" data-bind="text:projectPeriod"></span>
										
										<h4 class="h6 text-light-gray text-semibold" data-bind="visible:editMode">요약 <span class="text-danger" >*</span></h4>		
										<h2 class="h4 g-color-black g-font-weight-600 mb-3">						
											<a class="u-link-v5 g-color-black g-color-primary--hover" href="#!" data-bind="text:issue.summary, invisible:editMode"></a>
										</h2>
	 									<div class="form-group" data-bind="visible:editMode">
								            <input type="text" name="issue-summary" class="form-control" placeholder="간략하게 요약해주세요" data-bind="value: issue.summary" required validationMessage="요약정보를 입력하여주세요." />
								        </div>
										<div class="row">
								            <div class="col-sm-6">
								              <!-- Issue Type  -->
								              <h4 class="h6 g-mb-5">요청구분 <span class="text-danger" data-bind="visible:editMode">*</span></h4>
								              <input name="issue-type"
								               data-role="dropdownlist"  
								               placeholder = "어떤종류의 요청인지를 선택하여 주세요"
											   data-placeholder="어떤종류의 요청인지를 선택하여 주세요"
							                   data-auto-bind="true"
							                   data-value-primitive="true"
							                   data-text-field="name"
							                   data-value-field="code"
							                   data-bind="value:issue.issueType, source:issueTypeDataSource, enabled:editMode"
							                   required data-required-msg="어떤 종류의 요청인지를 선택하여 주세요"
							                   style="width:100%;"/>
							                   <span class="k-widget k-tooltip k-tooltip-validation k-invalid-msg" data-for="issue-type" role="alert" style="display:none;"></span>							                    
								              <!-- End Issue Type -->
								            </div>					
								            <div class="col-sm-6">
								              <!-- Status -->
								              <h4 class="h6 g-mb-5">상태</h4>
								              <input data-role="dropdownlist"  
											   data-placeholder="선택"
							                   data-auto-bind="true"
							                   data-value-primitive="true"
							                   data-text-field="name"
							                   data-value-field="code"
							                   data-bind="value:issue.status, source:statusDataSource, enabled:editModeForAssignee"
							                   style="width: 100%;"/>
								              <!-- End Status -->
								            </div>
								         </div>
								         <div class="row">
								            <div class="col-sm-6">
								              <!-- Priority Type  -->
								              <h4 class="h6 g-mb-5">우선순위 <span class="text-danger" data-bind="visible:editMode">*</span></h4>
								              <input data-role="dropdownlist"  
								               placeholder = "우선순위를 선택하여 주세요"
											   data-placeholder="선택"
							                   data-auto-bind="true"
							                   data-value-primitive="true"
							                   data-text-field="name"
							                   data-value-field="code"
							                   data-bind="value:issue.priority, source:priorityDataSource, enabled:editMode"
							                   style="width: 100%;"/>	
								              <!-- End Priority -->
								            </div>					
								            <div class="col-sm-6">
								              <!- Resolution -->
								              <h4 class="h6 g-mb-5">결과</h4>
								              <input data-role="dropdownlist"  
											   data-placeholder="선택"
							                   data-auto-bind="true"
							                   data-value-primitive="true"
							                   data-text-field="name"
							                   data-value-field="code"
							                   data-bind="value:issue.resolution, source:resolutionDataSource, enabled:editModeForAssignee"
							                   style="width: 100%;"/>
								              <!-- End Resolution -->
								            </div>
								         </div>
										 <div class="row" data-bind="visible: isDeveloper" style="display:none;">
								            <div class="col-sm-6">
								              <!-- Priority Type  -->
								              <h4 class="h6 g-mb-5">완료예정일</h4>
								              <input data-role="datepicker" data-bind="value: issue.dueDate, visible: isDeveloper, enabled: editModeForAssignee" style="width: 100%">
								              <!-- End Priority -->
								            </div>					
								            <div class="col-sm-6">
								              <!- Resolution -->
								              <h4 class="h6 g-mb-5">처리일자</h4>
								              <input data-role="datepicker" data-bind="value: issue.resolutionDate, visible: isDeveloper, enabled: editModeForAssignee" style="width: 100%">
								              <!-- End Resolution -->
								            </div>
								         </div>										         								         
								    </div>
									<div class="g-mb-30">     
										<div class="u-heading-v1-4 g-bg-main g-brd-gray-light-v2 g-mb-20">
					                     	<h2 class="h3 u-heading-v1__title g-mt-0 g-font-size-20">설명</h2>
										</div>
										<div id="issue-description-editor" class="hide"></div>
										<section class="g-mb-15 g-brd-2 g-brd-blue g-rounded-5 g-brd-around--lg g-pa-15 issue-body" data-bind="html:issue.description, invisible:editMode"></section>
									</div>
									<div class="g-mb-30" data-bind="invisible:isNew" style="display:none;">
										<div class="u-heading-v1-4 g-bg-main g-brd-gray-light-v2 g-mb-20">
					                      	<h2 class="h3 u-heading-v1__title g-mt-0 g-font-size-20">첨부파일</h2>
										</div>
										<form action="" method="post" enctype="multipart/form-data" id="issue-attachment-dropzone" class="u-dropzone g-rounded-5 g-brd-style-dashed" data-bind="visible:editMode">
												<div class="dz-default dz-message">
					                       	 		<i class="icon-svg icon-svg-dusk-upload"></i>
					                       	 		<span class="note">업로드할 이슈 관련 첨부파일은 이곳에 드레그하여 놓아주세요.</span>
					                       	 	</div>       
					                       	 	<div class="dropzone-previews">                       	 
					                       	 	</div>                 
												 <div class="fallback">
												     <input name="file" type="file" multiple style="display:none;"/>
												 </div>
										</form> 	
										
					                     <div class="table-responsive m-t-sm">						
					                     	<button class="btn u-btn-outline-blue g-mr-10 g-mb-15 pull-right" type="button" role="button" data-bind="click:back, visible:isNewAndSaved" style="">확인</button>	
							                <table class="table  u-table--v1">
							                	<!--
							                  	<thead class="text-uppercase g-letter-spacing-1">
							                    		<tr>
							                      		<th class="g-font-weight-100 g-color-black" width="60">&nbsp;</th>
							                      		<th class="g-font-weight-100 g-color-black g-min-width-200">파일</th>
				                       			 		<th class="g-font-weight-100 g-color-black text-right" width="100">크기(바이트)</th>
				                    					</tr>
				                  				</thead>
				                  			-->	
				                  				<tbody id="issue-attachment-listview" class="no-border" style="min-height:50px;">		                  			
							                		</tbody>
							            		</table>
							            </div>   										
									</div>
								</article>
								
								<div class="g-mb-30" data-bind="invisible:isNew" style="display:none;">
									<div class="u-heading-v1-4 g-bg-main g-brd-gray-light-v2 g-mb-20">
					                      <h2 class="h3 u-heading-v1__title g-mt-0 g-font-size-20">활동</h2>
									</div>
									<div class="tabs-container g-brd-grayblue">
										<ul class="nav nav-tabs">
											<li><a data-toggle="tab" href="#editor-options-tab-1" aria-expanded="false" data-kind="comments">댓글</a></li>
											<li><a data-toggle="tab" href="#editor-options-tab-2" aria-expanded="false" data-kind="activities">활동</a></li>
											<li><a data-toggle="tab" href="#editor-options-tab-3" aria-expanded="false" data-kind="properties">속성</a></li>
										</ul>
										<div class="tab-content">
											<div id="editor-options-tab-1" class="tab-pane active">
												<div class="panel-body">
												<div class="text-right g-brd-grayblue g-brd-1 g-brd-top-0 g-brd-left-0 g-brd-right-0 g-brd-style-solid g-mb-15">
												<a href="#!" class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" data-kind="comment" data-action="create" data-target="#issue-comment-listview"  data-object-id="0" data-parent-comment-id="0" >
								                    	<span class="">
								                      <i class="icon-bubble g-mr-3"></i>
								                      댓글쓰기
								                    </span>
								                </a>
												</div>
												<div id="issue-comment-listview" class="no-border" style="min-height:50px;"></div></div>
											</div>
											<div id="editor-options-tab-2" class="tab-pane">
												<div class="panel-body">
												아직 지원하지 않는 기능입니다. 
												</div>
											</div>
											<div id="editor-options-tab-3" class="tab-pane">
												<div class="panel-body">
												아직 지원하지 않는 기능입니다. 
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<!-- End Issue Blocks -->
						</div>
						<div class="col-lg-3 g-brd-left--lg g-brd-gray-light-v4 g-mb-80">
							<div class="g-pl-20--lg">
								<!-- Buttons  -->
								<div class="g-mb-50">
									<p class="g-font-size-17">
									등록일 : <span class="g-color-gray-dark-v4 " data-bind="text: formatedCreationDate"></span>  
									</p>	  
									<p data-bind="invisible:isNew" class="g-font-size-17" style="display:none;">
									마지막 수정일 : <span class="g-color-gray-dark-v4" data-bind="text: formatedModifiedDate"></span>  
									</p>	   
									<h3 class="h5 g-color-black g-font-weight-600 mb-4"></h3>
									<button class="btn u-btn-outline-blue g-mr-10 g-mb-15" type="button" role="button" data-bind="click:edit, visible:editable, invisible:editMode" style="display:none;">수정</button>
									<button class="btn u-btn-outline-blue g-mr-10 g-mb-15" type="button" role="button" data-bind="click:saveOrUpdate, visible:editMode" style="display:none;">저장</button>
									<button class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" type="button" role="button" data-bind="click:cancle, visible:editMode" style="display:none;">최소</button>
								</div>
								<!-- End Links -->
								<hr class="g-brd-gray-light-v4 g-my-50">
								<!-- Assigner -->
								<div class="g-mb-50">
									<h3 class="h5 g-color-black g-font-weight-600 mb-4">담당자</h3>
									<div class="media g-mb-25">
                  						<div class="media-body">
						                    <h4 class="h5 g-color-primary mb-0">
						                    		<img data-bind="attr:{ src: assigneeAvatarSrc  }"  width="64" height="64" src="/images/no-avatar.png" class="d-flex g-width-40 g-height-40 rounded-circle mr-2" alt="image">
										    		<span data-bind="text:issue.assignee.name"></span></h4>						                                 
										</div>
										<#if SecurityHelper.isUserInRole("ROLE_DEVELOPER") >
										
										<button class="btn btn-md u-btn-outline-indigo g-mb-15 g-mr-10 " type="button" role="button" data-bind="click:assignMe, invisible:isAssigned">나를 담당자로 지정합니다.</button>
										<span class="help-block" data-bind="visible:isDeveloper">또는 이름 또는 아이디로 검색할 수 있습니다.</span>
										<input data-role="combobox"
				                   		 data-placeholder="담당자 이름을 입력하세요."
										 data-filter="contains"
				                   		 data-text-field="name"
				                   	 	 data-value-field="username"
				                   	 	 data-autoBind: false,
				                   		 data-bind="value: issue.assignee, 
			                              source: userDataSource,
			                              visible: isDeveloper,
			                              enabled: editModeForAssignee,
			                              events:{ change : selectAssignee }"
			                   			 style=""/>		
			                   			 </#if>	
									</div>
								</div>
								<!-- End Repoter -->
								<hr class="g-brd-gray-light-v4 g-mt-50 mb-0">
								<!-- Repoter -->
								<div class="g-mb-50">
									<h3 class="h5 g-color-black g-font-weight-600 mb-4">리포터</h3>
									<div class="media g-mb-25">
                  						<div class="media-body">
						                    <h4 class="h5 g-color-primary mb-0">
						                    <img data-bind="attr:{ src: repoterAvatarSrc  }"  width="64" height="64" src="/images/no-avatar.png" class="d-flex g-width-40 g-height-40 rounded-circle mr-2" alt="image">
										    <span data-bind="text:issue.repoter.name"></span></h4>
						                    <span class="help-block" data-bind="visible:isDeveloper">이름 또는 아이디로 검색할 수 있습니다.</span>             
										</div>
										<input data-role="combobox"
				                   		 data-placeholder="리포터 이름을 입력하세요."
										 data-filter="contains" 
				                   		 data-text-field="name"
				                   	 	 data-value-field="username"
				                   		 data-bind="value:issue.repoter, 
			                              source: userDataSource,
			                              visible: isDeveloper,
			                              enabled: editModeForAssignee,
			                              events:{ change : selectRepoter }"
			                   			 style=""/>			
									</div>
								</div>	                   			 
								<!-- End Repoter -->
								<hr class="g-brd-gray-light-v4 g-my-50">
								<!-- Tags -->
								<div class="g-mb-40">
									<h3 class="h5 g-color-black g-font-weight-600 mb-4"></h3>
									<!--
									<ul class="u-list-inline mb-0">
									<li class="list-inline-item g-mb-10">
									<a class="u-tags-v1 g-color-gray-dark-v4 g-color-white--hover g-bg-gray-light-v5 g-bg-primary--hover g-font-size-12 g-rounded-50 g-py-4 g-px-15" href="#!">Design</a>
									</li>
									</ul>-->
									<!-- Buttons  -->
									<div class="g-mb-50">
										<button class="btn u-btn-outline-blue g-mr-10 g-mb-15" type="button" role="button" data-bind="click:edit, visible:editable, invisible:editMode" style="display:none;">수정</button>
										<button class="btn u-btn-outline-blue g-mr-10 g-mb-15" type="button" role="button" data-bind="click:saveOrUpdate, visible:editMode" style="display:none;">저장</button>
										<button class="btn u-btn-outline-darkgray g-mr-10 g-mb-15" type="button" role="button" data-bind="click:cancle, visible:editMode" style="display:none;">최소</button>
									</div>
									<!-- End Links -->
								</div>
								<!-- End Tags -->
							</div>
						</div>
					</div>                		
                		<!-- END ISSUE -->
            		</div>
        		</div>
	</section>			
	<!-- FOOTER START -->   
	<#include "includes/user-footer.ftl">
	<!-- FOOTER END -->  				

	<!-- issue comment modal -->
	<div class="modal fade comment-composer" id="issue-comment-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="colored-line"></div>
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<i aria-hidden="true" class="icon-svg icon-svg-sm icon-svg-ios-close m-t-xs"></i>
					</button>
					<h2 class="modal-title">
						<img src="/images/no-avatar.png" data-bind="attr:{ src: autherAvatarSrc }" class="d-flex g-width-35 g-height-35 rounded-circle mr-2" />
						<small>댓글쓰기</small>
					</h2>
				</div>
				<div class="modal-body no-padding">
					<div class="text-editor">
			           <!-- <textarea class="form-control" placeholder="내용" data-bind="value:text"></textarea>	-->		            
			            <div id="issue-comment-body" contenteditable="true" ></div>	   	            
				    </div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" data-bind="{click:save}">확인</button>
				</div>
			</div>
		</div>
	</div>	
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
		                   		 data-bind="value: issue.repotes,
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
		                   		 data-bind="value: issue.assignees,
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
	<script type="text/x-kendo-template" id="template">
                    <tr>
                      <td class="align-middle text-center">
                      ISSUE-#: issueId # 	
                      </td>
                      <td class="align-middle">
                     <a class="btn-link text-wrap g-font-weight-200 g-font-size-20" href="javascript:void();" data-action="edit" data-object-id="#= issueId #" data-action-target="issue" > #: summary # </a>
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
		
	<!-- issue comment template -->
	<script type="text/x-kendo-template" id="comment-template">
	<div class="social-talk p-xxs">
		<div class="media social-profile clearfix">
			<a class="pull-left">
				<img src="#= community.data.getUserProfileImage( user ) #" alt="profile-picture">
			</a>
			<div class="media-body">
				<div class="g-mb-15">
                    <h5 class="h5 g-color-gray-dark-v1 mb-0">#= community.data.getUserDisplayName( user ) #</h5>
                    <span class="g-color-gray-dark-v4 g-font-size-12">#: kendo.toString( new Date(creationDate), "g") #</span>
                 </div>
				<!--
				<span class="font-bold">#= community.data.getUserDisplayName( user ) #</span>
				<span class="text-muted">#: kendo.toString( new Date(creationDate), "g") #</span>
				-->
				<div class="g-py-10 g-font-size-16">
              	#= body #	
				</div>
				<div class="list-inline-item g-mr-20">
					<button class="btn btn-sm btn-link" type="button" data-kind="comment" data-action="list" data-object-id="#:objectId#" data-comment-id="#:commentId#" data-target="\\#message-#:objectId#-comment-#:commentId#-listview" aria-expanded="false" aria-controls="message-#:objectId#-comment-#:commentId#-listview"> <i class="icon-bubbles"></i> 답글보기 (<span>#: replyCount #</span>)</button>
					<button class="btn btn-sm btn-link" type="button" data-kind="comment" data-action="create" data-object-id="#: objectId #" data-parent-comment-id="#: commentId#" ><i class="icon-bubble"></i> 답글쓰기</button>	
				</div>		
				<div class="collapse no-border comment-reply" id="message-#:objectId#-comment-#:commentId#-listview"></div>		
			</div>
		</div>
	</div>	
	</script>  
    <script type="text/x-kendo-template" id="attachment-template">   
	<tr>
		<td class="align-middle text-center" width="50">		
			#if ( contentType.match("^image") ) {#	
			<img class="g-width-50 g-height-50" src="#= community.data.getAttachmentThumbnailUrl( data, true) #" />
			# }else if( contentType === "application/pdf" ){ #		
			<img class="g-brd-around g-brd-gray-light-v4 g-width-50 g-height-50" src="#= community.data.getAttachmentThumbnailUrl( data, true) #" />
			# } else { #			
				<i class="icon-svg icon-svg-sm icon-svg-dusk-attach m-t-xs"></i>
			# } #
		</td> 
		<td class="align-middle">
			<a class="btn btn-xs icon-svg-btn" href="#: community.data.getAttachmentUrl(data) #" target="_blank" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="첨부파일 다운로드">
				<i class="icon-svg icon-svg-xs m-t-xs icon-svg-dusk-desktop-download"></i>
			</a>
			#: name # 
		</td>
		<td class="align-middle text-right"><span class='text-muted'>#: formattedSize() #</span></td>
	</tr>            	        	        	
	</script>  
       		     		     		
</body>     		 
</html>
</#compress>
