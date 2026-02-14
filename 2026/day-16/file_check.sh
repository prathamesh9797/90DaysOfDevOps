#!/bin/bash

read -p "Enter the file path to be found: " FILE

if [ -f "$FILE" ]; then
    echo "File '$FILE' exists."
else
    echo "File '$FILE' does not exist."
fi

