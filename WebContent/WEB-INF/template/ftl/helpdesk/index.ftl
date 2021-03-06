<#ftl encoding="UTF-8"/>
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
	<!--<link href="/css/kendo.ui.core/web/kendo.common-bootstrap.core.css" rel="stylesheet" type="text/css" />-->
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
  		
  	<!-- Carousel CSS -->	
  	<link href="<@spring.url "/assets/vendor/slick-carousel/slick/slick.css"/>" rel="stylesheet" type="text/css" />	
  		
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
	        "community.ui.carousel" : { "deps" :['jquery'] }
	    },
		paths : {
			"jquery"    				: "/js/jquery/jquery-2.2.4.min",
			"bootstrap" 				: "/js/bootstrap/3.3.7/bootstrap.min",
			"kendo.ui.core.min" 		: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"community.ui.core" 		: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data",
			"community.ui.carousel"     : "/js/community.ui/community.ui.carousel",
			"slick"    			 		: "/assets/vendor/slick-carousel/slick/slick.min"					
		}
	});
	
	require([ 
		"jquery", 
		"kendo.ui.core.min",  
		"kendo.culture.ko-KR.min", 
		"community.data", 
		"community.ui.core", 
		"bootstrap",
		"community.ui.carousel",
		"slick"
		], function($, kendo ) {		
		
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
		
		// init carousel 
		$.community.ui.Carousel.init('.js-carousel');
		
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
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser);
			}
    		});
	});
	</script>		
</head>
<body id="page-top" class="landing-page no-skin-config">
	<!-- NAVBAR START -->   
	<#include "includes/user-top-navbar.ftl">
	<!-- NAVBAR END -->  
<div id="inSlider" class="carousel carousel-fade" data-ride="carousel">
    <ol class="carousel-indicators">
        <li data-target="#inSlider" data-slide-to="0" class="active"></li>
        <!--<li data-target="#inSlider" data-slide-to="1"></li>-->
    </ol>
    <div class="carousel-inner" role="listbox">
        <div class="item active">
            <div class="container">
                <div class="carousel-caption blank">
                    <h1>기술 지원 서비스</h1>
                    <p>
                    비용은 줄이고 서비스의 품질은 높이고<br/>
                    최적화된 유지보수,  지금 만나보십시오!
                    </p>                    
                    <p>
 					<a href="tel:070-7432-2657" class="btn btn-xl u-btn-pink u-btn-hover-v2-2 g-letter-spacing-0_5 text-uppercase g-rounded-50 g-px-30 g-mr-10 g-mb-15">
                        <span class="pull-left text-left g-font-size-30">
                          070-7432-2657
                          <span class="d-block g-font-size-14">helpdesk@podosw.com</span>
                        </span>
                        <i class="fa fa-volume-control-phone float-right g-font-size-60 g-ml-15"></i>
                      </a>                        
                    </p>
                </div>
                <div class="carousel-image wow zoomIn">
                    <img src="/images/blade-runner-guy-red-transparent-bg.png" alt="laptop"/>
                </div>                
            </div>   
            <!-- Set background for slide in css -->
            <div class="header-back one"></div>
        </div><!-- /.item  -->
        <!--
        <div class="item">
			<div class="container">
                <div class="carousel-caption">
                    <h1>
                    유지보수 재약정 수수료 정책 안내					
					</h1>
                    <p>
                    무상보증 또는 유상 유지보수 계약 종료 후, <br/>유지보수 계약없이 90 일 이상("실효 기간")이 경과된 시스템에 대한 유지보수 계약 체결 시,  <br/>
                    2018년 1월 1일부터는 유지보수 재약정 수수료가 부과됩니다.  <br/>
                    재약정 수수료는 무상보증 또는 유상 유지보수 계약 종료 이후, 실효 기간 일수에 근거하여 산정됩니다.  <br/>
                    가격 결정 및 관련 유지보수 서비스에 대한 정보에 대해서는, 귀사 담당 영업 대표에게 연락주시기 바랍니다. <br/>
                    </p> 
                </div>
            </div>           
            <div class="header-back two"></div>
        </div>  
    		-->
    		</div>
    		<!-- 
	    <a class="left carousel-control" href="#inSlider" role="button" data-slide="prev">
	        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
	        <span class="sr-only">Previous</span>
	    </a>
	    <a class="right carousel-control" href="#inSlider" role="button" data-slide="next">
	        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
	        <span class="sr-only">Next</span>
	    </a>
	   -->
	</div>
		<div class="g-mb-50">

              <section class="g-bg-gray-light-v5 g-py-50 g-px-30">
                <div class="container">
                  <div class="row">
                    <div class="col-md-9 align-self-center">
                      <h3 class="h4">유지보수 재약정 수수료 정책 안내	</h3>
                      <p class="lead g-mb-20 g-mb-0--md">
                      무상보증 또는 유상 유지보수 계약 종료 후, <br/>유지보수 계약없이 90 일 이상("실효 기간")이 경과된 시스템에 대한 유지보수 계약 체결 시,  <br/>
                    2018년 1월 1일부터는 유지보수 재약정 수수료가 부과됩니다.  <br/>
                    재약정 수수료는 무상보증 또는 유상 유지보수 계약 종료 이후, 실효 기간 일수에 근거하여 산정됩니다.  <br/>
                    가격 결정 및 관련 유지보수 서비스에 대한 정보에 대해서는, 귀사 담당 영업 대표에게 연락주시기 바랍니다. <br/>
                      </p>
                    </div>
					<!-- 
                    <div class="col-md-3 align-self-center text-md-right">
                    <a href="#!" class="btn btn-lg u-btn-inset u-btn-inset--rounded u-btn-darkgray g-font-weight-200 g-letter-spacing-0_5 text-uppercase g-brd-2 g-rounded-50 g-mr-10 g-mb-15">
                    <i class="fa fa-check-circle g-mr-3"></i>
                    유지보수 서비스 소개자료 다운로드
                  </a>
                  -->
                    </div>
                  </div>
                </div>
              </section>
          </div>

		<section id="features" class="container services">
		
		    <div class="row">
		        <div class="col-sm-3">
		            <h2>HELPDESK 운영</h2>
		            <p>전담 유지보수 인력이외에도 자사 HELPDESK에는 전문 유지 보수 인력이 항시 대기하고 있어 시스템의 안정적인 상태 유지, 
		            	오류 발생 시 즉각적인 대응이 가능하며 업무담당자 변경에도 업무 연속성 확보할 수 있습니다.</p>
		        </div>
		        <div class="col-sm-3">
		            <h2>HELPDESK 운영시간</h2>
		            <p>
		            메일, 전화, 온라인( csr.podosw.com ) 를 통하여 서비스 접수가 진행되며<br/>
		            메일, 전화, 원격등의 기술지원방법으로 처리 됩니다.</p>
					<ul>
						<li>월~금 9:00 ~ 18:00</li>
						<li>토요일, 일요일, 공휴일 휴무</li>
						<li class="text-danger">비상시 비상연락망을 통하여 응대</li>
					</ul>
		        </div>
		    </div>
		</section>


		<section id="pricing" class="">
		    <div class="container">
		        <div class="row m-b-lg">
		            <div class="col-lg-12 text-center">
		                <div class="navy-line"></div>
		                <h1>소프트웨어 기술 지원 서비스</h1>
		                <p>조직은 경쟁력을 유지하기 위해 가동 중단 또는 날짜가 지난 소프트웨어를 보유할 여유가 없습니다. 거의 모든 질문 또는 문제점에 대한 도움을 제공할 수 있는 심도 깊은 기술 지원에 액세스할 수 있어야 합니다. 
							숙련된 지원 담당자와 전화 또는 전자 문제점 제출을 통해 연락할 수 있으며 이들은 다양한 소프트웨어 문제점에 대한 도움을 제공할 수 있습니다. </p>
		            </div>
		        </div>
		        <div class="row">
		            <div class="col-lg-6 wow zoomIn animated" style="visibility: visible;">
		                <ul class="pricing-plan list-unstyled">
		                    <li class="pricing-title" style="background:#ccc;">
		                        하자보수
		                    </li>
		                    <li class="pricing-desc">
		                       구축후 소프트웨어 결함에 대한 1년간 하자보수를 지원합니다.
		                    </li>
		                    <li class="pricing-price">
		                        <span>무상</span>
		                    </li>
		                    <li>
							<table class="table table-bordered">
                                <thead>
                                <tr>
                                    <th colspan="2">기술지원방법</th> 
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td class="align-middle" width="100">전화</td>
                                    <td class="align-middle text-left">전화: 고객 요청 접수, 문의 응답 및 문제 해결 </td> 
                                </tr>
                                <tr>
                                    <td class="align-middle" width="100">온라인</td>
                                    <td class="align-middle text-left">온라인: 자체 CSR 사이트를 통한 요청 접수 및 지원, 메일을 통한 요청 접수 및 지원</td> 
                                </tr>
                                <tr>
                                    <td class="align-middle" width="100">원격</td>
                                    <td class="align-middle text-left">엔지니어가 고객사에 방문하여 지원 <br/>(방문지원의 경우 추가비용 발생)</td> 
                                </tr>
                                <tr>
                                    <td class="align-middle" width="100">방문</td>
                                    <td class="align-middle text-left">엔지니어가 고객사에 방문하여 지원 <br/>(방문지원의 경우 추가비용 발생)</td> 
                                </tr>                                                                                                 
                                </tbody>
                            </table>
		                    </li>                    
		                    <li>
		                    
							<table class="table table-bordered">
                                <thead>
                                <tr>
                                    <th colspan="2">소프트웨어 유지보수</th> 
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td class="align-middle" width="100">설계오류</td>
                                    <td class="align-middle text-left">소프트웨어의 하자 발생 원인이 설계상의 오류인 경우</td> 
                                </tr>
                                <tr>
                                    <td class="align-middle" width="100">코딩오류</td>
                                    <td class="align-middle text-left">소프트웨어의 하자 발생 원인이 코드상의 오류인 경우, 코딩상의 오류를 수정하여 패치 형태로 제공</td> 
                                </tr>                                                                                               
                                </tbody>
                            </table>		
                            <span class="text-danger">사용자 및 운영자의 고의나 과실 및 천재지변에 의한 장애는 제외 </span>		                      
		                    </li>
		                </ul>
		            </div> 
		            <div class="col-lg-6 wow zoomIn animated" style="visibility: visible;">
		                <ul class="pricing-plan list-unstyled">
		                    <li class="pricing-title">
		                        유상 유지보수
		                    </li>
		                    <li class="pricing-desc">
		                        소프트웨어 결함에 대한 지원 및 기능개선 건들에 대한 지원이 포함됩니다.
		                    </li>
		                    <li class="pricing-price">
		                        <span>구축비용의 10%~15%</span>
		                    </li>
		                    <li> 
							<table class="table table-bordered">
                                <thead>
                                <tr>
                                    <th colspan="2">기술지원방법</th> 
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td class="align-middle" width="100">전화</td>
                                    <td class="align-middle text-left">전화: 고객 요청 접수, 문의 응답 및 문제 해결 </td> 
                                </tr>
                                <tr>
                                    <td class="align-middle" width="100">온라인</td>
                                    <td class="align-middle text-left">온라인: 자체 CSR 사이트를 통한 요청 접수 및 지원, 메일을 통한 요청 접수 및 지원</td> 
                                </tr>
                                <tr>
                                    <td class="align-middle" width="100">원격</td>
                                    <td class="align-middle text-left">엔지니어가 고객사에 방문하여 지원 <br/>(방문지원의 경우 추가비용 발생)</td> 
                                </tr>
                                <tr>
                                    <td class="align-middle" width="100">방문</td>
                                    <td class="align-middle text-left">엔지니어가 고객사에 방문하여 지원 <br/>(방문지원의 경우 추가비용 발생)</td> 
                                </tr>                                                                                                 
                                </tbody>
                            </table>                                                               
		                    </li>   
		                    <li>
		                    <table class="table table-bordered">
                                <thead>
                                <tr>
                                    <th colspan="2">소프트웨어 유지보수</th> 
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td class="align-middle" width="100">설계 오류</td>
                                    <td class="align-middle text-left">소프트웨어의 하자 발생 원인이 설계상의 오류인 경우</td> 
                                </tr>
                                <tr>
                                    <td class="align-middle" width="100">코딩 오류</td>
                                    <td class="align-middle text-left">소프트웨어의 하자 발생 원인이 코드상의 오류인 경우, 코딩상의 오류를 수정하여 패치 형태로 제공</td> 
                                </tr>  
                                <tr>
                                    <td class="align-middle" width="100">장애 및 운영지원</td>
                                    <td class="align-middle text-left">장애 및 운영을 위한 기술지원</td> 
                                </tr> 
                                <tr>
                                    <td class="align-middle" width="100">기능 변경</td>
                                    <td class="align-middle text-left">월별 기능개선 건들에 대한 총 비용이 월 유지보수 비용을 넘을 경우 이월하여 처리하거나 유상으로 처리</td> 
                                </tr>    
                                <tr>
                                    <td class="align-middle" width="100">기능 추가</td>
                                    <td class="align-middle text-left">월별 기능추가 건들에 대한 총 비용이 월 유지보수 비용을 넘을 경우 이월하여 처리하거나 유상으로 처리</td> 
                                </tr>                                                                                                                                                             
                                </tbody>
                            </table>		

		                    </li>
		                    <li>
		                        정기정검 : 원격 , 방문 (방문지원의 경우 추가비용이 발생됩니다.)
		                    </li>		                             
		                </ul>
		            </div>
		        </div>
		        <div class="row m-t-lg ">
		            <div class="col-lg-8 col-lg-offset-2 text-center m-t-lg g-mb-50">
		                <p>* 소프트웨어 유지보수 대상은 (주)포도소프트웨어에 의하여 구축되었고 현재 운영중인 소프트웨어에 대한 유지보수를 의미합니다.</p>
		            </div>
		        </div>
		    </div>
		
		</section>
		
    <!-- Clients -->
    <div class="container g-py-70">
      <div class="js-carousel" data-infinite="true" data-autoplay="true" data-slides-show="6" data-responsive='[{
               "breakpoint": 1200,
               "settings": {
                 "slidesToShow": 6
               }
             }, {
               "breakpoint": 992,
               "settings": {
                 "slidesToShow": 5
               }
             }, {
               "breakpoint": 768,
               "settings": {
                 "slidesToShow": 4
               }
             }, {
               "breakpoint": 576,
               "settings": {
                 "slidesToShow": 2
               }
             }, {
               "breakpoint": 446,
               "settings": {
                 "slidesToShow": 1
               }
             }]'>
        <div class="js-slide u-block-hover">
          <img class="mx-auto g-width-80 u-block-hover__main--grayscale g-opacity-0_3 g-opacity-1--hover g-cursor-pointer" src="/assets/img-temp/200x100/img1.png" alt="Image description">
        </div>

        <div class="js-slide u-block-hover">
          <img class="mx-auto g-width-80 u-block-hover__main--grayscale g-opacity-0_3 g-opacity-1--hover g-cursor-pointer" src="/assets/img-temp/200x100/img2.png" alt="Image description">
        </div>

        <div class="js-slide u-block-hover">
          <img class="mx-auto g-width-80 u-block-hover__main--grayscale g-opacity-0_3 g-opacity-1--hover g-cursor-pointer" src="/assets/img-temp/200x100/img3.png" alt="Image description">
        </div>

        <div class="js-slide u-block-hover">
          <img class="mx-auto g-width-80 u-block-hover__main--grayscale g-opacity-0_3 g-opacity-1--hover g-cursor-pointer" src="/assets/img-temp/200x100/img4.png" alt="Image description">
        </div>

        <div class="js-slide u-block-hover">
          <img class="mx-auto g-width-80 u-block-hover__main--grayscale g-opacity-0_3 g-opacity-1--hover g-cursor-pointer" src="/assets/img-temp/200x100/img5.png" alt="Image description">
        </div>

        <div class="js-slide u-block-hover">
          <img class="mx-auto g-width-80 u-block-hover__main--grayscale g-opacity-0_3 g-opacity-1--hover g-cursor-pointer" src="/assets/img-temp/200x100/img6.png" alt="Image description">
        </div>

        <div class="js-slide u-block-hover">
          <img class="mx-auto g-width-80 u-block-hover__main--grayscale g-opacity-0_3 g-opacity-1--hover g-cursor-pointer" src="/assets/img-temp/200x100/img7.png" alt="Image description">
        </div>

        <div class="js-slide u-block-hover">
          <img class="mx-auto g-width-80 u-block-hover__main--grayscale g-opacity-0_3 g-opacity-1--hover g-cursor-pointer" src="/assets/img-temp/200x100/img8.png" alt="Image description">
        </div>

        <div class="js-slide u-block-hover">
          <img class="mx-auto g-width-80 u-block-hover__main--grayscale g-opacity-0_3 g-opacity-1--hover g-cursor-pointer" src="/assets/img-temp/200x100/img9.png" alt="Image description">
        </div>
      </div>
    </div>
    <!-- End Clients -->
    		
	<!-- FOOTER START -->   
	<#include "includes/user-footer.ftl">
	<!-- FOOTER END -->  
</body>
</html>