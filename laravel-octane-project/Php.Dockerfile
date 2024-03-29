# Use the official PHP image
FROM php:8.2-fpm

# Install system dependencies & PHP extensions needed by Laravel and Swoole
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip unzip \
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-install gd pdo pdo_mysql pcntl opcache && pecl install swoole \
&& docker-php-ext-enable swoole

# Set working directory
WORKDIR /var/www

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Prevent Composer's memory limit
ENV COMPOSER_MEMORY_LIMIT=-1

# Copy existing application directory
COPY . .

# Install dependencies
RUN composer install --optimize-autoloader --no-dev

# Change ownership of our applications
RUN chown -R www-data:www-data /var/www

# Expose port 8000 and start php-fpm server
EXPOSE 8000
CMD ["php", "artisan", "octane:start", "--server=swoole", "--host=0.0.0.0", "--port=8000"]
