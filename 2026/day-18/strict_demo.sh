#!/bin/bash
set -euo pipefail

echo "Starting strict mode demo..."

#  Undefined variable (set -u)
echo "Value of UNDEFINED_VAR is: $UNDEFINED_VAR"

# Command that fails (set -e)
echo "This will not run because the script will already exit above"
ls /non_existent_directory

#  Piped command where one part fails (set -o pipefail)
echo "Trying a piped command..."
cat /non_existent_file | grep "something"

echo "This line will never be reached"

