# Multi-stage build for optimized PHP-FPM 8.2 Alpine image
FROM php:8.2-fpm-alpine AS base

# Build args to align container user with host (avoid permission issues on bind mounts)
ARG PUID=1000
ARG PGID=1000

# Install essential system packages (Alpine uses apk, much smaller than apt)
# - bash: interactive shell (optional, ash is smaller but bash is more compatible)
# - git, unzip, curl: essential tooling for Composer
# - shadow: provides usermod/groupmod for UID/GID alignment
RUN set -eux; \
    apk add --no-cache \
        bash \
        git \
        unzip \
        curl \
        shadow \
        icu-dev \
        oniguruma-dev \
        libzip-dev \
        linux-headers \
    && rm -rf /var/cache/apk/*

# Align www-data UID/GID with host to prevent file ownership issues on bind mounts
RUN set -eux; \
    delgroup dialout; \
    addgroup -g "${PGID}" www-data || true; \
    adduser -u "${PUID}" -G www-data -s /bin/bash -D www-data || true

# Install Composer (latest stable) - optimized single-layer install
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# PHP extensions: Install core extensions needed by most Symfony apps in one layer
# - pdo_mysql: database connectivity
# - mbstring: multibyte string handling
# - intl: internationalization
# - zip: archive handling
# - opcache: performance (always enable in production)
RUN set -eux; \
    docker-php-ext-configure intl; \
    docker-php-ext-install -j"$(nproc)" \
        pdo_mysql \
        mbstring \
        intl \
        zip \
        opcache

# Install Xdebug extension (configuration will be mounted externally)
RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    apk del .build-deps

# Clean up and set working directory
WORKDIR /var/www/html

# Ensure www-data owns the working directory
RUN chown -R www-data:www-data /var/www/html
