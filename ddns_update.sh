#!/bin/sh

A_email=""
A_key=""
zone0=""
record0=""
zone1=""
record1=""

ip=$(curl -s -X GET https://checkip.amazonaws.com)

zone_ip=$(dig +short -4 name.name)

echo "zone ip $zone_ip server ip $ip"
if [ $ip = $zone_ip ]; then
        echo "$zone0 IP has not changed."
else
    zone_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone0" -H "X-Auth-Email: $A_email" -H "X-Auth-Key: $A_key" -H "Content-Type: app>    record_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record0" -H "X-Auth-Email: $A_email" -H "X-Auth-K>    curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" -H "X-Auth-Email: $A_email" -H "X-Auth-Key: $A_key" -H >fi


name_ip2=$(dig +short -4 name.name)
echo "name ip $name_ip2 server ip $ip"
if [ $ip = $name_ip2 ]; then
        echo "$zone1 IP has not changed."
else
    zone_identifier2=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone1" -H "X-Auth-Email: $A_email" -H "X-Auth-Key: $A_key" -H "Content-Type: ap>    record_identifier2=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier2/dns_records?name=$record1" -H "X-Auth-Email: $A_email" -H "X-Auth>    curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier2/dns_records/$record_identifier2" -H "X-Auth-Email: $A_email" -H "X-Auth-Key: $A_key" ->fi