#!/bin/bash
set -e

echo "================================"
echo " 🛠️ Node.js Dependency Fix"
echo "================================"

# Step 1: Update safe packages
echo
echo "🔹 Updating packages to safe latest versions..."
npm update || echo "⚠️ Some packages couldn't be updated automatically."

# Step 2: Fix vulnerabilities
echo
echo "🔹 Applying security fixes..."
npm audit fix || echo "⚠️ Some vulnerabilities require manual review (try: npm audit fix --force)."

# Step 3: Install missing peer deps
echo
echo "🔹 Checking for missing peer dependencies..."
peers=$(npm ls --all 2>&1 | grep "UNMET PEER DEPENDENCY" || true)
if [ -n "$peers" ]; then
  echo "$peers"
  echo
  echo "Installing missing peer dependencies (latest versions)..."
  echo "$peers" | awk '{print $NF}' | sort -u | while read dep; do
    echo "Installing: $dep"
    npm install "$dep" || echo "⚠️ Could not install $dep (may need manual resolution)."
  done
else
  echo "✅ No missing peer dependencies."
fi

# Step 4: Run npm doctor
echo
echo "🔹 Final health check..."
npm doctor || echo "⚠️ npm doctor found warnings."

echo
echo "================================"
echo " ✅ Fix complete"
echo "================================"
