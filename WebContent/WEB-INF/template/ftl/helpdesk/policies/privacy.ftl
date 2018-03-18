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
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser);
			}
    		});
     	
     	var renderTo = $('#page-top');
    		renderTo.data('model', observable);
    		community.ui.bind(renderTo, observable );	
    		
	});
	</script>		
</head>
<body id="page-top" class="landing-page skin-5">
	<!-- NAVBAR START -->   
	<#include "/includes/user-top-navbar.ftl">
	<!-- NAVBAR END -->  
	<section class="g-brd-bottom g-brd-gray-light-v4">
      <div class="container g-py-150">
        <div class="row">
          <div class="col-lg-6">
            <div class="d-inline-block g-width-80 g-height-4 g-bg-black mb-3"></div>
            <h2 class="g-color-black g-font-weight-700 g-font-size-50 g-line-height-1 mb-4"><#if __page?? >${__page.title}</#if></h2>
            <p class="mb-0"><#if __page.summary ?? >${__page.summary}</#if></p>
          </div>
        </div>
      </div>
    </section>	
	<section class="container g-py-100">
      <div class="g-mb-50">
        <h2 class="h3 g-color-black g-font-weight-600 mb-3">1. 수집하는 개인정보 항목</h2>
        <div class="mb-4">
          <p>회원가입, 서비스 이용 등을 위해 아래와 같은 최소한의 개인정보를 수집하고 있습니다.</p>
          <h3 class="g-color-black g-font-weight-600 mb-3">1-1. 수집항목</h3>
          <ul>
          <li class="mb-3">
            회원 가입시
          </li>
          <li class="mb-3">
            필수항목: 아이디, 비밀번호, 이름, 메일주소 
          </li>
          <li class="mb-3">
            선택항목: 
          </li>
        	  </ul>
        </div>
        <div class="mb-4">
        		<h3 class="g-color-black g-font-weight-600 mb-3">1-2. 수집방법</h3> 
        		<p>회원가입</p>
        </div>
      </div>

      <div class="g-mb-50">
        <h2 class="h3 g-color-black g-font-weight-600 mb-3">2. 개인정보의 수집 및 이용목적</h2>
        <div class="mb-4">
          <p>이용자의 개인정보를 다음과 같은 목적으로만 이용하며, 목적이 변경될 경우에는 반드시 사전에 이용자에게 동의를 구하도록 하겠습니다.</p>
          <ol>
          <li class="mb-3">
            아이디, 비밀번호, 별명 : 서비스 이용에 따른 본인식별, 중복가입 확인, 부정이용 방지를 위해 사용됩니다.
          </li>
          <li class="mb-3">
            이메일주소 : 전체메일발송, 패스워드 분실시 필요한 정보제공 및 민원처리 등을 위해 사용됩니다.
          </li>
          <li class="mb-3">
            이용자의 IP주소, 방문일시 : 불량회원의 부정 이용방지와 비인가 사용방지, 통계학적 분석에 사용됩니다.
          </li>
          <li class="mb-3">
            그 외 선택사항 : 개인 맞춤 서비스를 제공하기 위해 사용됩니다.
          </li>
        	  </ol>
        </div>
      </div>
 
	<div class="g-mb-50">
		<h2 class="h3 g-color-black g-font-weight-600 mb-3">3. 개인정보의 보유 및 이용기간</h2>
		<div class="mb-4">
			<p>회원가입일로부터 서비스를 제공하는 기간 동안에 한하여 이용자의 개인정보를 보유 및 이용합니다.</p>
			<p>다만 내부 방침에 의해 서비스 부정이용기록은 부정 가입 및 이용 방지를 위하여 회원 탈퇴 시점으로부터 최대 1년간 보관 후 파기하며,
			관계법령에 의해 보관해야 하는 정보는 법령이 정한 기간 동안 보관한 후 파기합니다.</p>
			<ol>
				<li class="mb-3">
				아이디, 비밀번호, 별명 : 서비스 이용에 따른 본인식별, 중복가입 확인, 부정이용 방지를 위해 사용됩니다.
				</li>
				<li class="mb-3">
				이메일주소 : 전체메일발송, 패스워드 분실시 필요한 정보제공 및 민원처리 등을 위해 사용됩니다.
				</li>
				<li class="mb-3">
				이용자의 IP주소, 방문일시 : 불량회원의 부정 이용방지와 비인가 사용방지, 통계학적 분석에 사용됩니다.
				</li>
				<li class="mb-3">
				그 외 선택사항 : 개인 맞춤 서비스를 제공하기 위해 사용됩니다.
				</li>
			</ol>
		</div>
	</div>
	 <div class="g-mb-50">
		<h2 class="h3 g-color-black g-font-weight-600 mb-3">4. 개인정보의 파기절차 및 방법</h2>
		<div class="mb-4">
			<p>이용자의 개인정보에 대해 개인정보의 수집·이용 목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다.</p>
			<p>다만 내부 방침에 의해 서비스 부정이용기록은 부정 가입 및 이용 방지를 위하여 회원 탈퇴 시점으로부터 최대 1년간 보관 후 파기하며,
			관계법령에 의해 보관해야 하는 정보는 법령이 정한 기간 동안 보관한 후 파기합니다.</p>
			<h3 class="g-color-black g-font-weight-600 mb-3">4-1. 파기절차</h3>
			 <p>회원이 회원가입 등을 위해 입력하신 정보는 목적이 달성된 후 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기되어집니다.</p>
			 <p>일정기간 저장된 개인정보는 법률에 의한 경우가 아니고서는 보유되어지는 이외의 다른 목적으로 이용되지 않습니다.</p>
		 	<h3 class="g-color-black g-font-weight-600 mb-3">4-2. 파기방법</h3>
		 	<p>개인정보 파기 시에는 전자적 파일 형태인 경우 복구 및 재생되지 않도록 기술적인 방법을 이용하여 완전하게 삭제하고, 그 밖에 기록물, 인쇄물, 
		 	서면 등의 경우 분쇄하거나 소각하여 파기합니다.</p>
		</div>
	</div>        
	<div class="g-mb-50">
		<h2 class="h3 g-color-black g-font-weight-600 mb-3">5. 개인정보 제공</h2>
		<div class="mb-4">
			<p>이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다.</p>
		</div>
	</div>		
	<div class="g-mb-50">
		<h2 class="h3 g-color-black g-font-weight-600 mb-3">6. 수집한 개인정보의 위탁</h2>
		<div class="mb-4">
			<p>회원의 동의없이 회원 정보를 외부 업체에 위탁하지 않습니다. 향후 그러한 필요가 생길 경우, 위탁 대상자와 위탁 업무 내용에 대해 회원에게 통지하고 필요한 경우 사전 동의를 받도록 하겠습니다.</p>
		</div>
	</div>	
	<!--
	<div class="g-mb-50">
		<h2 class="h3 g-color-black g-font-weight-600 mb-3">7. 이용자 및 법정대리인의 권리와 그 행사방법</h2>
		<div class="mb-4">
			<p>해당사항없습니다.</p>
		</div>
	</div>	
	-->
	<div class="g-mb-50">
		<h2 class="h3 g-color-black g-font-weight-600 mb-3">7. 개인정보 자동수집 장치의 설치, 운영 및 그 거부에 관한 사항</h2>
		<div class="mb-4">
			<p>해당사항없습니다.</p>
		</div>
	</div>	
	<div class="g-mb-50">
		<h2 class="h3 g-color-black g-font-weight-600 mb-3">8. 개인정보의 기술적, 관리적 보호대책</h2>
		<div class="mb-4">
			<p>이용자의 개인정보를 가장 소중한 가치로 여기고 개인정보를 처리함에 있어서 다음과 같은 노력을 다하고 있습니다.</p>
			<h3 class="g-color-black g-font-weight-600 mb-3">8-1. 개인정보의 암호화</h3>
			<p>이용자의 개인정보를 비밀번호에 의해 보호되며, 비밀번호 등 중요 데이터는 파일 및 전송데이터를 복호화할 수 없도록 단방향 암호화하여 보호합니다.</p>
			<h3 class="g-color-black g-font-weight-600 mb-3">8-2. 해킹 등의 대비한 기술적 대책</h3>
			<p>해킹이나 컴퓨터 바이러스 등에 의해 이용자의 개인정보가 유출되거나 훼손되는 것을 막기 위해 외부로부터 접근이 통제된 구역에 시스템을 설치하고 침입차단장치 및 침입탐지시스템을 설치하여 24시간 감시하고 있습니다.</p>
			<h3 class="g-color-black g-font-weight-600 mb-3">8-3. 개인 아이디와 비밀번호의 관리</h3>
			<p>이용자가 사용하는 ID와 비밀번호는 원칙적으로 이용자만이 사용할 수 있도록 되어 있습니다. 클리앙은 이용자의 개인적인 부주의로 ID, 비밀번호 등 개인정보가 유출되어 발생한 문제와 기본적인 인터넷의 위험성 때문에 일어나는 일들에 대해 책임을 지지 않습니다. 비밀번호에 대한 보안의식을 가지고 비밀번호를 자주 변경하며, 타인이 알기 쉬운 비밀번호를 사용하거나, 공용 PC 에서의 로그인시 개인정보가 누출되지 않도록 각별한 주의를 기울여 주시기 바랍니다.</p>
		</div>
	</div>	
					        		        
	<div class="g-mb-50">
		<h2 class="h3 g-color-black g-font-weight-600 mb-3">9. 개인정보에 관한 민원서비스</h2>
		<div class="mb-4">
			<p>이용자의 개인정보를 보호하고 궁금증 해결, 불만 처리를 위해 다음과 같이 책임자를 지정하고 운영하고 있습니다. 언제라도 문의 주시면 신속하고 충분한 답변을 드리도록 하겠습니다.</p>
			<p>helpdesk@podosw.com<p>
			<p>또한 개인정보가 침해되어 이에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하셔서 도움을 받으실 수 있습니다.</p>
			<ol>
				<li class="mb-3">개인정보침해신고센터 (privacy.kisa.or.kr / 국번없이 118)</li>
				<li class="mb-3">대검찰청 사이버수사과 (www.spo.go.kr / 국번없이 1301)</li>
				<li class="mb-3">경찰청 사이버안전국 (cyberbureau.police.go.kr / 국번없이 182)</li>
			</ol>	
		</div>
	</div>	
    </section>      
	<!-- FOOTER START -->   
	<#include "/includes/user-footer.ftl">
	<!-- FOOTER END -->  
</body>
</html>	
</#compress>