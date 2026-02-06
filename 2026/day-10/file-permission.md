# 

# Day 10 – File Permissions & File Operations Challenge
## Task
Master file permissions and basic file operations in Linux.

- Create and read files using `touch` , `cat` , `vim` 
- Understand and modify permissions using `chmod` 
---

### Task 1: Create Files (10 minutes)
1. Create empty file `devops.txt`  using `touch` 
2. Create `notes.txt`  with some content using `cat`  or `echo` 
3. Create `script.sh`  using `vim`  with content: `echo "Hello DevOps"` 
**Verify:** `ls -l` to see permissions

```
ubuntu@ip-172-31-2-199:~$ touch devops.txt
ubuntu@ip-172-31-2-199:~$ touch notes.txt
ubuntu@ip-172-31-2-199:~$ vim notes.txt
ubuntu@ip-172-31-2-199:~$ cat notes.txt
hello ! how are you
hope you are doing good!
ubuntu@ip-172-31-2-199:~$ vim script.sh
ubuntu@ip-172-31-2-199:~$ ls -l
total 12
-rw-rw-r-- 1 berlin ubuntu   0 Feb  6 06:31 bidkin.txt
-rw-rw-r-- 1 ubuntu ubuntu   0 Feb  6 17:34 devops.txt
-rw-rw-r-- 1 ubuntu ubuntu 595 Feb  5 19:33 nginx-log.txt
-rw-rw-r-- 1 ubuntu ubuntu  45 Feb  6 17:36 notes.txt
-rw-rw-r-- 1 ubuntu ubuntu   0 Feb  4 07:06 prathamesh.txt
-rw-rw-r-- 1 ubuntu ubuntu  20 Feb  6 17:37 script.sh
ubuntu@ip-172-31-2-199:~$ cat notes.txt
hello ! how are you
hope you are doing good!
ubuntu@ip-172-31-2-199:~$ chmod +x script.sh
ubuntu@ip-172-31-2-199:~$ ls -l
total 12
-rw-rw-r-- 1 berlin ubuntu   0 Feb  6 06:31 bidkin.txt
-rw-rw-r-- 1 ubuntu ubuntu   0 Feb  6 17:34 devops.txt
-rw-rw-r-- 1 ubuntu ubuntu 595 Feb  5 19:33 nginx-log.txt
-rw-rw-r-- 1 ubuntu ubuntu  45 Feb  6 17:36 notes.txt
-rw-rw-r-- 1 ubuntu ubuntu   0 Feb  4 07:06 prathamesh.txt
-rwxrwxr-x 1 ubuntu ubuntu  20 Feb  6 17:37 script.sh
ubuntu@ip-172-31-2-199:~$ ./script.sh
Hello DevOps
ubuntu@ip-172-31-2-199:~$
```


### Task 2: Read Files (10 minutes)
1. Read `notes.txt`  using `cat` 
2. View `script.sh`  in vim read-only mode
3. Display first 5 lines of `/etc/passwd`  using `head` 
4. Display last 5 lines of `/etc/passwd`  using `tail` 
![Screenshot from 2026-02-06 23-28-15.png](https://eraser.imgix.net/workspaces/iakQgzIPVHK2csJSiMUt/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-06%2023-28-15_HizhonmajuEPpVIhZDSgy.png?ixlib=js-3.8.0 "Screenshot from 2026-02-06 23-28-15.png")



### Task 3: Understand Permissions (10 minutes)
Format: `rwxrwxrwx` (owner-group-others)

- `r`  = read (4), `w`  = write (2), `x`  = execute (1)
Check your files: `ls -l devops.txt notes.txt script.sh` 

Answer: What are current permissions? Who can read/write/execute?

>> devops.txt have 664, notes.txt have 664, script.sh have 775 permission

```
ubuntu@ip-172-31-2-199:~$ ls -l
total 8
-rw-rw-r-- 1 ubuntu ubuntu  0 Feb  6 17:34 devops.txt
-rw-rw-r-- 1 ubuntu ubuntu 45 Feb  6 17:36 notes.txt
-rwxrwxr-x 1 ubuntu ubuntu 20 Feb  6 17:37 script.sh
ubuntu@ip-172-31-2-199:~$
```
### Task 4: Modify Permissions (20 minutes)
1. Make `script.sh`  executable → run it with `./script.sh` 
2. Set `devops.txt`  to read-only (remove write for all)
3. Set `notes.txt`  to `640`  (owner: rw, group: r, others: none)
4. Create directory `project/`  with permissions `755` 
**Verify:** `ls -l` after each change




![Screenshot from 2026-02-06 23-42-29.png](https://eraser.imgix.net/workspaces/iakQgzIPVHK2csJSiMUt/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-06%2023-42-29_jKtiJ72d9X8D5T897cKLO.png?ixlib=js-3.8.0 "Screenshot from 2026-02-06 23-42-29.png")



### Task 5: Test Permissions (10 minutes)
1. Try writing to a read-only file - what happens?
>> it shows `-- INSERT -- W10: Warning: Changing a readonly file`  and when we make change and go to save it shows below error :wq

```
E45: 'readonly' option is set (add ! to override)
```
1. Try executing a file without execute permission
>>ubuntu@ip-172-31-2-199:~$ ./script.sh
-bash: ./script.sh: Permission denied





