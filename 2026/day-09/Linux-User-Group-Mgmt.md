# 

# Day 09 – Linux User & Group Management Challenge
## Task
Today's goal is to **practice user and group management** by completing hands-on challenges.

Figure out how to:

- Create users and set passwords
- Create groups and assign users
- Set up shared directories with group permissions
- Task 1: Create Users (20 minutes)
    - `tokyo` 
    - `berlin` 
    - `professor` 



![user_passwords.png](https://eraser.imgix.net/workspaces/iakQgzIPVHK2csJSiMUt/wT5AjlQjuoRNZa07dGqXHOM5M9s2/user_passwords_27kS7llruYbK8Cz6xzurX.png?ixlib=js-3.8.0 "user_passwords.png")

### Task 2: Create Groups (10 minutes)
Create two groups:

- `developers` 
- `admins` 
**Verify:** Check `/etc/group` 

developers:x:1004:
admins:x:1005:
ubuntu@ip-172-31-2-199:/$



### Task 3: Assign to Groups (15 minutes)
Assign users:

- `tokyo`  → `developers` 
- `berlin`  → `developers`  + `admins`  (both groups)
- `professor`  → `admins` 
**Verify:** Use appropriate command to check group membership

```
developers:x:1004:tokyo,berlin
admins:x:1005:berlin,professor
ubuntu@ip-172-31-2-199:/$
```
### Task 4: Shared Directory (20 minutes)
1. Create directory: `/opt/dev-project` 
2. Set group owner to `developers` 
3. Set permissions to `775`  (rwxrwxr-x)
4. Test by creating files as `tokyo`  and `berlin` 


![Screenshot from 2026-02-06 21-49-51.png](https://eraser.imgix.net/workspaces/iakQgzIPVHK2csJSiMUt/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-06%2021-49-51_Z-BkipvphFdx2enalddrX.png?ixlib=js-3.8.0 "Screenshot from 2026-02-06 21-49-51.png")



