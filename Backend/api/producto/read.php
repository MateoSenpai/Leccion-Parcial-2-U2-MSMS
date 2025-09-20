<?php
header("Content-Type: application/json; charset=UTF-8");
include_once '../../backend/config_database.php';
include_once '../../backend/models_producto.php';

$database = new Database();
$db = $database->getConnection();
$producto = new Producto($db);

$stmt = $producto->read();
$num = $stmt->rowCount();

if ($num > 0) {
    $productos_arr = array();
    $productos_arr["records"] = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);
        $producto_item = array(
            "id" => $id,
            "nombre" => $nombre,
            "descripcion" => $descripcion,
            "precio" => $precio,
            "categoria_id" => $categoria_id,
            "categoria_nombre" => $categoria_nombre,
            "imagen" => $imagen,
            "created_at" => $created_at
        );
        array_push($productos_arr["records"], $producto_item);
    }

    http_response_code(200);
    echo json_encode($productos_arr);
} else {
    http_response_code(404);
    echo json_encode(array("message" => "No se encontraron productos."));
}
?>