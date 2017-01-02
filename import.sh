#!/bin/bash

## Import CSV FAG 04 Octobre 2016

INPUT=extract-log-olfeo.csv
,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while IFS=';' read -r USER IP LOGIN
do
echo "$USER $IP $LOGIN" | /opt/olfeo5/bin/squid_wrapper --squid-id 00 --report-size --no-cache --custom-timestamp
	
done < $INPUT
echo "Traitement terminé"

