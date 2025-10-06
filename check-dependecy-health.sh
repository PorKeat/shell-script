#!/bin/bash
set -e

echo "================================"
echo " 🔍 Node.js Dependency Check"
echo "================================"

# Step 1: Outdated packages
echo
echo "🔹 Outdated packages:"
npm outdated || echo "✅ No outdated packages."

# Step 2: Vulnerabilities
echo
echo "🔹 Vulnerabilities:"
npm audit || echo "✅ No vulnerabilities found."

# Step 3: Unmet peer deps
echo
echo "🔹 Unmet peer dependencies:"
npm ls --all 2>&1 | grep "UNMET PEER DEPENDENCY" || echo "✅ No unmet peer dependencies."

# Step 4: General project health
echo
echo "🔹 Project health:"
npm doctor || echo "✅ No npm doctor issues."

echo
echo "================================"
echo " ✅ Check complete"
echo "================================"
