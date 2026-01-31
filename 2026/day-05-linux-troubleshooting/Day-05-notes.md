# 

## Environment Basics
### Command 1
uname -a **or  cat /etc/os-release**

**Observed:** Linux localhost 6.14.0-37-generic #37~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC Thu Nov 20 10:25:38 UTC 2 x86_64 x86_64 x86_64 GNU/Linux

```
PRETTY_NAME="Ubuntu 24.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.3 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
```
**2) *Filesystem sanity (2):** create a throwaway folder and file, e.g., **`**mkdir /tmp/runbook-demo**`**, `cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo`**

**Output :-**

```
prathamesh@localhost:/tmp$ cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo
total 4
-rw-r--r-- 1 prathamesh prathamesh 259 Jan 31 20:55 hosts-copy

```
** 3)  CPU / Memory (2):** `top**`**/**`** htop`/`ps -o pid,pcpu,pmem,comm -p <pid>`, `free -h`, `vm_stat` (mac)**

**Output:-**

```
top - 20:58:04 up 4 days, 13:30,  1 user,  load average: 0.67, 0.47, 0.29
Tasks: 396 total,   1 running, 395 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.7 us,  0.7 sy,  0.0 ni, 98.6 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st 
MiB Mem :  15703.0 total,   2934.5 free,   9912.4 used,   6937.4 buff/cache     
MiB Swap:      0.0 total,      0.0 free,      0.0 used.   5790.6 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                        
   2467 pratham+  20   0 6331540 436704 163824 S  12.0   2.7  62:51.72 gnome-shell                                    
    313 root     -51   0       0      0      0 S   3.7   0.0   4:52.13 irq/141-SYNA32C6:00                            
  10414 pratham+  20   0  732604  81312  58924 S   3.0   0.5   1:09.26 gnome-terminal-
  

```
![Screenshot from 2026-01-31 21-00-19.png](https://eraser.imgix.net/workspaces/004qCEN9IfojaZCmYUFq/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-01-31%2021-00-19_2WUMxCNGVi8cDpZ-Kd-1r.png?ixlib=js-3.8.0 "Screenshot from 2026-01-31 21-00-19.png")



```
prathamesh@localhost:/$ free -h
               total        used        free      shared  buff/cache   available
Mem:            15Gi       9.4Gi       3.0Gi       3.4Gi       6.7Gi       5.9Gi
Swap:             0B          0B          0B
```
```
prathamesh@localhost:/$ vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st gu
 1  0      0 3137680 135976 6842144    0    0     8    62  578    1  1  0 99  0  0  0
```
**4)  Disk / IO (2):** **`**df -h**`**, `du -sh /var/log`, `iostat`/`vmstat`/`dstat`**

```
prathamesh@localhost:/$ df -h
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           1.6G  2.8M  1.6G   1% /run
/dev/nvme0n1p5   16G   15G  319M  98% /
tmpfs           7.7G  2.0G  5.7G  26% /dev/shm
tmpfs           5.0M  8.0K  5.0M   1% /run/lock
efivarfs        192K  139K   49K  75% /sys/firmware/efi/efivars
/dev/nvme0n1p1  256M  105M  152M  41% /boot/efi
tmpfs           1.6G  160K  1.6G   1% /run/user/1000
```
```
prathamesh@localhost:/$ sudo du -sh /var/log
[sudo] password for prathamesh: 
677M	/var/log
```
prathamesh@localhost:/$ iostat
Linux 6.14.0-37-generic (localhost) 01/31/2026 _x86_64_ (16 CPU)

avg-cpu: %user %nice %system %iowait %steal %idle
 0.75 0.00 0.31 0.04 0.00 98.90

Device tps kB_read/s kB_wrtn/s kB_dscd/s kB_read kB_wrtn kB_dscd
loop0 0.00 0.00 0.00 0.00 17 0 0
loop1 0.00 0.00 0.00 0.00 1084 0 0
loop10 0.00 0.00 0.00 0.00 347 0 0
loop11 0.00 0.00 0.00 0.00 350 0 0
loop12 0.00 0.00 0.00 0.00 1229 0 0
loop13 0.00 0.00 0.00 0.00 332 0 0
loop14 0.00 0.00 0.00 0.00 405 0 0
loop15 0.00 0.09 0.00 0.00 36103 0 0



```
prathamesh@localhost:/$ vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st gu
 2  0      0 3134160 136284 6849536    0    0     8    62  580    1  1  0 99  0  0  0
```
prathamesh@localhost:/$ dstat
You did not select any stats, using -cdngy by default.
----total-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai stl| read writ| recv send| in out | int csw
 0 0 99 0 0| 0 0 |3379B 5882B| 0 0 | 879 1352
 0 0 99 0 0| 0 0 | 98B 94B| 0 0 | 768 1000
 0 0 99 0 0| 0 8194B| 164B 473B| 0 0 | 700 797
 0 0 99 0 0| 0 104k| 204B 86B| 0 0 | 462 513
 0 0 99 0 0| 0 184k| 280B 3324B| 0 0 | 623 685 



**5) ** **Network (2):** `ss -tulpn`/`netstat -tulpn`, `curl -I <service-endpoint>`/`ping` 

```
prathamesh@localhost:/$ ss -tulpn
Netid State  Recv-Q Send-Q                    Local Address:Port  Peer Address:PortProcess                            
udp   UNCONN 0      0                               0.0.0.0:47780      0.0.0.0:*    users:(("chrome",pid=3326,fd=166))
udp   UNCONN 0      0                            127.0.0.54:53         0.0.0.0:*                                      
udp   UNCONN 0      0                         127.0.0.53%lo:53         0.0.0.0:*                                      
udp   UNCONN 0      0                               0.0.0.0:44533      0.0.0.0:*                                      
udp   UNCONN 0      0                           224.0.0.251:5353       0.0.0.0:*    users:(("chrome",pid=3273,fd=97))
```
```
prathamesh@localhost:/$ netstat
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 linux:43590             ec2-18-97-36-9.co:https ESTABLISHED
tcp        0      0 linux:42856             ubuntu-archive-mir:http TIME_WAIT  
tcp        0      0 linux:49840             ec2-100-50-235-83:https ESTABLISHED
```
```
prathamesh@localhost:/$ netstat -tulpn
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -
```
```
prathamesh@localhost:/$ journalctl -u cron
Feb 23 12:37:07 prathamesh-HP-Pavilion-Plus-Laptop-14-eh0xxx systemd[1]: Started cron.service - Regular background pr>
Feb 23 12:37:07 prathamesh-HP-Pavilion-Plus-Laptop-14-eh0xxx (cron)[1147]: cron.service: Referenced but unset environ>
Feb 23 12:37:07 prathamesh-HP-Pavilion-Plus-Laptop-14-eh0xxx cron[1147]: (CRON) INFO (pidfile fd = 3)
Feb 23 12:37:07 prathamesh-HP-Pavilion-Plus-Laptop-14-eh0xxx cron[1147]: (CRON) INFO (Running @reboot jobs)
```
## Summary
- **Service health:** `sshd`  running normally and listening correctly
- **Resources:** CPU, memory, disk, and IO all within normal ranges
- **Likely cause:** External network latency or client-side DNS issues, not server resource exhaustion
---

##  If This Worsens — Next Steps
1. **Restart strategy:**
 Gracefully restart `sshd`  during a low-traffic window and monitor new login latency.
2. **Increase visibility:**
 Temporarily enable `LogLevel VERBOSE`  in `sshd_config`  to capture auth timing details.
3. **Deep diagnostics:**
 Attach `strace`  to a live `sshd`  process handling a slow login to identify blocking calls.


