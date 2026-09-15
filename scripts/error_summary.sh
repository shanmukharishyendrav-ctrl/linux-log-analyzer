#!/bin/bash

echo "Frequent System Errors"
echo "======================"

grep "ERROR:" logs/system.log | \
sed 's/.*ERROR: //' | \
sort | uniq -c | sort -nr
