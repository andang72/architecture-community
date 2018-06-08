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
                    <#if SecurityHelper.isUserInRole("ROLE_ADMINISTRATOR") >
                    <a class="back g-mt-15 g-ml-10" href="<@spring.url "/secure/display/ftl/admin_v2.0/main"/>" ><i class="icon-svg icon-svg-sm icon-svg-dusk-administrative-tools "></i></a>
                    </#if>
                </div>               
                <div id="navbar" class="navbar-collapse collapse">
                    <ul class="nav navbar-nav navbar-right">                
					<#assign user_top_menu = CommunityContextHelper.getMenuService().getTreeWalker("USER_TOP_MENU") />		    
					<#list user_top_menu.getChildren()  as item >
					<#if SecurityHelper.isUserInRole(item.roles) >
					<li<#if __page?? && ( isGranted( item, __page)) > class="active"</#if> ><a href="${ item.location }">${ item.name }</a></li>   
					</#if>
					</#list> 
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
	
	<#function isGranted _item _page>
		<#if _item.isSetPage() &&  _item.page == 'technical-support.html' && (_page.name == 'issues.html' || _page.name == 'issue.html' || _page.name == 'issue-overviewstats.html') >
		<#return true>
		<#elseif _item.isSetPage() &&  _item.page == 'boards.html' && (_page.name == 'threads.html' || _page.name == 'view-thread.html') >
		<#return true>
		</#if>
  		<#return  _item.isSetPage() && (_item.page == _page.name) >
	</#function>