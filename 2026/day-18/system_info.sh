#!/bin/bash
set -euo pipefail

print_header() {
    echo
    echo "========================================"
    echo "$1"
    echo "========================================"
}

print_host_os() {
    local hostname os kernel

    hostname=$(hostname)
    if [[ -f /etc/os-release ]]; then
        os=$(awk -F= '/^PRETTY_NAME/ {gsub(/"/, "", $2); print $2}' /etc/os-release)
    else
        os="Unknown OS"
    fi
    kernel=$(uname -r)

    echo "Hostname : $hostname"
    echo "OS       : $os"
    echo "Kernel   : $kernel"
}

print_uptime() {
    local uptime
    uptime=$(uptime -p)
    echo "Uptime   : $uptime"
}

print_disk_usage() {
    echo "Top 5 disk usage (by size):"
    df -h --output=source,size,used,avail,pcent,target | head -n 1
    df -h --output=source,size,used,avail,pcent,target | tail -n +2 | sort -hr -k2 | head -n 5
}

print_memory_usage() {
    echo "Memory usage:"
    free -h
}

print_top_cpu_processes() {
    echo "Top 5 CPU consuming processes:"
    ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6
}

main() {
    print_header "SYSTEM INFORMATION"
    print_host_os

    print_header "UPTIME"
    print_uptime

    print_header "DISK USAGE"
    print_disk_usage

    print_header "MEMORY USAGE"
    print_memory_usage

    print_header "TOP 5 CPU CONSUMING PROCESSES"
    print_top_cpu_processes

    echo
    echo "Report generated at: $(date)"
}

main

