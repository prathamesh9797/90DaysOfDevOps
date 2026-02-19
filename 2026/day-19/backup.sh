#!/bin/bash
set -euo pipefail

SRC_DIR="${1:-}"
DEST_DIR="${2:-}"

if [[ -z "$SRC_DIR" || -z "$DEST_DIR" ]]; then
    echo "Usage: $0 <source_directory> <backup_destination>"
    exit 1
fi

if [[ ! -d "$SRC_DIR" ]]; then
    echo " Error: Source directory does not exist: $SRC_DIR"
    exit 1
fi

if [[ ! -d "$DEST_DIR" ]]; then
    echo " Error: Destination directory does not exist: $DEST_DIR"
    exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d")
ARCHIVE_NAME="backup-${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${DEST_DIR}/${ARCHIVE_NAME}"

echo " Creating backup..."
tar -czf "$ARCHIVE_PATH" -C "$SRC_DIR" .

if [[ -f "$ARCHIVE_PATH" ]]; then
    SIZE=$(du -h "$ARCHIVE_PATH" | awk '{print $1}')
    echo " Backup created: $ARCHIVE_NAME"
    echo " Size: $SIZE"
else
    echo " Backup failed: archive not found"
    exit 1
fi

echo " Cleaning old backups (>14 days)..."
deleted_count=0

while IFS= read -r -d '' file; do
    rm -f "$file"
    ((deleted_count++))
done < <(find "$DEST_DIR" -type f -name "backup-*.tar.gz" -mtime +14 -print0)

echo "  Old backups deleted: $deleted_count"
echo " Backup process completed successfully."

