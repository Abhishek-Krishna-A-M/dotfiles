#!/bin/bash

FILE_PATTERN=$1
MESSAGE=$2
BRANCH=$3

# 1. Argument Check
if [ "$#" -ne 3 ]; then
    echo "Error: Missing arguments."
    echo "Usage: gh <file_pattern> <message> <branch>"
    exit 1
fi

# 2. .env Safety Check
echo "Running security check..."

# Check if .env is currently staged for commit
if git diff --cached --name-only | grep -qE "^\.env$|/\.env$"; then
    echo ".env file is staged for commit."
    echo "Do you really want to push your secrets? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "Push aborted. Use 'git restore --staged .env' to unstage it."
        exit 1
    fi
fi

# Find any .env files in the current dir or subdirs
ENV_FILES=$(find . -maxdepth 3 -name ".env" \
    -not -path "*/node_modules/*" \
    -not -path "*/vendor/*" \
    -not -path "*/.git/*" \
    -not -path "*/.next/*" \
    -not -path "*/dist/*" \
    -not -path "*/build/*")

if [ -n "$ENV_FILES" ]; then
    echo "Found .env files at: $ENV_FILES"
    
    # 2. Check if .env is ignored (using git's own logic)
    # git check-ignore returns 0 if a file IS ignored
    if ! git check-ignore -q .env; then
        echo ".env is not ignored in .gitignore! Fixing..."
        
        # Add to .gitignore if not already there
        if ! grep -qs "^.env$" .gitignore; then
            echo ".env" >> .gitignore
            echo ".env*" >> .gitignore # Covers .env.local, etc.
            git add .gitignore
            echo "Added .env to .gitignore."
        fi
    fi
fi

# 3. Execution
echo "Proceeding with deployment..."
git add "$FILE_PATTERN"
git commit -m "$MESSAGE"
git push origin "$BRANCH"

echo "Success!"
