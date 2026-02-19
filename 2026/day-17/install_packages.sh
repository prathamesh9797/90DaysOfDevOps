#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
    echo " Please run this script as root (use sudo)."
    exit 1
fi


PACKAGES=("nginx" "curl" "wget")

# Detect package manager
if command -v dpkg &> /dev/null; then
    PKG_CHECK="dpkg -s"
    INSTALL_CMD="sudo apt-get install -y"
    UPDATE_CMD="sudo apt-get update -y"
elif command -v rpm &> /dev/null; then
    PKG_CHECK="rpm -q"
    if command -v dnf &> /dev/null; then
        INSTALL_CMD="sudo dnf install -y"
    else
        INSTALL_CMD="sudo yum install -y"
    fi
    UPDATE_CMD=""
else
    echo "No supported package manager found (dpkg or rpm)"
    exit 1
fi

echo "Checking and installing packages..."
echo "-----------------------------------"

# Update package index once (for apt)
if [[ -n "$UPDATE_CMD" ]]; then
    echo " Updating package index..."
    $UPDATE_CMD
fi

for pkg in "${PACKAGES[@]}"; do
    if $PKG_CHECK "$pkg" &> /dev/null; then
        echo " $pkg is already installed. Skipping."
    else
        echo " $pkg is not installed. Installing..."
        if $INSTALL_CMD "$pkg"; then
            echo " $pkg installed successfully."
        else
            echo " Failed to install $pkg."
        fi
    fi
done

echo "-----------------------------------"
echo "Package check completed."

