#!/bin/bash
# BDK Install Script
# Usage: bash bilge-development-kit/install.sh [target-dir]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-.}"

# Convert Windows backslashes to forward slashes
TARGET="${TARGET//\\//}"

# Resolve target to absolute path
if [ -d "$TARGET" ]; then
  TARGET="$(cd "$TARGET" && pwd)"
else
  echo "Error: Target directory '$TARGET' does not exist."
  exit 1
fi

if [ "$SCRIPT_DIR" = "$TARGET" ]; then
  echo "Error: Target cannot be the BDK repo itself."
  exit 1
fi

echo ""
echo "  BDK Installer"
echo "  Target: $TARGET"
echo ""

# Check if .agent/ already exists
if [ -d "$TARGET/.agent" ]; then
  echo "  Warning: .agent/ already exists."
  read -p "  Overwrite? (Y/n): " CONFIRM
  if [ "$CONFIRM" = "n" ] || [ "$CONFIRM" = "N" ]; then
    echo "  Aborted."
    exit 0
  fi
  rm -rf "$TARGET/.agent"
fi

# Copy .agent/ (main toolkit)
cp -r "$SCRIPT_DIR" "$TARGET/.agent"
echo "  [+] .agent/ copied"

# Remove nested .git if exists
rm -rf "$TARGET/.agent/.git"

# Remove install scripts from .agent/
rm -f "$TARGET/.agent/install.sh"
rm -f "$TARGET/.agent/install.ps1"

# Check if .claude/ already exists
if [ -d "$TARGET/.claude" ]; then
  echo "  Warning: .claude/ already exists."
  read -p "  Overwrite? (Y/n): " CONFIRM
  if [ "$CONFIRM" = "n" ] || [ "$CONFIRM" = "N" ]; then
    echo "  [~] .claude/ kept (existing)"
  else
    rm -rf "$TARGET/.claude"
    cp -r "$SCRIPT_DIR/.claude" "$TARGET/.claude"
    echo "  [+] .claude/ copied"
  fi
else
  cp -r "$SCRIPT_DIR/.claude" "$TARGET/.claude"
  echo "  [+] .claude/ copied"
fi

echo "  [+] cleaned up"
echo ""
echo "  BDK installed successfully!"
echo ""
echo "  Next steps:"
echo "    cd $TARGET"
echo "    /onboard"
echo ""
