#!/bin/bash

check_disk() {
    # Get available disk space on /
    df -h / | awk 'NR==2 {print $4}'
}

check_memory() {
    # Get available memory
    free -h | awk '/^Mem:/ {print $7}'
}

main() {
    disk_available=$(check_disk)
    memory_available=$(check_memory)

    echo "===== System Resource Check ====="
    echo "Available Disk (/): $disk_available"
    echo "Available Memory:   $memory_available"
}

main

