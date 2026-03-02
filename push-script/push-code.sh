#!/bin/bash
#
# ------------------------------------------------------------
# Auto Git Commit & Push Script
# Author: Porkeat
# Description:
#   - Detects the current Git branch dynamically
#   - Stages all changes automatically
#   - Shows staged files with color-coded status (Added, Modified, Deleted)
#   - Prompts for a commit message or accepts one as an argument
#   - Commits all changes
#   - Pushes to the remote branch and sets upstream if needed
#   - Works in Bash, Zsh, and can be run from Fish via `bash script.sh`
#
# Usage:
#   ./push.sh
#   ./push.sh "Your custom commit message"
# ------------------------------------------------------------

set -e  # Exit immediately if a command exits with a non-zero status

# -----------------------------
# Setup Colors
# -----------------------------
setup_colors() {
    if [[ -t 1 ]] && command -v tput > /dev/null 2>&1; then
        GREEN=$(tput setaf 2)
        YELLOW=$(tput setaf 3)
        RED=$(tput setaf 1)
        BLUE=$(tput setaf 4)
        BOLD=$(tput bold)
        NC=$(tput sgr0)
    else
        GREEN='' YELLOW='' RED='' BLUE='' BOLD='' NC=''
    fi
}

setup_colors

# -----------------------------
# Print functions
# -----------------------------
print_info()    { echo -e "${BLUE}ℹ️${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠️${NC} $1"; }
print_error()   { echo -e "${RED}✗${NC} $1"; }
print_header()  { echo -e "\n${BOLD}${BLUE}$1${NC}"; }

# -----------------------------
# Check Git repository
# -----------------------------
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    print_error "Not a git repository"
    exit 1
fi

# -----------------------------
# Get current branch
# -----------------------------
current_branch=$(git branch --show-current)
print_info "Current branch: ${BOLD}${current_branch}${NC}"

# -----------------------------
# Show Git status
# -----------------------------
print_header "Git Status"
git status --short

# -----------------------------
# Check for changes
# -----------------------------
if git diff-index --quiet HEAD -- 2>/dev/null; then
    print_warning "No changes to commit"
    exit 0
fi

# -----------------------------
# Get commit message
# -----------------------------
commit_message="$*"
if [ -z "$commit_message" ]; then
    echo ""
    read -r -p "Enter commit message: " commit_message
    if [ -z "$commit_message" ]; then
        print_error "Commit message cannot be empty"
        exit 1
    fi
fi

# -----------------------------
# Stage all changes
# -----------------------------
print_header "Staging Changes"
git add .
print_success "All changes staged"

# -----------------------------
# Show staged files
# -----------------------------
print_header "Files to be committed"
git diff --cached --name-status | while IFS= read -r line; do
    status="${line:0:1}"
    file="${line:2}"
    case "$status" in
        A) echo -e "  ${GREEN}+${NC} $file" ;;
        M) echo -e "  ${YELLOW}~${NC} $file" ;;
        D) echo -e "  ${RED}-${NC} $file" ;;
        *) echo -e "  ${BLUE}?${NC} $line" ;;
    esac
done

# -----------------------------
# Commit
# -----------------------------
print_header "Committing"
if git commit -m "$commit_message"; then
    print_success "Commit successful!"
else
    print_error "Commit failed"
    exit 1
fi

# -----------------------------
# Ask to push
# -----------------------------
echo ""
read -r -p "$(echo -e "${BLUE}Push to ${BOLD}origin/$current_branch${NC}${BLUE}? (y/n):${NC} ")" push_confirm

if [[ "$push_confirm" =~ ^[Yy]$ ]]; then
    print_header "Pushing to Remote"
    
    # Check if upstream exists
    if git rev-parse --verify "origin/$current_branch" > /dev/null 2>&1; then
        if git push origin "$current_branch"; then
            print_success "Successfully pushed to origin/$current_branch"
        else
            print_error "Push failed"
            exit 1
        fi
    else
        # First push, set upstream
        print_warning "No upstream branch found. Setting upstream..."
        if git push -u origin "$current_branch"; then
            print_success "Successfully pushed and set upstream to origin/$current_branch"
        else
            print_error "Push failed"
            exit 1
        fi
    fi
else
    print_info "Changes committed locally (not pushed)"
fi

print_success "${BOLD}Done!${NC}"