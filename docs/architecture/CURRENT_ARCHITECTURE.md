# Current Architecture

## 🏗️ **Architecture Overview**

This document describes the current architectural state of the Symfony Docker Multi-Environment Skeleton (v1.4.0).

### **Architecture Philosophy**
- **Simplicity First**: Start with proven patterns, evolve complexity as needed
- **Environment Consistency**: Identical behavior across dev/test/prod
- **Developer Experience**: Optimize for fast feedback and ease of use
- **Quality First**: Automated quality gates prevent technical debt
- **Multi-Project Ready**: Support concurrent development workflows

## 📊 **Current Architecture (v1.x - Layered)**

### **High-Level Structure**
```
┌─────────────────────────────────────────────────────┐
│                  Web Layer                          │
│  Nginx → PHP-FPM → Symfony Framework               │
└─────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────┐
│                Controller Layer                     │ 
│  HTTP Request Handling + Validation                │
└─────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────┐
│                Service Layer                        │
│  Business Logic + Application Services             │
└─────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────┐
│               Repository Layer                      │
│  Data Access + Query Logic                         │
└─────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────┐
│                Entity Layer                         │
│  Domain Models + Data Structures                   │
└─────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────┐
│              Infrastructure Layer                   │
│  Database + External Services + File System        │
└─────────────────────────────────────────────────────┘
```

### **Technology Stack**

#### **Runtime Environment**
```
PHP 8.2 FPM (Alpine Linux)
├── Extensions: pdo_mysql, intl, zip, opcache
├── Composer 2.x for dependency management
├── Xdebug 3.x for development debugging
└── OPcache for production performance
```

#### **Web Stack**
```
Nginx Alpine
├── FastCGI → PHP-FPM communication
├── Static file serving optimization
├── Gzip compression enabled
└── Security headers (planned v1.5.0)
```

#### **Database Stack**
```
MariaDB 11.4
├── Optimized for Symfony/Doctrine
├── UTF8MB4 charset support
├── Development: Volume persistence
└── Testing: In-memory (tmpfs)
```

#### **Development Tools**
```
Adminer (Database Admin)
├── Web-based database management
├── Multi-project port configuration
└── Direct database access for debugging
```

## 📁 **Directory Structure**

### **Source Code Organization**
```
src/
├── Controller/          # HTTP request handlers
│   └── SimpleController.php
├── Entity/             # Domain models (planned)
├── Repository/         # Data access layer (planned)
├── Service/            # Business logic (planned)
├── EventListener/      # Symfony event handling (planned)
└── Kernel.php          # Application kernel
```

### **Configuration Structure**
```
config/
├── packages/           # Bundle configuration
│   ├── framework.yaml  # Symfony framework config
│   ├── routing.yaml    # Routing configuration
│   └── cache.yaml      # Cache configuration
├── routes/             # Route definitions
│   └── framework.yaml  # Framework routes
├── services.yaml       # Service container
└── bundles.php         # Bundle registration
```

### **Testing Structure**
```
tests/
├── Unit/               # Unit tests for isolated components
│   └── ExampleUnitTest.php
├── Integration/        # Integration tests
│   └── KernelIntegrationTest.php
├── Controller/         # Controller functional tests
│   └── SimpleControllerTest.php
└── bootstrap.php       # Test bootstrap
```

### **Infrastructure Structure**
```
docker/
├── nginx/              # Nginx configuration
│   └── default.conf    # Virtual host configuration
├── php/                # PHP configuration
│   ├── php.ini         # PHP settings
│   ├── opcache.ini     # OPcache optimization
│   └── xdebug.ini      # Xdebug configuration
└── mysql/              # Database configuration (planned)
```

## 🔄 **Application Flow**

### **Request Lifecycle**
```
1. HTTP Request → Nginx
2. Nginx → PHP-FPM (FastCGI)
3. PHP-FPM → Symfony Kernel
4. Kernel → Route Resolution
5. Route → Controller Action
6. Controller → Service Layer (if complex logic)
7. Service → Repository (if data access)
8. Repository → Database
9. Response ← Reverse flow
```

### **Development Workflow**
```
1. Developer changes code
2. Volume mount updates container
3. OPcache invalidation (dev mode)
4. Immediate reflection in browser
5. Xdebug available for debugging
```

### **Quality Workflow**
```
1. Code change
2. Local: GrumPHP pre-commit hooks
3. Remote: GitHub Actions pipeline
4. Quality gates: Syntax + Style + Analysis + Tests
5. Merge approval required
```

## 🏛️ **Architectural Patterns**

### **Currently Implemented**

#### **Dependency Injection**
- Symfony Service Container
- Automatic service discovery
- Configuration-based service definition

#### **Configuration Management**
- Environment-based configuration (.env files)
- Multi-environment support (dev/test/prod)
- Hierarchical configuration loading

#### **Testing Patterns**
- Unit testing with PHPUnit
- Integration testing with Symfony test framework
- Test environment isolation

#### **Code Quality Patterns**
- Static analysis with PHPStan
- Code style enforcement with PHP-CS-Fixer
- Automated quality gates with GrumPHP

### **Planned for Future Versions**

#### **Domain-Driven Design (v2.0.0)**
- Domain entities with business logic
- Value objects for data integrity
- Domain services for complex operations
- Repository pattern for data access

#### **Hexagonal Architecture (v2.0.0)**
- Application layer with use cases
- Infrastructure layer with adapters
- Domain layer with pure business logic
- Dependency inversion principle

## 📊 **Data Architecture**

### **Current State**
- No database layer implemented yet
- Ready for Doctrine ORM integration
- Database migrations system prepared
- Multi-environment database support

### **Planned Database Architecture**
```
Application Layer
├── Entities (Domain Models)
├── Repositories (Data Access Interfaces)
└── Migrations (Schema Evolution)

Infrastructure Layer
├── Doctrine ORM Configuration
├── Database Connection Management
└── Query Optimization
```

## 🔒 **Security Architecture**

### **Current Implementation**
- Environment variable separation
- No secrets in committed code
- Development/production environment isolation

### **Planned Enhancements (v1.5.0)**
- Security headers implementation
- CORS configuration
- Rate limiting
- Input validation frameworks
- SQL injection protection (Doctrine)

## 📈 **Performance Architecture**

### **Current Optimizations**
- OPcache enabled in production
- Nginx static file serving
- Docker volume caching on macOS
- Composer optimization

### **Planned Optimizations**
- Redis/Memcached integration
- Application-level caching
- Database query optimization
- Asset compilation and minification

## 🔌 **Integration Architecture**

### **Internal Integrations**
- Symfony framework components
- Doctrine ORM (planned)
- Monolog logging (planned)
- Symfony Messenger (planned)

### **External Integrations**
- Database (MariaDB)
- Development tools (Adminer)
- CI/CD (GitHub Actions)
- Quality tools (PHPStan, PHP-CS-Fixer)

### **Planned Integrations**
- API clients for external services
- Event-driven architecture
- Message queues
- Monitoring and observability

## 🎯 **Architecture Principles**

### **SOLID Principles**
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Subtypes must be substitutable for base types
- **Interface Segregation**: Many specific interfaces vs one general
- **Dependency Inversion**: Depend on abstractions, not concretions

### **12-Factor App Principles**
- **Config**: Environment-based configuration
- **Dependencies**: Explicit dependency declaration
- **Processes**: Stateless, share-nothing architecture
- **Port Binding**: Self-contained service binding
- **Logs**: Treat logs as event streams

### **Clean Architecture Principles**
- **Independence**: Framework independence
- **Testability**: Easy to test business logic
- **UI Independence**: UI can change without changing business rules
- **Database Independence**: Business rules not bound to database
- **External Agency Independence**: Business rules don't know about external interfaces

## 📊 **Metrics & Monitoring**

### **Current Monitoring**
- Container health status
- Application logs via Docker logs
- Database connection monitoring
- Build pipeline success/failure

### **Planned Monitoring (v1.5.0)**
- Application performance metrics
- Error tracking and alerting
- Business metrics collection
- Infrastructure monitoring

## 🔄 **Evolution Strategy**

### **Current → v1.5.0 (Security & Monitoring)**
- Add security headers and CORS
- Implement health check endpoints
- Add structured logging
- Basic monitoring setup

### **v1.5.0 → v2.0.0 (DDD + Hexagonal)**
- Refactor to hexagonal architecture
- Implement domain-driven design patterns
- Add architectural testing with Deptrac
- Establish bounded contexts

### **v2.0.0+ (Scale & Optimization)**
- Microservices readiness
- Event-driven architecture
- Advanced caching strategies
- Performance optimization

---

**Last Updated**: November 5, 2025  
**Architecture Version**: v1.4.0  
**Next Review**: December 5, 2025