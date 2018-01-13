<#ftl encoding="UTF-8"/>
<#compress>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">    
    <title>${ CommunityContextHelper.getConfigService().getApplicationProperty("website.title", "") } | 로그인</title>
	<!-- Bootstrap CSS -->
	<link href="<@spring.url "/css/bootstrap/3.3.7/bootstrap.min.css"/>" rel="stylesheet" type="text/css" />
	<link href="<@spring.url "/fonts/font-awesome.css"/>" rel="stylesheet" type="text/css" />

	<!-- Bootstrap Theme CSS -->
	<link href="<@spring.url "/css/bootstrap.theme/inspinia/style.css"/>" rel="stylesheet" type="text/css" />	
	<link href="<@spring.url "/css/bootstrap.theme/inspinia/custom.css"/>" rel="stylesheet" type="text/css" />	
		
	<!-- Depends CSS -->
	<link href="<@spring.url "/css/animate/animate.css"/>" rel="stylesheet"/>
	<!-- Page landing js -->	   	
	<script data-pace-options='{ "ajax": false }' src='<@spring.url "/js/pace/pace.min.js"/>'></script>  
</head>
<body class="gray-bg skin-2">
    <div class="loginColumns animated fadeInDown">
        <div class="row">
            <div class="col-md-6">
                <h2 class="font-bold">Welcome to ${ CommunityContextHelper.getConfigService().getApplicationProperty("website.title", "") }</h2>
                <p>
                    서비스 이용하시려면 회원가입이 필요합니다. 아직 아이디가 없으시면 회원가입후 서비스를 이용하세요.
                </p>
            </div>
            <div class="col-md-6">
                <div class="ibox-content">
                    <form class="m-t" role="form" method="post" action="/accounts/auth/login_check" >
                        <div class="form-group">
                            <input type="text" id="usrname" name="username"  type="text" class="form-control" placeholder="아이디" required="" autofocus >
                        </div>
                        <div class="form-group">
                            <input id="password" name="password" type="password" class="form-control" placeholder="비밀번호" required="">
                        </div>
                        <div class="form-group"> 
					        <div class="checkbox">
					          <label>
					            <input type="checkbox" name="remember-me">로그인상태유지
					          </label>
					        </div>
                        </div>                        
                        <button type="submit" class="btn btn-success block full-width m-b">로그인</button>
                        <a href="#">
                            <small>계정찾기</small>
                        </a>
                        <p class="text-muted text-center">
                            <small>아직 회원이 아니신가요?</small>
                        </p>
                        <a class="btn btn-sm btn-white btn-block" href="join">회원가입</a>
                    </form>
                    <p class="m-t">
                        <small>${ CommunityContextHelper.getConfigService().getApplicationProperty("website.title", "리플리카") }는 spring, bootstrap 등의 오픈소프 기술을 기반으로 개발되었습니다.</small>
                    </p>
                </div>
            </div>
        </div>
        <hr/>
        <div class="row">
            <div class="col-md-6">
                ${ CommunityContextHelper.getConfigService().getApplicationProperty("website.copyright", "") }
            </div>
            <div class="col-md-6 text-right">
               <small>© 2017 - 2018 </small>
            </div>
        </div>
    </div>
</body>	
</html>
</#compress>