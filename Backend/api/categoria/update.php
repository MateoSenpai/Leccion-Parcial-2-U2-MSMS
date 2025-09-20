<?php
header("Content-Type: application/json; charset=UTF-8");
include_once '../../backend/config_database.php';
include_once '../../backend/models_categoria.php';

$database = new Database();
$db = $database->getConnection();
$categoria = new Categoria($db);

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->id) && !empty($data->nombre)) {
    $categoria->id = $data->id;
    $categoria->nombre = $data->nombre;
    $categoria->descripcion = $data->descripcion ?? '';

    if ($categoria->update()) {
        http_response_code(200);
        echo json_encode(array("message" => "Categoría actualizada correctamente."));
    } else {
        http_response_code(503);
        echo json_encode(array("message" => "No se pudo actualizar la categoría."));
    }
} else {
    http_response_code(400);
    echo json_encode(array("message" => "Datos incompletos. Se requiere ID y nombre."));
}
?>