#!/usr/bin/env bash

# Exits on error
set -e


install_git_hooks() {
    rsync -E scripts/git/hooks/* .git/hooks/
    echo "✅   Git hooks have been installed"
}

# Install git hooks
install_git_hooks

echo -n "✅   You are all setup up. Happy Coding !!"

