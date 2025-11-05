# Troubleshooting Guide

## 🚨 **Common Issues & Solutions**

### **Docker & Container Issues**

#### **Port Already in Use**
```bash
# Problem: Error starting container - port already in use
Error: bind: address already in use

# Diagnosis
make check-ports
lsof -i :8080

# Solutions
1. Change ports in .env:
   make set-ports NGINX=8090

2. Stop conflicting service:
   sudo lsof -ti:8080 | xargs kill -9

3. Use different project name:
   make set-ports PROJECT=myapp2
```

#### **Container Name Conflicts**
```bash
# Problem: Container name already exists
Error: container name "symfony-nginx" is already in use

# Solution
1. Change project name:
   make set-ports PROJECT=unique-name

2. Or remove existing containers:
   docker container prune
   make up
```

#### **Permission Denied Errors**
```bash
# Problem: Permission denied when accessing files
Error: Permission denied: /var/www/html/var/cache

# Diagnosis
ls -la var/

# Solutions
1. Fix container user mapping in .env:
   PUID=1000  # Your user ID
   PGID=1000  # Your group ID

2. Get your actual IDs:
   id -u  # User ID
   id -g  # Group ID

3. Rebuild with correct IDs:
   make down
   make build
   make up

4. Manual fix (temporary):
   make bash
   chown -R www-data:www-data /var/www/html/var
```

#### **Volume Mount Issues on macOS**
```bash
# Problem: Slow performance or files not updating
# Cause: Docker Desktop volume performance on macOS

# Solutions
1. Check volume configuration in docker-compose.yml:
   - .:/var/www/html:cached  # Should have :cached

2. Increase Docker Desktop resources:
   Docker Desktop → Preferences → Resources
   Memory: 4GB+, CPUs: 2+

3. Use delegated volumes for write-heavy operations:
   - ./var:/var/www/html/var:delegated
```

### **Database Issues**

#### **Database Connection Failed**
```bash
# Problem: SQLSTATE[HY000] [2002] Connection refused
Error: Connection refused

# Diagnosis
make logs-db
docker compose ps

# Solutions
1. Wait for database to fully start:
   make logs-db | grep "ready for connections"

2. Check DATABASE_URL in .env:
   DATABASE_URL=mysql://symfony:symfony@db:3306/app

3. Verify database container is running:
   make ps
   
4. Reset database:
   make down
   docker volume prune
   make up
```

#### **Database Port Conflicts**
```bash
# Problem: Local MySQL/PostgreSQL conflict
Error: bind: address already in use (port 3306/5432)

# Solutions
1. Change database port:
   make set-ports DB=5433

2. Stop local database:
   sudo service mysql stop
   sudo service postgresql stop

3. Use different port in DATABASE_URL:
   DATABASE_URL=mysql://symfony:symfony@db:3306/app
   # Note: Internal port stays 3306, external changes
```

#### **Database Data Persistence**
```bash
# Problem: Database data lost after restart
# Cause: Missing volume configuration

# Verify volumes exist:
docker volume ls | grep db-data

# Recreate if missing:
make down
make up
```

### **Code Quality Issues**

#### **GrumPHP Commit Failures**
```bash
# Problem: GrumPHP prevents commits
Error: service "php" is not running

# Solutions
1. Start containers first:
   make up
   git commit -m "your message"

2. Check GrumPHP configuration:
   cat grumphp.yml

3. Run quality checks manually:
   make quality

4. Fix specific issues:
   make fix          # Code style
   make stan         # Fix PHPStan issues
   make test         # Fix failing tests
```

#### **PHPStan Errors**
```bash
# Problem: PHPStan Level 6 failures
Error: Property has no typehint specified

# Common fixes:
1. Add type hints:
   private string $property;
   public function method(int $param): bool

2. Add PHPDoc for complex types:
   /** @var array<string, mixed> */
   private array $config;

3. Use mixed type for unknown:
   public function getData(): mixed

4. Ignore specific errors (last resort):
   // @phpstan-ignore-next-line
```

#### **PHP-CS-Fixer Issues**
```bash
# Problem: Code style violations
Error: Files are not following PSR-12

# Solutions
1. Auto-fix most issues:
   make fix

2. Manual fixes for complex cases:
   - Check specific file:
     make bash
     vendor/bin/php-cs-fixer fix src/Controller/YourController.php --dry-run

3. Configuration issues:
   cat .php-cs-fixer.dist.php
```

#### **PHPUnit Test Failures**
```bash
# Problem: Tests failing unexpectedly

# Diagnosis
make test
make test-verbose

# Common solutions:
1. Clear test cache:
   make console cache:clear --env=test

2. Reset test database:
   make console doctrine:database:drop --env=test --force
   make console doctrine:database:create --env=test
   make console doctrine:migrations:migrate --env=test

3. Check test environment configuration:
   cat .env.test
```

### **Xdebug Issues**

#### **Xdebug Not Working**
```bash
# Problem: Xdebug not connecting to IDE

# Diagnosis
make xstatus
make xdebug-info

# Solutions
1. Verify Xdebug is enabled:
   make xon
   make xstatus

2. Check IDE configuration:
   - Port: 9003
   - Host: localhost
   - Path mapping: /var/www/html → your-project-path

3. Check Docker networking:
   make bash
   ping host.docker.internal

4. Verify environment variable:
   echo $XDEBUG_MODE  # Should show "develop,debug"
```

#### **Xdebug Performance Issues**
```bash
# Problem: Application very slow with Xdebug

# Solution
1. Disable when not debugging:
   make xoff

2. Check Xdebug mode:
   make xstatus
   # Should be "off" when not debugging

3. Optimize Xdebug configuration:
   cat docker/php/xdebug.ini
```

### **Performance Issues**

#### **Slow Container Startup**
```bash
# Problem: Containers take too long to start

# Diagnosis
time make up

# Solutions
1. Use existing images instead of building:
   make up  # Instead of make build

2. Optimize Docker Desktop:
   - Increase memory allocation
   - Enable VirtioFS file sharing

3. Prune Docker system:
   docker system prune -a
   docker volume prune
```

#### **Slow Application Response**
```bash
# Problem: Web application responds slowly

# Diagnosis
make logs-nginx | grep "upstream"
make logs-php | grep "slow"

# Solutions
1. Disable Xdebug if not needed:
   make xoff

2. Check OPcache status:
   make bash
   php -m | grep -i opcache

3. Optimize PHP configuration:
   cat docker/php/opcache.ini

4. Monitor resource usage:
   docker stats
```

### **Development Environment Issues**

#### **Hot Reload Not Working**
```bash
# Problem: Code changes not reflected immediately

# Solutions
1. Verify volume mounts:
   docker compose config | grep volumes

2. Check file permissions:
   ls -la
   # Files should be readable by container

3. Restart web server:
   make restart-nginx

4. Clear Symfony cache:
   make console cache:clear
```

#### **Composer Issues**
```bash
# Problem: Composer install/update failures

# Diagnosis
make composer-install
make logs-php

# Solutions
1. Update Composer:
   make bash
   composer self-update

2. Clear Composer cache:
   make bash
   composer clear-cache

3. Install with verbose output:
   make bash
   composer install -vvv

4. Check memory limits:
   make bash
   php -ini | grep memory_limit
```

### **CI/CD Pipeline Issues**

#### **GitHub Actions Failures**
```bash
# Problem: CI pipeline failing

# Diagnosis
1. Check specific job failure in GitHub Actions
2. Run same commands locally:
   make quality

# Common solutions:
1. Update GitHub Actions cache:
   # Clear cache in GitHub repository settings

2. Check PHP version compatibility:
   # Ensure CI uses same PHP version as local

3. Test locally with same conditions:
   ENV=test make up
   make quality
```

#### **Quality Gate Failures**
```bash
# Problem: Quality checks failing in CI but passing locally

# Solutions
1. Ensure same environment:
   ENV=test make quality

2. Check for environment-specific issues:
   cat .env.test

3. Clear all caches:
   make console cache:clear --env=test
   docker system prune
```

## 🔧 **Diagnostic Commands**

### **System Health Check**
```bash
# Complete system status
make ps                 # Container status
make show-config       # Port configuration
make check-ports       # Port availability
docker system df       # Disk usage
docker system events   # Real-time events
```

### **Performance Analysis**
```bash
# Resource usage
docker stats           # Real-time container stats
make logs | tail -100  # Recent application logs
top                    # System resource usage
```

### **Network Debugging**
```bash
# Network connectivity
make bash
ping db               # Database connectivity
ping host.docker.internal  # Host connectivity
netstat -tlnp         # Open ports
```

## 📞 **Getting Help**

### **Log Collection for Support**
```bash
# Collect comprehensive logs
mkdir debug-logs
make logs > debug-logs/containers.log
docker system info > debug-logs/docker-info.log
make show-config > debug-logs/config.log
docker compose config > debug-logs/compose-config.log
```

### **Community Resources**
- **GitHub Issues**: Report bugs and feature requests
- **Documentation**: [docs/](../README.md)
- **Architecture Decisions**: [docs/adr/](../adr/)

### **Emergency Recovery**
```bash
# Nuclear option: Reset everything
make down
docker system prune -a --volumes
docker volume prune
rm -rf var/cache/* var/log/*
cp .env.example .env
make up
```

---

**Last Updated**: November 5, 2025  
**Version**: v1.4.0