<?php
// Datos de conexión a la base de datos
$servername = "localhost:3307";
$username = "root";
$password = "Sqlgorod132435";
$dbname = "sis104basedatos";

// Obtén los datos del formulario
$imagen = $_POST['imagen'];
$nombre = $_POST['nombre'];
$precio = $_POST['precio'];

// Crear la conexión a la base de datos
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar si la conexión es exitosa
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

// Preparar la consulta SQL para insertar los datos en la tabla
$sql = "INSERT INTO productos (imagen, nombre, precio) VALUES ('$imagen', '$nombre', '$precio')";

// Ejecutar la consulta SQL
if ($conn->query($sql) === TRUE) {
    echo "Datos guardados correctamente";
} else {
    echo "Error al guardar los datos: " . $conn->error;
}

// Cerrar la conexión a la base de datos
$conn->close();
?>

