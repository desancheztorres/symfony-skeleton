# Conventional Commits Guide

Este proyecto utiliza [Conventional Commits](https://www.conventionalcommits.org/) para automatizar el versionado semántico y la generación de releases.

## 📋 **Formato de Commits**

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## 🏷️ **Tipos de Commits**

### **Major Changes (BREAKING CHANGE)**
```bash
# Cambia la API o comportamiento existente
feat!: change authentication method to OAuth2
feat(auth)!: replace JWT with OAuth2 implementation

BREAKING CHANGE: Authentication now requires OAuth2 tokens instead of JWT
```

### **Minor Changes (Features)**
```bash
# Nuevas funcionalidades
feat: add user registration endpoint
feat(api): implement user profile management
feat(auth): add password reset functionality
```

### **Patch Changes (Bug Fixes)**
```bash
# Corrección de errores
fix: resolve memory leak in user service
fix(api): handle null values in response
fix(auth): prevent duplicate user registration
```

### **Otros Tipos**
```bash
# Documentación
docs: update API documentation
docs(readme): add installation instructions

# Refactoring
refactor: extract user validation logic
refactor(auth): simplify token generation

# Performance
perf: optimize database queries
perf(api): reduce response time by 50%

# Tests
test: add unit tests for user service
test(integration): add API endpoint tests

# Chores (no afectan la versión)
chore: update dependencies
chore(deps): bump symfony to 7.3.1
ci: update GitHub Actions workflow
style: fix code formatting
```

## 🔄 **Versionado Automático**

El sistema automáticamente incrementa las versiones según el tipo de commit:

- **BREAKING CHANGE**: `1.0.0` → `2.0.0` (Major)
- **feat**: `1.0.0` → `1.1.0` (Minor)
- **fix**: `1.0.0` → `1.0.1` (Patch)
- **otros**: No incrementan versión

## 📖 **Ejemplos Prácticos**

### **Feature con scope**
```bash
git commit -m "feat(api): add user authentication endpoint

- Implement JWT token generation
- Add login/logout endpoints
- Include rate limiting protection"
```

### **Bug fix crítico**
```bash
git commit -m "fix: prevent SQL injection in user queries

Resolves security vulnerability in user search functionality
by implementing prepared statements."
```

### **Breaking change**
```bash
git commit -m "feat!: migrate to PHP 8.2 type declarations

BREAKING CHANGE: All method signatures now use strict types.
Update your implementations to include proper type hints."
```

## 🚀 **Workflow de Release**

1. **Desarrollo**: Commits con conventional format
2. **Pull Request**: CI valida tests, stan, fixer
3. **Merge a main**: Semantic release automático
4. **Tag creado**: Release workflow se ejecuta
5. **CHANGELOG**: Generado automáticamente

## 🎯 **Mejores Prácticas**

### **DO ✅**
```bash
feat: add user registration
fix: resolve memory leak in service
docs: update installation guide
test: add integration tests for API
```

### **DON'T ❌**
```bash
update stuff                    # Muy vago
Fixed bug                       # No sigue formato
Added new feature for users     # Muy verboso
WIP: working on authentication  # Work in progress
```

## 🔧 **Configuración IDE**

### **VS Code Extensions**
- Conventional Commits
- GitLens
- Git Graph

### **Commit Template**
```bash
# ~/.gitmessage
# <type>[optional scope]: <description>
# 
# [optional body]
# 
# [optional footer(s)]
```

```bash
git config commit.template ~/.gitmessage
```

## 📊 **Monitoreo de Commits**

Revisa la calidad de tus commits:
```bash
# Ver historial reciente
git log --oneline -10

# Verificar formato
git log --grep="^(feat|fix|docs|style|refactor|test|chore)"
```

## 🔗 **Referencias**

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)