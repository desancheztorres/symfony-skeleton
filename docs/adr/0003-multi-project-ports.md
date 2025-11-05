# ADR-003: Multi-Project Port Configuration

## Status
**Accepted** - Implemented in v1.4.0

## Date
2025-11-05

## Context
Development teams often need to run multiple Symfony projects simultaneously for comparison, testing, or development of related systems. The default skeleton configuration caused port conflicts and container name collisions when running multiple instances.

### Problems to Solve
- Port conflicts when running multiple skeleton-based projects
- Container name collisions in Docker
- Manual port management complexity
- Lack of project isolation
- Poor developer experience for multi-project workflows

## Decision
Implement configurable port management through environment variables with intelligent defaults and management tools.

### Core Configuration Variables
```bash
NGINX_PORT=8080           # Web server port (configurable)
DB_PORT=5432              # Database port (changed from 3306)
ADMINER_PORT=8081         # Database admin interface port
COMPOSE_PROJECT_NAME=symfony-skeleton  # Container name prefix
```

### Key Design Decisions

#### Port Defaults Strategy
- **NGINX_PORT**: Default 8080 (common non-privileged web port)
- **DB_PORT**: Default 5432 (PostgreSQL default, avoiding MySQL 3306 conflicts)
- **ADMINER_PORT**: Default 8081 (sequential to NGINX)
- **PROJECT_NAME**: Descriptive default with easy customization

#### Container Naming Pattern
```bash
${COMPOSE_PROJECT_NAME}-nginx     # Web server
${COMPOSE_PROJECT_NAME}-php       # PHP-FPM
${COMPOSE_PROJECT_NAME}-mariadb   # Database
${COMPOSE_PROJECT_NAME}-adminer   # Database admin
```

#### Management Tools Integration
- **Makefile commands** for easy port management
- **Automatic conflict detection** before startup
- **Interactive configuration** for new projects
- **Status reporting** for current configuration

## Implementation

### Environment Files Structure
```bash
.env                    # Main configuration (gitignored)
.env.example           # Template with defaults (committed)
.env.local             # Local overrides (gitignored)
```

### Docker Compose Integration
All docker-compose files updated to use environment variables:
- `docker-compose.yml` (development)
- `docker-compose.test.yml` (testing)
- `docker-compose.prod.yml` (production)

### Makefile Commands
```bash
make env-copy          # Copy .env.example to .env
make show-config       # Display current configuration
make check-ports       # Check port availability
make set-ports         # Interactive port configuration
```

### Port Conflict Detection
```bash
# Automatic detection using lsof
lsof -i :8080 >/dev/null 2>&1 && echo "Port busy" || echo "Port free"
```

## Multi-Project Usage Patterns

### Example Configurations

#### Project 1: E-commerce Application
```bash
NGINX_PORT=8080
DB_PORT=5432
ADMINER_PORT=8081
COMPOSE_PROJECT_NAME=ecommerce-app
```

#### Project 2: Blog System
```bash
NGINX_PORT=8090
DB_PORT=5433
ADMINER_PORT=8091
COMPOSE_PROJECT_NAME=blog-system
```

#### Project 3: Admin Dashboard
```bash
NGINX_PORT=8100
DB_PORT=5434
ADMINER_PORT=8101
COMPOSE_PROJECT_NAME=admin-dashboard
```

### Port Range Recommendations
- **8080-8089**: Primary applications
- **8090-8099**: Secondary applications  
- **8100-8109**: Admin/internal tools
- **5432-5439**: Database ports
- **8081, 8091, 8101**: Adminer instances

## Consequences

### Positive
- ✅ **Zero Conflicts**: Multiple projects can run simultaneously
- ✅ **Easy Management**: Simple Makefile commands for configuration
- ✅ **Clear Isolation**: Unique container names prevent collisions
- ✅ **Developer Experience**: Intuitive port management
- ✅ **Backward Compatible**: Existing projects continue working
- ✅ **Documentation**: Complete usage examples and troubleshooting

### Negative
- ❌ **Configuration Overhead**: Additional setup step for new projects
- ❌ **Port Tracking**: Teams need to coordinate port usage
- ❌ **Memory Usage**: Multiple projects consume more system resources

### Neutral
- 🔄 **Learning Curve**: Developers need to understand port configuration
- 🔄 **Maintenance**: Port assignments need occasional cleanup

## Usage Guidelines

### Best Practices
1. **Port Planning**: Use logical port ranges for project types
2. **Documentation**: Keep port assignments documented in team wikis
3. **Conflict Checking**: Always run `make check-ports` before startup
4. **Consistent Naming**: Use descriptive `COMPOSE_PROJECT_NAME` values

### Anti-Patterns to Avoid
- Using random port numbers without pattern
- Sharing port configurations between unrelated projects
- Ignoring port conflicts and forcing container startup
- Using privileged ports (< 1024) for development

## Monitoring & Maintenance

### Success Metrics
- Time to set up new project: Target < 2 minutes
- Port conflict incidents: Target 0 per month
- Developer satisfaction with multi-project setup

### Maintenance Tasks
- Quarterly review of port assignments
- Update documentation with new project examples
- Monitor system resource usage with multiple projects

## Future Enhancements

### Planned for v1.5.0
- Automatic port assignment suggestions
- Integration with project discovery tools
- Health check endpoints with project identification

### Planned for v2.0.0
- Service mesh integration for inter-project communication
- Centralized project registry
- Automated cleanup of unused configurations

## Review Date
2025-12-05 (1 month review cycle)

## Related Decisions
- [ADR-001: Multi-Environment Docker Configuration](0001-multi-environment-docker.md)
- [ADR-002: GitHub Actions CI/CD Pipeline](0002-github-actions-ci.md)

## References
- [Docker Compose Environment Variables](https://docs.docker.com/compose/environment-variables/)
- [12-Factor App Config Principles](https://12factor.net/config)
- [Port Assignment Best Practices](https://www.iana.org/assignments/service-names-port-numbers/)
- [Makefile Best Practices](https://tech.davis-hansson.com/p/make/)