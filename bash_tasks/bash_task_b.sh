#!/bin/bash

#1. From which ip were the most requests?
req_max=$(cat example_log.log | awk '{print $1}' | sort | uniq -c | sort -rn | head -n1 | awk '{print $2}') 

#2. What is the most requested page?
req_page=$(cat example_log.log | awk '{print $11}' | grep -v "-" | sort | uniq -c | sort -nr | less | head -1 | awk '{print $2}')

#3. How many requests were there from each ip?
req_quant=$(cat example_log.log | awk '{print $1}' | sort | uniq -c | sort -n )

#4. What non-existent pages were clients referred to?
non_exist=$(cat example_log.log | grep ' 404 ' | awk '{print $11}' | sort | uniq)

#5. What time did site get the most requests?
#req_time=$(cat example_log.log | awk '{print $4}' | cut -d ":" -f -3 | sort | uniq -c | sort -nr | head -1 | cut -d "[" -f 2) #minutes
req_time=$(cat example_log.log | awk '{print $4}' | sort | cut -d ":" -f -2 | uniq -c | sort -nr | head -1 | cut -d "[" -f 2)  #hours

#6. What search bots have accessed the site? (UA + IP)
search_bots=$(cat example_log.log | grep -i 'bot/.*;\|bot ' | awk '{print $1, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25}' | sort | uniq)

cat <<EOF> taskb.txt
1. The most requests where from: $req_max

2. The most requested page is: $req_page

3. Quantity of requests from each IP:
$req_quant

4. Non-existent pages clients reffered to:
$non_exist

5. The site got the most requests at: $req_time:00-59

6.The search bots have accessed the site are: 
$search_bots
EOF

echo "find the results in taskb.txt"
