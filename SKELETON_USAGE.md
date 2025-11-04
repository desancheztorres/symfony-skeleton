# 🏗️ Symfony Docker Skeleton - Usage Guide

This repository is a **production-ready Symfony 7.3 skeleton** with Docker, Xdebug, testing, and code quality tools pre-configured.

## 🚀 Creating a New Project

### Option 1: Using this skeleton directly
```bash
# Clone the skeleton
git clone <this-repository-url> my-new-project
cd my-new-project

# Remove git history and start fresh
rm -rf .git
git init
git add .
git commit -m "Initial commit from Symfony Docker Skeleton"

# Customize for your project
```

### Option 2: Using Composer (if published)
```bash
composer create-project company/symfony-docker-skeleton my-new-project
cd my-new-project
```

## 🔧 Project Customization

### 1. Update Project Information

**composer.json:**
```json
{
    "name": "your-company/your-project-name",
    "description": "Your project description",
    "license": "MIT",
    ...
}
```

**README.md:**
- Update project title
- Update description
- Update repository URLs
- Add project-specific information

### 2. Environment Configuration

**Create `.env.local`:**
```bash
# Copy and customize
cp .env .env.local

# Update these values:
DB_USER=your_db_user
DB_PASSWORD=your_secure_password
DB_NAME=your_project_name
```

**Docker User IDs (macOS/Linux):**
```bash
# Add to .env.local
PUID=$(id -u)
PGID=$(id -g)
```

### 3. Initialize the Project

```bash
# Start the environment
make up

# Install dependencies
make composer-install

# Initialize database
make init

# Run quality checks
make quality
```

## 📁 What's Included

### Core Stack
- **Symfony 7.3** - Latest LTS framework
- **PHP 8.2** - Modern PHP with performance improvements
- **Docker** - Optimized Alpine containers
- **Nginx** - High-performance web server
- **MariaDB 11.4** - Reliable database

### Development Tools
- **Xdebug 3.4.7** - Debugging (PHPStorm ready)
- **PHPUnit 11.5+** - Testing framework
- **PHPStan Level 6** - Static analysis
- **PHP-CS-Fixer** - Code formatting
- **30+ Make commands** - Developer workflow

### Pre-configured Features
- ✅ **Hot-reload configuration** - No rebuilds needed
- ✅ **External PHP config** - Easy customization
- ✅ **Optimized images** - 68% smaller than standard
- ✅ **Complete testing suite** - Unit, integration, controller tests
- ✅ **Code quality enforcement** - Automated checks
- ✅ **Debugging ready** - PHPStorm integration tested

## 🛠️ Development Workflow

### Daily Commands
```bash
make up              # Start development environment
make quality         # Run all quality checks
make test            # Run test suite
make xon             # Enable Xdebug debugging
make xoff            # Disable Xdebug (performance)
```

### Code Quality
```bash
make fix             # Fix code style
make stan            # Run static analysis  
make test-coverage   # Generate coverage report
```

## 🎯 Project Structure

```
your-project/
├── docker/          # Docker configuration
├── src/             # Application code
├── tests/           # Test files (unit, integration, controller)
├── config/          # Symfony configuration
├── public/          # Web root
├── Makefile         # Development commands
├── README.md        # Project documentation
└── composer.json    # Dependencies
```

## 🚀 Deployment Ready

This skeleton includes:
- **Production Docker optimizations**
- **OPcache configuration**
- **Security best practices**
- **Environment-based configuration**
- **CI/CD ready commands**

## 📚 Additional Documentation

- `README.md` - Complete project documentation
- `ENVIRONMENT_CHECK.md` - Setup verification
- `DEBUG_TESTING_GUIDE.md` - Xdebug setup
- `SETUP_COMPLETE.md` - Feature overview

## 🤝 Contributing to the Skeleton

If you improve this skeleton, consider contributing back:

1. Fork the original skeleton repository
2. Make your improvements
3. Test with `make quality`
4. Submit a pull request

---

**Happy coding with Symfony Docker Skeleton!** 🚀