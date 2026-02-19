#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/maintenance.log"
LOG_DIR="/var/log/myapp"
SRC_DIR="/data"
DEST_DIR="/backups"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

run_log_rotation() {
    log "Starting log rotation for $LOG_DIR"
    /home/prathamesh/devops/scripts/log_rotate.sh "$LOG_DIR" >> "$LOG_FILE" 2>&1
    log "Log rotation completed"
}

run_backup() {
    log "Starting backup from $SRC_DIR to $DEST_DIR"
    /home/prathamesh/devops/scripts/backup.sh "$SRC_DIR" "$DEST_DIR" >> "$LOG_FILE" 2>&1
    log "Backup completed"
}

main() {
    log "===== Maintenance job started ====="
    run_log_rotation
    run_backup
    log "===== Maintenance job finished ====="
}

main

