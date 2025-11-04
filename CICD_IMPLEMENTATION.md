# 🚀 CI/CD Implementation Guide

> **Complete GitHub Actions setup for automated testing, quality checks, and releases**

## 📋 **Overview**

This guide documents the complete CI/CD implementation added to the Symfony Docker skeleton, providing automated workflows for pull request validation, continuous integration, security scanning, and semantic releases.

## 🏗️ **Architecture Overview**

```
🔄 GitHub Actions Workflows
├── 📝 PR Validation (pr-validation.yml)
│   ├── Conventional Commits validation
│   ├── PR size analysis and labeling
│   ├── Quick syntax checks
│   └── Auto-labeling based on content
├── 🧪 CI Pipeline (ci.yml)
│   ├── Code Quality (PHPStan, CS-Fixer, Tests)
│   ├── Multi-Environment Builds (dev/test/prod)
│   ├── Integration Tests (with MariaDB)
│   ├── Security Scans (Trivy, Composer audit)
│   └── Performance Tests (load testing)
├── 🔒 Dependency Review (dependency-review.yml)
│   ├── Vulnerability scanning
│   ├── License compliance
│   └── Security reporting
├── 🏷️ Semantic Versioning (semantic-version.yml)
│   ├── Conventional commit analysis
│   ├── Automatic version bumping
│   ├── Changelog generation
│   └── Tag creation
└── 📦 Release (release.yml)
    ├── Release note generation
    ├── Asset compilation
    └── Distribution preparation
```

## 🎯 **Workflow Details**

### **1. Pull Request Validation**

**Triggers:** PR opened, edited, synchronize, reopened

**Jobs:**
- **Validate PR Title**: Ensures conventional commit format
- **PR Size Check**: Analyzes and labels PR size (S/M/L/XL/XXL)
- **Quick Validation**: Fast syntax and composer validation
- **Auto-label**: Adds labels based on PR type and scope

**Example PR titles:**
```
✅ feat(auth): add JWT token validation
✅ fix: resolve memory leak in user service
✅ docs: update API documentation
❌ Added new stuff
❌ Fixed bug
```

### **2. CI Pipeline**

**Triggers:** Push to main/develop, Pull requests

**Five parallel jobs:**

#### **🔍 Code Quality**
```yaml
- PHPStan Level 6 analysis
- PHP-CS-Fixer style checks
- PHPUnit test suite
- Composer security audit
```

#### **🏗️ Multi-Environment Builds**
```yaml
- Development environment build
- Testing environment build  
- Production environment build
- Docker image validation
```

#### **🧪 Integration Tests**
```yaml
- MariaDB service container
- Database migrations
- API endpoint testing
- End-to-end scenarios
```

#### **🛡️ Security Scans**
```yaml
- Trivy CVE scanner
- Docker image vulnerability scan
- Dependency security audit
- OWASP ZAP baseline scan
```

#### **⚡ Performance Tests**
```yaml
- Load testing with Apache Bench
- Response time validation
- Memory usage monitoring
- Concurrent request handling
```

### **3. Dependency Review**

**Triggers:** Pull requests

**Purpose:** Automatically reviews dependency changes for security vulnerabilities

**Features:**
- GitHub's dependency review action
- Composer security audit
- PR comments with security warnings
- Artifact upload for audit results

### **4. Semantic Versioning**

**Triggers:** Push to main branch

**Process:**
1. Analyzes conventional commits since last release
2. Determines version bump type (major/minor/patch)
3. Generates changelog from commit messages
4. Creates git tag with new version
5. Triggers release workflow if new version created

**Version Bumping Rules:**
```
feat: 1.0.0 → 1.1.0 (minor)
fix: 1.0.0 → 1.0.1 (patch)
feat!: 1.0.0 → 2.0.0 (major - breaking change)
docs/chore/etc: No version bump
```

### **5. Release Workflow**

**Triggers:** Tag creation, manual dispatch

**Process:**
1. Builds optimized production Docker images
2. Generates comprehensive release notes
3. Creates GitHub release with assets
4. Notifies relevant stakeholders

## 📝 **Conventional Commits Integration**

The CI/CD system is built around [Conventional Commits](./CONVENTIONAL_COMMITS.md) specification:

### **Commit Types**
- `feat`: New features → Minor version bump
- `fix`: Bug fixes → Patch version bump
- `docs`: Documentation → No version bump
- `style`: Code style → No version bump
- `refactor`: Code refactoring → No version bump
- `test`: Tests → No version bump
- `chore`: Maintenance → No version bump
- `ci`: CI/CD changes → No version bump

### **Breaking Changes**
Add `!` after type for breaking changes:
```bash
feat!: migrate to PHP 8.3
# Results in major version bump (1.0.0 → 2.0.0)
```

### **Scopes (Optional)**
```bash
feat(auth): add OAuth2 support
fix(api): resolve rate limiting issue
docs(readme): update installation guide
```

## 🔧 **Setup Instructions**

### **1. Repository Setup**

1. **Enable GitHub Actions**:
   ```bash
   # Actions are enabled by default for new repos
   # For existing repos: Settings → Actions → Allow all actions
   ```

2. **Configure Branch Protection** (Settings → Branches):
   ```yaml
   Rules for main branch:
   ☑️ Require a pull request before merging
   ☑️ Require status checks to pass before merging
     - 🔍 PHP Syntax Check
     - 🎨 Code Style (PHP-CS-Fixer)
     - 📊 Static Analysis (PHPStan)
     - 🧪 Unit Tests (PHPUnit)
     - 📦 Composer Validation
   ☑️ Require conversation resolution before merging
   ☑️ Include administrators
   ```
   
   **Quick setup:**
   ```bash
   make branch-protection
   # O directamente: ./scripts/setup-branch-protection.sh
   ```

3. **Update Badge URLs**:
   Replace `USERNAME/REPOSITORY` in README.md badges:
   ```markdown
   [![CI Pipeline](https://github.com/YOUR_USERNAME/YOUR_REPO/workflows/CI%20Pipeline/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/ci.yml)
   ```

### **2. Secrets Configuration**

No additional secrets required! All workflows use `GITHUB_TOKEN` which is automatically provided.

### **3. First Run**

1. **Commit the workflows**:
   ```bash
   git add .github/
   git commit -m "ci: add comprehensive GitHub Actions CI/CD pipeline"
   git push origin main
   ```

2. **Create first PR**:
   ```bash
   git checkout -b feat/test-ci-pipeline
   echo "# Test" >> TEST.md
   git add TEST.md
   git commit -m "feat: add test file for CI validation"
   git push origin feat/test-ci-pipeline
   # Create PR through GitHub UI
   ```

3. **Verify workflows**:
   - Check Actions tab in GitHub
   - Confirm all 5 CI jobs complete successfully
   - Verify PR gets automatically labeled
   - Test semantic release on merge

## 📊 **Monitoring & Insights**

### **GitHub Actions Dashboard**

Navigate to **Actions** tab to monitor:
- ✅ Workflow run history
- ⏱️ Average execution times
- 🔍 Detailed job logs
- 📈 Success/failure trends

### **Security Insights**

Navigate to **Security** tab for:
- 🛡️ Dependency vulnerability alerts
- 📊 Code scanning results
- 🔒 Secret scanning findings

### **Performance Metrics**

CI Pipeline provides metrics for:
- **Build Times**: Track build performance across environments
- **Test Execution**: Monitor test suite execution time
- **Security Scans**: Track vulnerability scan duration
- **Performance Tests**: API response time benchmarks

## 🚨 **Troubleshooting**

### **Common Issues**

#### **1. CI Jobs Failing**

```bash
# Check specific job logs in Actions tab
# Common issues:
- Docker build context problems
- Dependency installation failures
- Test environment configuration
```

#### **2. PR Validation Errors**

```bash
# Most common: Invalid PR title format
✅ Good: "feat(auth): add user authentication"
❌ Bad: "Added authentication feature"

# Fix: Update PR title to follow conventional commits
```

#### **3. Semantic Release Not Triggering**

```bash
# Ensure commits follow conventional format
git log --oneline -5

# Check if main branch is protected
# Verify webhook deliveries in Settings → Webhooks
```

#### **4. Performance Test Failures**

```bash
# Usually due to:
- Service startup time (increase wait periods)
- Resource constraints (reduce concurrent requests)
- Network latency (adjust timeout values)
```

### **Debugging Steps**

1. **Check Action Logs**:
   ```
   GitHub → Actions → Failed Run → Job Details
   ```

2. **Local Testing**:
   ```bash
   # Test Docker builds locally
   make env-dev
   make test

   # Validate commit format
   git log --oneline | head -5
   ```

3. **Validate Workflows**:
   ```bash
   # Use GitHub CLI to validate syntax
   gh workflow list
   gh workflow view ci.yml
   ```

## 🎯 **Best Practices**

### **Commit Guidelines**

1. **Use Conventional Commits**:
   ```bash
   feat: add feature
   fix: resolve bug
   docs: update documentation
   ```

2. **Write Descriptive Messages**:
   ```bash
   ✅ feat(auth): implement JWT token validation with refresh mechanism
   ❌ feat: add auth stuff
   ```

3. **Keep Changes Focused**:
   - One feature/fix per commit
   - Related changes in same PR
   - Break large features into smaller PRs

### **PR Management**

1. **Size Guidelines**:
   - 🟢 S (0-50 lines): Quick review
   - 🔵 M (51-200 lines): Standard review
   - 🟡 L (201-500 lines): Thorough review needed
   - 🟠 XL (501-1000 lines): Consider splitting
   - 🔴 XXL (1000+ lines): Should be broken down

2. **Review Process**:
   - Wait for all CI checks to pass
   - Address review feedback
   - Ensure conventional commit format
   - Squash related commits before merge

### **Release Management**

1. **Version Strategy**:
   - Use semantic versioning (MAJOR.MINOR.PATCH)
   - Document breaking changes clearly
   - Maintain backward compatibility when possible

2. **Release Notes**:
   - Generated automatically from conventional commits
   - Manual editing possible for major releases
   - Include migration guides for breaking changes

## 📈 **Metrics & KPIs**

Track these metrics to improve your CI/CD process:

### **Development Metrics**
- **Build Success Rate**: Target 95%+
- **Average PR Size**: Keep under 200 lines
- **CI Execution Time**: Monitor for performance degradation
- **Test Coverage**: Maintain or improve coverage

### **Security Metrics**
- **Vulnerability Response Time**: Fix critical issues within 24h
- **Dependency Freshness**: Keep dependencies updated
- **Security Scan Coverage**: 100% of PRs scanned

### **Release Metrics**
- **Release Frequency**: Aim for regular, small releases
- **Hot Fix Rate**: Minimize emergency releases
- **Release Success Rate**: Target 100% successful deployments

## 🔄 **Continuous Improvement**

### **Regular Reviews**

1. **Monthly CI/CD Review**:
   - Analyze workflow performance
   - Update dependencies
   - Review security scan results
   - Optimize build times

2. **Quarterly Process Review**:
   - Evaluate conventional commit adoption
   - Review PR size trends
   - Update workflows based on team feedback
   - Benchmark against industry standards

### **Workflow Updates**

1. **Stay Updated**:
   - Monitor GitHub Actions marketplace
   - Update action versions regularly
   - Follow security best practices
   - Adopt new features as available

2. **Customize for Your Team**:
   - Adjust notification settings
   - Modify PR size thresholds
   - Customize security scan sensitivity
   - Add team-specific quality gates

---

## 📚 **Additional Resources**

- [Conventional Commits Specification](https://conventionalcommits.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org/)
- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [PHPStan Documentation](https://phpstan.org/user-guide/getting-started)

---

**💡 Pro Tip**: Start with the basic CI pipeline and gradually add more advanced features like performance testing and security scanning as your team becomes comfortable with the workflow.