# Day 21 – Shell Scripting Cheat Sheet

## Challenge Tasks
### Task 1: Basics
Document the following with short descriptions and examples:

1. Shebang (`#!/bin/bash` ) — what it does and why it matters
2. Running a script — `chmod +x` , `./script.sh` , `bash script.sh` 
3. Comments — single line (`#` ) and inline
4. Variables — declaring, using, and quoting (`$VAR` , `"$VAR"` , `'$VAR'` )
5. Reading user input — `read` 
6. Command-line arguments — `$0` , `$1` , `$#` , `$@` , `$?` 


| Topic | Key Syntax | Example | Description |
| ----- | ----- | ----- | ----- |
| Shebang | #!/bin/bash | Shebang (`#!/bin/bash`) tells the OS which interpreter to use to run the script when executed directly. | Put at top of file, then run  |
| Running a Script | chmod +x ./script.sh  | chmod +x test.sh | makes shell script executable |
| Comments | # | # This prints hello | anything written under comment will not get execute |
| Variables | `VAR="value"` `$VAR` `"$VAR"` `'$VAR'`  | <p>NAME="DevOps"; echo "$NAME"</p><p></p> |  |
| Read Input | read -p variable | read USER | Run script, then type input |
| Command-line Args | $0 $1 $# $@ $? | echo "First: $1" | ./script.sh hello |
---

### Task 2: Operators and Conditionals
Document with examples:

1. String comparisons — `=` , `!=` , `-z` , `-n` 
2. Integer comparisons — `-eq` , `-ne` , `-lt` , `-gt` , `-le` , `-ge` 
3. File test operators — `-f` , `-d` , `-e` , `-r` , `-w` , `-x` , `-s` 
4. `if` , `elif` , `else`  syntax
5. Logical operators — `&&` , `||` , `!` 
6. Case statements — `case ... esac` 
| Topic | Key Syntax | Example | Description |
| ----- | ----- | ----- | ----- |
| String Compare | <p>= ,! =, -z, -n </p><p></p><p></p><p></p> | <p></p><p>`[ "$a" = "$b" ]`<br />`[ -z "$name" ]`<br />`[ -n "$name" ]` </p><p></p> | <ul><li>`=`  → strings are equal</li><li>`! =`  → strings are not equal</li><li>`-z "$var"`  → string is **empty**</li><li>`-n "$var"`  → string is **not empty**</li></ul> |
| Integer Comparison | `-eq` `-ne` `-lt`   `-gt` `-le` `-ge`  | <p>[ "$num" -eq 10 ]</p><p>[ "$num" -ne 10 ]</p><p>[ "$num" -lt 10 ]</p><p>[ "$num" -gt 10 ]</p><p>[ "$num" -le 10 ]</p><p>[ "$num" -ge 10 ]</p> | <p>`-eq`  → equal to</p><p>`-ne`  → not equal to</p><p>`-lt`  → less than</p><p>`-gt`  → greater than</p><p>`-le`  → less than or equal to</p><p>`-ge`  → greater than or equal to</p> |
| File test operators | -f, -d, -e, -r, -w, -x, -s | <p>[ -f file.txt ]</p><p>[ -d mydir ]</p><p>[ -e file.txt ]</p><p>[ -r file.txt ]</p><p>[ -w file.txt ]</p><p>[ -x script.sh ]</p><p>[ -s file.txt ]</p> | <p>`-f`  → “Is this a file?”</p><p>`-d`  → “Is this a folder?”</p><p>`-e`  → “Does this exist?”</p><p>`-r`  → “Can I read this file?”</p><p>`-w`  → “Can I write to this file?”</p><p>`-x`  → “Can I run this file?”</p><p>`-s`  → “Is this file not empty?”</p> |
| if  | <p>if [ cond ]; then ... </p><p>fi</p> | <p>if [ -f file.txt ]; then </p><p>echo "Exists"; </p><p>fi</p> |  |
| if else | <p>if [ cond ]; then</p><p>....</p><p>else</p><p>....</p><p>fi</p><p></p> | <p>if [ -f file.txt ]; then </p><p>echo OK;</p><p>else </p><p>echo No; </p><p>fi</p> |  |
| if / elif / else | <p>if [ cond ]; then ... </p><p>elif [ cond ]; then ... </p><p>else </p><p>... </p><p>fi</p> | <p>if [ "$1" = "start" ]; then</p><p>echo Go;</p><p>elif [ "$1" = "stop" ]; then</p><p>echo Stop; </p><p>else </p><p>echo Usage;</p><p>fi</p> | ./script.sh start |
| <p>Logical Operators</p><p>AND OR NOT</p> | && || ! | <p>[ -f file.txt ] && echo "Exists"</p><p>[ -f file.txt ] || echo "Missing"</p><p>[ ! -f file.txt ]</p> | <p>`&&`  → do next thing **only if first is true**</p><p>`||`  → do next thing **only if first is false**</p><p>`!`  → reverse the result (true becomes false)</p> |
| Case statements  | case VAR in ... esac | case $1 in start) echo "Start";; stop) echo "Stop";; *) echo "Usage";; esac | Run: `./script.sh start`  |
---

### Task 3: Loops
Document with examples:

1. `for`  loop — list-based and C-style
2. `while`  loop
3. `until`  loop
4. Loop control — `break` , `continue` 
5. Looping over files — `for file in *.log` 
6. Looping over command output — `while read line` 
| Topic | Key Syntax | Example | Descriptin |
| ----- | ----- | ----- | ----- |
| For (list) | <p>for i in list; </p><p>do</p><p>...</p><p>done</p> | <p>for i in 1 2 3; </p><p>do</p><p>echo $i;</p><p>done</p> |  |
| For (C-style) | for ((i=0;i<n;i++)) | <p>for ((i=0;i<3;i++)); </p><p>do</p><p>echo $i; </p><p>done</p> |  |
| While Loop | <p>while [ cond ];</p><p>do</p><p>....</p><p>done</p> | <p>while read line; </p><p>do</p><p>echo $line; </p><p>done</p> |  |
| Until Loop | <p>until [ cond ];</p><p>do </p><p>...</p><p>done</p> | <p>until [ -f file.txt ]; </p><p>do</p><p>sleep 1;</p><p>done</p> |  |
| Break | break | <p>for i in 1 2 3; </p><p>do</p><p>break;</p><p>done</p> |  |
| continue | continue | for i in 1 2 3; do continue; done |  |
| Loop Files | for f in *.log | for f in *.log; do echo $f; done |  |
| Loop Cmd Output | cmd | while read line | ls | while read line; do echo $line; done |  |
---

### Task 4: Functions
Document with examples:

1. Defining a function — `function_name() { ... }` 
2. Calling a function
3. Passing arguments to functions — `$1` , `$2`  inside functions
4. Return values — `return`  vs `echo` 
5. Local variables — `local` 


| Topic | Key Syntax | Example | Description |
| ----- | ----- | ----- | ----- |
| Define Function | name() { ... } | greet() { echo "Hi"; } |  |
| Call Function | name | greet |  |
| Function Args | $1 $2 | sum() { echo $(($1+$2)); } | Call: `sum 2 3`  |
| Return Value | `return` / `echo`  | get() { echo "OK"; } | VAR=$(get) |
| Local Var | local VAR | local msg="hi" | use inside function |
---

### Task 5: Text Processing Commands
Document the most useful flags/patterns for each:

1. `grep`  — search patterns, `-i` , `-r` , `-c` , `-n` , `-v` , `-E` 
2. `awk`  — print columns, field separator, patterns, `BEGIN/END` 
3. `sed`  — substitution, delete lines, in-place edit
4. `cut`  — extract columns by delimiter
5. `sort`  — alphabetical, numerical, reverse, unique
6. `uniq`  — deduplicate, count
7. `tr`  — translate/delete characters
8. `wc`  — line/word/char count
9. `head`  / `tail`  — first/last N lines, follow mode
| Topic | Key Syntax | Example | How to Run |
| ----- | ----- | ----- | ----- |
| grep | grep -i -r -c -n -v -E | grep -i "error" app.log | <p>**grep** → find text</p><p>`**-i**`  → ignore upper/lower case</p><p>`**-r**`  → search in folders</p><p>`**-c**`  → count matches</p><p>`**-n**`  → show line numbers</p><p>`**-v**`  → show lines that do **not** match</p><p>`**-E**`  → allow patterns like `this|that` </p> |
| awk | awk '{print $1}' -F | awk -F: '{print $1}' /etc/passwd | <p>Split columns by `,` </p><p>Print column 1 and 3</p><p>`**-F**` ** = Field separator**</p><p>Think: **F = Fields**</p><p></p> |
| sed | sed 's/a/b/' -i '/p/d' | sed -i 's/foo/bar/g' file |  |
| cut | cut -dX -fN | cut -d, -f1 data.csv |  |
| sort | sort -n -r -u | sort -nr file |  |
| uniq | uniq -c | `sort file |  |
| tr | tr 'a-z' 'A-Z' | `echo hi |  |
| wc | wc -l -w -c | wc -l app.log |  |
| head /tail | `head -n` `tail -n` `tail -f`  | tail -f app.log |  |
---

### Task 6: Useful Patterns and One-Liners
Include at least 5 real-world one-liners you find useful. Examples:

- Find and delete files older than N days
- Count lines in all `.log`  files
- Replace a string across multiple files
- Check if a service is running
- Monitor disk usage with alerts
- Parse CSV or JSON from command line
- Tail a log and filter for errors in real time
## Super simple meanings
- **Delete old files** → clean up old logs
- **Count lines** → see how big logs are
- **Replace in files** → change text everywhere
- **Check service** → see if app is running
- **Disk alert** → warn when disk is full
- **Parse CSV** → pick columns from CSV
- **Live error log** → watch errors in real time
- Tail a log and filter for errors in real time


- find /var/log -type f -name "*.log" -mtime +15 -exec rm -f {} \;Find and delete files older than N days
- wc -l /var/log/*.logCount lines in all .log files
- sed -i 's/db.oldserver.com/db.newserver.com/g' /etc/myapp/conf.d/*.confReplace a string across multiple files
- systemctl is-active --quiet nginx && echo "Running" || echo "Stopped"Check if a service is running
- df -h | awk '$5+0 > 80 {print $0}' | mail -s "Disk Usage Alert on $(hostname)" your.email@example.comMonitor disk usage with alerts
- tail -f /var/log/syslog | grep -E 'ERROR|CRITICAL'


---



### Task 7: Error Handling and Debugging
Document with examples:

1. Exit codes — `$?` , `exit 0` , `exit 1` 
2. `set -e`  — exit on error
3. `set -u`  — treat unset variables as error
4. `set -o pipefail`  — catch errors in pipes
5. `set -x`  — debug mode (trace execution)
6. Trap — `trap 'cleanup' EXIT` 


### Super simple meanings
**Exit codes** → tell if last command worked (0 = OK, not 0 = error)

`**set -e**`  → stop script if something fails

`**set -u**`  → error if you use a variable that doesn’t exist

`**set -o pipefail**`  → catch errors in `cmd1 | cmd2` 

`**set -x**`  → show each command as it runs (debugging)

`**trap**` → run cleanup code when script exits 



### Task 8: Bonus — Quick Reference Table
Summary Table Added in detailed version above 



