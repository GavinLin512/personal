# 使用官方 PHP 镜像
FROM php:8.3-fpm

# 設定工作目錄
WORKDIR /var/www

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libzip-dev \
    nodejs \
    npm

# 安裝 PHP 擴展
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# 安裝 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 複製現有應用程式
COPY . .

# 安裝 Laravel 依賴
RUN composer install

# 安裝 Node.js 依賴
RUN npm install

# 設定權限
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www

# 開放端口
EXPOSE 9000

# 啟動 PHP-FPM 伺服器
CMD ["php-fpm"]
