<?php
session_start();

$conn = new mysqli("db", "root", "root", "demo_shop");
$conn->set_charset("utf8mb4");
// --- LOGIC AJAX LOGOUT ---
// Khi JS gọi index.php?action=ajax_logout, code này sẽ chạy và trả về "ok"
if (isset($_GET['action']) && $_GET['action'] == 'ajax_logout') {
    session_unset();
    session_destroy();
    echo "ok";
    exit; 
}
// --- END LOGIC ---
// Mặc định hiển thị tất cả
$sql = "SELECT * FROM products";

// Nếu có tìm kiếm
if (isset($_GET['search']) && !empty($_GET['search'])) {
    $search = $_GET['search'];
    // Vẫn giữ lỗi SQL Injection theo ý bạn để demo
    $sql = "  SELECT * FROM products WHERE name LIKE '%$search%'  ";
}



?>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechStore - Cửa hàng công nghệ</title>
    <link rel="icon" type="image/x-icon" href="LOGO.ico">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <nav class="navbar">
        <a href="index.php" class="brand"><i class="fas fa-laptop-code"></i> TechStore</a>
        
        <div class="user-info">
            <div id="logged-in-panel" style="display: <?php echo isset($_SESSION['user']) ? 'block' : 'none'; ?>;">
                <span>Xin chào, <b id="username-display"><?php echo isset($_SESSION['user']) ? htmlspecialchars($_SESSION['user']) : ''; ?></b></span>
                
                <?php if (isset($_SESSION['role']) && $_SESSION['role'] == 'admin'): ?>
                    <a href="admin.php" class="btn-auth btn-admin" style="background-color: #d32f2f; margin-right: 5px; color: white; padding: 5px 10px; border-radius: 4px; text-decoration: none;">
                        <i class="fas fa-user-shield"></i> Admin
                    </a>
                <?php endif; ?>

                <a href="#" onclick="handleLogout(event)" class="btn-auth btn-logout">Đăng xuất</a>
            </div>

            <div id="guest-panel" style="display: <?php echo isset($_SESSION['user']) ? 'none' : 'block'; ?>;">
                <span>Khách</span>
                <a href="login.php" class="btn-auth btn-login">Đăng nhập</a>
            </div>
        </div>
    </nav>

    <div class="search-container">
        <h1>Tìm kiếm sản phẩm yêu thích</h1>
        <form method="GET" class="search-box">
            <input type="text" name="search" placeholder="Nhập tên sản phẩm " 
                   value="<?php echo isset($_GET['search']) ? htmlspecialchars($_GET['search']) : ''; ?>">
            <button type="submit"><i class="fas fa-search"></i></button>
        </form>
        <?php if (isset($_GET['search'])): ?>
        <?php endif; ?>
    </div>

    <div class="container">
        <div class="product-grid">
            <?php
            // Xử lý truy vấn Multi Query (để demo lỗi Stacked Queries)
            if ($conn->multi_query($sql)) {
                if ($result = $conn->store_result()) {
                    if ($result->num_rows > 0) {
                        while ($row = $result->fetch_assoc()) {
                            $img_url = !empty($row['image_url']) ? $row['image_url'] : "https://via.placeholder.com/300x200?text=No+Image";
                            ?>
                            <div class="product-card">
                                <img src="<?php echo htmlspecialchars($img_url); ?>" alt="Product Image" class="product-img">
                                <div class="product-info">
                                    <div class="product-name"><?php echo htmlspecialchars($row['name']); ?></div>
                                    <div class="product-desc"><?php echo htmlspecialchars($row['description']); ?></div>
                                    <div class="product-meta">
                                        <div class="price"><?php echo number_format($row['price']); ?> ₫</div>
                                        <div class="rating">
                                            <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                                        </div>
                                    </div>
                                    <button class="btn-add-cart"><i class="fas fa-cart-plus"></i> Thêm vào giỏ</button>
                                </div>
                            </div>
                            <?php
                        }
                    } else {
                        echo '<div class="no-result">Không tìm thấy sản phẩm nào phù hợp.</div>';
                    }
                    $result->free();
                }
                // Vòng lặp để chạy hết các query phía sau (nếu bị tấn công)
                while ($conn->more_results() && $conn->next_result()) { }
            } 
            
            ?>
        </div>
    </div>

    <script>
    function handleLogout(event) {
        event.preventDefault();

        // Tự động lấy tên file hiện tại để tránh lỗi 404
        const currentUrl = window.location.pathname.split('/').pop() || 'index.php'; 
        
        fetch(currentUrl + '?action=ajax_logout')
            .then(response => response.text())
            .then(data => {
                console.log("Server trả về:", data); 

                // Chấp nhận cả "ok" và "logout_success"
                if (data.includes("ok") || data.includes("logout_success")) {
                    
                    // Ẩn panel User (bao gồm cả nút Admin bên trong đó)
                    document.getElementById('logged-in-panel').style.display = 'none';
                    
                    // Hiện panel Khách
                    document.getElementById('guest-panel').style.display = 'block';
                    
                    // Xóa tên hiển thị
                    document.getElementById('username-display').innerText = '';
                    
                } else {
                    console.error("Lỗi: Server chưa xác nhận logout");
                }
            })
            .catch(error => {
                console.error('Lỗi kết nối:', error);
            });
    }
    </script>

</body>
</html>