# 🚀 Getting Started with Fasting Tracker Pro

> Complete setup guide from cloning to running the full stack (frontend + backend)

---

## 📋 Prerequisites

Before you begin, ensure you have:

- **Git** (v2.30+): `git --version`
- **Node.js** (v18+): `node --version` && `npm --version`
- **Java 21**: `java -version` (for backend)
- **Maven** (v3.8+): `mvn --version` (for backend)
- **Docker & Docker Compose** (optional, for database): `docker --version`
- **PostgreSQL** (v15+ OR use Docker)
- **macOS/Linux** (or WSL2 on Windows)

---

## 🔧 Step 1: Clone the Repository

```bash
# Clone the main repository
git clone https://github.com/larson-frontend/fasting-service.git
cd fasting-service

# Initialize submodules (includes shared-instructions)
git submodule update --init --recursive

# Verify submodule is loaded
ls -la shared-instructions/
# Should show: agent-usage.md, copilot.instructions.md, TEAM_SETUP_GUIDE.md, etc.
```

---

## 📁 Step 2: Understand the Project Structure

```
fasting-service/                          # Main workspace root
├── shared-instructions/                  # Shared docs (symlinked in projects)
│   ├── copilot.instructions.md          # Copilot agent instructions
│   ├── agent-usage.md                   # Agent usage history
│   ├── TEAM_SETUP_GUIDE.md              # Team onboarding
│   └── agents/                          # Agent-specific configs
├── fasting-frontend/                     # Vue.js + Capacitor mobile app
│   ├── src/                             # TypeScript/Vue source code
│   ├── android/                         # Android native project
│   ├── ios/                             # iOS native project
│   ├── .vscode/settings.json            # Copilot instructions (symlinked)
│   ├── package.json                     # Dependencies & npm scripts
│   └── capacitor.config.ts              # Mobile app config
├── fasting-service/                      # Spring Boot Java backend
│   ├── src/                             # Java source code
│   ├── pom.xml                          # Maven dependencies
│   ├── Dockerfile                       # Docker image definition
│   ├── docker-compose.yml               # Local development stack
│   └── .vscode/settings.json            # Copilot instructions (symlinked)
└── deployment/                           # Deployment guides
```

---

## 🗂️ Step 3: Setup Database

### Option A: Docker (Recommended for Quick Start)

```bash
cd fasting-service

# Start PostgreSQL in Docker
docker-compose up -d fasting-db

# Verify database is running
docker ps | grep fasting-db

# Check connection
docker-compose exec fasting-db psql -U postgres -c "SELECT 1"
```

### Option B: Local PostgreSQL

```bash
# Create database
createdb fasting_tracker_dev

# Create user
psql -U postgres -c "CREATE USER fasting WITH PASSWORD 'dev_password';"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE fasting_tracker_dev TO fasting;"
```

Update `fasting-service/application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/fasting_tracker_dev
spring.datasource.username=fasting
spring.datasource.password=dev_password
```

---

## 🔨 Step 4: Build & Run Backend

```bash
cd fasting-service

# Install dependencies & run tests
mvn clean install

# Expected output:
# [INFO] BUILD SUCCESS
# [INFO] Tests run: 92, Failures: 0, Errors: 0

# Run backend server
mvn spring-boot:run

# OR run directly
java -jar target/fasting-service-0.0.1-SNAPSHOT.jar
```

**Backend is running at:** `http://localhost:8080/api`

Test it:
```bash
curl http://localhost:8080/api/health
# Response: {"status":"UP"}
```

---

## 🎨 Step 5: Build & Run Frontend

```bash
cd fasting-frontend

# Install npm dependencies
npm install

# Expected output:
# added 638 packages, 0 vulnerabilities

# Run development server
npm run dev

# Output will show:
# VITE v7.2.6 ready in XXX ms
# ➜  Local:   http://localhost:5173/
```

**Frontend is running at:** `http://localhost:5173`

### Common Frontend Commands

```bash
npm run build              # Production build
npm run preview            # Preview production build
npm run test:all           # Run all tests (159 + 21 = 180 tests)
npm run type-check         # TypeScript validation
npm run pre-publication-check  # Validate publication readiness
```

---

## 🧪 Step 6: Verify Full Stack

### Health Checks

```bash
# Backend health
curl http://localhost:8080/api/health
# Expected: {"status":"UP"}

# Frontend (in browser)
open http://localhost:5173
# Should load Fasting Tracker app
```

### Run Tests

```bash
# Frontend tests
cd fasting-frontend
npm run test:all
# Expected: 159 passed | 4 todo, 21/21 standalone tests passed

# Backend tests
cd ../fasting-service
mvn test
# Expected: Tests run: 92, BUILD SUCCESS
```

---

## 💡 Step 7: Understanding Copilot Instructions

### How It Works

1. **Copilot reads from `.vscode/settings.json`:**
   ```json
   "copilot.instructions": [
     "shared-instructions/copilot.instructions.md"
   ]
   ```

2. **The symlink resolves automatically:**
   - `fasting-frontend/shared-instructions/` → `../shared-instructions/` (root)
   - `fasting-service/shared-instructions/` → `../shared-instructions/` (root)

3. **All projects share the same instructions:**
   - Single source of truth in `shared-instructions/copilot.instructions.md`
   - Every developer gets consistent agent behavior
   - Updates apply everywhere automatically

### Using the Agent

Open VS Code and start coding:

```bash
# Open workspace
code /path/to/fasting-service

# In the editor:
# ⌘ + I (Mac) or Ctrl + I (Linux/Windows) → Opens Copilot Chat
# Type your question or request
# Agent automatically detects task type and selects best model
```

**Example:** 
```
"Create a function to validate email addresses"
→ Agent detects: code task
→ Selects: Claude Sonnet 4.5 (for complex logic)
→ Provides: Implementation with explanation
```

---

## 🚀 Step 8: Building for Mobile

### Android

```bash
cd fasting-frontend

# Build and sync to Android
npm run android:sync

# Open Android Studio
npm run android:open

# Build signed APK (requires keystore setup - see ANDROID_SIGNING.md)
npm run build-release-apk
```

### iOS

```bash
cd fasting-frontend

# Build and sync to iOS
npm run ios:sync

# Open Xcode
npm run ios:open

# Build for App Store (requires Apple Developer account)
# In Xcode: Product → Archive → Distribute App → App Store Connect
```

---

## 📱 Step 9: Publication Readiness

### Pre-Submission Checklist

```bash
cd fasting-frontend

# Run automated validation
npm run pre-publication-check

# Expected output:
# ✓ All tests passing (159 frontend + 21 standalone)
# ✓ Production build successful
# ✓ Android configuration ready
# ✓ iOS configuration ready
# ... (more checks)
# ✓ All checks passed! Ready for publication.
```

### For Android

1. See: `fasting-frontend/PUBLICATION_GUIDE.md` (Android section)
2. See: `fasting-frontend/ANDROID_SIGNING.md` (keystore setup)
3. Upload to: Google Play Console

### For iOS

1. See: `fasting-frontend/IOS_PUBLISHING.md` (step-by-step guide)
2. Set up: Apple Developer account & certificates
3. Upload to: App Store Connect

---

## 🔒 Security & Environment Variables

### Frontend Production

Create `.env.production` in `fasting-frontend/`:

```env
VITE_API_BASE=https://your-api-domain.com/api
VITE_APP_VERSION=1.0.0
VITE_ENABLE_ANALYTICS=true
VITE_SECURE_STORAGE_ENABLED=true
```

### Backend Production

Create `.env` or set environment variables:

```bash
export DB_PASSWORD=secure_password
export JWT_SECRET=your_256bit_random_secret
export SPRING_PROFILES_ACTIVE=prod
```

---

## 🐛 Troubleshooting

### Frontend Issues

```bash
# Clear cache and reinstall
npm run clean
npm install

# Port already in use
lsof -i :5173  # Find process
kill -9 <PID>  # Kill process

# TypeScript errors
npm run type-check

# Tests failing
npm run test:all -- --reporter=verbose
```

### Backend Issues

```bash
# Clear Maven cache
mvn clean

# Database connection refused
# Check: Is PostgreSQL running?
docker ps | grep fasting-db

# Port 8080 in use
lsof -i :8080
```

### Git Issues

```bash
# Submodule not loading
git submodule update --init --recursive

# Symlink issues (Windows)
# Use: git config core.symlinks true
# Then: git reset --hard HEAD

# Verify symlinks
ls -la fasting-frontend/shared-instructions
# Should show: shared-instructions -> ../shared-instructions
```

---

## 📚 Documentation Files

| File | Purpose | Location |
|------|---------|----------|
| **PUBLICATION_GUIDE.md** | Complete publication guide | `fasting-frontend/` |
| **ANDROID_SIGNING.md** | Android keystore setup | `fasting-frontend/` |
| **IOS_PUBLISHING.md** | iOS App Store steps | `fasting-frontend/` |
| **PRODUCTION_DEPLOYMENT.md** | Backend deployment | `fasting-service/` |
| **copilot.instructions.md** | Agent instructions | `shared-instructions/` |
| **TEAM_SETUP_GUIDE.md** | Team onboarding | `shared-instructions/` |
| **agent-usage.md** | Agent usage history | `shared-instructions/` |

---

## 🚀 Quick Reference Commands

```bash
# Frontend
npm run dev                    # Start dev server (5173)
npm run build                  # Production build
npm run test:all              # Run all tests
npm run type-check            # TypeScript check
npm run pre-publication-check # Validate publication
npm run build-release-apk     # Build signed APK

# Backend
mvn clean install             # Build with tests
mvn spring-boot:run          # Run server (8080)
mvn test                      # Run tests only
mvn clean package -DskipTests # Build without tests

# Android
npm run android:sync          # Sync to Android
npm run android:open          # Open Android Studio

# iOS
npm run ios:sync              # Sync to iOS
npm run ios:open              # Open Xcode

# Database
docker-compose up -d fasting-db    # Start PostgreSQL
docker-compose down                 # Stop all services
docker-compose exec fasting-db psql # Access database
```

---

## 🎯 Next Steps After Setup

1. ✅ **Read the documentation**
   - Review `TEAM_SETUP_GUIDE.md` for team workflow
   - Check `copilot.instructions.md` for agent behavior

2. ✅ **Try the Copilot agent**
   - Open VS Code
   - Press `⌘ + I` (Mac) or `Ctrl + I` (Linux/Windows)
   - Ask a question about the codebase

3. ✅ **Run tests to verify everything works**
   - Frontend: `npm run test:all` (should see 180 tests pass)
   - Backend: `mvn test` (should see 92 tests pass)

4. ✅ **Explore the codebase**
   - Frontend: Start in `src/App.vue`
   - Backend: Check `src/main/java/com/larslab/fasting/controller/`

5. ✅ **For publication**
   - Run: `npm run pre-publication-check`
   - Follow: `PUBLICATION_GUIDE.md`
   - Submit to: Google Play & Apple App Store

---

## 📞 Getting Help

- **Copilot Chat**: Press `⌘ + I` to ask the agent
- **Documentation**: Check files in `shared-instructions/`
- **Tests**: Run full test suite to verify your changes
- **Git History**: Review commits to see how features were built

---

**Last Updated:** December 20, 2025
**Version:** 1.0.0
**Status:** Production Ready ✅

---

> 💡 **Tip:** The Copilot agent is available in your workspace. It reads instructions from `shared-instructions/copilot.instructions.md` and provides context-aware help for your task at hand!
