
#!/bin/bash

REPORT="reports/security_report.txt"

echo "==================================" > "$REPORT"
echo " Linux Security Monitoring Report" >> "$REPORT"
echo "==================================" >> "$REPORT"
echo "" >> "$REPORT"

echo "1. FAILED LOGIN ATTEMPTS" >> "$REPORT"
grep -c "Failed password" logs/auth.log >> "$REPORT"
echo "" >> "$REPORT"

echo "2. FAILED LOGINS BY IP" >> "$REPORT"
grep "Failed password" logs/auth.log | \
awk '{for (i=1; i<=NF; i++) if ($i == "from") print $(i+1)}' | \
sort | uniq -c | sort -nr >> "$REPORT"
echo "" >> "$REPORT"

echo "3. SUSPICIOUS IP ADDRESSES" >> "$REPORT"
grep "Failed password" logs/auth.log | \
awk '{for (i=1; i<=NF; i++) if ($i == "from") print $(i+1)}' | \
sort | uniq -c | \
awk '$1 >= 3 {
    print "ALERT: " $2 " has " $1 " failed login attempts"
}' >> "$REPORT"
echo "" >> "$REPORT"

echo "4. FREQUENT SYSTEM ERRORS" >> "$REPORT"
grep "ERROR:" logs/system.log | \
sed 's/.*ERROR: //' | \
sort | uniq -c | sort -nr >> "$REPORT"

echo "Report generated successfully!"
echo "Saved to: $REPORT"
