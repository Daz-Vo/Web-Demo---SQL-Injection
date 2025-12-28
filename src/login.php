<?php
session_start();
$conn = new mysqli("db", "root", "root", "demo_shop");
$conn->set_charset("utf8mb4");

if ($conn->connect_error) {
    die("Kết nối thất bại: " . $conn->connect_error);
}

$error = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // --- LỖ HỔNG: SQL Injection Login Bypass ---
    // Vẫn giữ nguyên logic nối chuỗi chết người này
    $sql = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
    
    // Thực thi
    if ($conn->multi_query($sql)) {
        $result = $conn->store_result();
        if ($result && $result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $_SESSION['user'] = $row['username'];
            $_SESSION['role'] = $row['role'];
            header("Location: index.php");
            exit;
        } else {
            $error = "Tài khoản hoặc mật khẩu không chính xác!";
        }
    } else {
        // Trường hợp lỗi cú pháp SQL (khi nhập ký tự ')
        $error = "Lỗi hệ thống (SQL Error): " . $conn->error; 
    }
}
?>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - TechStore</title>
    <link rel="icon" type="image/x-icon" href="LOGO.ico">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <style>
        :root {
            --primary-color: #007bff;
            --bg-color: #f4f7f6;
            --text-color: #333;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
        }

        .btn-login {
  width: 100%;
  padding: 12px;
  background-color: var(--primary-color);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.3s;
  margin-top: 10px;
}

.btn-login:hover {
  background-color: #0056b3;
}

    </style>
</head>
<body>

    <div class="login-wrapper">
        <div class="brand-logo">
            <i class="fas fa-laptop-code"></i> TechStore
        </div>

        <div class="login-card">
            <div class="login-header">
                <h2>Chào mừng trở lại</h2>
                <p>Vui lòng đăng nhập để tiếp tục mua sắm</p>
            </div>

            <?php if (!empty($error)): ?>
                <div class="alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <?php echo $error; ?>
                </div>
            <?php endif; ?>

            <form method="POST">
                <div class="form-group">
                    <label for="username">Tên đăng nhập</label>
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" id="username" name="username" class="form-control" placeholder="Tên đăng nhập" required>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" class="form-control" placeholder="••••••" required>
                </div>

                <button type="submit" class="btn-login">Đăng nhập</button>
            </form>

            <div class="footer-links">
                <a href="#">Quên mật khẩu?</a> • <a href="#">Đăng ký tài khoản</a>
            </div>
        </div>
    </div>

</body>
</html>