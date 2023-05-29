# Gunakan image resmi PHP 7.4 sebagai base image
FROM php:8.2-fpm

# Instal dependensi yang diperlukan
RUN apt-get update && apt-get install -y \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install ekstensi PHP yang diperlukan
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Set working directory ke direktori proyek Laravel
WORKDIR /var/www/html

# Copy file proyek Laravel ke working directory di container
COPY . /var/www/html

RUN chown -R www-data:www-data /var/www/html

RUN chmod -R 777 /var/www/html/storage

# Set permission untuk folder storage dan bootstrap/cache
# RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependensi PHP melalui Composer
RUN composer install --optimize-autoloader --no-dev

# Set permission untuk folder vendor
RUN chown -R www-data:www-data /var/www/html/vendor

# Expose port 9000 untuk koneksi ke server PHP-FPM
EXPOSE 9000

# Command yang dijalankan ketika container dijalankan
CMD ["php-fpm"]
