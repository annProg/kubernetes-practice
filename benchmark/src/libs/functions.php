<?php
/**
 * Usage:
 * File Name:
 * Author: annhe  
 * Mail: i@annhe.net
 * Created Time: 2018-04-28 13:19:56
 **/

function build_table($array, $title="Table"){
	// start table
	$html = '<table>';
	$html .= '<caption>' . $title . '</caption>';
	// header row
	$html .= '<tr><th>Key</th><th>Value</th></tr>';
	foreach($array as $key=>$value){
			$html .= '<tr>';
			$html .= '<td>' . htmlspecialchars($key) . '</td><td>' . htmlspecialchars($value) . '</td></tr>';
	}
	$html .= '</table>';
	return $html;
}
