<?php

	include "notorm/NotORM.php";
	header("Content-Type:application/json");
	
	$pdo = new PDO("mysql:host=localhost:3307;dbname=sis104basedatos","root","Sqlgorod132435");
	$db = new NotORM($pdo);
	

	$data_array = array();
	foreach($db->pedidos() as $d)(
		$data_array[] = array(
			'id' =>$d['id'],
			'listProd' =>$d['listProd'],
			'precio'=>$d['precio'],
			'cantidad' =>$d['cantidad']
		)
		);
	echo json_encode($data_array);

?>