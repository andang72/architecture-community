<#ftl encoding="UTF-8"/>
<#assign user = SecurityHelper.getUser() />	
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title></title>
<!-- Bootstrap core CSS -->
<link href="/css/bootstrap/3.3.7/bootstrap-theme.min.css" rel="stylesheet" type="text/css" />
<link href="/css/bootstrap/3.3.7/bootstrap.min.css" rel="stylesheet" type="text/css" />

<link href="/css/bootstrap.theme/inspinia/style.css" rel="stylesheet" type="text/css" />
<link href="/fonts/font-awesome.css" rel="stylesheet" type="text/css" />

<!-- Requirejs for js loading -->
<script src="/js/require.js/2.3.5/require.js" type="text/javascript"></script>

<!-- Application JavaScript
    ================================================== -->    
<script>
	require.config({
		shim : {
	        "bootstrap" : { "deps" :['jquery'] },
	        "kendo.ui.core.min" : { "deps" :['jquery'] },
	        "kendo.culture.ko-KR.min" : { "deps" :['kendo.ui.core.min'] },
	        "podo.ui.core" : { "deps" :['kendo.culture.ko-KR.min'] }
	    },
		paths : {
			"jquery"    					: "/js/jquery/jquery-2.2.4.min",
			"bootstrap" 					: "/js/bootstrap/3.3.7/bootstrap.min",
			"kendo.ui.core.min" 			: "/js/kendo.ui.core/kendo.ui.core.min",
			"kendo.culture.ko-KR.min"	: "/js/kendo.ui.core/cultures/kendo.culture.ko-KR.min",
			"podo.ui.core" 				: "/js/podo.ui/podo.ui.core"
		}
	});
	
	require([ "jquery", "kendo.ui.core.min", "podo.ui.core", "kendo.culture.ko-KR.min", "bootstrap"], function($, kendo ) {
		console.log("hello");
		kendo.culture("ko-KR");
		
	});
	
</script>
    
  </head>
<body class="top-navigation">
    <div id="wrapper">
        <div id="page-wrapper" class="gray-bg">
        <div class="row border-bottom white-bg">
        <nav class="navbar navbar-static-top" role="navigation">
            <div class="navbar-header">
                <button aria-controls="navbar" aria-expanded="false" data-target="#navbar" data-toggle="collapse" class="navbar-toggle collapsed" type="button">
                    <i class="fa fa-reorder"></i>
                </button>
                <a href="#" class="navbar-brand">MUSI</a>
            </div>
            <div class="navbar-collapse collapse" id="navbar">
                <ul class="nav navbar-nav">
                    <li class="active">
                        <a aria-expanded="false" role="button" href="layouts.html"> Back to main Layout page</a>
                    </li>
                    <li class="dropdown">
                        <a aria-expanded="false" role="button" href="#" class="dropdown-toggle" data-toggle="dropdown"> Menu item <span class="caret"></span></a>
                        <ul role="menu" class="dropdown-menu">
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a aria-expanded="false" role="button" href="#" class="dropdown-toggle" data-toggle="dropdown"> Menu item <span class="caret"></span></a>
                        <ul role="menu" class="dropdown-menu">
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a aria-expanded="false" role="button" href="#" class="dropdown-toggle" data-toggle="dropdown"> Menu item <span class="caret"></span></a>
                        <ul role="menu" class="dropdown-menu">
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a aria-expanded="false" role="button" href="#" class="dropdown-toggle" data-toggle="dropdown"> Menu item <span class="caret"></span></a>
                        <ul role="menu" class="dropdown-menu">
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                            <li><a href="">Menu item</a></li>
                        </ul>
                    </li>

                </ul>
                <ul class="nav navbar-top-links navbar-right">
                    <li>
                        <a href="login.html">
                            <i class="fa fa-sign-out"></i> Log out
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
        </div>
        <div class="wrapper wrapper-content">
            <div class="container">
            <div class="row">
                <div class="col-md-2">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <span class="label label-success pull-right">Monthly</span>
                            <h5>Views</h5>
                        </div>
                        <div class="ibox-content">
                            <h1 class="no-margins">386,200</h1>
                            <div class="stat-percent font-bold text-success">98% <i class="fa fa-bolt"></i></div>
                            <small>Total views</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <span class="label label-info pull-right">Annual</span>
                            <h5>Orders</h5>
                        </div>
                        <div class="ibox-content">
                                    <h1 class="no-margins">80,800</h1>
                                    <div class="stat-percent font-bold text-info">20% <i class="fa fa-level-up"></i></div>
                                    <small>New orders</small>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <span class="label label-primary pull-right">Today</span>
                            <h5>visits</h5>
                        </div>
                        <div class="ibox-content">

                            <div class="row">
                                <div class="col-md-6">
                                    <h1 class="no-margins">$ 406,420</h1>
                                    <div class="font-bold text-navy">44% <i class="fa fa-level-up"></i> <small>Rapid pace</small></div>
                                </div>
                                <div class="col-md-6">
                                    <h1 class="no-margins">206,120</h1>
                                    <div class="font-bold text-navy">22% <i class="fa fa-level-up"></i> <small>Slow pace</small></div>
                                </div>
                            </div>


                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Monthly income</h5>
                            <div class="ibox-tools">
                                <span class="label label-primary">Updated 12.2015</span>
                            </div>
                        </div>
                        <div class="ibox-content no-padding">
                            <div class="flot-chart m-t-lg" style="height: 55px;">
                                <div class="flot-chart-content" id="flot-chart1"></div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
                <div class="row">
                    <div class="col-lg-8">
                        <div class="ibox float-e-margins">
                            <div class="ibox-content">
                                <div>
                                        <span class="pull-right text-right">
                                        <small>Average value of sales in the past month in: <strong>United states</strong></small>
                                            <br/>
                                            All sales: 162,862
                                        </span>
                                    <h3 class="font-bold no-margins">
                                        Half-year revenue margin
                                    </h3>
                                    <small>Sales marketing.</small>
                                </div>

                                <div class="m-t-sm">

                                    <div class="row">
                                        <div class="col-md-8">
                                            <div>
                                            <canvas id="lineChart" height="114"></canvas>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <ul class="stat-list m-t-lg">
                                                <li>
                                                    <h2 class="no-margins">2,346</h2>
                                                    <small>Total orders in period</small>
                                                    <div class="progress progress-mini">
                                                        <div class="progress-bar" style="width: 48%;"></div>
                                                    </div>
                                                </li>
                                                <li>
                                                    <h2 class="no-margins ">4,422</h2>
                                                    <small>Orders in last month</small>
                                                    <div class="progress progress-mini">
                                                        <div class="progress-bar" style="width: 60%;"></div>
                                                    </div>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>

                                </div>

                                <div class="m-t-md">
                                    <small class="pull-right">
                                        <i class="fa fa-clock-o"> </i>
                                        Update on 16.07.2015
                                    </small>
                                    <small>
                                        <strong>Analysis of sales:</strong> The value has been changed over time, and last month reached a level over $50,000.
                                    </small>
                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <span class="label label-warning pull-right">Data has changed</span>
                                <h5>User activity</h5>
                            </div>
                            <div class="ibox-content">
                                <div class="row">
                                    <div class="col-xs-4">
                                        <small class="stats-label">Pages / Visit</small>
                                        <h4>236 321.80</h4>
                                    </div>

                                    <div class="col-xs-4">
                                        <small class="stats-label">% New Visits</small>
                                        <h4>46.11%</h4>
                                    </div>
                                    <div class="col-xs-4">
                                        <small class="stats-label">Last week</small>
                                        <h4>432.021</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="row">
                                    <div class="col-xs-4">
                                        <small class="stats-label">Pages / Visit</small>
                                        <h4>643 321.10</h4>
                                    </div>

                                    <div class="col-xs-4">
                                        <small class="stats-label">% New Visits</small>
                                        <h4>92.43%</h4>
                                    </div>
                                    <div class="col-xs-4">
                                        <small class="stats-label">Last week</small>
                                        <h4>564.554</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="row">
                                    <div class="col-xs-4">
                                        <small class="stats-label">Pages / Visit</small>
                                        <h4>436 547.20</h4>
                                    </div>

                                    <div class="col-xs-4">
                                        <small class="stats-label">% New Visits</small>
                                        <h4>150.23%</h4>
                                    </div>
                                    <div class="col-xs-4">
                                        <small class="stats-label">Last week</small>
                                        <h4>124.990</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>Custom responsive table </h5>
                            </div>
                            <div class="ibox-content">
                                
                            </div>
                        </div>
                    </div>

                </div>

            </div>

        </div>
        <div class="footer">
            <div class="pull-right">
                10GB of <strong>250GB</strong> Free.
            </div>
            <div>
                <strong>Copyright</strong> Example Company &copy; 2014-2017
            </div>
        </div>

	</div>
	</div>
</body>
</html>
