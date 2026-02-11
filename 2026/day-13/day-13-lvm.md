# 

# Day 13 – Linux Volume Management (LVM)
## Task
Learn LVM to manage storage flexibly – create, extend, and mount volumes.

**Watch First:** [﻿Linux LVM Tutorial](https://youtu.be/Evnf2AAt7FQ?si=ncnfQYySYtK_2K3c) 

---

## Expected Output
- A markdown file: `day-13-lvm.md` 
- Screenshots of command outputs
## Challenge Tasks
### Task 1: Check Current Storage
Run: `lsblk`, `pvs`, `vgs`, `lvs`, `df -h` 

```
ubuntu@ip-172-31-2-199:/$ lsblk
NAME     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0      7:0    0 27.8M  1 loop /snap/amazon-ssm-agent/12322
loop1      7:1    0 27.6M  1 loop /snap/amazon-ssm-agent/11797
loop2      7:2    0   74M  1 loop /snap/core22/2163
loop3      7:3    0   74M  1 loop /snap/core22/2292
loop4      7:4    0 50.9M  1 loop /snap/snapd/25577
loop5      7:5    0 48.1M  1 loop /snap/snapd/25935
xvda     202:0    0   25G  0 disk 
├─xvda1  202:1    0   24G  0 part /
├─xvda14 202:14   0    4M  0 part 
├─xvda15 202:15   0  106M  0 part /boot/efi
└─xvda16 259:0    0  913M  0 part /boot
```
```
root@ip-172-31-2-199:/# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        24G  2.6G   21G  11% /
tmpfs           479M     0  479M   0% /dev/shm
tmpfs           192M  896K  191M   1% /run
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/xvda16     881M   89M  730M  11% /boot
/dev/xvda15     105M  6.2M   99M   6% /boot/efi
tmpfs            96M   12K   96M   1% /run/user/1000
```
---

# **Create Virtual storage using Amazon EBS and added 10GB storage to the EC2 instance**
![Screenshot from 2026-02-11 12-06-40.png](https://eraser.imgix.net/workspaces/uCLblDWRBITvKZZO2Yov/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-11%2012-06-40_lRGVGc6Tk74DTrNChOrsD.png?ixlib=js-3.8.0 "Screenshot from 2026-02-11 12-06-40.png")

---

### Task 1: Check Current Storage
Run: `lsblk`, `pvs`, `vgs`, `lvs`, `df -h` 

#### ubuntu@ip-172-31-2-199:~$ lsblk
NAME     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0      7:0    0 27.6M  1 loop /snap/amazon-ssm-agent/11797
loop1      7:1    0 50.9M  1 loop /snap/snapd/25577
loop2      7:2    0 27.8M  1 loop /snap/amazon-ssm-agent/12322
loop3      7:3    0   74M  1 loop /snap/core22/2163
loop4      7:4    0 48.1M  1 loop /snap/snapd/25935
loop5      7:5    0   74M  1 loop /snap/core22/2292
xvda     202:0    0   25G  0 disk 
├─xvda1  202:1    0   24G  0 part /
├─xvda14 202:14   0    4M  0 part 
├─xvda15 202:15   0  106M  0 part /boot/efi
└─xvda16 259:0    0  913M  0 part /boot
**xvdf     202:80   0   10G  0 disk**

 Underlined Disk got added
### Task 2: Create Physical Volume
```
ubuntu@ip-172-31-2-199:/$ sudo pvcreate /dev/xvdf
Physical volume "/dev/xvdf" successfully created.
ubuntu@ip-172-31-2-199:/$ sudo pvs
PV         VG        Fmt  Attr PSize   PFree  
/dev/xvdf  devops-vg lvm2 a--  <10.00g <10.00g
```
### Task 3: Create Volume Group
```
ubuntu@ip-172-31-2-199:/$ sudo vgcreate devops-vg /dev/xvdf
  Volume group "devops-vg" successfully created
ubuntu@ip-172-31-2-199:/$ vgs
VG        #PV #LV #SN Attr   VSize   VFree  
devops-vg   1   0   0 wz--n- <10.00g <10.00g
```
### Task 4: Create Logical Volume
```
ubuntu@ip-172-31-2-199:/$ sudo lvcreate -n app-data -L 500M devops-vg
  Logical volume "app-data" created.
ubuntu@ip-172-31-2-199:/$ sudo lvs
  LV       VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  app-data devops-vg -wi-a----- 500.00m
```
---

# **Task 5: Format and Mount**
# **mkfs.ext4 /dev/devops-vg/app-data
**
```
ubuntu@ip-172-31-2-199:/$ sudo mkfs -t ext4 /dev/devops-vg/app-data
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 128000 4k blocks and 128000 inodes
Filesystem UUID: 3aac25f5-1cb2-47c8-a079-b709b765ffb1
Superblock backups stored on blocks: 
	32768, 98304

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done
```
---

# **Create a Mount Point**
# **mkdir -p /mnt/app-data**
```
ubuntu@ip-172-31-2-199:/$ sudo mkdir /mnt/app-data
ubuntu@ip-172-31-2-199:/$ cd /mnt
ubuntu@ip-172-31-2-199:/mnt$ ls -l
total 16
drwxr-xr-x 2 root root 4096 Feb 11 06:59 app-data

```
---

# **mount /dev/devops-vg/app-data /mnt/app-data**
```
ubuntu@ip-172-31-2-199:/$ sudo mount /dev/devops-vg/app-data /mnt/app-data
ubuntu@ip-172-31-2-199:/$ df -h
Filesystem                        Size  Used Avail Use% Mounted on
tmpfs                              96M  932K   95M   1% /run
/dev/xvda1                         24G  2.6G   21G  11% /
tmpfs                             479M     0  479M   0% /dev/shm
tmpfs                             5.0M     0  5.0M   0% /run/lock
/dev/xvda16                       881M   89M  730M  11% /boot
/dev/xvda15                       105M  6.2M   99M   6% /boot/efi
tmpfs                              96M   12K   96M   1% /run/user/1000
/dev/mapper/devops--vg-app--data  452M   24K  417M   1% /mnt/app-data
```
---

# **df -h /mnt/app-data**
```
ubuntu@ip-172-31-2-199:/$ df -h /mnt/app-data
Filesystem                        Size  Used Avail Use% Mounted on
/dev/mapper/devops--vg-app--data  452M   24K  417M   1% /mnt/app-data
```
---

# **Task 6: Extend the Volume**
# **lvextend  -r -L +200M /dev/devops-vg/app-data**
```
ubuntu@ip-172-31-2-199:/$ sudo lvextend -L +200M /dev/devops-vg/app-data
  Size of logical volume devops-vg/app-data changed from 500.00 MiB (125 extents) to 700.00 MiB (175 extents).
  Logical volume devops-vg/app-data successfully resized.

```


#### **You can use the -r flag in the lvextend command to resize the file system automatically. Otherwise , you will need to run a seperate command to resize file system.**
## **resize2fs /dev/devops-vg/app-data**
ubuntu@ip-172-31-2-199:/$ sudo resize2fs /dev/devops-vg/app-data
resize2fs 1.47.0 (5-Feb-2023)
Filesystem at /dev/devops-vg/app-data is mounted on /mnt/app-data; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 1
The filesystem on /dev/devops-vg/app-data is now 179200 (4k) blocks long.



---

# **df -h /mnt/app-data**


```
ubuntu@ip-172-31-2-199:/$ df -h /mnt/app-data
Filesystem                        Size  Used Avail Use% Mounted on
/dev/mapper/devops--vg-app--data  637M   24K  594M   1% /mnt/app-data
```


