#!/bin/bash

# Charge HQ API Endpoint
endpoint="https://api.chargehq.net/api/public/push-solar-data"

# Add apiKey, Envoy IP and interval in seconds below.
apiKey="<apiKey>"
local_envoy_ip="envoy.local"
interval=60
# get token from: https://enlighten.enphaseenergy.com/entrez-auth-token?serial_num=<envoy-serial-number>  
sixMonthToken="<token>"


while true; do

sleep $interval &

# write the sessionId cookie to local file and ignore self signed certificate
session=$( curl -k -m 30 -s -S -c "cookies.jar" -X GET -H "Accept: application/json" -H "Authorization: Bearer $sixMonthToken" "https://$local_envoy_ip/auth/check_jwt" )

# make request with cookie file containing sessionId 
envoycontent=$( curl -k -m 30 -s -S -b "cookies.jar" -X GET -H "Accept: application/json" "https://$local_envoy_ip/production.json" )

production_kw=$( jq -r '.production[1].wNow/1000' <<< "${envoycontent}" | sed -E 's/\.([0-9]{3})[0-9]*/.\1/g' | sed 's/^-.*/0/' )
consumption_kw=$( jq -r '.consumption[0].wNow/1000' <<< "${envoycontent}" | sed -E 's/\.([0-9]{3})[0-9]*/.\1/g' )

net_import_kw=$( bc <<< "$consumption_kw - $production_kw" | sed -E 's/^(-?)\./\10./' )

JSON_payload={\"apiKey\":\"$apiKey\",\"siteMeters\":{\"net_import_kw\":$net_import_kw,\"consumption_kw\":$consumption_kw,\"production_kw\":$production_kw}}

curl -m 30 -s -X POST -H "Content-Type: application/json" -d "$JSON_payload" "$endpoint" > /dev/null

wait
done
