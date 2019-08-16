#!/bin/sh
DATE_EXEC="$(date "+%d %b %Y %H:%M")" #Collect date & time.
TMPFILE=$(mktemp /tmp/ipinfoXXX.txt) #Create a temporary file to keep data in.
IP=$(echo $SSH_CLIENT | awk '{print $1}') #Get Client IP address.
PORT=$(echo $SSH_CLIENT | awk '{print $3}') #Get SSH port
HOSTNAME=$(hostname -f) #Get hostname
IPADDR=$(hostname -i | awk '{print $1}')
curl https://ipinfo.io/$IP -s -o $TMPFILE #Get info on client IP.
CITY=$(cat $TMPFILE | sed -n 's/^  "city":[[:space:]]*//p' | sed 's/"//g') #Client IP info parsing
REGION=$(cat $TMPFILE | sed -n 's/^  "region":[[:space:]]*//p' | sed 's/"//g')
COUNTRY=$(cat $TMPFILE | sed -n 's/^  "country":[[:space:]]*//p' | sed 's/"//g')
ORG=$(cat $TMPFILE | sed -n 's/^  "org":[[:space:]]*//p' | sed 's/"//g')
TEXT="$DATE_EXEC: ${USER} logged in to $HOSTNAME ($IPADDR) from $IP - $ORG - $CITY, $REGION, $COUNTRY port $PORT"
signal-cli  -u +<senders phone> send -m "$TEXT" +<recipient> #  Replace <>s with phone numbers with the country code.
rm $TMPFILE #clean up after
