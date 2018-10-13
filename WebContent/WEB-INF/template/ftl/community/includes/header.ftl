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
              <img src="<@spring.url "/images/icons/ios/helpdesk.svg"/>" class="g-width-50 g-pos-abs" style="top:-5px;" alt="Image Description">
            </a>
            <!-- End Logo -->  
                                                        
            <!-- Navigation -->
            <#assign user_top_menu = CommunityContextHelper.getMenuService().getTreeWalker("USER_TOP_MENU") />		
            <div class="collapse navbar-collapse align-items-center flex-sm-row g-pt-10 g-pt-5--lg" id="navBar">
            <ul class="navbar-nav text-uppercase g-font-weight-600 ml-auto">
            <#list user_top_menu.getChildren()  as item >
            <#if SecurityHelper.isUserInRole(item.roles) >
			<li class="nav-item g-mx-20--lg <#if __page?? && ( isGranted( item, __page)) >active</#if>" ><a href="${ item.location }" class="nav-link px-0">${ item.name } </a></li>   
			</#if>
            </#list>
            <#if currentUser.anonymous >
            <li class="nav-item g-mx-20--lg" ><a  href="<@spring.url "/accounts/login"/>" class="nav-link px-0" >로그인</a></li>
            </#if>
            </ul>

            <!-- User -->
            <#if !currentUser.anonymous >                           
			<div class="g-pos-rel g-width-150 g-pt-3--lg g-ml-30 g-ml-0--lg  g-font-weight-400">
				<a href="#!" class="g-color-white g-color-primary--hover g-text-underline--none--hover d-block" aria-controls="accounts-me-dropdown" aria-haspopup="true" aria-expanded="false" data-dropdown-event="click" data-dropdown-target="#accounts-me-dropdown" data-dropdown-type="css-animation" data-dropdown-duration="500" data-dropdown-hide-on-scroll="false" data-dropdown-animation-in="fadeIn" data-dropdown-animation-out="fadeOut">
		             <span class="g-pos-rel">
	        			<span class="u-badge-v2--xs u-badge--top-right g-hidden-sm-up g-bg-lightblue-v5 g-mr-5"></span>
	                	<img class="g-width-30 g-height-30 rounded-circle g-mr-10--sm" src="/download/avatar/${ currentUser.username }?height=96&amp;width=96" alt="Image description">
	                </span>				
	                <span class="g-pos-rel g-top-2">
	        			<!--<span class="g-hidden-sm-down">${currentUser.name} </span>-->
	                	<i class="fa fa-angle-down"></i> 
	                </span>				
				</a>
	              <ul id="accounts-me-dropdown" class="list-unstyled text-left u-shadow-v23 g-pos-abs g-left-0 g-bg-white g-width-160 g-z-index-2 g-py-20 g-pb-15 g-mt-25--lg g-mt-20--lg--scrolling u-dropdown--css-animation u-dropdown--hidden" aria-labelledby="languages-dropdown-invoker-2" style="animation-duration: 500ms; left: 0px;">
		            <#if SecurityHelper.isUserInRole("ROLE_ADMINISTRATOR") >
		            <li> 
		            <a class="d-block g-color-main g-color-primary--hover g-text-underline--none--hover g-py-8 g-px-20" href="<@spring.url "/secure/display/ftl/admin_v2.0/main"/>">관리자</a>
		            </li>
		            </#if>                  
	                <li>
	                  <a class="d-block g-color-main g-color-primary--hover g-text-underline--none--hover g-py-8 g-px-20" href="<@spring.url "/display/pages/profile.html"/>">프로파일</a>
	                </li>
	                <li>
	                  <a class="d-block g-color-main g-color-primary--hover g-text-underline--none--hover g-py-8 g-px-20" href="<@spring.url "/accounts/logout"/>">로그아웃</a>
	                </li>
	              </ul>
			</div>
            </#if>                                                                                           
            <!-- End User -- >
                                    
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