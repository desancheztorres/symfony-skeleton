# ADR-001: Multi-Environment Docker Configuration

## Status
**Accepted** - Implemented in v1.2.0

## Date
2025-11-05

## Context
We needed a robust containerized development environment that supports multiple environments (development, testing, production) with different optimizations and configurations for each use case.

### Problems to Solve
- Inconsistent environments between local development, CI/CD, and production
- Manual environment setup complexity
- Different optimization requirements per environment
- Security considerations for production deployments

## Decision
Implement Docker multi-stage builds with three distinct targets:

### Development Target
- **Purpose**: Local development with hot reloading and debugging
- **Features**: 
  - Xdebug enabled for debugging
  - Volume mounts for hot code reloading
  - Development dependencies included
  - Composer cache optimization
- **Trade-offs**: Larger image size, less security

### Testing Target  
- **Purpose**: CI/CD pipeline optimization
- **Features**:
  - Minimal dependencies for faster builds
  - In-memory database for speed
  - No debug tools
  - Optimized for automation
- **Trade-offs**: Not suitable for interactive debugging

### Production Target
- **Purpose**: Secure, optimized production deployment
- **Features**:
  - Minimal image size (Alpine Linux)
  - No development dependencies
  - Code baked into image (no volumes)
  - Security hardening
  - OPcache optimizations
- **Trade-offs**: No debugging capabilities, immutable deployments

## Implementation

### Dockerfile Structure
```dockerfile
# Base stage with common dependencies
FROM php:8.2-fpm-alpine AS base
# ... common setup

# Development stage
FROM base AS development
# ... development-specific configuration

# Testing stage  
FROM base AS testing
# ... testing-specific configuration

# Production stage
FROM base AS production
# ... production-specific configuration
```

### Docker Compose Files
- `docker-compose.yml` - Development environment
- `docker-compose.test.yml` - Testing environment
- `docker-compose.prod.yml` - Production environment

## Consequences

### Positive
- ✅ **Environment Consistency**: Identical environments across dev/test/prod
- ✅ **Optimization**: Each environment optimized for its specific use case
- ✅ **Security**: Production environment hardened and minimal
- ✅ **Performance**: Testing environment optimized for CI/CD speed
- ✅ **Developer Experience**: Hot reloading and debugging in development

### Negative
- ❌ **Complexity**: More complex Dockerfile and build process
- ❌ **Build Time**: Multiple targets can increase build time
- ❌ **Maintenance**: Need to maintain three different configurations

### Neutral
- 🔄 **Learning Curve**: Team needs to understand multi-stage builds
- 🔄 **Documentation**: Requires comprehensive documentation

## Monitoring
- Build times across different targets
- Image sizes for each environment
- Developer onboarding time
- Production deployment reliability

## Review Date
2025-12-05 (1 month review cycle)

## Related Decisions
- [ADR-002: GitHub Actions CI/CD Pipeline](0002-github-actions-ci.md)
- [ADR-003: Multi-Project Port Configuration](0003-multi-project-ports.md)

## References
- [Docker Multi-Stage Builds Documentation](https://docs.docker.com/develop/dev-best-practices/multistage-build/)
- [PHP-FPM Alpine Best Practices](https://github.com/docker-library/docs/tree/master/php)
- [Symfony Docker Best Practices](https://symfony.com/doc/current/deployment.html)