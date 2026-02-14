# 

# Day 16 – Shell Scripting Basics
## Task
Start your shell scripting journey — learn the fundamentals every script needs.

You will:

- Understand **shebang** (`#!/bin/bash` ) and why it matters
- Work with **variables**, **echo**, and **read**
- Write basic **if-else** conditions
---

## Challenge Tasks
### Task 1: Your First Script
1. Create a file `hello.sh` 
2. Add the shebang line `#!/bin/bash`  at the top
3. Print `Hello, DevOps!`  using `echo` 
4. Make it executable and run it
```
chmod +x hello.sh
./hello.sh
```
**Document:** What happens if you remove the shebang line?

>>  The shebang line (like `#!/usr/bin/env python3` or `#!/bin/bash`) tells your OS _which interpreter to use_ when you try to run a script directly as an executable,

If you remove it , running with explicit interpreter still works like bash hello.sh or python3 hello.py

Without a shebang, your shell won’t know what program should run the file and you’ll likely get:

- `Exec format error` , or
- It’ll try to run it as a shell script and explode in weird ways.


```
prathamesh@localhost:~/devops$ vim hello.sh
prathamesh@localhost:~/devops$ ls -l
total 24
-rw-rw-r-- 1 prathamesh prathamesh  35 Feb 13 07:45 hello.sh

prathamesh@localhost:~/devops$ chmod +x hello.sh
prathamesh@localhost:~/devops$ ls -l
total 24
-rwxrwxr-x 1 prathamesh prathamesh  35 Feb 13 07:45 hello.sh

prathamesh@localhost:~/devops$ ./hello.sh
Hello, DevOps
```
---

### Task 2: Variables
1. Create `variables.sh`  with:
    - A variable for your `NAME` 
    - A variable for your `ROLE`  (e.g., "DevOps Engineer")
    - Print: `Hello, I am <NAME> and I am a <ROLE>` 

2. Try using single quotes vs double quotes — what's the difference?
>>Whatever you write inside single quotes is printed **exactly as-is**.Bash treats it like plain text. Double quotes let Bash **fill in variables** and run commands.

Use **double quotes** when you want variables to work.
Use **single quotes** when you want text to stay exactly the same.

```
prathamesh@localhost:~/devops$ vim variables.sh
prathamesh@localhost:~/devops$ chmod +x variables.sh
-rwxrwxr-x 1 prathamesh prathamesh 160 Feb 13 08:02 variables.sh

prathamesh@localhost:~/devops$ ./variables.sh
Enter your name:PRATHAMESH
Enter your Role:DEVOPS ENGINEER 
Hello, I am PRATHAMESH and I am a DEVOPS ENGINEER
```
---

### Task 3: User Input with read
1. Create `greet.sh`  that:
    - Asks the user for their name using `read` 
    - Asks for their favourite tool
    - Prints: `Hello <name>, your favourite tool is <tool>` 

```
prathamesh@localhost:~/devops$ vim greet.sh

prathamesh@localhost:~/devops$ chmod +x greet.sh
prathamesh@localhost:~/devops$ ls -l
-rwxrwxr-x 1 prathamesh prathamesh 154 Feb 13 10:05 greet.sh

prathamesh@localhost:~/devops$ ./greet.sh
Please enter your name :prathamesh
Please enter your favourite tool :jenkins
Hello prathamesh Your favourite Tool is jenkins
```
---

### Task 4: If-Else Conditions
1. Create `check_number.sh`  that:
    - Takes a number using `read` 
    - Prints whether it is **positive**, **negative**, or **zero**

```
prathamesh@localhost:~/devops$ ./check_number.sh
Enter Your Number: 1
1 is a positive number
prathamesh@localhost:~/devops$ ./check_number.sh
Enter Your Number: -1
-1 is a negative number
prathamesh@localhost:~/devops$ ./check_number.sh
Enter Your Number: 0
0 is Zero
```
1. Create `file_check.sh`  that:
    - Asks for a filename
    - Checks if the file **exists** using `-f` 
    - Prints appropriate message

```
prathamesh@localhost:~/devops$ ls 
check_file.sh    file_check.sh  hello-dosto.txt  install_package.sh  user_input.sh
check_number.sh  greet.sh       hello.sh         script.sh           variables.sh
prathamesh@localhost:~/devops$ vim file_check.sh
prathamesh@localhost:~/devops$ ./file_check.sh
Enter the file path to be found: /bin/passwd
File '/bin/passwd' exists.
```
---

### Task 5: Combine It All
Create `server_check.sh` that:

1. Stores a service name in a variable (e.g., `nginx` , `sshd` )
2. Asks the user: "Do you want to check the status? (y/n)"
3. If `y`  — runs `systemctl status <service>`  and prints whether it's **active** or **not**
4. If `n`  — prints "Skipped."
```
prathamesh@localhost:~/devops$ vim server_check.sh
prathamesh@localhost:~/devops$ ./server_check.sh
bash: ./server_check.sh: Permission denied
prathamesh@localhost:~/devops$ chmod +x server_check.sh
prathamesh@localhost:~/devops$ ./server_check.sh
Do you want to check the status of nginx? (y/n): y
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running) since Sat 2026-02-14 03:49:41 IST; 20h ago
       Docs: man:nginx(8)
    Process: 2083 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 2103 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 2116 (nginx)
      Tasks: 17 (limit: 18649)
     Memory: 13.0M (peak: 14.4M)
        CPU: 85ms
     CGroup: /system.slice/nginx.service
             ├─2116 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
             ├─2117 "nginx: worker process"
             ├─2118 "nginx: worker process"
             ├─2120 "nginx: worker process"
             ├─2121 "nginx: worker process"
             ├─2123 "nginx: worker process"
             ├─2124 "nginx: worker process"
             ├─2125 "nginx: worker process"
             ├─2126 "nginx: worker process"
             ├─2127 "nginx: worker process"
             ├─2128 "nginx: worker process"
             ├─2129 "nginx: worker process"
             ├─2130 "nginx: worker process"
             ├─2131 "nginx: worker process"
             ├─2133 "nginx: worker process"
             ├─2134 "nginx: worker process"
             └─2135 "nginx: worker process"

Feb 14 03:49:40 localhost systemd[1]: Starting nginx.service - A high performance web server and a reverse proxy serv>
Feb 14 03:49:41 localhost systemd[1]: Started nginx.service - A high performance web server and a reverse proxy serve>
lines 1-31
```
```
prathamesh@localhost:~/devops$ ls
check_file.sh    file_check.sh  hello-dosto.txt  install_package.sh  server_check.sh  variables.sh
check_number.sh  greet.sh       hello.sh         script.sh           user_input.sh
prathamesh@localhost:~/devops$ ./server_check.sh
Do you want to check the status of nginx? (y/n): n
Skipped.
prathamesh@localhost:~/devops$
```


