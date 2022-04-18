Bash script to take solar data from local Enphase Envoy and push it to the ChargeHQ API.
Allows charging EV with excess solar.

Works with version 5 Envoy firmware.  
Version 7 will break the http auth and require further work.    
Uses the Envoy production.json data.

Modify the following values in the script:

chargeHQ_URL = `'https://<ChargeHQ API URL as provided by Jay>'`  
local_envoy_ip = Leave as `'envoy'` or change to your Envoy IP address  
siteId = `'<your siteId as provided by ChargeHQ>'`  

The script runs in an infinite loop updating data every 30 seconds. Time interval set by the sleep command.

Negative net_import = exporting  

Full API not documented as not publicly available.

Requirements: jq & bc

eg.  
sudo apt install jq bc
