# 

## Task
This is a **continuation of Day 05**, but much simpler.

Today’s goal is to **practice basic file read/write** using only fundamental commands.

You will create a small text file and practice:

- Creating a file
- Writing text to a file
- Appending new lines
- Reading the file back
## Expected Output
By the end of today, you should have:

- the new created files
- A markdown file named:
`practice-files.md` 
Create a file named `notes.txt` 

Write 3 lines into the file using **redirection** (`>`  and `>>` )

Use `**cat**`  to read the full file

Use `**head**`  and `**tail**`  to read parts of the file

Use `**tee**`  once to write and display at the same time

Keep it short (8–12 lines total in the file) 

**OUTPUT :-**

```
prathamesh@localhost:/home$ ls
devops  notes.txt  prathamesh
prathamesh@localhost:/home$ sudo vim notes.txt
prathamesh@localhost:/home$ cat notes.txt
>       My name is prathamesh
>       i was working for TCS
>       I am thankful for the opportunity






>>      I have started my next journey with trainwithshubham
>>      may god bless me
prathamesh@localhost:/home$
```
```
prathamesh@localhost:/home$ head notes.txt
>       My name is prathamesh
>       i was working for TCS
>       I am thankful for the opportunity






>>      I have started my next journey with trainwithshubham
prathamesh@localhost:/home$ tail notes.txt
>       i was working for TCS
>       I am thankful for the opportunity






>>      I have started my next journey with trainwithshubham
>>      may god bless me
prathamesh@localhost:/home$
```
```
prathamesh@localhost:/home$ sudo echo "this line is written using tee" | tee notes.txt
tee: notes.txt: Permission denied
[sudo] password for prathamesh: 
this line is written using tee
prathamesh@localhost:/home$
```


