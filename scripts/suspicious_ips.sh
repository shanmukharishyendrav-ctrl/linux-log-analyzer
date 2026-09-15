#!/bin/bash

echo "Suspicious IP Address Detector"
echo "=============================="

grep "Failed password" logs/auth.log | \
awk '{for (i=1; i<=NF; i++) if ($i == "from") print $(i+1)}' | \
sort | uniq -c | \
awk '$1 >= 3 {
    print "ALERT: " $2 " has " $1 " failed login attempts"
}'
