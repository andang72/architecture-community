	<!-- Header -->
    <header id="js-header" class="u-header u-header--sticky-top u-header--toggle-section u-header--change-appearance" data-header-fix-moment="300">
      <div class="u-header__section u-header__section--dark g-bg-black-opacity-0_4 g-transition-0_3 g-py-10" data-header-fix-moment-exclude="g-bg-black-opacity-0_4 g-py-10" data-header-fix-moment-classes="g-bg-black-opacity-0_7 g-py-0">
        <nav class="navbar navbar-expand-lg">
          <div class="container">
            <!-- Responsive Toggle Button -->
            <button class="navbar-toggler navbar-toggler-right btn g-line-height-1 g-brd-none g-pa-0 g-pos-abs g-top-3 g-right-0" type="button" aria-label="Toggle navigation" aria-expanded="false" aria-controls="navBar" data-toggle="collapse" data-target="#navBar">
              <span class="hamburger hamburger--slider">
            <span class="hamburger-box">
              <span class="hamburger-inner"></span>
              </span>
              </span>
            </button>
            <!-- End Responsive Toggle Button -->

            <!-- Logo -->
            <a href="/" class="navbar-brand">
              <img src="/images/icons/ios/helpdesk.svg" class="g-width-50" alt="Image Description">
            </a>
            <!-- End Logo --> 
            <#if SecurityHelper.isUserInRole("ROLE_ADMINISTRATOR") >
            <a class="back g-mt-5 g-ml-10" href="<@spring.url "/secure/display/ftl/admin_v2.0/main"/>" ><i class="icon-svg icon-svg-sm icon-svg-dusk-administrative-tools "></i></a>
            </#if>
                    
            <!-- Navigation -->
            <#assign user_top_menu = CommunityContextHelper.getMenuService().getTreeWalker("USER_TOP_MENU") />		
            <div class="collapse navbar-collapse align-items-center flex-sm-row g-pt-10 g-pt-5--lg" id="navBar">
            <ul class="navbar-nav text-uppercase g-font-weight-600 ml-auto">
            <#list user_top_menu.getChildren()  as item >
            <#if SecurityHelper.isUserInRole(item.roles) >
			<li class="nav-item g-mx-20--lg <#if __page?? && ( isGranted( item, __page)) >active</#if>" ><a href="${ item.location }" class="nav-link px-0">${ item.name } </a></li>   
			</#if>
            </#list>
            <#if !currentUser.anonymous >
            <li class="nav-item g-mx-20--lg" ><a  href="<@spring.url "/accounts/logout"/>" class="nav-link px-0" >로그아웃</a></li>
            <#else>
            <li class="nav-item g-mx-20--lg" ><a  href="<@spring.url "/accounts/login"/>" class="nav-link px-0" >로그인</a></li>
            </#if>
            </ul>
            </div>
            <!-- End Navigation -->
          </div>
        </nav>
      </div>
    </header>
    <!-- End Header -->
	<#function isGranted _item _page>
		<#if _item.isSetPage() &&  _item.page == 'technical-support.html' && (_page.name == 'issues.html' || _page.name == 'issue.html' || _page.name == 'issue-overviewstats.html') >
		<#return true>
		<#elseif _item.isSetPage() &&  _item.page == 'boards.html' && (_page.name == 'threads.html' || _page.name == 'view-thread.html') >
		<#return true>
		</#if>
  		<#return  _item.isSetPage() && (_item.page == _page.name) >
	</#function>    