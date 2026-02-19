#!/bin/bash

greet() {
    local name="$1"
    echo "Hello, $name!"
}

add() {
    local a="$1"
    local b="$2"
    local sum=$((a + b))
    echo "Sum: $sum"
}

# Call the functions
greet "Prathamesh"
add 10 20

