<?php

$servername = "localhost:3307";
$username = "root";
$password = "Sqlgorod132435";
$dbname = "sis104basedatos";


// Obtener los datos enviados desde Flutter
$usernameInput = $_POST['username'];
$passwordInput = $_POST['password'];

try {
    // Crear una nueva conexión PDO
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    
    // Establecer el modo de error PDO en excepciones
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Preparar la consulta SQL para obtener los datos del usuario
    $stmt = $conn->prepare("SELECT rol FROM usuarios WHERE username = :username AND password = :password");
    $stmt->bindParam(':username', $usernameInput);
    $stmt->bindParam(':password', $passwordInput);
    
    // Ejecutar la consulta
    $stmt->execute();
    
    // Obtener el resultado de la consulta
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($result) {
        // El usuario fue encontrado en la base de datos
        $response = array('rol' => $result['rol']);
    } else {
        // Credenciales inválidas
        http_response_code(401);
        exit();
    }
    
    // Convertir el arreglo de respuesta a JSON
    $jsonResponse = json_encode($response);
    
    // Configurar las cabeceras de la respuesta HTTP
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    
    // Enviar la respuesta al cliente
    echo $jsonResponse;
} catch(PDOException $e) {
    // Error en la conexión a la base de datos
    http_response_code(500);
    exit();
}