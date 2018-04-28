<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title><?php print(getenv('APP_NAME'));?></title>
	<style>
		table {
			font-family: arial, sans-serif;
			border-collapse: collapse;
			width: 100%;
		}

		td, th {
			border: 1px solid #dddddd;
			text-align: left;
			padding: 8px;``
		}
		
		#main {
			width: 85%;
			margin-left:auto;
			margin-right:auto;
		}
	
		.left {
			float: left;
			width: 49%;
		}
		.right {
			float: right;
			width: 49%;
		}
	</style>
</head>
<body>
<div id="main">
	<div class="left">

<?php
/**
 * Usage:
 * File Name: index.php
 * Author: annhe  
 * Mail: i@annhe.net
 * Created Time: 2018-04-28 11:25:43
 **/

require 'libs/appconfig.php';
require 'libs/functions.php';
define('APPCONFIGDIR','/run/secrets/appconfig');

$config = new AppConfig(APPCONFIGDIR);
print_r(build_table($config->gets(), getenv("APP_NAME") . "配置项列表"));
?>
	</div>
	<div class="right">
<?php
print_r(build_table(getenv(), "环境变量列表"));	
?>
	</div>
</div>
</body>
</html>
