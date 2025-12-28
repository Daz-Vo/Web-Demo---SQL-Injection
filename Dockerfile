FROM php:8.0-apache

# Cài đặt extension mysqli để kết nối database
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# Cấp quyền cho thư mục html (tùy chọn, giúp tránh lỗi permission)
RUN chown -R www-data:www-data /var/www/html