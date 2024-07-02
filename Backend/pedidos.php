<?php
// Configuración de la conexión a la base de datos
$servername = "localhost:3307";
$username = "root";
$password = "Sqlgorod132435";
$dbname = "sis104basedatos";

// Crear la conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar la conexión
if ($conn->connect_error) {
    die("Error en la conexión a la base de datos: " . $conn->connect_error);
}

// Obtener los datos enviados en la solicitud POST
$jsonData = file_get_contents('php://input');

// Decodificar el JSON recibido
$data = json_decode($jsonData, true);

// Verificar si se recibieron datos válidos
if (is_array($data) && count($data) > 0) {
    // Preparar la consulta de inserción
    $stmt = $conn->prepare("INSERT INTO pedidos (listProd, precio, cantidad) VALUES (?, ?, ?)");

    // Vincular los parámetros de la consulta
    $stmt->bind_param("sdi", $listProd, $precio, $cantidad);

    // Iterar sobre los pedidos y ejecutar la inserción
    foreach ($data as $product) {
        $listProd = $product['listProd'];
        $precio = $product['precio'];
        $cantidad = $product['cantidad'];

        // Ejecutar la consulta
        $stmt->execute();
    }

    // Cerrar la consulta
    $stmt->close();

    // Enviar respuesta de éxito
    http_response_code(200);
    echo "Datos guardados correctamente en la base de datos";
} else {
    // Enviar respuesta de error
    http_response_code(400);
    echo "Error: Datos inválidos";
}

// Cerrar la conexión a la base de datos
$conn->close();
?>
