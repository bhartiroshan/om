#!/bin/bash

configure_backup(){

    local PRIVATEKEY=$1
    local PUBLICKEY=$2  
    local HEADDB=$3
    local BLOCKSTORE=$4
    local FSSTORE=$5
    local OMHOST=$6

    mkdir -p $HEADDB
    chown -R 'mongodb-mms':'mongodb-mms' $HEADDB

    mkdir -p $FSSTORE
    chown -R 'mongodb-mms':'mongodb-mms' $FSSTORE

    HOSTNAME=`hostname -f`

    curl --user "$PUBLICKEY:$PRIVATEKEY" --digest \
     --header 'Accept: application/json' \
     --header 'Content-Type: application/json' \
     --request PUT "http://$OMHOST:8080/api/public/v1.0/admin/backup/daemon/configs/$HOSTNAME?pretty=true" \
     --data '{
       "assignmentEnabled" : true,
       "backupJobsEnabled" : true,
       "configured" : true,
       "garbageCollectionEnabled" : true,
       "machine" : {
         "headRootDirectory" : "'$HEADDB'",
         "machine" : "'$HOSTNAME'"
       },
       "numWorkers" : 4,
       "resourceUsageEnabled" : true,
       "restoreQueryableJobsEnabled" : true
     }'

}