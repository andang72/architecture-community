<#ftl encoding="UTF-8"/>
<#compress>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">    
    <title>Login</title>

	<!-- Bootstrap CSS -->
	<link href="/css/bootstrap/3.3.7/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<link href="/fonts/font-awesome.css" rel="stylesheet" type="text/css" />

	<!-- Bootstrap Inspinia Theme CSS -->
	<link href="/css/bootstrap.theme/inspinia/style.css" rel="stylesheet" type="text/css" />
		
	<!-- Depends CSS -->
	<link href="/css/animate/animate.css" rel="stylesheet"/>
</head>
<body class="gray-bg skin-2">
    <div class="loginColumns animated fadeInDown">
        <div class="row">
            <div class="col-md-6">
                <h2 class="font-bold">Welcome to MUSI +</h2>
                <p>
                    Perfectly designed and precisely prepared admin theme with over 50 pages with extra new web app views.
                </p>
                <p>
                    Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.
                </p>
                <p>
                    When an unknown printer took a galley of type and scrambled it to make a type specimen book.
                </p>
                <p>
                    <small>It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.</small>
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
					            <input type="checkbox" name="remember-me"> 로그인상태유지
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
                        <small>Inspinia we app framework base on Bootstrap 3 &copy; 2014</small>
                    </p>
                </div>
            </div>
        </div>
        <hr/>
        <div class="row">
            <div class="col-md-6">
                Copyright Example Company
            </div>
            <div class="col-md-6 text-right">
               <small>© 2017 - 2018 </small>
            </div>
        </div>
    </div>
</body>	
</html>
</#compress>