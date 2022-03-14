#!/bin/bash

set -e

if [[ $# != 1 ]]; then
	echo usage: `basename $0 aws-profile`
	exit 1
fi

PROFILE=$1

# Used for directory and file names
SANITIZED_PROFILE=`echo $PROFILE | sed 's~/~_~g'`

# Hosted zones are global resources, so only check one region
get_all_hosted_zones(){
	aws --profile $PROFILE route53 list-hosted-zones --region us-east-1 | jq '.HostedZones[].Id' | sed -e 's/"//g' -e 's~/hostedzone/~~g'
}

# Retrieve and save the resource record sets for a hosted zone
save_resource_record_sets(){
	HOSTED_ZONE_ID=$1

	mkdir -p resource-record-sets/$SANITIZED_PROFILE

	# If the details have not already been retrieved, retrieve them
	if [ ! -f "resource-record-sets/$SANITIZED_PROFILE/$HOSTED_ZONE_ID.json" ]; then
		aws --profile $PROFILE route53 list-resource-record-sets --region us-east-1 --hosted-zone-id $HOSTED_ZONE_ID > resource-record-sets/$SANITIZED_PROFILE/$HOSTED_ZONE_ID.json || sleep 5 && save_resource_record_sets $HOSTED_ZONE_ID
	fi
}

main(){
	echo -e "$PROFILE\n"

	aws --profile $PROFILE sso login

	# Save resource record sets from all hosted zones
	for HOSTED_ZONE_ID in `get_all_hosted_zones`; do
		echo -e "\t$HOSTED_ZONE_ID"
		save_resource_record_sets $HOSTED_ZONE_ID
	done

	mkdir -p results
	grep -rli 'mailgun' resource-record-sets/$SANITIZED_PROFILE | node filter-hosted-zone-files.js > results/$SANITIZED_PROFILE.txt
	echo The results have been written to results/$SANITIZED_PROFILE.txt
}

main
