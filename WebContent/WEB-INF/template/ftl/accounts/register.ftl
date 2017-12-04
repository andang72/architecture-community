<#ftl encoding="UTF-8"/>
<#compress>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>INSPINIA | Register</title>
    <link href="/css/bootstrap/3.3.7/bootstrap.min.css" rel="stylesheet">
    <link href="/fonts/font-awesome.css" rel="stylesheet">
    <link href="/css/animate/animate.css" rel="stylesheet">
    <link href="/css/jquery.icheck/skins/all.css" rel="stylesheet">
    <link href="/css/bootstrap.theme/inspinia/style.css" rel="stylesheet">    
    <link href="/css/community.ui/community.ui.style.css" rel="stylesheet">    
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
	        "jquery.icheck" 			: { "deps" :['jquery'] },
	        "inspinia"					: { "deps" :['jquery', 'jquery.metisMenu', 'jquery.slimscroll'] }
		},
		paths : {
			"jquery"    					: "/js/jquery/jquery-3.1.1.min",
			"bootstrap" 					: "/js/bootstrap/3.3.7/bootstrap.min",
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"jquery.metisMenu"			: "/js/jquery.metisMenu/metisMenu.min",
			"jquery.slimscroll"			: "/js/jquery.slimscroll/1.3.8/jquery.slimscroll.min",
			"jquery.icheck"				: "/js/jquery.icheck/icheck.min" ,
			"inspinia" 					: "/js/bootstrap.theme/inspinia/inspinia",		
			"community.ui.core" 			: "/js/community.ui/community.ui.core",
			"community.data" 			: "/js/community.ui/community.data"
		}
	});	
	require([ "jquery", "bootstrap", "kendo.ui.core.min", "community.ui.core", "community.data", "jquery.metisMenu" , "jquery.slimscroll", "jquery.icheck", "inspinia"], function($, kendo ) {
		
		$('.i-checks').iCheck({
            checkboxClass: 'icheckbox_flat-blue',
            radioClass: 'iradio_flat-blue',
        });
            
		community.ui.setup({
		  	features : {
				accounts: true
		  	},
		  	'features.accounts.authenticate' :function(e){
		  		if( !e.token.anonymous ){
		  			observable.setUser(e.token);
		  			console.log("Hi " +  observable.currentUser.name + "!! you don't have be here." );
		    		}
		  	}
		});	
		
		var renderTo = $('#register');
		
		var validator = $("#register-form").kendoValidator({
			rules : {
				matches: function (input) {
					var matchesPropertyName = input.data("matches");
					if (!matchesPropertyName) return true;
				    	var propertyName = input.prop("kendoBindingTarget").toDestroy[0].bindings.value.path;
				    return (observable.get(matchesPropertyName) === observable.get(propertyName));
				}
			},
			messages : {
				matches: function (input) {
		  			return input.data("matches-msg") || "Does not match";
				}
			},
			errorTemplate: '<div class="alert alert-danger">#=message#</div>'			
                            
		}).data("kendoValidator");
		
		var observable = new community.ui.observable({ 
			currentUser : new community.model.User(),
			enabled : true,
			agree : false,
			setUser : function( data ){
				var $this = this;
				data.copy($this.currentUser);
				if(!$this.currentUser.anonymous){
					$this.set('enabled',false);
				}
			},
			signup : function (e){			
				e.preventDefault();		
				console.log("let's signup.");		 
				var $this = this;
				console.log( community.ui.stringify($this.currentUser) );		
				if (validator.validate()) {
					community.ui.progress(renderTo, true);				
					community.ui.ajax( '<@spring.url "/data/accounts/signup-with-user.json" />', {
							data: community.ui.stringify($this.currentUser),
							contentType : "application/json",
							success : function(response){
								if( response.success ){
									// gonguration !!
								}
							}
					}).always( function () {
						community.ui.progress(renderTo, false);
					});	
				}
			}			
		});		
		
		community.ui.bind(renderTo, observable );
	});	
	</script>
	<style>
	.alert-danger {
	 	margin-top: 15px;
    		margin-bottom: 0px;
    		padding: 5px;
	}
	.text-danger .k-invalid-msg {
		padding-top: 5px;
	}
	</style>
</head>
<body class="gray-bg skin-2">
    <div class="middle-box text-center loginscreen   animated fadeInDown">
        <div id="register">
            <div>
                <h1 class="logo-name">MUSI</h1>
            </div>
            <h3>Register to MUSI</h3>
            <p>로그인 정보 및 가입정보를 입력하세요.</p>
            <form class="m-t" role="form" id="register-form" name="register-form" method="POST" accept-charset="utf-8" >
                <div class="form-group">
                    <input type="text" class="form-control" name="name" placeholder="이름"  data-bind="enabled: enabled, value:currentUser.name" required data-required-msg="이름을 입력하여 주십시오." >
                </div>
                <div class="form-group">
                    <input type="email" class="form-control" name="email" placeholder="메일"  data-bind="enabled: enabled, value:currentUser.email" required data-required-msg="메일주소를 입력하여 주십시오." data-email-msg="메일주소 형식이 바르지 않습니다.">
                </div>
                <div class="form-group">
                    <input type="password" class="form-control" name="password" placeholder="비밀번호" data-bind="enabled: enabled, value:currentUser.password" required  data-required-msg="비밀번호를 입력하여 주십시오.">
                </div>
                <div class="form-group">
                        <div class="checkbox i-checks"><label> <input type="checkbox" name="agree" data-bind="enabled: enabled, "checked: agree""  required validationMessage="회원가입을 위하여 동의가 필요합니다." ><i></i>  이용 약관 및 정책 동의 </label>
                        </div>
                        <p class="text-danger k-invalid-msg" data-for="agree" role="alert"></p>
                </div>
                <button type="button" class="btn btn-success block full-width m-b" data-bind="enabled: enabled, click:signup" >회원가입</button>

                <p class="text-muted text-center"><small>이미 회원인가요 ?</small></p>
                <a class="btn btn-sm btn-white btn-block" href="login" data-bind="enabled: enabled">로그인</a>
            </form>
            <p class="m-t"> <small>Inspinia we app framework base on Bootstrap 3 &copy; 2014</small> </p>
        </div>
    </div>
</body>

</html>
</#compress>