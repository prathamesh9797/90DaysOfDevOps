# Day 38 – YAML Basics

### Task 1: Key-Value Pairs
Create `person.yaml` that describes yourself with:

- `name` 
- `role` 
- `experience_years` 
- `learning`  (a boolean)
**Verify:** Run `cat person.yaml` — does it look clean? No tabs?

>>

```
name: prathamesh
role: devops-engineer
experience_years: 2
learning: true
```
```
ubuntu@ip-172-31-17-9:~/github-actions/yaml$ vim person.yaml
ubuntu@ip-172-31-17-9:~/github-actions/yaml$ cat person.yaml

name: prathamesh
role: devops-engineer
experience_years: 2
learning: true
```
---

### Task 2: Lists
Add to `person.yaml`:

- `tools`  — a list of 5 DevOps tools you know or are learning
- `hobbies`  — a list using the inline format `[item1, item2]` 
#### **Write in your notes: What are the two ways to write a list in YAML?**
###  Block Style (Dash `-` notation)
Each item starts with a dash.

```
languages:
- Python
- Java
- C++
```
This is the **most common and easiest to read** format.

### Flow Style (Bracket `[ ]` notation)
Items are written inside square brackets, separated by commas.

```
languages: [Python, Java, C++]
```
This style is **more compact** but less commonly used for long lists.



```
ubuntu@ip-172-31-17-9:~/github-actions/yaml$ vim person.yaml
ubuntu@ip-172-31-17-9:~/github-actions/yaml$ cat person.yaml

name: prathamesh
role: devops-engiineer
experience_years: 2
learning: true

tools:
  - docker
  - kubernetes
  - ansible
  - terraform
  - aws
hobbies: [cricket, swimming, movies]
```
---

### Task 3: Nested Objects
Create `server.yaml` that describes a server:

- `server`  with nested keys: `name` , `ip` , `port` 
- `database`  with nested keys: `host` , `name` , `credentials`  (nested further: `user` , `password` )
**Verify:** Try adding a tab instead of spaces — what happens when you validate it?

YAML **does not allow tabs for indentation**. If you insert a tab and try to validate or parse the file (for example with a YAML linter or a program that reads YAML), you will typically get an error such as:

```
found character '\t' that cannot start any token
```
or

```
Tab characters are not allowed for indentation
```
```

ubuntu@ip-172-31-17-9:/github-actions/yaml$ vim server.yaml
ubuntu@ip-172-31-17-9:~/github-actions/yaml$ cat server.yaml

server:
  name: amazon-ec2
  ip: 44.243.213.152
  port: 22
database:
  host: mysql
  name: my_database
  credentials:
    user: prathamesh
    password: test@123

```
---

### Task 4: Multi-line Strings
In `server.yaml`, add a `startup_script` field using:

1. The `|`  block style (preserves newlines)
2. The `>`  fold style (folds into one line)
#### **Write in your notes: When would you use **`**|**`** vs **`**>**`**?**


```
ubuntu@ip-172-31-17-9:~/github-actions/yaml$ vim server.yaml
ubuntu@ip-172-31-17-9:~/github-actions/yaml$ cat server.yaml

server:
  name: amazon-ec2
  ip: 44.243.213.152
  port: 8080
  startup_script_literal: |
    echo "starting server..."
    systemctl start nginx
    echo "server started"
  startup_script_folded: >
    echo "starting server..."
    systemctl start nginx
    echo "server started"
database:
  host: localhost
  name: app_db
  credentials:
    user: admin
    password: secret123
```
#### `|` Literal Block Style
- **Preserves line breaks exactly as written**
- Each line stays separate.
Result when read:

```
echo "Starting server..."systemctl start nginxecho "Server started"
```
Good for:

- Shell scripts
- Logs
- Configuration blocks
- Code snippets
****`**>**`**  Folded Style**

- **Folds newlines into spaces**
- Lines become one continuous paragraph (except blank lines).
Result when read:

```
echo "Starting server..." systemctl start nginx echo "Server started"
```
Good for:

- Long text
- Descriptions
- Messages
- Documentation strings
### What you should write in your notes
`**|**`** (literal style)** → keeps line breaks exactly as written (used for scripts or code).
 `**>**`** (folded style)** → converts line breaks into spaces (used for long text paragraphs).

---

### Task 5: Validate Your YAML
1. Install `yamllint`  or use an online validator
2. Validate both your YAML files
3. Intentionally break the indentation — what error do you get?
4. Fix it and validate again


![Screenshot from 2026-03-07 07-21-08.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-07%2007-21-08_ldJXP46CwDud1UYRbfyCP.png?ixlib=js-3.8.0 "Screenshot from 2026-03-07 07-21-08.png")

---

### Task 6: Spot the Difference
Read both blocks and write what's wrong with the second one:

```
# Block 1 - correct
name: devops
tools:
  - docker
  - kubernetes
```
The list items (`- docker` , `- kubernetes` ) are **properly indented under **`**tools**` .

YAML clearly understands that `**tools**` ** contains a list**.

```
Block 2 - broken
name: devops
tools:
- docker
  - kubernetes
```
**What's wrong:**

1. The first list item `- docker`  is **not indented under **`**tools**` .
2. The second item `- kubernetes`  **is indented**, creating **inconsistent indentation**.
3. YAML requires **consistent indentation for list items**.
Because of this, YAML may interpret the structure incorrectly or produce a parsing error.

### **List items must be consistently indented under their parent key.**
### In Block 2, `- docker`  is not indented while `- kubernetes`  is, which breaks YAML structure.
## Hints
- YAML uses **spaces only** — never tabs
- Indentation is everything — 2 spaces is standard
- Strings don't need quotes unless they contain special characters (`:` , `#` , etc.)
- `true` /`false`  are booleans, `"true"`  is a string
- Validate online: yamllint.com


