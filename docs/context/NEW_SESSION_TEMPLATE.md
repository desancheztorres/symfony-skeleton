# NEW SESSION TEMPLATE - AI Assistant Context

## 🤖 **Copy/Paste Template for New AI Conversations**

Use this template when starting a new conversation with any AI assistant to provide complete context:

---

### **PROJECT CONTEXT**

Hi! I'm working on a **Symfony Docker Multi-Environment Skeleton** project. Here's the complete context:

#### **📋 Project Overview**
- **Repository**: `symfony-skeleton` by `desancheztorres`
- **Current Version**: v1.4.0
- **Purpose**: Multi-project Symfony skeleton with Docker + CI/CD
- **Branch**: `feat/multi-project-port-configuration` (or specify current)

#### **🏗️ Technical Stack**
```
Framework: Symfony 7.3 LTS + PHP 8.2 FPM
Database: MariaDB 11.4
Web Server: Nginx Alpine
Containerization: Docker multi-stage (dev/test/prod)
CI/CD: GitHub Actions (5 parallel jobs)
Quality: PHPStan L6 + PHP-CS-Fixer + PHPUnit + GrumPHP
```

#### **⚙️ Current Configuration (.env)**
```bash
NGINX_PORT=8090
DB_PORT=5432  
ADMINER_PORT=8081
COMPOSE_PROJECT_NAME=demo-app
APP_ENV=dev
XDEBUG_MODE=develop,debug
```

#### **🔧 Available Commands**
```bash
# Environment
make up/down/restart/ps
make env-copy/show-config/check-ports/set-ports

# Quality & Testing  
make quality/test/fix
make composer-install/composer-update

# Development
make bash/logs/console
make xon/xoff/xstatus
```

#### **📁 Project Structure**
```
├── src/                 # Symfony application code
├── tests/              # PHPUnit tests
├── docker/             # Docker configuration files
├── config/             # Symfony configuration
├── docs/               # Project documentation
├── .github/workflows/  # CI/CD pipeline
├── docker-compose.yml  # Main compose file
├── Makefile           # Development commands
└── grumphp.yml        # Quality hooks
```

#### **🎯 Recent Accomplishments**
- ✅ Multi-environment Docker setup (v1.2.0)
- ✅ GitHub Actions CI/CD pipeline (v1.3.0)  
- ✅ Multi-project port configuration (v1.4.0)
- ✅ Complete documentation structure

#### **📚 Documentation References**
- Full context: `docs/context/PROJECT_CONTEXT.md`
- Architecture decisions: `docs/adr/`
- Development workflow: `docs/development/DEVELOPMENT_WORKFLOW.md`
- Troubleshooting: `docs/development/TROUBLESHOOTING.md`

---

### **🎯 CURRENT QUESTION/TASK**

[Describe specifically what you want to work on or ask about]

**Context**: [Provide any additional specific context for your current task]

**Goal**: [What do you want to achieve]

**Constraints**: [Any limitations or requirements]

---

## 📝 **Example Usage Scenarios**

### **For New Feature Development**
```
I want to implement [feature] in this Symfony skeleton.
Current state: [describe current implementation]
Requirements: [list specific requirements]
```

### **For Bug Fixes**
```
I'm experiencing [issue] when [doing what].
Error: [paste error message]
Expected: [what should happen]
```

### **For Architecture Questions**
```
I'm planning to [architectural change].
Current architecture: [reference docs/architecture/]
Goal: [what you want to achieve]
```

### **For CI/CD Issues**
```
My GitHub Actions pipeline is [failing/needs enhancement].
Current pipeline: 5 jobs (syntax, style, analysis, tests, composer)
Issue: [specific problem]
```

### **For Multi-Project Setup**
```
I need to [set up multiple projects/resolve port conflicts].
Current config: [paste .env variables]
Desired setup: [describe what you want]
```

## 🔄 **Session Continuation Pattern**

When continuing work from a previous session, add:

```
This is a continuation of previous work on [feature/issue].
Previous state: [what was accomplished]
Current state: [where you left off]  
Next steps: [what needs to be done]
```

## 🚨 **Important Notes for AI Assistants**

### **Code Quality Requirements**
- ALL commits must pass GrumPHP hooks (no `--no-verify`)
- PHPStan Level 6 compliance required
- PSR-12 code style enforced
- Tests required for new features

### **Development Workflow** 
- Always use `make` commands instead of direct docker/composer
- Check port availability with `make check-ports` before starting
- Document any new features in appropriate docs/ folder
- Follow semantic versioning for releases

### **Multi-Project Considerations**
- Each project needs unique ports and container names
- Use `COMPOSE_PROJECT_NAME` for container isolation
- Default ports: NGINX=8080, DB=5432, ADMINER=8081
- Test port conflicts before deployment

### **Architecture Evolution**
- Current: Layered architecture (v1.x)
- Target: DDD + Hexagonal architecture (v2.x)
- Use Deptrac for dependency analysis (planned)
- Security-first approach for all implementations

---

**Template Version**: v1.4.0  
**Last Updated**: November 5, 2025  
**Usage**: Copy/paste the PROJECT CONTEXT section + your specific question