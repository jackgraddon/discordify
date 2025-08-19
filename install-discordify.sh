#!/bin/bash
# install-discordify.sh
# Simple install script for discordify CLI tool.
# Downloads the latest discordify.sh from GitHub and places it in /usr/local/bin/discordify
# Then sets executable permissions.

INSTALL_PATH="/usr/local/bin/discordify"
GITHUB_RAW_URL="https://raw.githubusercontent.com/jackgraddon/discordify/main/discordify.sh"

echo "Installing discordify..."

# Check for curl or wget
if command -v curl >/dev/null 2>&1; then
  downloader="curl -Lo"
elif command -v wget >/dev/null 2>&1; then
  downloader="wget -O"
else
  echo "Error: Neither curl nor wget is installed. Please install one to continue."
  exit 1
fi

# Download the script
echo "Downloading discordify.sh from GitHub..."
if ! $downloader "$INSTALL_PATH" "$GITHUB_RAW_URL"; then
  echo "Error: Failed to download discordify.sh."
  exit 1
fi

# Make executable
chmod +x "$INSTALL_PATH"

echo "discordify installed successfully at $INSTALL_PATH"
echo "You can now run the command: discordify"
