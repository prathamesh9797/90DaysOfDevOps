#!/bin/bash

demo_local() {
    local msg="I am LOCAL"
    echo "Inside demo_local(): msg = $msg"
}

demo_global() {
    msg="I am GLOBAL"
    echo "Inside demo_global(): msg = $msg"
}

echo "Before calling functions: msg = ${msg:-<not set>}"

demo_local
echo "After demo_local(): msg = ${msg:-<not set>}"

demo_global
echo "After demo_global(): msg = $msg"

