# 

## Quick Concepts (write 1–2 bullets each)
- OSI layers (L1–L7) vs TCP/IP stack (Link, Internet, Transport, Application)
- Where **IP**, **TCP/UDP**, **HTTP/HTTPS**, **DNS** sit in the stack
- One real example: “`curl https://example.com`  = App layer over TCP over IP”


**OSI (L1–L7) vs TCP/IP stack (Link, Internet, Transport, Application)**

- OSI is a **teaching model** (7 layers) for thinking about where problems live; TCP/IP is the **practical model** used on real networks.
- TCP/IP collapses OSI’s lower layers into **Link** and upper layers into **Application**.
**Where IP, TCP/UDP, HTTP/HTTPS, DNS sit in the stack**

- **IP** → Internet layer; **TCP/UDP** → Transport layer.
- **HTTP/HTTPS, DNS** → Application layer (they run _on top of_ TCP/UDP and IP).
**One real example**

- `curl https://example.com`  = **Application (HTTP/HTTPS)** over **Transport (TCP)** over **Internet (IP)** over **Link (Ethernet/Wi-Fi)**.


---



## Hands-on Checklist (run these; add 1–2 line observations)
- **Identity:** `hostname -I`  (or `ip addr show` ) — note your IP.
```
ubuntu@ip-172-31-2-199:/$ hostname -I
172.31.2.199 172.17.0.1 
ubuntu@ip-172-31-2-199:/$ ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enX0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc fq_codel state UP group default qlen 1000
    link/ether 0a:2d:73:ae:7c:df brd ff:ff:ff:ff:ff:ff
    inet 172.31.2.199/20 metric 100 brd 172.31.15.255 scope global dynamic enX0
       valid_lft 2524sec preferred_lft 2524sec
    inet6 fe80::82d:73ff:feae:7cdf/64 scope link 
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 9e:ec:33:6d:ec:83 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
```
---

**Reachability:** `ping <target>`  — mention latency and packet loss.

ubuntu@ip-172-31-2-199:/$ ping google.com
PING google.com (172.217.174.78) 56(84) bytes of data.
64 bytes from bom07s25-in-f14.1e100.net (172.217.174.78): icmp_seq=1 ttl=117 time=1.27 ms
64 bytes from bom07s25-in-f14.1e100.net (172.217.174.78): icmp_seq=2 ttl=117 time=0.866 ms
64 bytes from bom07s25-in-f14.1e100.net (172.217.174.78): icmp_seq=3 ttl=117 time=1.39 ms
64 bytes from bom07s25-in-f14.1e100.net (172.217.174.78): icmp_seq=4 ttl=117 time=1.09 ms
64 bytes from bom07s25-in-f14.1e100.net (172.217.174.78): icmp_seq=5 ttl=117 time=0.887 ms

---

- **Path:** `traceroute <target>`  (or `tracepath` ) — note any long hops/timeouts.
```
ubuntu@ip-172-31-2-199:/$ traceroute google.com
traceroute to google.com (142.251.222.110), 30 hops max, 60 byte packets
 1  240.2.196.14 (240.2.196.14)  1.693 ms 240.2.196.12 (240.2.196.12)  1.659 ms 240.2.196.15 (240.2.196.15)  1.948 ms
 2  242.6.252.135 (242.6.252.135)  1.891 ms 242.6.253.129 (242.6.253.129)  1.862 ms 242.6.252.3 (242.6.252.3)  1.864 ms
 3  * * *
 4  * * 99.82.178.53 (99.82.178.53)  1.413 ms
 5  * * *
 6  142.250.60.134 (142.250.60.134)  1.522 ms 192.178.86.238 (192.178.86.238)  2.205 ms 142.250.214.110 (142.250.214.110)  2.170 ms
 7  142.251.77.95 (142.251.77.95)  1.484 ms 142.251.77.97 (142.251.77.97)  1.455 ms 192.178.110.110 (192.178.110.110)  1.293 ms
 8  pnbomb-az-in-f14.1e100.net (142.251.222.110)  1.076 ms 142.250.226.135 (142.250.226.135)  3.336 ms  3.312 ms

ubuntu@ip-172-31-2-199:/$ tracepath google.com
 1?: [LOCALHOST]                      pmtu 9001
 1:  ip-172-31-0-1.ap-south-1.compute.internal             0.172ms pmtu 1500
 1:  240.2.196.14                                          1.687ms asymm  8 
 2:  242.6.253.133                                         4.751ms asymm  9 
 3:  no reply
 4:  99.82.178.53                                          1.982ms asymm 10 
 5:  no reply
```
---

- **Ports:** `ss -tulpn`  (or `netstat -tulpn` ) — list one listening service and its port.
```
ubuntu@ip-172-31-2-199:/$ ss -tulpn
Netid     State      Recv-Q      Send-Q               Local Address:Port            Peer Address:Port     Process     
udp       UNCONN     0           0                       127.0.0.54:53                   0.0.0.0:*                    
udp       UNCONN     0           0                    127.0.0.53%lo:53                   0.0.0.0:*                    
udp       UNCONN     0           0                172.31.2.199%enX0:68                   0.0.0.0:*                    
udp       UNCONN     0           0                        127.0.0.1:323                  0.0.0.0:*                    
udp       UNCONN     0           0                            [::1]:323                     [::]:*                    
tcp       LISTEN     0           4096                       0.0.0.0:22                   0.0.0.0:*
```
```
ubuntu@ip-172-31-2-199:/$ sudo ss -tulpn
Netid       State        Recv-Q       Send-Q                 Local Address:Port               Peer Address:Port       Process                                                                                                               
udp         UNCONN       0            0                         127.0.0.54:53                      0.0.0.0:*           users:(("systemd-resolve",pid=473,fd=16))                                                                            
udp         UNCONN       0            0                      127.0.0.53%lo:53                      0.0.0.0:*           users:(("systemd-resolve",pid=473,fd=14))                                                                            
udp         UNCONN       0            0                  172.31.2.199%enX0:68                      0.0.0.0:*           users:(("systemd-network",pid=630,fd=11))                                                                            
udp         UNCONN       0            0                          127.0.0.1:323                     0.0.0.0:*           users:(("chronyd",pid=784,fd=5))                                                                                     
udp         UNCONN       0            0                              [::1]:323                        [::]:*           users:(("chronyd",pid=784,fd=6))                                                                                     
tcp         LISTEN       0            4096                         0.0.0.0:22                      0.0.0.0:*           users:(("sshd",pid=1410,fd=3),("systemd",pid=1,fd=85))                                                               
tcp         LISTEN       0            511                          0.0.0.0:80                      0.0.0.0:*           users:(("nginx",pid=747,fd=5),("nginx",pid=733,fd=5))
```
---

- **Name resolution:** `dig <domain>`  or `nslookup <domain>`  — record the resolved IP.
```
ubuntu@ip-172-31-2-199:/$ dig google.com

; <<>> DiG 9.18.39-0ubuntu0.24.04.2-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 40032
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		190	IN	A	142.250.77.78

;; Query time: 1 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Wed Feb 11 10:18:33 UTC 2026
;; MSG SIZE  rcvd: 55
```
```
ubuntu@ip-172-31-2-199:/$ nslookup google.com
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
Name:	google.com
Address: 142.250.77.78
Name:	google.com
Address: 2404:6800:4009:809::200e
```
---

- **HTTP check:** `curl -I <http/https-url>`  — note the HTTP status code.
- status code is showing HTTP/2 200 >> means success , the request worked & page is reachable
- HTTP/2 > protocol is used 
- 200 > Ok , 301/302 > Redirect , 401/403 > Auth / Permission issue , 404 > Not found 500/502/503 >> server problem
```
ubuntu@ip-172-31-2-199:/$ curl -I https://github.com/prathamesh9797/90DaysOfDevOps/blob/master/2026/day-14/README.md
HTTP/2 200 
date: Wed, 11 Feb 2026 10:20:54 GMT
content-type: text/html; charset=utf-8
vary: X-PJAX, X-PJAX-Container, Turbo-Visit, Turbo-Frame, X-Requested-With, Sec-Fetch-Site,Accept-Encoding, Accept, X-Requested-With
x-repository-download: git clone https://github.com/prathamesh9797/90DaysOfDevOps.git
x-raw-download: https://raw.githubusercontent.com/prathamesh9797/90DaysOfDevOps/master/2026/day-14/README.md
etag: W/"e82641555b29029607b96aef64827a96"
cache-control: max-age=0, private, must-revalidate
strict-transport-security: max-age=31536000; includeSubdomains; preload
x-frame-options: deny
x-content-type-options: nosniff
x-xss-protection: 0
referrer-policy: no-referrer-when-downgrade
```
---

- **Connections snapshot:** `netstat -an | head`  — count ESTABLISHED vs LISTEN (rough).
```
ubuntu@ip-172-31-2-199:/$ netstat -an | head
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:46009         0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN     
tcp        0      0 172.31.2.199:42264      13.126.16.60:80         TIME_WAIT  
tcp        0    124 172.31.2.199:22         49.36.32.17:44596       ESTABLISHED
tcp6       0      0 :::22                   :::*                    LISTEN
```
---

## Mini Task: Port Probe & Interpret
1. Identify one listening port from `ss -tulpn`  (e.g., SSH on 22 or a local web app).
2. From the same machine, test it: `nc -zv localhost <port>`  (or `curl -I http://localhost:<port>` ).
3. Write one line: is it reachable? If not, what’s the next check? (e.g., service status, firewall).


### **Port 80 is listening and reachable locally (HTTP 200 from Nginx); **
```
ubuntu@ip-172-31-2-199:/$ ss -tulpn
Netid     State      Recv-Q      Send-Q               Local Address:Port            Peer Address:Port     Process     
udp       UNCONN     0           0                       127.0.0.54:53                   0.0.0.0:*                    
udp       UNCONN     0           0                    127.0.0.53%lo:53                   0.0.0.0:*                    
udp       UNCONN     0           0                172.31.2.199%enX0:68                   0.0.0.0:*                    
udp       UNCONN     0           0                        127.0.0.1:323                  0.0.0.0:*                    
udp       UNCONN     0           0                            [::1]:323                     [::]:*                    
tcp       LISTEN     0           4096                       0.0.0.0:22                   0.0.0.0:*                    
tcp       LISTEN     0           511                        0.0.0.0:80                   0.0.0.0:*                    
tcp       LISTEN     0           4096                    127.0.0.54:53                   0.0.0.0:*                    
tcp       LISTEN     0           4096                     127.0.0.1:46009                0.0.0.0:*                    
tcp       LISTEN     0           4096                 127.0.0.53%lo:53                   0.0.0.0:*                    
tcp       LISTEN     0           4096                          [::]:22                      [::]:*                    
tcp       LISTEN     0           511                           [::]:80                      [::]:*                    
ubuntu@ip-172-31-2-199:/$ curl -I http://localhost:80
HTTP/1.1 200 OK
Server: nginx/1.24.0 (Ubuntu)
Date: Wed, 11 Feb 2026 10:31:08 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Thu, 05 Feb 2026 19:16:41 GMT
Connection: keep-alive
ETag: "6984ec99-267"
Accept-Ranges: bytes
```
## Reflection
- **Fastest “something’s broken” signal:**
 `ping`  (quick reachability check) or a simple `curl -I https://service`  for app-level health. If either fails, you know immediately where to start digging (network vs app).
- **Next layer to inspect (OSI / TCP-IP):**
    - **If DNS fails:** inspect the **Application layer** first (DNS config/records), then step down to **Transport/Network** (UDP/TCP 53 reachability, routing, firewall).
    - **If HTTP 500 appears:** stay at the **Application layer** (server logs, dependencies, config, deployments), then check **Transport** for resets/timeouts if errors are intermittent.

- **Two follow-up checks in a real incident:**
    1. Check **service logs + recent deploys/config changes** (did something just change?).
    2. Verify **upstream dependencies** (DB/cache/third-party API health) and basic **resource pressure** (CPU, memory, disk, connection pools).



