# 🧠 Git Automation Scripts

A collection of shell scripts for automating **Git workflows**, **version management**, and **dependency health checks**.

---

## 📜 Scripts Overview

### 🏷 **push-tag.sh**

Automated Git tag versioning with smart increment logic.

#### Features

- Auto-increments **patch version** (`v1.2.3 → v1.2.4`)
- Rolls over to **minor version** when patch reaches 10 (`v1.2.9 → v1.3.0`)
- Creates **initial tag** `v1.0.0` if no tags exist
- Prompts for confirmation before pushing

#### Example

```bash
./push-tag.sh
# Current tag: v1.2.3
# New tag: v1.2.4
# Create and push tag v1.2.4? (y/n): y
```

### 📤 **push-code.sh**

Streamlined commit and push workflow.

#### Features

- Interactive or argument-based commit messages
- Displays git status and changed files
- Auto-detects current branch
- Colorized terminal output
- Confirmation prompt before pushing

#### Example

```bash
# Interactive mode
./push-code.sh

# With message
./push-code.sh "fix: update readme"
```

### ⚙️ **push-code-v2.sh**

Enhanced version of `push-code.sh` with improved automation and workflow optimizations.

### 🔍 **check-dependency-health.sh**

Dependency health scanner for Node.js projects.

#### Scans for

- Outdated packages
- Security vulnerabilities
- Version conflicts

### 🔧 **fix-dependency-health.sh**

Automated dependency resolver.

#### Fixes

- Updates outdated packages
- Resolves version conflicts
- Cleans up dependency tree

---

## 🚀 Quick Start

### Installation

```bash
# Clone or copy scripts to your project
chmod +x *.sh
```

### Usage

```bash
# Tag and release
./push-tag.sh

# Commit and push changes
./push-code.sh "your commit message"

# Check dependencies
./check-dependency-health.sh

# Fix dependency issues
./fix-dependency-health.sh
```

---

## ✨ Features

- ✅ Colorized terminal output
- ✅ Error handling and validation
- ✅ User confirmation prompts
- ✅ Auto branch detection
- ✅ Semantic versioning support
- ✅ CI/CD friendly

---

## 🧩 Prerequisites

- Git installed and configured
- Bash shell
- Git remote repository access
- Node.js / npm (for dependency scripts)

---

## 🧱 Workflow Example

```bash
# 1. Make changes to your code

# 2. Run dependency check
./check-dependency-health.sh

# 3. Commit and push changes
./push-code.sh "feat: add new feature"

# 4. Create version tag
./push-tag.sh

# 5. Tag triggers CI/CD deployment
```
