#!/bin/bash

configure_backup(){

    local PRIVATEKEY=$1
    local PUBLICKEY=$2  
    local HEADDB=$3
    local BLOCKSTORE=$4
    local FSSTORE=$5
    local OMHOST=$6

    mkdir -p $HEADDB
    mkdir -p $FSSTORE

    HOSTNAME=`hostname -f`

    # Enable Backup Daemon
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

     # Create Filesystem Store
    curl --user "$PUBLICKEY:$PRIVATEKEY" --digest \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --request POST "http://$OMHOST:8080/api/public/v1.0/admin/backup/snapshot/fileSystemConfigs?pretty=true" \
    --data '{
    "assignmentEnabled" : true,
    "mmapv1CompressionSetting" : "NONE",
    "storePath" : "'$FSSTORE'",
    "id" : "FSSTORE",
    "wtCompressionSetting" : "NONE"
    }'

    #Create Oplog Store
    curl --user "$PUBLICKEY:$PRIVATEKEY" --digest \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --request POST "http://$OMHOST:8080/api/public/v1.0/admin/backup/oplog/mongoConfigs?pretty=true" \
    --data '{
    "assignmentEnabled" : true,
    "encryptedCredentials" : false,
    "labels" : [ "l1", "l2" ],
    "maxCapacityGB" : 8,
    "uri" : "'$BLOCKSTORE'",
    "id" : "OPLOG",
    "ssl" : false,
    "writeConcern" : "W2"
    }'

    #Create Blockstore
    curl --user "$PUBLICKEY:$PRIVATEKEY" --digest \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --request POST "http://$OMHOST:8080/api/public/v1.0/admin/backup/snapshot/mongoConfigs?pretty=true" \
    --data '{
    "assignmentEnabled" : true,
    "encryptedCredentials" : false,
    "loadFactor" : 2,
    "maxCapacityGB" : 8,
    "uri" : "'$BLOCKSTORE'",
    "ssl" : false,
    "id" : "BLOCKSTORE",
    "writeConcern" : "W2"
    }'

}