# Multi-Project Port Configuration

This document explains how to configure different ports for running multiple Symfony projects simultaneously.

## 🎯 **Overview**

The skeleton now supports configurable ports to avoid conflicts when running multiple projects based on this skeleton. Each project can have its own ports for:

- **NGINX** (web server)
- **Database** (MariaDB)
- **Adminer** (database administration)
- **Container names** (via project name)

## ⚙️ **Configuration**

### Environment Variables

The following variables in `.env` control port configuration:

```bash
# Multi-project port configuration
NGINX_PORT=8080          # Web server port
DB_PORT=5432             # Database port (changed from 3306 to avoid MySQL conflicts)
ADMINER_PORT=8081        # Adminer web interface port
COMPOSE_PROJECT_NAME=symfony-skeleton  # Docker container prefix
```

### Default Ports

- **NGINX**: 8080 (web application)
- **Database**: 5432 (to avoid conflicts with local MySQL on 3306)
- **Adminer**: 8081 (database management)

## 🚀 **Quick Setup**

### 1. Copy Environment File

```bash
make env-copy
```

### 2. Check Current Configuration

```bash
make show-config
```

### 3. Check Port Availability

```bash
make check-ports
```

### 4. Set Custom Ports (if needed)

```bash
# Set all ports at once
make set-ports NGINX=8090 DB=5433 ADMINER=8082 PROJECT=myapp

# Set individual ports
make set-ports NGINX=8090
make set-ports PROJECT=myapp2
```

## 🏗️ **Multi-Project Example**

### Project 1: Default Skeleton

```bash
# .env
NGINX_PORT=8080
DB_PORT=5432
ADMINER_PORT=8081
COMPOSE_PROJECT_NAME=symfony-skeleton
```

**Access URLs:**
- App: http://localhost:8080
- Adminer: http://localhost:8081

### Project 2: E-commerce App

```bash
# .env
NGINX_PORT=8090
DB_PORT=5433
ADMINER_PORT=8091
COMPOSE_PROJECT_NAME=ecommerce-app
```

**Access URLs:**
- App: http://localhost:8090
- Adminer: http://localhost:8091

### Project 3: Blog System

```bash
# .env
NGINX_PORT=8100
DB_PORT=5434
ADMINER_PORT=8101
COMPOSE_PROJECT_NAME=blog-system
```

**Access URLs:**
- App: http://localhost:8100
- Adminer: http://localhost:8101

## 📋 **Makefile Commands**

| Command | Description |
|---------|-------------|
| `make env-copy` | Copy `.env.example` to `.env` |
| `make show-config` | Display current port configuration |
| `make check-ports` | Check if configured ports are available |
| `make set-ports` | Set ports interactively |

## 🔧 **Manual Configuration**

You can also edit the `.env` file directly:

```bash
# Edit .env file
NGINX_PORT=8090
DB_PORT=5433
ADMINER_PORT=8091
COMPOSE_PROJECT_NAME=my-custom-project
```

Then restart the containers:

```bash
make down
make up
```

## 🐳 **Container Naming**

With `COMPOSE_PROJECT_NAME=myapp`, containers will be named:
- `myapp-php`
- `myapp-nginx`
- `myapp-mariadb`
- `myapp-adminer`

This prevents conflicts when running multiple projects.

## 🌐 **Access URLs**

After starting the containers, access your application at:

- **Main Application**: `http://localhost:${NGINX_PORT}`
- **Database Admin**: `http://localhost:${ADMINER_PORT}`

## 🔍 **Troubleshooting**

### Port Already in Use

```bash
# Check what's using the port
lsof -i :8080

# Or use the Makefile command
make check-ports
```

### Container Name Conflicts

If you get Docker container name conflicts:

```bash
# Change the project name
make set-ports PROJECT=unique-project-name

# Or edit .env directly
COMPOSE_PROJECT_NAME=unique-project-name
```

### Reset to Defaults

```bash
# Copy default configuration
cp .env.example .env

# Or set defaults manually
make set-ports NGINX=8080 DB=5432 ADMINER=8081 PROJECT=symfony-skeleton
```

## 📊 **Port Planning Template**

Use this template to plan ports for multiple projects:

| Project | NGINX | DB | Adminer | Project Name |
|---------|-------|-----|---------|--------------|
| skeleton | 8080 | 5432 | 8081 | symfony-skeleton |
| ecommerce | 8090 | 5433 | 8091 | ecommerce-app |
| blog | 8100 | 5434 | 8101 | blog-system |
| api | 8110 | 5435 | 8111 | api-service |
| dashboard | 8120 | 5436 | 8121 | admin-dashboard |

## 🎯 **Best Practices**

1. **Port Ranges**: Use logical port ranges (8080-8089, 8090-8099, etc.)
2. **Naming**: Use descriptive project names
3. **Documentation**: Keep track of used ports in your team
4. **Testing**: Always run `make check-ports` before starting
5. **Consistency**: Use the same port offset for all services in a project

## 🔄 **Integration with Existing Workflows**

This configuration works seamlessly with:

- ✅ Development workflow (`make up`, `make down`)
- ✅ Testing environment (`make env-test`)
- ✅ Production deployment (`make env-prod`)
- ✅ CI/CD pipeline (uses Docker internal networking)
- ✅ Xdebug configuration (automatically uses correct ports)

## 📈 **Version History**

- **v1.4.0**: Added multi-project port configuration support
- **v1.3.0**: Simplified CI/CD pipeline
- **v1.2.0**: Multi-environment Docker support