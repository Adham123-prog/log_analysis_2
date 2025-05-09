#!/bin/bash

# Automatically use log file from Desktop
LOG_FILE="$HOME/Desktop/company_ai_log"
OUTPUT_FILE="log_analysis_report_$(date +%Y%m%d_%H%M%S).txt"

if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found at $LOG_FILE"
    exit 1
fi

echo "Log File Analysis Report" > "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "===========================================" >> "$OUTPUT_FILE"

# 1. Request Counts
{
    echo "1. Request Counts:"
    total=$(wc -l < "$LOG_FILE")
    get=$(grep -c '"GET ' "$LOG_FILE")
    post=$(grep -c '"POST ' "$LOG_FILE")
    echo "Total Requests: $total"
    echo "GET Requests: $get"
    echo "POST Requests: $post"
} >> "$OUTPUT_FILE"

echo -e "\n2. Unique IP Addresses and Methods:" >> "$OUTPUT_FILE"
awk '{ip=$1; method=$6; gsub(/\"/, "", method); count[ip][method]++} 
     END {
         print "IP Address       GET   POST";
         for (ip in count) {
             printf "%-15s %4d %6d\n", ip, count[ip]["GET"]+0, count[ip]["POST"]+0
         }
     }' "$LOG_FILE" >> "$OUTPUT_FILE"

# 3. Failure Requests
{
    echo -e "\n3. Failure Requests:"
    failed=$(grep -E 'HTTP/[0-9.]+" [45][0-9]{2}' "$LOG_FILE" | wc -l)
    percent=$(echo "scale=2; $failed/$total*100" | bc)
    echo "Total Failed Requests (4xx/5xx): $failed"
    echo "Failure Percentage: $percent%"
} >> "$OUTPUT_FILE"

# 4. Top User
{
    echo -e "\n4. Most Active IP:"
    awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print "IP: "$2" with "$1" requests"}'
} >> "$OUTPUT_FILE"

# 5. Daily Request Averages
{
    echo -e "\n5. Daily Request Average:"
    total_days=$(awk '{print $4}' "$LOG_FILE" | cut -d: -f1 | tr -d '[' | sort -u | wc -l)
    avg=$(echo "scale=2; $total/$total_days" | bc)
    echo "Average Requests Per Day: $avg"
} >> "$OUTPUT_FILE"

# 6. Failure by Day
{
    echo -e "\n6. Failure Analysis by Day:"
    grep -E 'HTTP/[0-9.]+" [45][0-9]{2}' "$LOG_FILE" | awk '{print $4}' | cut -d: -f1 | tr -d '[' | sort | uniq -c | sort -nr
} >> "$OUTPUT_FILE"

# Additional: Requests by Hour
{
    echo -e "\n7. Requests by Hour:"
    awk -F: '{print $2}' "$LOG_FILE" | sort | uniq -c | sort -n
} >> "$OUTPUT_FILE"

# Additional: Status Codes Breakdown
{
    echo -e "\n8. Status Code Breakdown:"
    awk '{print $9}' "$LOG_FILE" | grep -E '^[0-9]{3}$' | sort | uniq -c | sort -nr
} >> "$OUTPUT_FILE"

# Additional: Most Active User by Method
{
    echo -e "\n9. Most Active IPs by Method:"
    echo "GET method top user:";
    grep '"GET ' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -1
    echo "POST method top user:";
    grep '"POST ' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -1
} >> "$OUTPUT_FILE"

# Additional: Failure Patterns by Hour
{
    echo -e "\n10. Failure Patterns by Hour:"
    grep -E 'HTTP/[0-9.]+" [45][0-9]{2}' "$LOG_FILE" | awk -F: '{print $2}' | sort | uniq -c | sort -nr
} >> "$OUTPUT_FILE"

# Analysis Suggestions (placeholder text)
{
    echo -e "\n11. Analysis Suggestions:"
    echo "- Review peak failure hours and investigate root causes."
    echo "- Consider rate limiting for IPs with excessive requests."
    echo "- Optimize endpoints with high POST traffic."
    echo "- Investigate 5xx errors for backend issues."
    echo "- Look into 4xx spikes to improve user experience or security."
} >> "$OUTPUT_FILE"

echo -e "\nAnalysis Complete. Output saved to $OUTPUT_FILE"
