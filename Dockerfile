# Multi-stage Dockerfile for Symfony Docker Skeleton
# Optimized builds for development, testing, and production environments
# =======================================================================

# ================================================
# Stage 1: Base - Common foundation for all environments
# ================================================
FROM php:8.2-fpm-alpine AS base

# Build arguments for user mapping
ARG PUID=1000
ARG PGID=1000

# Install essential system dependencies
RUN set -eux; \
    apk add --no-cache \
        bash \
        git \
        libzip-dev \
        icu-dev \
        mysql-client; \
    # Create application user and group
    addgroup -g ${PGID} -S app; \
    adduser -u ${PUID} -S app -G app

# Install core PHP extensions required for Symfony
RUN set -eux; \
    docker-php-ext-configure intl; \
    docker-php-ext-install -j"$(nproc)" \
        pdo_mysql \
        intl \
        zip \
        opcache

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Set working directory
WORKDIR /var/www/html

# ================================================
# Stage 2: Development - Full tooling for local development
# ================================================
FROM base AS development

# Install development tools and Xdebug
RUN set -eux; \
    apk add --no-cache \
        $PHPIZE_DEPS \
        linux-headers; \
    # Install Xdebug for debugging
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    # Clean up build dependencies
    apk del $PHPIZE_DEPS; \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Copy development PHP configuration
COPY docker/php/dev/ /usr/local/etc/php/conf.d/

# Set environment identifier
ENV APP_ENV=dev

# ================================================
# Stage 3: Testing - Optimized for CI/CD pipelines
# ================================================
FROM base AS testing

# Install additional extensions for testing (without Xdebug for speed)
RUN set -eux; \
    docker-php-ext-install -j"$(nproc)" pcntl

# Copy testing PHP configuration
COPY docker/php/test/ /usr/local/etc/php/conf.d/

# Set environment identifier
ENV APP_ENV=test

# Copy source code for testing in CI
COPY . .

# Install dependencies including dev packages for testing
RUN set -eux; \
    composer install --optimize-autoloader --no-interaction

# ================================================
# Stage 4: Production - Minimal and optimized for performance
# ================================================
FROM base AS production

# Copy production PHP configuration
COPY docker/php/prod/ /usr/local/etc/php/conf.d/

# Set environment identifier
ENV APP_ENV=prod

# Copy application source code
COPY . .

# Install production dependencies only and optimize
RUN set -eux; \
    composer install --no-dev --optimize-autoloader --no-scripts --no-interaction; \
    composer dump-autoload --optimize --no-dev --classmap-authoritative; \
    # Remove development files and directories
    rm -rf \
        tests/ \
        .git/ \
        .github/ \
        phpunit.dist.xml \
        phpstan.dist.neon \
        .php-cs-fixer.dist.php \
        grumphp.yml \
        docker/ \
        Makefile \
        *.md; \
    # Set proper ownership and permissions
    chown -R app:app /var/www/html; \
    chmod -R 755 /var/www/html

# Switch to application user for security
USER app

# Health check for production monitoring
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD php-fpm-healthcheck || exit 1
