#!/bin/bash

# Add URL supplied by ChargeHQ developer (Jay)
chargeHQ_URL="https://<enter supplied URL here>"

# Add siteId and envoy ip below
siteId="<siteID>"
local_envoy_ip="envoy"

while true; do

sleep 30 &

envoycontent=$( curl -s -X GET -H "Accept: application/json" "http://$local_envoy_ip/production.json" )
production_kw=$( jq -r '.production[1].wNow/1000' <<< "${envoycontent}" | sed -E 's/\.([0-9]{6})[0-9]*/.\1/g' | sed 's/^-.*/0/' )
consumption_kw=$( jq -r '.consumption[0].wNow/1000' <<< "${envoycontent}" | sed -E 's/\.([0-9]{6})[0-9]*/.\1/g' )

net_import_kw=$( bc <<< "$consumption_kw - $production_kw" | sed -E 's/^(-?)\./\10./' )

if [[ $net_import_kw =~ ['-'] ]]; then
   import_kw=0
   export_kw=${net_import_kw#-}
else
   import_kw=$net_import_kw
   export_kw=0
fi

JSON_payload={\"siteId\":\"$siteId\",\"siteMeters\":{\"import_kw\":$import_kw,\"export_kw\":$export_kw,\"net_import_kw\":$net_import_kw,\"consumption_kw\":$consumption_kw,\"production_kw\":$production_kw}}

curl -s -X PUT -H "Content-Type: application/json" -d "$JSON_payload" "$chargeHQ_URL" > /dev/null

wait
done
