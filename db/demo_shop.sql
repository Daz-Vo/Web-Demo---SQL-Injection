-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Máy chủ: db
-- Thời gian đã tạo: Th12 28, 2025 lúc 09:14 AM
-- Phiên bản máy phục vụ: 5.7.44
-- Phiên bản PHP: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `demo_shop`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `credit_cards`
--

CREATE TABLE `credit_cards` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `card_number` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cvv` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `credit_cards`
--

INSERT INTO `credit_cards` (`id`, `user_id`, `card_number`, `cvv`, `owner_name`) VALUES
(1, 1, '4444-5555-6666-7777', '123', 'NGUYEN VAN ADMIN'),
(2, 2, '1234-5678-9012-3456', '999', 'TRAN THI USER');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(15,0) DEFAULT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `image_url`, `created_at`) VALUES
(1, 'iPhone 15 Pro Max', 'Titan tự nhiên, 256GB, Chip A17 Pro mạnh mẽ nhất.', 0, 'https://cdn.tgdd.vn/Products/Images/42/305658/iphone-15-pro-max-blue-thumbnew-600x600.jpg', '2025-12-24 03:31:35'),
(2, 'MacBook Air M2', 'Màn hình Liquid Retina, mỏng nhẹ, pin 18 tiếng.', 26500000, 'https://img.lazcdn.com/g/p/2586e193b5955a92ebcf85163f05721f.png_200x200q80.png', '2025-12-24 03:31:35'),
(3, 'Samsung Galaxy S24 Ultra', 'AI Phone, Camera 200MP, Zoom 100x.', 30990000, 'https://cdn.tgdd.vn/Products/Images/42/307174/samsung-galaxy-s24-ultra-grey-thumbnew-600x600.jpg', '2025-12-24 03:31:35'),
(4, 'Sony WH-1000XM5', 'Tai nghe chống ồn chủ động tốt nhất thế giới.', 8490000, 'https://img.lazcdn.com/g/p/1fe8efff59e217c0f7910ad28f41a982.jpg_200x200q80.jpg', '2025-12-24 03:31:35'),
(5, 'Chuột Logitech MX Master 3S', 'Chuột công thái học, cuộn vô cực, click không tiếng động.', 2190000, 'https://img.lazcdn.com/g/ff/kf/S3ce9179900d045629acaaf560e40472bW.png_200x200q80.png', '2025-12-24 03:31:35'),
(6, 'iPhone 15 Plus', 'Màn hình lớn 6.7 inch, Dynamic Island, Pin trâu cả ngày.', 25990000, 'https://img.lazcdn.com/g/p/7b6383944b2b179f602d14c808b17c06.jpg_200x200q80.jpg', '2025-12-24 03:36:42'),
(7, 'iPhone 14 Pro Gold', 'Thiết kế sang trọng, khung thép không gỉ, 3 Camera đỉnh cao.', 24500000, 'https://img.lazcdn.com/g/p/d3fd98045274de44857f5393ea945bf7.png_200x200q80.png', '2025-12-24 03:36:42'),
(8, 'iPhone 13 128GB', 'Thiết kế nhỏ gọn, hiệu năng vẫn rất mượt mà trong tầm giá.', 13590000, 'https://img.lazcdn.com/g/p/b9acb3e14a64bcce0e33f69d296df29c.png_200x200q80.png', '2025-12-24 03:36:42'),
(9, 'Laptop ASUS ROG Strix G16', 'Cấu hình khủng i7-13650HX, RTX 4060, Màn 165Hz cho game thủ.', 32990000, 'https://img.lazcdn.com/g/p/11526de0415fcdf266d3ab1d9641df48.png_200x200q80.png', '2025-12-24 03:36:42'),
(10, 'iPad Air 6 M2', 'Chip M2 xử lý đồ họa cực nhanh, thiết kế siêu mỏng.', 16990000, 'https://img.lazcdn.com/g/p/27958574290a13bf4dacf3981c2d7d10.jpg_200x200q80.jpg', '2025-12-24 03:36:42'),
(11, 'Apple Watch Ultra 2', 'Vỏ Titan siêu bền, pin 36 tiếng, chuyên cho dân thể thao.', 21490000, 'https://img.lazcdn.com/g/p/c84147b73fe19c535dda696a35090cd1.png_200x200q80.png', '2025-12-24 03:36:42'),
(12, 'Loa Marshall Stanmore III', 'Âm thanh huyền thoại, bass đầm, decor phòng cực đẹp.', 8990000, 'https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/2162/325337/loa-bluetooth-marshall-stanmore-iii-den-6-638606954565073151.jpg', '2025-12-24 03:36:42');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `role`, `created_at`) VALUES
(1, 'admin', 'admin123', 'Quản Trị Viên', 'admin', '2025-12-24 03:31:35'),
(2, 'user', '123456', 'Khách Hàng Thân Thiết', 'user', '2025-12-24 03:31:35'),
(3, 'hacker', 'hackme', 'Hacker Mũ Trắng', 'user', '2025-12-24 03:31:35');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `credit_cards`
--
ALTER TABLE `credit_cards`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `credit_cards`
--
ALTER TABLE `credit_cards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
