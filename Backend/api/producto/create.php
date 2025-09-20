<?php
header("Content-Type: application/json; charset=UTF-8");
include_once '../../backend/config_database.php';
include_once '../../backend/models_producto.php';

$database = new Database();
$db = $database->getConnection();
$producto = new Producto($db);

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->nombre) && !empty($data->precio) && !empty($data->categoria_id)) {
    $producto->nombre = $data->nombre;
    $producto->descripcion = $data->descripcion ?? '';
    $producto->precio = $data->precio;
    $producto->categoria_id = $data->categoria_id;
    $producto->imagen = $data->imagen ?? '';

    if ($producto->create()) {
        http_response_code(201);
        echo json_encode(array("message" => "Producto creado correctamente."));
    } else {
        http_response_code(503);
        echo json_encode(array("message" => "No se pudo crear el producto."));
    }
} else {
    http_response_code(400);
    echo json_encode(array("message" => "Datos incompletos. Se requiere nombre, precio y categoría."));
}
?>