#!/bin/sh /etc/rc.common

START=99  # The start priority
# Replace with your details
ZONE_ID=''
API_TOKEN=''

update_dns() {
    RECORD_NAME=$1
    LAST_IP_FILE="/tmp/last_ip_$RECORD_NAME"

    # Check if the last IP file exists and read it
    if [ -f "$LAST_IP_FILE" ]; then
        LAST_IP=$(cat "$LAST_IP_FILE")
    else
        LAST_IP=""
    fi

    # Update only if IPs are different
    if [ "$CURRENT_IP" != "$LAST_IP" ]; then
        # Fetch the record ID
        RESPONSE=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$RECORD_NAME" \
            -H "Authorization: Bearer $API_TOKEN" \
            -H "Content-Type: application/json")
        RECORD_ID=$(echo $RESPONSE | jsonfilter -e '@.result[0].id')

        # Only print this if there's an error then exit
        if [ -z "$RECORD_ID" ]; then
            echo "Failed to fetch Record ID for $RECORD_NAME"
            echo "Response: $RESPONSE"
            return 1
        fi
    else echo "$RECORD_NAME IP record match, no update needed"
    return 0
    fi
    # Update the DNS record
    UPDATE_RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: application/json" \
        --data '{"type":"A","name":"'"$RECORD_NAME"'","content":"'"$IP"'","ttl":1,"proxied":false}')

    # Check if the update was successful
    SUCCESS=$(echo $UPDATE_RESPONSE | jsonfilter -e '@.success')
    if [ "$SUCCESS" != "true" ]; then
        echo "Failed to update $RECORD_NAME"
        echo "Update response: $UPDATE_RESPONSE"
        return 1
    fi
    echo "Domain IP Updated"
    }

start() {
    echo "Running Domain IP updater..."
    while true; do

    if ! update_dns "www.governance.page"; then
        return 1
    fi

    if ! update_dns "governance.page"; then
        return 1
    fi
    # Random delay to make the update time somewhat unpredictable
    # Delay will be between 450 (7.5 minutes) and 900 seconds (15 minutes)
    # RANDOM % 450 gives a range of 0-449, adding 450 sets the range to 450-899
    # and this will rate limit queries
    sleep $((450 + RANDOM % 450))
    # Fetch the current public IP
    CURRENT_IP=$(curl -4 -s http://ifconfig.me)
    done
    }

