<?php
header("Content-Type: application/json; charset=UTF-8");
include_once '../../backend/config_database.php';
include_once '../../backend/models_producto.php';

$database = new Database();
$db = $database->getConnection();
$producto = new Producto($db);

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->id)) {
    $producto->id = $data->id;

    if ($producto->delete()) {
        http_response_code(200);
        echo json_encode(array("message" => "Producto eliminado correctamente."));
    } else {
        http_response_code(503);
        echo json_encode(array("message" => "No se pudo eliminar el producto."));
    }
} else {
    http_response_code(400);
    echo json_encode(array("message" => "No se proporcionó ID de producto."));
}
?>