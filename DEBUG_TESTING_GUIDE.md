# 🐛 Xdebug Testing Guide - WORKING SETUP!

This guide contains the **tested and working** configuration for Xdebug with PHPStorm.

## 🚀 Quick Start (Proven to Work)

1. **Enable Xdebug:**
   ```bash
   make xon
   ```

2. **Start PHPStorm debugger** (Listen for PHP Debug Connections - phone icon)

3. **Open Simple Controller:**
   - File: `src/Controller/SimpleController.php`
   - Set breakpoint on **line 15**: `$message = "Hello from Symfony!";`

4. **Visit URL with debug session:**
   ```
   http://localhost:8080/?XDEBUG_SESSION=PHPSTORM
   ```
   
   OR use the test command:
   ```bash
   make xtest
   ```

## ✅ Working Configuration

### PHPStorm Settings (CRITICAL - Use exactly these values)

#### 1. Server Configuration (Settings → PHP → Servers)
- **Name:** `localhost` (exactly this - matches PHP_IDE_CONFIG)
- **Host:** `localhost`  
- **Port:** `8080`
- **Debugger:** `Xdebug`
- **Use path mappings:** ✅ ENABLED
- **Path mapping:** 
  - Local: `/Users/your-username/Projects/app`
  - Remote: `/var/www/html`

#### 2. Debug Settings (Settings → PHP → Debug)
- **Debug port:** `9003`
- **Can accept external connections:** ✅ ENABLED
- **Force break at first line:** ❌ DISABLED

#### 3. CLI Interpreter (Settings → PHP → CLI Interpreter)
- **Type:** Docker Compose
- **Configuration files:** `docker-compose.yml`
- **Service:** `php`

## 🔧 PHPStorm Setup

### 1. Configure PHP Interpreter
- Go to **Settings → PHP → CLI Interpreter**
- Add a new **Docker Compose** interpreter
- Select your `docker-compose.yml` file
- Choose the `php` service
- Set the path mappings:
  - Local: `/Users/your-username/Projects/app`
  - Remote: `/var/www/html`

### 2. Configure Debug Settings
- Go to **Settings → PHP → Debug**
- Set **Debug port:** `9003`
- Check **Can accept external connections**
- Uncheck **Force break at first line when no path mapping specified**

### 3. Configure Server Settings
- Go to **Settings → PHP → Servers**
- Create new server:
  - **Name:** `localhost`
  - **Host:** `localhost`
  - **Port:** `8080`
  - **Debugger:** `Xdebug`
  - **Use path mappings:** ✅
  - **Project files:** `/var/www/html`

## 🎯 Testing Workflow

### Basic Testing
1. Start PHPStorm debugger (Listen for PHP Debug Connections)
2. Set a breakpoint in `src/Controller/DebugController.php` at line ~25
3. Visit http://localhost:8080/debug/
4. PHPStorm should break at your breakpoint

### Advanced Testing
1. Set breakpoints in different methods:
   - `index()` - Basic debugging
   - `stepDebug()` - Step-by-step execution
   - `exceptionTest()` - Exception handling
   - `complexData()` - Complex data inspection

2. Practice debugging techniques:
   - **Step Over (F8)** - Execute next line
   - **Step Into (F7)** - Enter function calls
   - **Step Out (Shift+F8)** - Exit current function
   - **Evaluate Expression (Alt+F8)** - Run code in context

## 🔍 Debugging Tips

### Variables Panel
- Inspect local and global variables
- Expand arrays and objects
- Right-click for more options

### Watches
- Add expressions to monitor
- Track variable changes
- Monitor object states

### Console
- Execute PHP code in current context
- Test expressions before using them
- Debug complex logic

### Stack Trace
- Navigate function call hierarchy
- Understand execution flow
- Jump between stack frames

## 🛠️ Useful Make Commands

```bash
# Xdebug Controls
make xon              # Enable Xdebug (develop,debug mode)
make xoff             # Disable Xdebug (better performance)
make xstatus          # Show current Xdebug status
make xdebug-info      # Show Xdebug configuration
make xdebug-test      # Open debug interface and show status

# Docker Controls
make up               # Start all services
make down             # Stop all services
make php-shell        # Enter PHP container shell
make php-config       # Show PHP configuration files
```

## 🚨 Troubleshooting

### Xdebug Not Connecting
1. Check if Xdebug is enabled: `make xstatus`
2. Verify PHPStorm is listening on port 9003
3. Check path mappings in PHPStorm
4. Ensure firewall allows port 9003

### Breakpoints Not Working
1. Verify file path mappings
2. Check if breakpoints are in executable code
3. Ensure PHPStorm server configuration is correct
4. Try setting breakpoint in `public/index.php`

### Performance Issues
1. Disable Xdebug when not debugging: `make xoff`
2. Use specific debug mode: `XDEBUG_MODE=debug`
3. Check Docker resource allocation

### Path Mapping Issues
1. Use absolute paths in PHPStorm configuration
2. Verify Docker volume mounts
3. Check case sensitivity (especially on Windows)

## 📊 Debug Information

The debug controller provides comprehensive information:

- **Xdebug Status:** Version, mode, and configuration
- **PHP Environment:** Version, extensions, memory usage
- **Request Details:** Headers, parameters, server info
- **Execution Metrics:** Response time, memory usage

## 🎓 Learning Resources

- [Xdebug Documentation](https://xdebug.org/docs/)
- [PHPStorm Debugging Guide](https://www.jetbrains.com/help/phpstorm/debugging.html)
- [Docker Xdebug Setup](https://www.jetbrains.com/help/phpstorm/docker.html)

---

**💡 Pro Tip:** Use the `/debug/api` endpoint in automated tests to verify Xdebug is properly configured in your CI/CD pipeline.