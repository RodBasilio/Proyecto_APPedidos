<?php

// Conexión a la base de datos (ajusta los valores según tu configuración)
$servername = "localhost:3307";
$username = "root";
$password = "Sqlgorod132435";
$dbname = "sis104basedatos";

// Crear conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar la conexión
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Consulta para eliminar todos los datos de la tabla
$sql = "TRUNCATE TABLE pedidos";

if ($conn->query($sql) === TRUE) {
    echo "Todos los datos fueron eliminados exitosamente.";
} else {
    echo "Error al eliminar los datos: " . $conn->error;
}

// Cerrar conexión
$conn->close();

?>
