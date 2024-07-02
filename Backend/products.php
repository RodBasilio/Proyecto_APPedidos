<?php

	include "notorm/NotORM.php";
	header("Content-Type:application/json");
	
	$pdo = new PDO("mysql:host=localhost:3307;dbname=sis104basedatos","root","Sqlgorod132435");
	$db = new NotORM($pdo);
	/*
	foreach ($db->lugares() as $d) { // get all applications
		echo "$d[nombre]\n"; // print application title
	}
	*/
	//echo json_encode($db->lugares());
	//idata_array = array();
	//foreach($db->)

	$data_array = array();
	foreach($db->productos() as $d)(
		$data_array[] = array(
			'id' =>$d['id'],
			'imagen' =>$d['imagen'],
			'nombre' =>$d['nombre'],
			'precio' =>$d['precio']
		)
		);
	echo json_encode($data_array);

?>