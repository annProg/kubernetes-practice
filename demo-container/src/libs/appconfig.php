<?php
/**
 * Usage:
 * File Name: index.php
 * Author: annhe  
 * Mail: i@annhe.net
 * Created Time: 2018-04-28 11:25:43
 **/

class AppConfig {
	protected $configs = [];

	function __construct($dir) {
		if($handle = opendir($dir)){
			$files = [];
			while (false !== ($file = readdir($handle))){
				$files[] = $file;
			}
			closedir($handle);
		}
		$files =  array_filter($files, "self::filter_filename");
		foreach($files as $k => $v) {
			$this->configs[$v] = file_get_contents($dir . '/' . $v);
		}
	}

	function filter_filename($name) {
		if($name == "." || $name == "..") {
			return false;
		}
		return true;
	}

	function gets() {
		return $this->configs;
	}

	function get($key) {
		if(!array_key_exists($key, $this->configs)) {
			return "NULL";
		}
		return $this->configs[$key];
	}
}
