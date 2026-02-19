# Day 20 – Bash Scripting Challenge: Log Analyzer and Report Generator

### Task 1: Input and Validation
Your script should:

1. Accept the path to a log file as a command-line argument
2. Exit with a clear error message if no argument is provided
3. Exit with a clear error message if the file doesn't ex#!/bin/bash
set -euo pipefail

LOG_FILE="${1:-}"

#  No argument provided
if [[ -z "$LOG_FILE" ]]; then
    echo "Usage: $0 <path_to_log_file>"
    exit 1
fi

# File does not exist
if [[ ! -f "$LOG_FILE" ]]; then
    echo "❌ Error: Log file does not exist: $LOG_FILE"
    exit 1
fi

echo "Analyzing log file: $LOG_FILE"
---

### Task 2: Error Count
1. Count the total number of lines containing the keyword `ERROR`  or `Failed` 
2. Print the total error count to the console
```
# Task 2: Error Count
ERROR_COUNT=$(grep -Eci "ERROR|Failed" "$LOG_FILE" || true)

echo "Total errors (ERROR or Failed): $ERROR_COUNT"
```
## Why this works
- `grep -E`  → enables regex (`ERROR|Failed` )
- `-i`  → case-insensitive match (`error` , `ERROR` , `Failed` , etc.)
- `-c`  → returns count of matching lines
- `|| true`  → prevents script from exiting when there are **0 matches** (important with `set -e` )
---

### Task 3: Critical Events
1. Search for lines containing the keyword `CRITICAL` 
2. Print those lines along with their line number
```
# Task 3: Critical Events
echo "--- Critical Events ---"

CRITICAL_EVENTS=$(grep -n "CRITICAL" "$LOG_FILE" || true)

if [[ -n "$CRITICAL_EVENTS" ]]; then
    # Prefix with "Line " for nicer output
    echo "$CRITICAL_EVENTS" | sed 's/^/Line /'
else
    echo "No CRITICAL events found."
fi
```
## Why this works
- `grep -n "CRITICAL"`  → finds matching lines and prepends the **line number**
- `|| true`  → prevents the script from exiting if no matches are found (important with `set -e` )
- `sed 's/^/Line /'`  → formats output to match the example:
---

### Task 4: Top Error Messages
1. Extract all lines containing `ERROR` 
2. Identify the **top 5 most common** error messages
3. Display them with their occurrence count, sorted in descending order
```
# Task 4: Top Error Messages
echo "--- Top 5 Error Messages ---"

TOP_ERRORS=$(grep "ERROR" "$LOG_FILE" \
    | awk '{$1=$2=$3=""; sub(/^ +/, ""); print}' \
    | sort | uniq -c | sort -rn | head -5 || true)

if [[ -n "$TOP_ERRORS" ]]; then
    echo "$TOP_ERRORS"
else
    echo "No ERROR messages found."
fi
```
`grep "ERROR"`  → filters only error lines

`awk '{$1=$2=$3=""; ... }`  → strips timestamps (adjust if your log format differs)

`sort | uniq -c`  → counts identical messages

`sort -rn`  → sorts by frequency (descending)

`head -5`  → top 5 results

`|| true`  → keeps script alive in strict mode if no matches

---

### Task 5: Summary Report
Generate a summary report to a text file named `log_report_<date>.txt` (e.g., `log_report_2026-02-11.txt`). The report should include:

1. Date of analysis
2. Log file name
3. Total lines processed
4. Total error count
5. Top 5 error messages with their occurrence count
6. List of critical events with line numbers
```
========== LOG ANALYSIS REPORT ==========
Date of analysis      : 2026-02-20
Log file              : sample_log.log
Total lines processed : 2450
Total error count     : 32

--- Top 5 Error Messages ---
45 Connection timed out
32 File not found
28 Permission denied
15 Disk I/O error
9  Out of memory

--- Critical Events ---
Line 84: 2025-07-29 10:15:23 CRITICAL Disk space below threshold
Line 217: 2025-07-29 14:32:01 CRITICAL Database connection lost
=========================================
```
The script generates a daily summary report named `log_report_<date>.txt` using the current date.
 It includes the log file name, total lines processed, total error count, top 5 most common error messages, and a list of critical events with line numbers. This provides a quick, readable overview of log health for daily operational review.


DATE=$(date +%Y-%m-%d)
REPORT_FILE="log_report_${DATE}.txt"
TOTAL_LINES=$(wc -l < "$LOG_FILE")

{
    echo "========== LOG ANALYSIS REPORT =========="
    echo "Date of analysis      : $DATE"
    echo "Log file              : $LOG_FILE"
    echo "Total lines processed : $TOTAL_LINES"
    echo "Total error count     : $ERROR_COUNT"
    echo
    echo "--- Top 5 Error Messages ---"
    if [[ -n "$TOP_ERRORS" ]]; then
        echo "$TOP_ERRORS"
    else
        echo "No ERROR messages found."
    fi
    echo
    echo "--- Critical Events ---"
    if [[ -n "$CRITICAL_EVENTS" ]]; then
        echo "$CRITICAL_EVENTS" | sed 's/^/Line /'
    else
        echo "No CRITICAL events found."
    fi
    echo "========================================="
} > "$REPORT_FILE"

echo " Summary report generated: $REPORT_FILE"



---



