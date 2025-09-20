<?php
header("Content-Type: application/json; charset=UTF-8");
include_once '../../backend/config_database.php';
include_once '../../backend/models_categoria.php';

$database = new Database();
$db = $database->getConnection();
$categoria = new Categoria($db);

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->nombre)) {
    $categoria->nombre = $data->nombre;
    $categoria->descripcion = $data->descripcion ?? '';

    if ($categoria->create()) {
        http_response_code(201);
        echo json_encode(array("message" => "Categoría creada correctamente."));
    } else {
        http_response_code(503);
        echo json_encode(array("message" => "No se pudo crear la categoría."));
    }
} else {
    http_response_code(400);
    echo json_encode(array("message" => "Datos incompletos. Se requiere al menos el nombre."));
}
?>