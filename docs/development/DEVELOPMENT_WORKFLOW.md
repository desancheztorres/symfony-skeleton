# Development Workflow

## 🚀 **Getting Started**

### **Initial Setup**
```bash
# 1. Clone the repository
git clone https://github.com/desancheztorres/symfony-skeleton.git
cd symfony-skeleton

# 2. Setup environment configuration
make env-copy

# 3. Configure ports (if needed for multi-project)
make show-config
make check-ports
make set-ports NGINX=8090 PROJECT=my-project  # optional

# 4. Start development environment
make up

# 5. Install dependencies
make composer-install

# 6. Verify setup
make ps
make logs
```

### **Access Points**
- **Application**: http://localhost:${NGINX_PORT}
- **Adminer**: http://localhost:${ADMINER_PORT}
- **Logs**: `make logs`
- **Shell**: `make bash`

## 🔄 **Daily Development Workflow**

### **Starting Work**
```bash
# 1. Update codebase
git pull origin main

# 2. Start environment
make up

# 3. Update dependencies (if composer.lock changed)
make composer-update

# 4. Check system status
make ps
make show-config
```

### **During Development**
```bash
# Code editing (hot reload enabled)
# Files auto-update in containers via volume mounts

# Run quality checks
make quality           # All quality checks
make fix              # Auto-fix code style
make test             # Run tests only

# Database operations
make db-create        # Create database
make migrate          # Run migrations
make fixtures         # Load test data

# Debugging
make xon              # Enable Xdebug
make bash             # Access container shell
make logs             # View logs
```

### **Before Committing**
```bash
# 1. Run full quality suite
make quality

# 2. Fix any issues
make fix              # Auto-fix code style issues
# Manual fixes for PHPStan/PHPUnit issues

# 3. Commit (GrumPHP hooks will run automatically)
git add .
git commit -m "feat: your feature description"

# 4. Push and create PR
git push origin feature-branch
```

## 🏗️ **Feature Development Process**

### **1. Planning Phase**
```bash
# Create feature branch
git checkout -b feat/your-feature-name

# Document architecture decisions if needed
touch docs/adr/000X-your-decision.md
```

### **2. Implementation Phase**
```bash
# Start with tests (TDD approach)
touch tests/Unit/YourFeatureTest.php
make test

# Implement feature
# Edit src/ files

# Continuous validation
make quality           # Run after significant changes
```

### **3. Testing Phase**
```bash
# Unit tests
make test

# Integration tests (if applicable)
make test-integration

# Manual testing
make up
# Test via browser/API

# Performance validation (if applicable)
make test-performance
```

### **4. Documentation Phase**
```bash
# Update relevant documentation
# - README.md (if public API changes)
# - docs/architecture/ (if architecture changes)
# - Code comments (if complex logic)

# Create/update ADR if architectural decision made
touch docs/adr/000X-your-decision.md
```

### **5. Review Phase**
```bash
# Final quality check
make quality

# Create comprehensive commit
git add .
git commit -m "feat: comprehensive description

- Feature details
- Breaking changes (if any)
- Documentation updates"

# Push and create PR
git push origin feat/your-feature-name
```

## 🔧 **Common Development Tasks**

### **Database Operations**
```bash
# Create fresh database
make db-drop
make db-create
make migrate

# Load test data
make fixtures

# Database admin interface
open http://localhost:${ADMINER_PORT}
# Server: db, User: symfony, Password: symfony, Database: app
```

### **Code Quality Management**
```bash
# Check current quality status
make quality

# Fix code style automatically
make fix

# Run specific quality tools
make lint             # PHP syntax check
make cs-check         # Code style check
make cs-fix           # Code style fix
make stan             # PHPStan analysis
make test             # PHPUnit tests

# Show PHPStan analysis details
make stan-verbose
```

### **Xdebug Management**
```bash
# Enable Xdebug for debugging
make xon

# Disable Xdebug for performance
make xoff

# Check Xdebug status
make xstatus

# Show Xdebug configuration
make xdebug-info

# Test Xdebug connection
make xdebug-test
```

### **Container Management**
```bash
# View container status
make ps

# View logs
make logs              # All containers
make logs-php          # PHP container only
make logs-nginx        # Nginx container only
make logs-db           # Database container only

# Access container shells
make bash              # PHP container bash
make sh                # PHP container sh

# Restart services
make restart           # All services
make restart-php       # PHP only
make restart-nginx     # Nginx only
```

### **Multi-Project Operations**
```bash
# Setup new project configuration
make env-copy
make set-ports NGINX=8100 DB=5435 ADMINER=8101 PROJECT=new-project

# Check for port conflicts
make check-ports

# Show current configuration
make show-config

# Switch between project configurations
# Edit .env manually or use set-ports
```

## 🌍 **Environment Management**

### **Development Environment**
```bash
# Default: docker-compose.yml
make up                # Start development environment
ENV=dev make up        # Explicit development

# Features:
# - Hot code reloading
# - Xdebug enabled
# - Volume mounts
# - Debug tools available
```

### **Testing Environment**
```bash
# Use: docker-compose.test.yml
ENV=test make up

# Features:
# - Optimized for CI/CD
# - In-memory database
# - Minimal dependencies
# - Fast startup
```

### **Production Environment**
```bash
# Use: docker-compose.prod.yml
ENV=prod make up

# Features:
# - Security hardened
# - Minimal image size
# - Code baked into image
# - Production optimizations
```

## 📊 **Monitoring & Debugging**

### **Performance Monitoring**
```bash
# Container resource usage
docker stats

# Application performance
make logs | grep "performance"

# Database performance
make bash
# Inside container: mysql performance analysis
```

### **Debugging Techniques**
```bash
# 1. Enable Xdebug
make xon

# 2. Set IDE breakpoints
# Configure PhpStorm/VSCode for Docker Xdebug

# 3. Use Symfony debug tools
make console debug:container
make console debug:router
make console debug:config

# 4. Database debugging
# Access Adminer: http://localhost:${ADMINER_PORT}
# Direct database access: make bash -> mysql commands
```

### **Log Analysis**
```bash
# Application logs
make logs-php | grep ERROR

# Web server logs
make logs-nginx | grep 404

# Database logs
make logs-db | grep "slow query"

# System logs
docker system events
```

## 🚨 **Troubleshooting Common Issues**

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed troubleshooting guide.

## 📚 **Additional Resources**

- **Project Context**: [docs/context/PROJECT_CONTEXT.md](../context/PROJECT_CONTEXT.md)
- **Architecture Decisions**: [docs/adr/](../adr/)
- **Troubleshooting**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Multi-Project Setup**: [MULTI_PROJECT_PORTS.md](../../MULTI_PROJECT_PORTS.md)

---

**Last Updated**: November 5, 2025  
**Version**: v1.4.0