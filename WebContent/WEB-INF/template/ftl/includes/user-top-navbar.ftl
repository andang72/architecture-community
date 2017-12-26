	<div class="navbar-wrapper">
        <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
            <div class="container">
                <div class="navbar-header page-scroll">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="/index.html">HELPDESK</a>
                </div>
                <div id="navbar" class="navbar-collapse collapse">
                    <ul class="nav navbar-nav navbar-right">
                        <li <#if ! __page?? >class="active"</#if>><a class="page-scroll" href="/#page-top">Home</a></li>                        
                        <li <#if __page?? && ( __page.name == "technical-support.html" ) >class="active"</#if>><a class="page-scroll" href="<@spring.url "/display/pages/technical-support.html"/>">기술지원서비스</a></li>
                        <li <#if __page?? && ( __page.name == "boards.html" || __page.name == "threads.html" || __page.name == "view-thread.html" ) >class="active"</#if>><a class="page-scroll" href="<@spring.url "/display/pages/boards.html"/>">커뮤니티</a></li>
                        <#if !currentUser.anonymous >
                        <li><a  href="<@spring.url "/accounts/logout"/>">로그아웃</a></li>
                        <#else>
                        <li><a  href="<@spring.url "/accounts/login"/>">로그인</a></li>
                        </#if>
                    </ul>
                </div>
            </div>
        </nav>
	</div>	