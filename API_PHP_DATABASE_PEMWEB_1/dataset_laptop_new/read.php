<?php 


// Database connection
require '../config/connect_db.php';

// Allow CORS requests from any origin
header("Access-Control-Allow-Origin: *");
// Allow specific HTTP methods
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
// Allow specific HTTP headers
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Query to select data
$query = "SELECT * FROM dataset_laptop_new LIMIT 20";
$result = mysqli_query($conn, $query);
$rows = [];

// Fetch the data
while ($row = mysqli_fetch_assoc($result)) {
    $rows[] = $row;
}

// Return the data as JSON
echo json_encode($rows);

?>
