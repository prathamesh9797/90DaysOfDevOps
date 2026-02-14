#!/bin/bash


read -p "Enter Your Number: " NUM

if [ $NUM -gt 0 ]; then
	echo "$NUM is a positive number"
elif [ $NUM -lt 0 ]; then
	echo "$NUM is a negative number"
else
	echo "$NUM is Zero"
fi
