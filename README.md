Bash script to take solar & consumption data locally from Enphase Envoy and push it to the Charge HQ API.
Allows charging EV with excess solar.

Further information on Push API obtainable from Charge HQ https://chargehq.net/kb/push-api 

Known working with version 5 Envoy firmware.  

Uses the Envoy production.json data.

Modify the following values in the script:

local_envoy_ip = Leave as `'envoy'` or change to your Envoy IP address  
apiKey = `'<your apiKey>'` (obtainable from https://app.chargehq.net/config/energy-monitor)
interval = `60` (Do not set less than 30s as per Charge HQ instructions) 

The script runs in an infinite loop. Remove while/sleep/wait/done commands if you prefer to use crontab. 

Negative net_import = exporting  

Requirements: jq & bc

eg.  
sudo apt install jq bc
