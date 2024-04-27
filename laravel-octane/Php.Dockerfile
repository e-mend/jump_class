# Use the official PHP image
FROM php:8.2-fpm

# Install system dependencies & PHP extensions needed by Laravel and Swoole
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libcurl4-openssl-dev \
    pkg-config \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libzip-dev \
    libssl-dev \
    libxml2-dev \
    libfreetype6-dev \
    supervisor \
    zip unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pcntl opcache \
    && pecl install swoole \
    && docker-php-ext-enable swoole

RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

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

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Change ownership of our applications
RUN chown -R www-data:www-data /var/www

# Expose port 8000 and start php-fpm server
EXPOSE 8000

CMD ["php", "artisan", "octane:start", "--host=localhost", "--port=8000", "--watch"]
# php artisan octane:start --host=localhost --port=8000 --watch
