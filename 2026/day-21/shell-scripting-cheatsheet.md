# Day 21 – Shell Scripting Cheat Sheet

Welcome to the Shell Scripting Cheat Sheet! This guide covers the essential commands, syntax, and concepts needed to write, debug, and execute bash scripts effectively.

---

## Task 1: Basics

Understanding the foundational elements of a shell script.

| Topic | Key Syntax | Example | Description |
| --- | --- | --- | --- |
| **Shebang** | `#!/bin/bash` | `#!/bin/bash` | Tells the OS which interpreter to use. Put at the very top of the file. |
| **Running a Script** | `chmod +x script.sh`<br>`./script.sh` | `chmod +x test.sh` | Makes the shell script executable before running it. |
| **Comments** | `#` | `# This prints hello` | Anything written after the `#` will not be executed. |
| **Variables** | `VAR="value"`<br>`$VAR`<br>`"$VAR"`<br>`'$VAR'` | `NAME="DevOps"`<br>`echo "$NAME"` | Declares and uses variables. Double quotes allow variable expansion; single quotes treat it as literal text. |
| **Read Input** | `read -p "Prompt" VAR` | `read USER` | Pauses the script to accept user input from the keyboard. |
| **Command-line Args** | `$0`, `$1`, `$#`, `$@`, `$?` | `echo "First: $1"` | Passed when executing: `./script.sh hello` (`hello` becomes `$1`). |

---

## Task 2: Operators and Conditionals

Making decisions and comparing values in scripts.

| Topic | Key Syntax | Example | Description |
| --- | --- | --- | --- |
| **String Compare** | `=`, `!=`, `-z`, `-n` | `[ "$a" = "$b" ]`<br>`[ -z "$name" ]` | `=` (equal), `!=` (not equal), `-z` (is empty), `-n` (is not empty). |
| **Integer Compare** | `-eq`, `-ne`, `-lt`, `-gt`, `-le`, `-ge` | `[ "$num" -eq 10 ]` | `-eq` (equal), `-ne` (not equal), `-lt` (less), `-gt` (greater), `-le` (less/equal), `-ge` (greater/equal). |
| **File Tests** | `-f`, `-d`, `-e`, `-r`, `-w`, `-x`, `-s` | `[ -f file.txt ]` | `-f` (is file), `-d` (is folder), `-e` (exists), `-r` (readable), `-w` (writable), `-x` (executable), `-s` (not empty). |
| **if** | `if [ cond ]; then ... fi` | `if [ -f file.txt ]; then echo "Exists"; fi` | Executes code if the condition is true. |
| **if / else** | `if [ cond ]; then ... else ... fi` | `if [ -f file.txt ]; then echo "OK"; else echo "No"; fi` | Provides an alternative action if the condition is false. |
| **if / elif / else** | `if [ cond ]; then ... elif [ cond ]; then ... else ... fi` | `if [ "$1" = "start" ]; then echo "Go"; elif [ "$1" = "stop" ]; then echo "Stop"; else echo "Usage"; fi` | Handles multiple specific conditions. |
| **Logical Operators** | `&&`, `\|\|`, `!` | `[ -f file.txt ] && echo "Exists"` | `&&` (AND - do if true), `\|\|` (OR - do if false), `!` (NOT - reverse boolean). |
| **Case Statements** | `case VAR in ... esac` | `case $1 in start) echo "Start";; stop) echo "Stop";; *) echo "Usage";; esac` | Clean alternative to complex if/elif chains. |

---

## Task 3: Loops

Repeating tasks efficiently.

| Topic | Key Syntax | Example | Description |
| --- | --- | --- | --- |
| **For (list)** | `for i in list; do ... done` | `for i in 1 2 3; do echo $i; done` | Iterates over a defined list of items. |
| **For (C-style)** | `for ((i=0;i<n;i++))` | `for ((i=0;i<3;i++)); do echo $i; done` | Classic numerical iteration. |
| **While Loop** | `while [ cond ]; do ... done` | `while [ $i -lt 5 ]; do echo $i; done` | Runs as long as the condition evaluates to true. |
| **Until Loop** | `until [ cond ]; do ... done` | `until [ -f file.txt ]; do sleep 1; done` | Runs until the condition becomes true. |
| **Break** | `break` | `for i in 1 2 3; do break; done` | Exits the loop entirely. |
| **Continue** | `continue` | `for i in 1 2 3; do continue; done` | Skips the rest of the current iteration and moves to the next. |
| **Loop Files** | `for f in *.log` | `for f in *.log; do echo $f; done` | Iterates over files matching a pattern in a directory. |
| **Loop Cmd Output** | `while read line` | `ls \| while read line; do echo $line; done` | Reads the output of a command line by line. |

---

## Task 4: Functions

Creating reusable blocks of code.

| Topic | Key Syntax | Example | Description |
| --- | --- | --- | --- |
| **Define Function** | `name() { ... }` | `greet() { echo "Hi"; }` | Groups commands into a named block. |
| **Call Function** | `name` | `greet` | Executes the function (do not use parentheses when calling). |
| **Function Args** | `$1`, `$2` | `sum() { echo $(($1+$2)); }` | Access passed variables inside the function. Call via: `sum 2 3` |
| **Return Value** | `return` / `echo` | `get() { echo "OK"; }` | Capture output into a variable: `VAR=$(get)` |
| **Local Var** | `local VAR` | `local msg="hi"` | Restricts the variable scope to the function itself. |

---

## Task 5: Text Processing Commands

Tools for analyzing and manipulating text and files.

| Topic | Key Syntax | Example | Description |
| --- | --- | --- | --- |
| **grep** | `grep -i -r -c -n -v -E` | `grep -i "error" app.log` | Finds text. `-i` (ignore case), `-r` (recursive), `-c` (count), `-n` (line nums), `-v` (invert match), `-E` (regex). |
| **awk** | `awk '{print $1}' -F` | `awk -F: '{print $1}' /etc/passwd` | Great for columns. `-F` sets the field separator. Example prints column 1 separated by `:`. |
| **sed** | `sed 's/old/new/'` | `sed -i 's/foo/bar/g' file` | Stream editor for substitution. `-i` edits the file in-place. `g` replaces all instances globally. |
| **cut** | `cut -dX -fN` | `cut -d, -f1 data.csv` | Extracts columns. `-d` sets the delimiter, `-f` selects the field number. |
| **sort** | `sort -n -r -u` | `sort -nr file` | Sorts lines. `-n` (numeric), `-r` (reverse), `-u` (unique). |
| **uniq** | `uniq -c` | `sort file \| uniq -c` | Deduplicates adjacent lines. `-c` counts occurrences. (Must be sorted first). |
| **tr** | `tr 'old' 'new'` | `echo hi \| tr 'a-z' 'A-Z'` | Translates or deletes characters. Example converts to uppercase. |
| **wc** | `wc -l -w -c` | `wc -l app.log` | Counts content. `-l` (lines), `-w` (words), `-c` (characters). |
| **head / tail** | `head -n`, `tail -n`, `tail -f` | `tail -f app.log` | Views edges of files. `tail -f` follows the file in real-time as it updates. |

---

## Task 6: Useful Patterns and One-Liners

Real-world commands for daily administrative tasks.

* **Find and delete files older than N days (Clean up old logs):**
    `find /var/log -type f -name "*.log" -mtime +15 -exec rm -f {} \;`
* **Count lines in all `.log` files (See how big logs are):**
    `wc -l /var/log/*.log`
* **Replace a string across multiple files (Change text everywhere):**
    `sed -i 's/db.oldserver.com/db.newserver.com/g' /etc/myapp/conf.d/*.conf`
* **Check if a service is running:**
    `systemctl is-active --quiet nginx && echo "Running" || echo "Stopped"`
* **Monitor disk usage with alerts (Warn when disk is full):**
    `df -h | awk '$5+0 > 80 {print $0}' | mail -s "Disk Usage Alert on $(hostname)" your.email@example.com`
* **Tail a log and filter for errors in real time:**
    `tail -f /var/log/syslog | grep -E 'ERROR|CRITICAL'`

---

## Task 7: Error Handling and Debugging

Making scripts robust and easy to troubleshoot.

* **Exit codes (`$?`, `exit 0`, `exit 1`):** Tells if the last command worked. `0` = OK (Success), any other number = Error.
* **`set -e`**: Stops the script immediately if any command fails.
* **`set -u`**: Throws an error if you try to use a variable that hasn’t been declared/exists.
* **`set -o pipefail`**: Catches errors within piped commands (e.g., `cmd1 | cmd2`). Prevents a successful `cmd2` from masking a failed `cmd1`.
* **`set -x`**: Debugging mode. Prints each command to the terminal right before it runs.
* **Trap (`trap 'cleanup' EXIT`)**: Runs specified cleanup code (like deleting temporary files) whenever the script exits, even if it crashes.

---

## Task 8: Bonus — Quick Reference Table
*(Note: Summary tables have been integrated into the detailed sections above for optimal quick-reference).*
