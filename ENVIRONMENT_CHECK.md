# ✅ Environment Verification Checklist

Use this checklist to verify your development environment is properly set up.

## 🔍 Quick Health Check

Run these commands to verify everything is working:

### 1. Docker Services Status
```bash
make ps
```
**Expected:** All containers should be "Up" (db may show "unhealthy" initially, that's normal)

### 2. Application Response
```bash
curl -I http://localhost:8080/
```
**Expected:** `HTTP/1.1 200 OK`

### 3. Xdebug Configuration
```bash
docker compose exec php env | grep XDEBUG
```
**Expected:**
```
XDEBUG_MODE=debug  (or "off" if disabled)
XDEBUG_CONFIG=client_host=host.docker.internal client_port=9003 start_with_request=yes
```

### 4. Composer Dependencies
```bash
make composer-install
```
**Expected:** No errors, dependencies installed

### 5. Code Quality Tools
```bash
make stan
make cs
make fix
```
**Expected:** PHPStan and PHP-CS-Fixer run without errors

### 6. Testing Suite
```bash
make test
```
**Expected:** All PHPUnit tests pass (green output)

## 🛠️ Setup Verification (First Time)

### New Team Member Checklist

- [ ] **Docker Desktop** installed and running
- [ ] **Make** command available (`make --version`)
- [ ] **Git** repository cloned
- [ ] **Environment started** (`make up`)
- [ ] **Dependencies installed** (`make composer-install`)
- [ ] **Database initialized** (`make init`)
- [ ] **Application accessible** at http://localhost:8080
- [ ] **Tests passing** (`make test`)
- [ ] **Code quality tools working** (`make quality`)
- [ ] **PHPStorm configured** (if using Xdebug)

### PHPStorm Debugging Verification

- [ ] **Server configured:** Name = `localhost`, Host = `localhost`, Port = `8080`
- [ ] **Path mappings set:** Project root → `/var/www/html`
- [ ] **Debug port:** `9003`
- [ ] **External connections:** Enabled
- [ ] **Xdebug enabled:** `make xon`
- [ ] **Debugger listening:** Phone icon active in PHPStorm
- [ ] **Breakpoint test:** Set breakpoint in SimpleController.php line 15
- [ ] **Debug session:** Visit http://localhost:8080/?XDEBUG_SESSION=PHPSTORM
- [ ] **Breakpoint hit:** PHPStorm should pause execution

## 🚨 Common Issues & Solutions

### "Container not found" or "Port already in use"
```bash
make down
docker system prune -f
make up
```

### "Permission denied" errors
```bash
sudo chown -R $(id -u):$(id -g) .
```

### Xdebug not connecting
```bash
make xoff && make xon
make xstatus
```

### Database connection issues
```bash
make db-drop db-create migrate
```

## 📊 Performance Verification

### Expected Performance Metrics
- **Container startup:** ~15-30 seconds
- **Application response:** <200ms
- **Memory usage:** ~256MB total
- **Image sizes:** ~180MB (vs ~580MB standard)

### Check Resource Usage
```bash
docker stats --no-stream
```

## ✅ Environment Ready!

If all checks pass, your development environment is fully functional and ready for team development.

**Next steps:**
1. Read the main README.md for detailed documentation
2. Configure your IDE following the debugging section
3. Start developing!

---
**Created:** November 3, 2025  
**Environment:** Symfony 7.3 + PHP 8.2 + Docker + Xdebug  
**Status:** ✅ Tested and Working