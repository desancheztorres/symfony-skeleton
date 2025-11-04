# PHP Configuration Management

This setup uses external PHP configuration files instead of building them into the Docker image, making it more efficient and flexible.

## 📁 Configuration Files

### `docker/php/php.ini`
Main PHP configuration optimized for Symfony development:
- Memory limit: 512MB
- Upload limits: 64MB
- Error reporting: Full (development)
- UTF-8 defaults
- Session security settings

### `docker/php/opcache.ini` 
OPcache configuration for performance:
- Development: File validation enabled (hot-reload)
- Memory: 256MB cache
- 20,000 max files
- JIT disabled for development stability

### `docker/php/xdebug.ini`
Xdebug configuration for debugging:
- PHPStorm integration ready
- Environment variable control (`XDEBUG_MODE`)
- Performance optimized settings
- Logging disabled by default

### `docker/php/php.prod.ini`
Production-ready configuration template:
- Security hardened
- Error display disabled
- OPcache optimized for performance
- Xdebug disabled
- Smaller resource limits

## 🚀 Advantages of External Configuration

### ✅ **Efficiency Benefits**
- **No Docker rebuild** needed for config changes
- **Faster development** iteration
- **Smaller image size** (no inline configuration)
- **Layer caching** not affected by config changes

### ✅ **Flexibility Benefits**
- **Runtime configuration** changes
- **Environment-specific** settings
- **Easy A/B testing** of configurations
- **Version control** of all settings

### ✅ **Maintenance Benefits**
- **Clear separation** of concerns
- **Easier debugging** with dedicated files
- **Better documentation** with comments
- **Team collaboration** on configurations

## 🔧 Usage Commands

```bash
# View current PHP configuration
make php-config

# Check current Xdebug status
make xstatus

# Enable Xdebug for debugging
make xon

# Disable Xdebug for performance
make xoff

# Switch to production configuration
make php-prod

# Switch back to development configuration
make php-dev

# Restart PHP after manual config changes
docker compose restart php
```

## 📊 Configuration Comparison

| Setting | Development | Production |
|---------|-------------|------------|
| Memory Limit | 512MB | 256MB |
| Error Display | On | Off |
| Upload Limit | 64MB | 32MB |
| OPcache Validation | Enabled | Disabled |
| OPcache JIT | Disabled | Enabled |
| Xdebug | Available | Disabled |
| Disabled Functions | None | exec, shell_exec, etc. |

## 🛠️ Customization

### Modify Development Settings
Edit files directly in `docker/php/`:
- `php.ini` - Main PHP settings
- `opcache.ini` - Performance tuning
- `xdebug.ini` - Debugging configuration

### Create Environment Variants
```bash
# Copy and modify for staging
cp docker/php/php.ini docker/php/php.staging.ini

# Use in docker-compose.staging.yml
- ./docker/php/php.staging.ini:/usr/local/etc/php/php.ini:ro
```

### Override Individual Settings
Add environment variables in docker-compose.yml:
```yaml
environment:
  - PHP_MEMORY_LIMIT=1024M
  - PHP_MAX_EXECUTION_TIME=120
```

## 🔄 Migration from Inline Configuration

The previous inline configuration in Dockerfile has been removed and moved to external files. Benefits:

- **Before**: Config changes required `docker compose build --no-cache`
- **After**: Config changes only require `docker compose restart php`

- **Before**: ~2 minutes rebuild time
- **After**: ~5 seconds restart time

This dramatically improves development workflow efficiency.

## 🚨 Important Notes

1. **File Permissions**: Ensure config files are readable (644)
2. **Syntax Validation**: Test config changes with `php -t` 
3. **Environment Variables**: Xdebug still uses `XDEBUG_MODE` for runtime control
4. **Production**: Always use `php.prod.ini` for production deployments
5. **Git Tracking**: All config files are version controlled