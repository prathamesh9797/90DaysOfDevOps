#!/bin/bash

SERVICE="nginx"   # it can be anything sshd, docker, etc. if you want

read -p "Do you want to check the status of $SERVICE? (y/n): " CHOICE

if [ "$CHOICE" = "y" ]; then
    systemctl status "$SERVICE"

    if systemctl is-active --quiet "$SERVICE"; then
        echo "$SERVICE is active."
    else
        echo "$SERVICE is not active."
    fi

elif [ "$CHOICE" = "n" ]; then
    echo "Skipped."
else
    echo "Invalid choice. Please enter y or n."
fi
