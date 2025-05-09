# Log File Analysis with Bash Script

## Objective

This project analyzes Apache access log files using a Bash script to extract meaningful insights and identify potential issues. The analysis helps in understanding request patterns, spotting failures, and suggesting improvements to optimize web service performance.

## Features Implemented

### 1. Request Counts

* Counts the total number of requests.
* Separately counts the number of GET and POST requests.

### 2. Unique IP Addresses

* Counts total unique IPs accessing the server.
* For each IP, reports how many GET and POST requests were made.

### 3. Failure Requests

* Detects all failed requests (status codes 4xx and 5xx).
* Calculates the failure rate as a percentage of total requests.

### 4. Top User

* Identifies the most active IP address based on the number of requests.

### 5. Daily Request Averages

* Calculates the average number of requests per day from the log.

### 6. Failure Analysis by Day

* Shows which days had the highest number of failure responses.

### 7. Request by Hour

* Breaks down the number of requests made during each hour of the day.

### 8. Status Code Breakdown

* Counts how many times each HTTP status code occurred (e.g., 200, 404, 500).

### 9. Most Active User by Method

* Identifies the top IP for GET and the top IP for POST requests.

### 10. Patterns in Failure Requests

* Highlights the specific hours when failures occur most frequently.

### 11. Analysis Suggestions

* Offers practical advice to reduce failures, secure the server, and improve performance based on the data.

## How to Use

1. Place your Apache log file as `server.log` on your Desktop.
2. Run the script:

   ```bash
   ./analyze_log.sh
   ```
3. The analysis report will be generated in the same directory with a timestamped filename.

## Technologies Used

* Bash scripting
* Linux utilities: `awk`, `grep`, `sort`, `uniq`, `bc`

## Deliverables

* `analyze_log.sh`: The main Bash script for log analysis.
* `log_analysis_report_<timestamp>.txt`: The generated report.
* `README.md`: Project overview and instructions.



---

### Author
adham ahmed reda
2205087
