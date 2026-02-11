# 

# Networking Concepts: DNS, IP, Subnets & Ports
## Task
- Understand how **DNS** resolves names to IPs
- Learn **IP addressing** (IPv4, public vs private)
- Break down **CIDR notation** and **subnetting** basics
- Know common **ports** and why they matter
---

# **Task 1: DNS – How Names Become IPs**
# **Explain in 3–4 lines: what happens when you type **`**google.com**`**  in a browser?**
>> When you type `google.com` in your browser, your system first uses **DNS** to resolve the domain name into an IP address.
 Then it establishes a **TCP connection** (and TLS for HTTPS) with that IP.
 Your browser sends an **HTTP request**, and Google’s server responds with the page data.
 Finally, the browser **renders the HTML/CSS/JS** to show you the website.



# **What are these record types? Write one line each:**
# ****`**A**`** , **`**AAAA**`** , **`**CNAME**`** , **`**MX**`** , **`**NS**`** **
**A** → Maps a domain to an **IPv4 address** (e.g., `google.com → 142.250.x.x` )

**AAAA** → Maps a domain to an **IPv6 address**

**CNAME** → Points one domain to **another domain name** (alias)

**MX** → Specifies the **mail servers** for a domain (email routing)

**NS** → Tells which **name servers** are authoritative for the domain



# **Run: **`**dig google.com**`**  — identify the A record and TTL from the output**
**TTL** → `191` 

**Record type (A)** → `A` 

**IP (A record value)** → `142.250.195.14` 

```
ubuntu@ip-172-31-2-199:/$ dig google.com

; <<>> DiG 9.18.39-0ubuntu0.24.04.2-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 38711
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		191	IN	A	142.250.195.14

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Wed Feb 11 11:03:44 UTC 2026
;; MSG SIZE  rcvd: 55
```
---

### Task 2: IP Addressing
## **What is an IPv4 address? How is it structured? (e.g., **`**192.168.1.10**`** )**
>>  An **IPv4 address** is a unique **32-bit numeric identifier** used to identify devices on a network.

**Structure (e.g., **`**192.168.1.10**`**):**

- It’s written in **dotted-decimal format**: four numbers (octets) separated by dots.
- Each octet ranges from **0–255** (because 8 bits × 4 = 32 bits total).
Example: `192.168.1.10` = 4 octets → `192` · `168` · `1` · `10` 



## Difference between **public** and **private** IPs — give one example of each
>>  **Public IP:**
 Globally routable on the internet; used to identify your network to the outside world.
 _Example:_ `8.8.8.8` 

**Private IP:**
 Used inside local networks; not directly reachable from the internet (via NAT).
 _Example:_ `192.168.1.10` 

(Private ranges: `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`)



## **What are the private IP ranges?**
## ****`**10.x.x.x**`** , **`**172.16.x.x – 172.31.x.x**`** , **`**192.168.x.x**`** **
>> **10.0.0.0 – 10.255.255.255** → `10.x.x.x` 

**172.16.0.0 – 172.31.255.255** → `172.16.x.x – 172.31.x.x` 

**192.168.0.0 – 192.168.255.255** → `192.168.x.x` 

These ranges are reserved for **internal/private networks** and aren’t routable on the public internet (they typically go out via NAT).



## **Run: **`**ip addr show**`**  — identify which of your IPs are private**


### Private IPs in your output
- `**127.0.0.1/8**` ** (lo)**
 → Loopback (localhost). Special-purpose private address used by your own machine.
- `**172.31.2.199/20**` ** (enX0)**
 → Falls in the private range **172.16.0.0 – 172.31.255.255**
- `**172.17.0.1/16**` ** (docker0)**
 → Also in the private range **172.16.0.0 – 172.31.255.255** (used by Docker bridge)
```
buntu@ip-172-31-2-199:/$ ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enX0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc fq_codel state UP group default qlen 1000
    link/ether 0a:2d:73:ae:7c:df brd ff:ff:ff:ff:ff:ff
    inet 172.31.2.199/20 metric 100 brd 172.31.15.255 scope global dynamic enX0
       valid_lft 3083sec preferred_lft 3083sec
    inet6 fe80::82d:73ff:feae:7cdf/64 scope link 
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 9e:ec:33:6d:ec:83 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
```
---

## **Task 3: CIDR & Subnetting**
## **What does **`**/24**`**  mean in **`**192.168.1.0/24**`** ?**
>> `/24` in `**192.168.1.0/24**` is the **CIDR prefix length** — it means **24 bits are for the network**, and the remaining **8 bits are for hosts**.

**What that implies:**

- Subnet mask = **255.255.255.0**
- Total IPs = **256** (0–255)
- Usable hosts = **254** (from `192.168.1.1`  to `192.168.1.254` )
- Network = `192.168.1.0` , Broadcast = `192.168.1.255` 


## How many usable hosts in a `/24`? A `/16`? A `/28`? 
>> **usable hosts** in each subnet (IPv4):

- **/24** → 256 total − 2 = **254 usable hosts**
- **/16** → 65,536 total − 2 = **65,534 usable hosts**
- **/28** → 16 total − 2 = **14 usable hosts**
Rule of thumb:

>  Usable hosts = 2(32−prefix)−22^{(32 - prefix)} - 22(32−prefix)−2 



## Explain in your own words: why do we subnet?
>>  We subnet to **split a big network into smaller, manageable pieces**.

This helps with:

- **Better performance** (smaller broadcast domains = less noise)
- **Security & isolation** (separate teams/apps/envs)
- **Efficient IP usage** (don’t waste huge ranges on small groups)
- **Cleaner network design** (easier routing, scaling, troubleshooting)
In short: subnetting keeps networks **organized, secure, and scalable**.



## **Quick exercise — fill in:**
| **CIDR** | **Subnet Mask** | **Total IPs** | **Usable Hosts** |
| ----- | ----- | ----- | ----- |
| /24 | 255.255.255.0  | 256 | 254 |
| /16 | 255.255.0.0  | 65,536 | 65,534 |
| /28 | 255.255.255.240  | 16 | 14 |
---

## **Task 4: Ports – The Doors to Services**
1. What is a port? Why do we need them?
>> A **port** is a logical number that identifies a **specific service or application** on a machine.
 We need ports so **multiple services can run on the same IP** without conflict (e.g., web, SSH, DB all on one server).

#### **One-liner to remember:**
> ** IP = ****_which machine_****, Port = ****_which service on that machine_****.**

1. Document these common ports:
| **Port** | **Service** |
| ----- | ----- |
| 22 | SSH (remote login) |
| 80 | HTTP (web traffic) |
| 443 | HTTPS (secure web traffic) |
| 53 | DNS (name resolution) |
| 3306 | MySQL (database) |
| 6379 | Redis (in-memory cache) |
| 27017 | MongoDB (NoSQL database) |
## **Run **`**ss -tulpn**`**  — match at least 2 listening ports to their services**
>> tcp   LISTEN   0   4096   0.0.0.0:22    0.0.0.0:*   users:(("sshd",...))
      tcp   LISTEN   0   511    0.0.0.0:80    0.0.0.0:*   users:(("nginx",...))

### Matched ports → services
- **Port 22 → SSH**
 Service: `sshd`  (remote login into the server)
- **Port 80 → HTTP**
 Service: `nginx`  (web server serving HTTP traffic)
>  From `ss -tulpn`, port **22** is listening for **SSH (sshd)** and port **80** is listening for **HTTP (nginx)** on my instance.

---

# **Task 5: Putting It Together**
# **Answer in 2–3 lines each:**
## **You run **`**curl http://myapp.com:8080**`**  — what networking concepts from today are involved?**
>> `**curl http://myapp.com:8080**`** — what concepts are involved?**
 This uses **DNS** to resolve `myapp.com` → IP, then opens a **TCP connection** to **port 8080**, and sends an **HTTP request** at the Application layer. It’s App (HTTP) over Transport (TCP) over Internet (IP).

## **Your app can't reach a database at **`**10.0.1.50:3306**`**  — what would you check first?**
>> First check **network reachability** (`ping 10.0.1.50`) and **port access** (`nc -zv 10.0.1.50 3306`).
 If reachable, verify the **DB service is running/listening** and that **firewall/security groups** allow TCP 3306.

