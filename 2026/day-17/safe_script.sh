#!/bin/bash
set -e

DIR="/tmp/devops-test"
FILE="test.txt"

echo " Creating directory..."
mkdir "$DIR" || echo "  Directory already exists"

echo " Entering directory..."
cd "$DIR" || { echo " Failed to enter $DIR"; exit 1; }

echo " Creating file..."
touch "$FILE" || { echo " Failed to create file $FILE"; exit 1; }

echo " All operations completed successfully!"

