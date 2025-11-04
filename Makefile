# Simple Makefile for Docker + Symfony developer workflow
# Note: Make recipes must be indented with a TAB character.

# Tools
COMPOSE := docker compose
EXEC_PHP := $(COMPOSE) exec php
RUN_PHP  := $(COMPOSE) run --rm php

# Default target
.DEFAULT_GOAL := help

# Always run these targets (don't treat them as files)
.PHONY: up build down restart ps logs logs-php logs-nginx logs-db bash sh composer-install composer-update \
	console cc db-create db-drop migrate fixtures init xon xoff xstatus xdebug-info xdebug-full xdebug-test \
	php-config php-prod php-dev optimize-images git-hooks-install git-hooks-run git-hooks-run-all \
	git-hooks-configure git-hooks-status security-check security-advisories help

## —— Docker lifecycle ————————————————————————————————————————————————
up: ## Build and start containers in background
	$(COMPOSE) up -d --build

build: ## Build images without starting containers
	$(COMPOSE) build

down: ## Stop and remove containers, networks, etc.
	$(COMPOSE) down

restart: ## Restart running containers
	$(COMPOSE) restart

ps: ## Show container status
	$(COMPOSE) ps

logs: ## Tail all service logs
	$(COMPOSE) logs -f

logs-php: ## Tail PHP logs
	$(COMPOSE) logs -f php

logs-nginx: ## Tail Nginx logs
	$(COMPOSE) logs -f nginx

logs-db: ## Tail MariaDB logs
	$(COMPOSE) logs -f db

## —— Shells ————————————————————————————————————————————————————————
bash: ## Open bash in PHP container
	$(EXEC_PHP) bash

sh: ## Open sh in PHP container
	$(EXEC_PHP) sh

## —— Composer ————————————————————————————————————————————————————————
composer-install: ## Install Composer dependencies (optimized)
	$(EXEC_PHP) composer install --no-interaction --prefer-dist --optimize-autoloader

composer-update: ## Update Composer dependencies
	$(EXEC_PHP) composer update --no-interaction

composer-require: ## Require a package (usage: make composer-require PKG="vendor/package")
	@if [ -z "$(PKG)" ]; then echo "❌ Error: PKG parameter required. Usage: make composer-require PKG=\"vendor/package\""; exit 1; fi
	$(EXEC_PHP) composer require $(PKG) --no-interaction

composer-require-dev: ## Require a dev package (usage: make composer-require-dev PKG="vendor/package")
	@if [ -z "$(PKG)" ]; then echo "❌ Error: PKG parameter required. Usage: make composer-require-dev PKG=\"vendor/package\""; exit 1; fi
	$(EXEC_PHP) composer require --dev $(PKG) --no-interaction

install-phpunit: ## Install PHPUnit and testing dependencies
	$(EXEC_PHP) composer require --dev phpunit/phpunit symfony/test-pack --no-interaction

## —— Symfony Console ———————————————————————————————————————————————
# Use: make console CMD="cache:clear -e dev"
console: ## Run Symfony console command (pass CMD="..."), e.g. make console CMD="cache:clear"
	$(EXEC_PHP) php bin/console $(CMD)

cc: ## Clear cache
	$(EXEC_PHP) php bin/console cache:clear

## —— Database (Doctrine) ————————————————————————————————————————————
db-create: ## Create database if not exists
	$(EXEC_PHP) php bin/console doctrine:database:create --if-not-exists

db-drop: ## Drop database (force)
	$(EXEC_PHP) php bin/console doctrine:database:drop --force --if-exists

migrate: ## Run migrations
	$(EXEC_PHP) php bin/console doctrine:migrations:migrate -n

fixtures: ## Load fixtures (requires doctrine-fixtures-bundle)
	$(EXEC_PHP) php bin/console doctrine:fixtures:load -n

init: up composer-install db-create migrate ## One-shot: up + deps + db + migrate

## —— Xdebug toggles (JetBrains Docker best practices) ————————————————
# Xdebug is installed; activate via XDEBUG_MODE. These targets recreate php.
xon: ## Enable Xdebug (debug mode) for PHPStorm
	@echo "🐛 Enabling Xdebug..."
	XDEBUG_MODE=debug $(COMPOSE) up -d --no-deps php
	@echo "✅ Xdebug enabled. Connect PHPStorm to localhost:9003"

xoff: ## Disable Xdebug (off) for better performance
	@echo "⚡ Disabling Xdebug..."
	XDEBUG_MODE=off $(COMPOSE) up -d --no-deps php
	@echo "✅ Xdebug disabled for better performance"

xstatus: ## Show current Xdebug configuration
	@echo "📊 Xdebug Status:"
	@$(EXEC_PHP) php -r "echo 'Xdebug loaded: ' . (extension_loaded('xdebug') ? 'YES' : 'NO') . PHP_EOL;"
	@$(EXEC_PHP) php -r "echo 'Xdebug mode: ' . (function_exists('xdebug_info') ? ini_get('xdebug.mode') : 'Not available') . PHP_EOL;"
	@echo ""
	@echo "Environment variables:"
	@$(EXEC_PHP) env | grep -E "XDEBUG|PHP_IDE" || echo "No Xdebug environment variables set"

xdebug-info: ## Show complete Xdebug configuration
	@echo "=== Xdebug Extension Status ==="
	$(EXEC_PHP) php -m | grep -i xdebug || echo "Xdebug not found"
	@echo ""
	@echo "=== Xdebug Key Settings ==="
	$(EXEC_PHP) php -i | grep -E "xdebug\.(mode|start_with_request|idekey)"

xdebug-full: ## Show all Xdebug configuration details
	@echo "=== Complete Xdebug Information ==="
	$(EXEC_PHP) php -i | grep -i xdebug

xtest: ## Test simple debugging (JetBrains recommended)
	@echo "🧪 Testing Xdebug setup..."
	@echo "1. Make sure Xdebug is enabled: make xon"
	@echo "2. Start PHPStorm debugger (phone icon)"
	@echo "3. Set breakpoint in src/Controller/SimpleController.php line 15"
	@echo "4. Visit: http://localhost:8080/?XDEBUG_SESSION=PHPSTORM"
	@echo ""
	@echo "Alternative: Visit http://localhost:8080/ and trigger with browser extension"
	@command -v open >/dev/null 2>&1 && open "http://localhost:8080/?XDEBUG_SESSION=PHPSTORM" || echo "Open: http://localhost:8080/?XDEBUG_SESSION=PHPSTORM"

## —— Code Quality ————————————————————————————————————————————————
stan: ## Run PHPStan analysis
	$(EXEC_PHP) vendor/bin/phpstan analyse

cs: ## Run PHP-CS-Fixer (dry-run)
	$(EXEC_PHP) vendor/bin/php-cs-fixer fix --dry-run --diff --ansi --allow-risky=yes

fix: ## Run PHP-CS-Fixer (fix)
	$(EXEC_PHP) vendor/bin/php-cs-fixer fix --ansi --allow-risky=yes

## —— Testing (PHPUnit) ————————————————————————————————————————————
test: ## Run PHPUnit tests
	$(EXEC_PHP) vendor/bin/phpunit

test-coverage: ## Run PHPUnit tests with coverage
	$(EXEC_PHP) vendor/bin/phpunit --coverage-html var/coverage

test-unit: ## Run only unit tests
	$(EXEC_PHP) vendor/bin/phpunit tests/Unit

test-integration: ## Run only integration tests
	$(EXEC_PHP) vendor/bin/phpunit tests/Integration

test-filter: ## Run specific test (usage: make test-filter FILTER="TestClassName")
	$(EXEC_PHP) vendor/bin/phpunit --filter $(FILTER)

## —— Full Quality Check ————————————————————————————————————————————
quality: ## Run all quality checks (fix, stan, test)
	@echo "🔧 Running PHP-CS-Fixer..."
	$(EXEC_PHP) vendor/bin/php-cs-fixer fix --ansi --allow-risky=yes
	@echo "🔍 Running PHPStan..."
	$(EXEC_PHP) vendor/bin/phpstan analyse
	@echo "🧪 Running PHPUnit tests..."
	$(EXEC_PHP) vendor/bin/phpunit
	@echo "✅ All quality checks passed!"

## —— PHP Configuration ——————————————————————————————————————————————
php-config: ## Show current PHP configuration
	$(EXEC_PHP) php --ini
	@echo ""
	@echo "=== Key PHP Settings ==="
	$(EXEC_PHP) php -i | grep -E "(memory_limit|max_execution_time|upload_max_filesize|post_max_size|opcache|xdebug\.mode)"

php-prod: ## Switch to production PHP configuration  
	@echo "Switching to production PHP configuration..."
	cp docker/php/php.prod.ini docker/php/php.ini
	$(COMPOSE) restart php
	@echo "✅ Production configuration applied"

php-dev: ## Switch to development PHP configuration
	@echo "Switching to development PHP configuration..."  
	git checkout docker/php/php.ini 2>/dev/null || echo "Development config already active"
	$(COMPOSE) restart php
	@echo "✅ Development configuration applied"

## —— Docker optimization ——————————————————————————————————————————————
optimize-images: ## Rebuild images with optimizations and show size comparison
	@echo "Building optimized images..."
	$(COMPOSE) build --no-cache
	@echo "\nImage sizes:"
	@docker images | grep -E "(symfony|REPOSITORY)" | head -10

clean-build: ## Clean build cache and rebuild
	docker builder prune -f
	$(COMPOSE) build --no-cache --pull

## —— Git Hooks (GrumPHP) ——————————————————————————————————————————
git-hooks-install: ## Install GrumPHP git hooks
	@echo "🔨 Installing GrumPHP git hooks..."
	$(EXEC_PHP) vendor/bin/grumphp git:init
	@echo "✅ Git hooks installed successfully!"

git-hooks-run: ## Run GrumPHP checks manually on staged files
	@echo "🔍 Running GrumPHP checks..."
	$(EXEC_PHP) vendor/bin/grumphp run

git-hooks-run-all: ## Run GrumPHP checks on all files
	@echo "🔍 Running GrumPHP checks on all files..."
	$(EXEC_PHP) vendor/bin/grumphp run --tasks=

git-hooks-configure: ## Configure GrumPHP with Docker
	@echo "⚙️ Configuring GrumPHP..."
	$(EXEC_PHP) vendor/bin/grumphp configure

git-hooks-status: ## Show GrumPHP git hooks status
	@echo "📊 GrumPHP Git Hooks Status:"
	@ls -la .git/hooks/ | grep -E "(pre-commit|commit-msg)" || echo "No GrumPHP hooks found"
	@echo ""
	@echo "Configuration file:"
	@ls -la grumphp.yml 2>/dev/null || echo "grumphp.yml not found"

## —— Security ——————————————————————————————————————————————————————
security-check: ## Check for security vulnerabilities using Composer audit
	@echo "🔒 Checking for security vulnerabilities..."
	$(EXEC_PHP) composer audit

security-advisories: ## Check PHP Security Advisories (detailed output)
	@echo "🔒 Checking security advisories..."
	$(EXEC_PHP) composer audit --format=json || true

## —— Help ——————————————————————————————————————————————————————————
help: ## Show this help
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'