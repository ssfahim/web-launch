FROM php:8.1.0-apache

# Set working directory
WORKDIR /var/www/html

# Enable Apache mod_rewrite and change port
RUN a2enmod rewrite && \
    sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf

# Install system dependencies
RUN apt-get update -y && apt-get install -y \
    libicu-dev \
    libmariadb-dev \
    unzip zip \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    git \
    curl \
    nano \
    libonig-dev

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql intl

# GD configuration
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy Laravel project (including storage and bootstrap/cache)
COPY ./laravel-app /var/www/html

# Install Laravel dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Apache config
COPY apache/laravel.conf /etc/apache2/sites-available/000-default.conf

# Ensure required directories exist and set permissions
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port and run Apache
EXPOSE 8080
CMD ["apache2-foreground"]
