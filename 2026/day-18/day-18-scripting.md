# Day 18 – Shell Scripting: Functions & intermediate Concepts

### Task 1: Basic Functions
1. Create `functions.sh`  with:
    - A function `greet`  that takes a name as argument and prints `Hello, <name>!` 
    - A function `add`  that takes two numbers and prints their sum
    - Call both functions from the script

prathamesh@localhost:/devops/scripts$ vim functions.sh
prathamesh@localhost:/devops/scripts$ chmod +x functions.sh
prathamesh@localhost:~/devops/scripts$ ./functions.sh
Hello, Prathamesh!
Sum: 30

---

### Task 2: Functions with Return Values
1. Create `disk_check.sh`  with:
    - A function `check_disk`  that checks disk usage of `/`  using `df -h` 
    - A function `check_memory`  that checks free memory using `free -h` 
    - A main section that calls both and prints the results

```
prathamesh@localhost:~/devops/scripts$ vim disk_check.sh
prathamesh@localhost:~/devops/scripts$ chmod +x disk_check.sh
prathamesh@localhost:~/devops/scripts$ ./disk_check.sh
===== System Resource Check =====
Available Disk (/): 169M
Available Memory:   9.7Gi
```
---

### Task 3: Strict Mode — `set -euo pipefail`
1. Create `strict_demo.sh`  with `set -euo pipefail`  at the top
2. Try using an **undefined variable** — what happens with `set -u` ?
3. Try a command that **fails** — what happens with `set -e` ?
4. Try a **piped command** where one part fails — what happens with `set -o pipefail` ?
**Document:** What does each flag do?

- `set -e`  →
- `set -u`  →
- `set -o pipefail`  →
```
prathamesh@localhost:~/devops/scripts$ vim strict_demo.sh
prathamesh@localhost:~/devops/scripts$ chmod +x strict_demo.sh
prathamesh@localhost:~/devops/scripts$ ./strict_demo.sh
Starting strict mode demo...
./strict_demo.sh: line 7: UNDEFINED_VAR: unbound variable
```
---

### Task 4: Local Variables
1. Create `local_demo.sh`  with:
    - A function that uses `local`  keyword for variables
    - Show that `local`  variables don't leak outside the function
    - Compare with a function that uses regular variables

```
prathamesh@localhost:~/devops/scripts$ vim local_demo.sh
prathamesh@localhost:~/devops/scripts$ chmod +x local_demo.sh
prathamesh@localhost:~/devops/scripts$ ./local_demo.sh
Before calling functions: msg = <not set>
Inside demo_local(): msg = I am LOCAL
After demo_local(): msg = <not set>
Inside demo_global(): msg = I am GLOBAL
After demo_global(): msg = I am GLOBAL
prathamesh@localhost:~/devops/scripts$
```
---

### Task 5: Build a Script — System Info Reporter
Create `system_info.sh` that uses functions for everything:

1. A function to print **hostname and OS info**
2. A function to print **uptime**
3. A function to print **disk usage** (top 5 by size)
4. A function to print **memory usage**
5. A function to print **top 5 CPU-consuming processes**
6. A `main`  function that calls all of the above with section headers
7. Use `set -euo pipefail`  at the top
Output should look clean and readable.



prathamesh@localhost:/devops/scripts$ vim system_info.sh
prathamesh@localhost:/devops/scripts$ ./system_info.sh

# ========================================
SYSTEM INFORMATION
Hostname : localhost
OS : Ubuntu 24.04.3 LTS
Kernel : 6.14.0-37-generic

# ========================================
UPTIME
Uptime : up 6 days, 2 hours, 40 minutes

# ========================================
DISK USAGE
Top 5 disk usage (by size):
Filesystem Size Used Avail Use% Mounted on
/dev/nvme0n1p6 196G 128G 68G 66% /media/prathamesh/New Volume
/dev/nvme0n1p5 16G 15G 168M 99% /
tmpfs 7.7G 133M 7.6G 2% /dev/shm
tmpfs 1.6G 2.8M 1.6G 1% /run
tmpfs 1.6G 156K 1.6G 1% /run/user/1000

# ========================================
MEMORY USAGE
Memory usage:
 total used free shared buff/cache available
Mem: 15Gi 5.8Gi 5.8Gi 1.3Gi 5.4Gi 9.6Gi
Swap: 0B 0B 0B

# ========================================
TOP 5 CPU CONSUMING PROCESSES
Top 5 CPU consuming processes:
 PID USER %CPU %MEM COMMAND
 131446 pratham+ 100 0.0 ps
 129335 pratham+ 6.4 3.0 chrome
 124317 pratham+ 3.7 2.1 chrome
 32463 pratham+ 2.5 2.4 chrome
 30889 pratham+ 1.1 1.6 chrome

Report generated at: Fri Feb 20 01:00:26 AM IST 2026

