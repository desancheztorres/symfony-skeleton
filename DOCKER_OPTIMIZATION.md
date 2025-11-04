# Docker Image Optimization Report

## Optimizations Applied

### 1. Base Image Change: Debian → Alpine
- **Before**: `php:8.2-fpm` (Debian-based, ~400MB)
- **After**: `php:8.2-fpm-alpine` (~80MB base)
- **Savings**: ~75% image size reduction

### 2. Multi-stage Build Structure
- Cleaner layer management
- Optimized for Docker cache reuse
- Copy Composer binary from official image instead of installing

### 3. Package Management Optimization
- Alpine uses `apk` (faster, smaller packages)
- Combined RUN commands to reduce layers
- Proper cleanup with `--no-cache` and `apk del .build-deps`

### 4. Healthcheck Removal
- Removed PHP container healthcheck (unnecessary overhead)
- Removed Nginx healthcheck (Alpine Nginx is very stable)
- Kept only MariaDB healthcheck (critical service)

### 5. Volume Mount Optimization
- Changed from `:delegated` to `:cached` (better macOS performance)
- Added `:ro,cached` for Nginx (read-only with caching)

### 6. PHPStorm Xdebug Configuration
- Set `XDEBUG_IDEKEY=PHPSTORM`
- Added `xdebug.file_link_format` for PHPStorm integration
- Optimized nesting level for complex debugging
- Disabled verbose logging for performance

## Size Comparison (Estimated)

| Component | Before | After | Savings |
|-----------|--------|-------|---------|
| PHP Image | ~450MB | ~120MB | 73% |
| Nginx Image | ~50MB | ~40MB | 20% |
| Total Stack | ~500MB | ~160MB | 68% |

## PHPStorm Setup

1. Configure PHP Remote Interpreter:
   - Host: `localhost`, Port: `22` (if SSH) or use Docker directly
   - Docker container: `symfony-php`

2. Configure Xdebug:
   - Host: `host.docker.internal`
   - Port: `9003`
   - IDE Key: `PHPSTORM`

3. Path Mappings:
   - Local path: `/Users/ctorres/Projects/app`
   - Remote path: `/var/www/html`

## Commands

```bash
# Enable Xdebug for PHPStorm
make xon
# or
XDEBUG_MODE=debug make up

# Check image sizes
docker images | grep symfony

# Verify Xdebug configuration
make xstatus
```