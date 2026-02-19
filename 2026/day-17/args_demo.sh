#!/bin/bash


echo "Script name: $0"
echo "Total number of arguments: $#"

echo "All arguments:"
for arg in "$@"; do
  echo " - $arg"
done

