# PROJECT CONTEXT - Symfony Docker Multi-Environment Skeleton

## 🎯 **Sobre este Proyecto**

Este proyecto es un **Symfony Docker Multi-Environment Skeleton** diseñado para ser la base de múltiples proyectos Symfony con las siguientes características:

- ✅ **Multi-environment**: dev/test/prod environments optimizados
- ✅ **CI/CD automatizado**: GitHub Actions con 5 jobs paralelos
- ✅ **Multi-project support**: Puertos configurables para múltiples proyectos simultáneos
- ✅ **Code quality enforcement**: PHPStan, PHP-CS-Fixer, PHPUnit, GrumPHP
- 🔄 **DDD + Hexagonal Architecture**: Planificado para v2.0.0

## 🏗️ **Stack Tecnológico**

### **Core Framework**
- **Symfony 7.3 LTS** - Framework PHP moderno
- **PHP 8.2 FPM** - Última versión estable con Alpine Linux
- **MariaDB 11.4** - Base de datos principal
- **Nginx Alpine** - Servidor web optimizado

### **Containerización**
- **Docker multi-stage builds**:
  - `development`: Xdebug enabled, volume mounts, hot reload
  - `testing`: Optimizado para CI/CD, in-memory database
  - `production`: Minimal size, security hardened, no debug tools

### **Quality Assurance**
- **PHPStan Level 6** - Análisis estático avanzado
- **PHP-CS-Fixer** - PSR-12 code style enforcement
- **PHPUnit** - Testing framework con coverage
- **GrumPHP** - Git hooks para quality gates
- **Composer** - Dependency management validation

### **CI/CD Pipeline**
- **GitHub Actions** - 5 jobs paralelos optimizados:
  1. 🔍 **syntax-check** - PHP lint validation
  2. 🎨 **code-style** - PHP-CS-Fixer enforcement
  3. 📊 **static-analysis** - PHPStan Level 6
  4. 🧪 **unit-tests** - PHPUnit with coverage
  5. 📦 **composer-validate** - Dependencies validation

## ⚙️ **Multi-Project Configuration**

### **Variables de Entorno (.env)**
```bash
###> multi-project/port-configuration ###
NGINX_PORT=8090               # Web server port
DB_PORT=5432                  # Database port (avoiding MySQL default 3306)
ADMINER_PORT=8081             # Database admin interface
COMPOSE_PROJECT_NAME=demo-app # Unique project identifier
###< multi-project/port-configuration ###
```

### **Container Naming Pattern**
- `${COMPOSE_PROJECT_NAME}-nginx` → `demo-app-nginx`
- `${COMPOSE_PROJECT_NAME}-php` → `demo-app-php`
- `${COMPOSE_PROJECT_NAME}-mariadb` → `demo-app-mariadb`
- `${COMPOSE_PROJECT_NAME}-adminer` → `demo-app-adminer`

### **Multi-Project Example Setup**
```bash
# Project 1: E-commerce
NGINX_PORT=8080, DB_PORT=5432, PROJECT=ecommerce-app

# Project 2: Blog System  
NGINX_PORT=8090, DB_PORT=5433, PROJECT=blog-system

# Project 3: Admin Dashboard
NGINX_PORT=8100, DB_PORT=5434, PROJECT=admin-dashboard
```

## 🔄 **Workflow de Desarrollo**

### **Comandos Principales**
```bash
# Environment management
make up                  # Start development environment
make down               # Stop all containers
make restart            # Restart containers
make ps                 # Show container status

# Multi-project configuration
make env-copy           # Copy .env.example to .env
make show-config        # Display current port configuration
make check-ports        # Check port availability
make set-ports          # Configure ports interactively

# Code quality
make quality            # Run all quality checks
make test              # Run PHPUnit tests
make fix               # Auto-fix code style issues

# Database operations
make db-create         # Create database
make db-drop           # Drop database
make migrate           # Run migrations
make fixtures          # Load test fixtures

# Development tools
make bash              # Access PHP container shell
make logs              # View container logs
make xon/xoff          # Enable/disable Xdebug
```

### **Git Workflow con GrumPHP**
```bash
# GrumPHP ejecuta automáticamente en cada commit:
1. PHP Lint           # Syntax validation
2. Composer          # Dependency validation  
3. JSON Lint         # JSON files validation
4. YAML Lint         # YAML files validation
5. PHP-CS-Fixer      # Code style enforcement
6. PHPStan           # Static analysis
7. PHPUnit           # Unit tests execution
```

## 📊 **Arquitectura Actual**

### **Layered Architecture (v1.x)**
```
┌─────────────────────────────────────┐
│              Controller             │ ← HTTP Layer
├─────────────────────────────────────┤
│               Service               │ ← Business Logic
├─────────────────────────────────────┤
│              Repository             │ ← Data Access
├─────────────────────────────────────┤
│               Entity                │ ← Domain Models
└─────────────────────────────────────┘
```

### **Target Architecture (v2.x)**
```
┌─────────────────────────────────────┐
│            Infrastructure           │ ← Controllers, DB, External APIs
├─────────────────────────────────────┤
│             Application             │ ← Use Cases, DTOs, Services
├─────────────────────────────────────┤
│               Domain                │ ← Entities, Value Objects, Rules
└─────────────────────────────────────┘
```

## 🚀 **Version History & Roadmap**

### **Released Versions**
- **v1.1.0** - GrumPHP git hooks + code quality
- **v1.2.0** - Multi-environment Docker architecture
- **v1.3.0** - GitHub Actions CI/CD pipeline
- **v1.4.0** - Multi-project port configuration ← CURRENT

### **Planned Versions**
- **v1.5.0** - Security headers, CORS, health checks
- **v1.6.0** - Database foundation (Doctrine migrations)
- **v1.7.0** - API foundation (REST + OpenAPI)
- **v2.0.0** - DDD + Hexagonal Architecture migration

## 🎓 **Conocimiento Técnico Acumulado**

### **Docker Best Practices Applied**
- Multi-stage builds para diferentes entornos
- Alpine Linux para minimal footprint
- User mapping para evitar permission issues
- Volume optimization para performance en macOS
- Health checks solo donde son críticos

### **CI/CD Optimizations**
- Jobs paralelos para máxima velocidad
- Caché de Composer entre builds
- Fail-fast strategy para feedback rápido
- Matrix strategy para multiple PHP versions (futuro)

### **Multi-Project Lessons Learned**
- Port conflicts son comunes en desarrollo
- Container name collisions causan errores
- Environment variables son más flexibles que hardcoded values
- Makefile commands simplifican DevX

### **Code Quality Evolution**
- Started: Basic PHPStan Level 0
- Current: PHPStan Level 6 + strict rules
- Future: PHPStan Level 8 + custom rules
- Architecture: Deptrac rules para DDD enforcement

## 🔧 **Configuration Files Key Locations**

```bash
# Environment configuration
.env                    # Main environment variables
.env.example           # Template with defaults
.env.local             # Local overrides (gitignored)

# Docker configuration  
docker-compose.yml     # Development environment
docker-compose.test.yml # Testing environment
docker-compose.prod.yml # Production environment
Dockerfile             # Multi-stage container definition

# Quality tools
grumphp.yml           # Git hooks configuration
phpstan.neon          # Static analysis rules
phpunit.xml           # Testing configuration
.github/workflows/    # CI/CD pipeline definitions

# Development tools
Makefile              # Development commands
bin/console           # Symfony console
bin/phpunit           # PHPUnit executable
```

## 🎯 **Best Practices Establecidas**

### **Development Workflow**
1. Always run `make check-ports` before `make up`
2. Use `make quality` before commits
3. Keep port configurations documented
4. Test multi-project scenarios regularly

### **Code Quality Standards**
- PHPStan Level 6 mandatory (no errors allowed)
- PSR-12 code style enforced
- 80%+ test coverage target
- No deprecations in production code

### **Documentation Standards**
- ADRs for architectural decisions
- README updates for new features
- Code comments for complex business logic
- API documentation for public endpoints

### **Security Practices**
- No secrets in committed files
- Environment-specific configurations
- Regular dependency updates
- Security scanning in CI (planned)

## 🤝 **Team Collaboration**

### **Branch Strategy**
- `main` - Production ready code
- `feat/*` - Feature development
- `fix/*` - Bug fixes
- `docs/*` - Documentation updates

### **PR Requirements**
- All CI/CD checks passing
- Code review approval
- Documentation updates included
- Breaking changes documented

### **Release Process**
1. Feature branch → PR → Review → Merge
2. Semantic versioning (semver)
3. Release notes generation
4. Tag creation and deployment

---

**Last Updated**: November 5, 2025  
**Current Version**: v1.4.0  
**Next Milestone**: v1.5.0 - Security & Monitoring