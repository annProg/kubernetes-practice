<?php

if(!defined('DOKU_INC')) define('DOKU_INC',dirname(__FILE__).'/');
if(!defined('DOKU_CONF')) define('DOKU_CONF',DOKU_INC.'conf/');
if(!defined('DOKU_LOCAL')) define('DOKU_LOCAL',DOKU_INC.'conf/');
require_once(dirname(__FILE__) .'/PassHash.class.php');

$phash = new PassHash();
$pass = $phash->hash_smd5($argv[1]);
print_r($pass . "\n");
