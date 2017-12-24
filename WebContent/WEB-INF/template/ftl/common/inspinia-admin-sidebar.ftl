			
     <nav class="navbar-default navbar-static-side" role="navigation">
        <div class="sidebar-collapse">
            <ul class="nav metismenu" id="side-menu">
                <li class="nav-header">
                    <div class="dropdown profile-element">
                    		<span><img alt="image" class="img-circle" data-bind="attr:{ src: userAvatarSrc  }"  width="64" height="64" src="/images/no-avatar.png" /></span>
                        <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                            <span class="clear">
                                <span class="block m-t-xs"><strong class="font-bold"><span data-bind="text:currentUser.name"></span></strong></span> 
                                <span class="text-muted text-xs block">Art Director <b class="caret"></b></span> 
                            </span> 
                        </a>
                        <ul class="dropdown-menu animated fadeInRight m-t-xs">
                            <li><a href="view.html?t=/admin/profile">프로필</a></li>
                            <li class="divider"></li>
                            <li><a href="/accounts/logout">로그아웃</a></li>
                        </ul>
                    </div>
                    <div class="logo-element">
                       MUSU
                    </div>
                </li>

                <li>
                    <a href="#"><i class="fa fa-th-large"></i> <span class="nav-label">커뮤니티</span> <span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level collapse">
                        <li><a href="view.html?t=/admin/manage-projects" data-page='/admin/manage-projects'>프로젝트</a></li>
                        <li><a href="view.html?t=/admin/manage-boards" data-page='/admin/manage-boards'>게시판</a></li>
                    </ul>
                </li>                         
                <li>
                    <a href="#"><i class="fa fa-th-large"></i> <span class="nav-label">자원</span> <span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level collapse">
                        <li><a href="view.html?t=/admin/manage-cloud-photos" data-page='/admin/manage-menu'>이미지</a></li>
                        <li><a href="view.html?t=/admin/manage-cloud-files" data-page='/admin/manage-menu'>파일</a></li>
                    		<li><a href="view.html?t=/admin/manage-menu" data-page='/admin/manage-menu' >메뉴</a></li>	
                    		<li><a href="view.html?t=/admin/manage-pages" data-page='/admin/manage-menu'>페이지</a></li>	
                    	    <li><a href="view.html?t=/admin/manage-templetes" data-page='/admin/manage-menu'>템플릿</a></li>	
                    </ul>
                </li>                                           
                <li>
                    <a href="#"><i class="fa fa-th-large"></i> <span class="nav-label">보안</span> <span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level collapse">
                        <li><a href="view.html?t=/admin/manage-users">사용자</a></li>
                        <li><a href="view.html?t=/admin/manage-groups">그룹</a></li>
                        <li><a href="view.html?t=/admin/manage-security">권한</a></li>
                    </ul>
                </li>        
                <!--        
                <li>
                    <a href="index.html"><i class="fa fa-th-large"></i> <span class="nav-label">Dashboards</span> <span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level collapse">
                        <li><a href="index.html">Dashboard v.1</a></li>
                        <li><a href="dashboard_2.html">Dashboard v.2</a></li>
                        <li><a href="dashboard_3.html">Dashboard v.3</a></li>
                        <li><a href="dashboard_4_1.html">Dashboard v.4</a></li>
                        <li><a href="dashboard_5.html">Dashboard v.5 </a></li>
                    </ul>
                </li>
                <li>
                    <a href="layouts.html"><i class="fa fa-diamond"></i> <span class="nav-label">Layouts</span></a>
                </li>
                <li class="active">
                    <a href="#"><i class="fa fa-files-o"></i> <span class="nav-label">Other Pages</span><span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li><a href="search_results.html">Search results</a></li>
                        <li class="active"><a href="empty_page.html">Empty page</a></li>
                    </ul>
                </li>-->
            </ul>
        </div>
    </nav>