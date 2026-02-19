#!/bin/bash
set -euo pipefail

LOG_DIR="${1:-}"

if [[ -z "$LOG_DIR" ]]; then
    echo "Usage: $0 <log_directory>"
    exit 1
fi

if [[ ! -d "$LOG_DIR" ]]; then
    echo " Error: Directory does not exist: $LOG_DIR"
    exit 1
fi

compressed_count=0
deleted_count=0

# Compress .log files older than 7 days
while IFS= read -r -d '' file; do
    gzip "$file"
    ((compressed_count++))
done < <(find "$LOG_DIR" -type f -name "*.log" -mtime +7 -print0)

# Delete .gz files older than 30 days
while IFS= read -r -d '' file; do
    rm -f "$file"
    ((deleted_count++))
done < <(find "$LOG_DIR" -type f -name "*.gz" -mtime +30 -print0)

echo " Log rotation completed for: $LOG_DIR"
echo " Compressed files (>7 days): $compressed_count"
echo "  Deleted .gz files (>30 days): $deleted_count"

