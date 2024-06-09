<?php 

// require '../config/connect_db.php';

// // Allow CORS requests from any origin
// header("Access-Control-Allow-Origin: *");
// // Allow specific HTTP methods
// header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
// // Allow specific HTTP headers
// header("Access-Control-Allow-Headers: Content-Type, Authorization");

// // $query = "SELECT * FROM pengguna WHERE id_pengguna = '$id_pengguna'";
// $username = $_POST['username'];
// $password = $_POST['password'];

// $query = "SELECT username, password FROM pengguna
// WHERE username = $username AND password = $password";
// $result = mysqli_query($conn, $query);

// $rows = [];
// while ($row = mysqli_fetch_assoc($result)) {
//     $rows[] = $row;
// }

// echo json_encode($rows);

// if(mysqli_num_rows($conn) > 0) {
//     $rows = [];
//     while ($row = mysqli_fetch_assoc($result)) {
//         $rows[] = $row;
//     }

//     echo json_encode($rows);
// } else {
//     echo json_encode(array("data"=>"not found"));    
// }


require '../config/connect_db.php';

// Allow CORS requests from any origin
header("Access-Control-Allow-Origin: *");
// Allow specific HTTP methods
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
// Allow specific HTTP headers
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Escape the input to prevent SQL Injection
    $username = mysqli_real_escape_string($conn, $username);
    $password = mysqli_real_escape_string($conn, $password);

    $query = "SELECT id_pengguna, username FROM pengguna WHERE username = '$username' AND password = '$password'";
    $result = mysqli_query($conn, $query);

    if ($result) {
        $row = mysqli_fetch_assoc($result);
        if ($row) {
            echo json_encode([
                "success" => true,
                "id_pengguna" => $row['id_pengguna'],
                "username" => $row['username']
            ]);
        } else {
            echo json_encode([
                "success" => false,
                "message" => "Username atau password tidak terdaftar!"
            ]);
        }
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Error executing query: " . mysqli_error($conn)
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "Invalid request method"
    ]);
}

mysqli_close($conn);

?>