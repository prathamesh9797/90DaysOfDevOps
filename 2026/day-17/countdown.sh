#!/bin/bash


#Takes a number from the user
#Counts down to 0 using a while loop
#Prints "Done!" at the end



read -p "please input number" i


while (( i>=0))
do 
	echo " $i "
	((i--))
done
echo "done"
