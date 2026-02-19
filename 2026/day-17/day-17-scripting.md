# Shell Scripting: Loops, Arguments & Error Handling

## Challenge Tasks
### Task 1: For Loop
1. Create `for_loop.sh`  that:
    - Loops through a list of 5 fruits and prints each one

```
prathamesh@localhost:~/devops/scripts$ ./for_loop.sh
banana
apple
guava
orange
pineapple
prathamesh@localhost:~/devops/scripts$
```
1. Create `count.sh`  that:
    - Prints numbers 1 to 10 using a for loop

```
prathamesh@localhost:~/devops/scripts$ ./count.sh
1
2
3
4
5
6
7
8
9
10
```
---

### Task 2: While Loop
1. Create `countdown.sh`  that:
    - Takes a number from the user
    - Counts down to 0 using a while loop
    - Prints "Done!" at the end

```
prathamesh@localhost:~/devops/scripts$ ./countdown.sh
please input number5
 5 
 4 
 3 
 2 
 1 
 0 
done
```
---

### Task 3: Command-Line Arguments
1. Create `greet.sh`  that:
    - Accepts a name as `$1` 
    - Prints `Hello, <name>!` 
    - If no argument is passed, prints "Usage: ./greet.sh "

```
prathamesh@localhost:~/devops/scripts$ ./greet.sh
Usage: ./greet.sh <name>
prathamesh@localhost:~/devops/scripts$ ./greet.sh rama
Hello, rama!
prathamesh@localhost:~/devops/scripts$
```
1. Create `args_demo.sh`  that:
    - Prints total number of arguments (`$#` )
    - Prints all arguments (`$@` )
    - Prints the script name (`$0` )

prathamesh@localhost:/devops/scripts$ vim args_demo.sh
prathamesh@localhost:/devops/scripts$ chmod +x args_demo.sh
prathamesh@localhost:/devops/scripts$ ./args_demo.sh
Script name: ./args_demo.sh
Total number of arguments: 0
All arguments:
prathamesh@localhost:/devops/scripts$ ./args_demo.sh 1 2 3 4
Script name: ./args_demo.sh
Total number of arguments: 4
All arguments:

- 1
- 2
- 3
- 4
---

### Task 4: Install Packages via Script
1. Create `install_packages.sh`  that:
    - Defines a list of packages: `nginx` , `curl` , `wget` 
    - Loops through the list
    - Checks if each package is installed (use `dpkg -s`  or `rpm -q` )
    - Installs it if missing, skips if already present
    - Prints status for each package

```
prathamesh@localhost:~/devops/scripts$ ./install_packages.sh
Checking and installing packages...
-----------------------------------
 Updating package index...
[sudo] password for prathamesh: 
Get:1 https://dl.google.com/linux/chrome/deb stable InRelease [1,825 B]
Hit:2 https://packages.microsoft.com/repos/code stable InRelease                                                     
Hit:3 http://in.archive.ubuntu.com/ubuntu noble InRelease                         
Get:4 https://dl.google.com/linux/chrome/deb stable/main amd64 Packages [1,211 B] 
Get:5 http://security.ubuntu.com/ubuntu noble-security InRelease [126 kB]              
Get:6 http://security.ubuntu.com/ubuntu noble-security/restricted amd64 Packages [2,516 kB]
Get:7 http://security.ubuntu.com/ubuntu noble-security/restricted Translation-en [582 kB]
Get:8 http://security.ubuntu.com/ubuntu noble-security/restricted amd64 Components [212 B]
Get:9 http://security.ubuntu.com/ubuntu noble-security/universe i386 Packages [579 kB]
Get:10 http://security.ubuntu.com/ubuntu noble-security/universe amd64 Packages [935 kB]
Get:11 http://security.ubuntu.com/ubuntu noble-security/universe amd64 Components [74.2 kB]
Get:12 http://security.ubuntu.com/ubuntu noble-security/main amd64 Packages [1,474 kB]
Get:13 http://security.ubuntu.com/ubuntu noble-security/main i386 Packages [379 kB]                                  
Get:14 http://security.ubuntu.com/ubuntu noble-security/main Translation-en [237 kB]                                 
Get:15 http://security.ubuntu.com/ubuntu noble-security/main amd64 Components [21.5 kB]                              
Get:16 http://security.ubuntu.com/ubuntu noble-security/multiverse amd64 Components [212 B]                          
Fetched 6,927 kB in 9s (794 kB/s)                                                                                    
Reading package lists... Done
 nginx is already installed. Skipping.
 curl is already installed. Skipping.
 wget is already installed. Skipping.
-----------------------------------
Package check completed.
```
---

### Task 5: Error Handling
1. Create `safe_script.sh`  that:
    - Uses `set -e`  at the top (exit on error)
    - Tries to create a directory `/tmp/devops-test` 
    - Tries to navigate into it
    - Creates a file inside
    - Uses `||`  operator to print an error if any step fails

Example:

```
mkdir /tmp/devops-test || echo "Directory already exists"
```
```
prathamesh@localhost:~/devops/scripts$ vim safe_script.sh
prathamesh@localhost:~/devops/scripts$ chmod +x safe_script.sh
prathamesh@localhost:~/devops/scripts$ ./safe_script.sh
 Creating directory...
 Entering directory...
 Creating file...
 All operations completed successfully!
prathamesh@localhost:~/devops/scripts$
```


