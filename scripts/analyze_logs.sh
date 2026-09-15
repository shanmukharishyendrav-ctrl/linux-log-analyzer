#!/bin/bash

echo "Linux Log Analyzer"
echo "=================="

echo "Total failed login attempts:"

grep -c "Failed password" logs/auth.log

echo ""
echo "Failed login attempts by IP:"

grep "Failed password" logs/auth.log | awk '
{
    for (i=1; i<=NF; i++) {
        if ($i == "from") {
            print $(i+1)
        }
    }
}' | sort | uniq -c | sort -nr

