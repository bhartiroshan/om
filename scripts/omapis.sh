#!/bin/bash

##Create first user in Ops Manager
create_user(){
  local omhost=$1
  local username=$2
  local password=$3
  local firstname=$4
  local firstname=$5

  curl --digest \
     --header "Accept: application/json" \
     --header "Content-Type: application/json" \
     --request POST "http://$omhost:8080/api/public/v1.0/unauth/users?pretty=true&whitelist=0.0.0.0" \
     --data '
       {
         "username": "'$username'",
         "password": "'$password'",
         "firstName": "'$firstname'",
         "lastName": "'$lastname'"
       }'   
}

prechecks(){

    local AUTOMATIONDIR=$1
    local OMRELEASEDIR=$2
    local CONFDIR=$3
    local MONGODRELEASES=$4
 
    if [[ -d "$AUTOMATIONDIR" ]]
    then
        echo "Skipping creating $AUTOMATIONDIR directory, it already exists."
    else
        mkdir -p $AUTOMATIONDIR
    fi

    if [[ -d "$OMRELEASEDIR" ]]
    then
        echo "Skipping creating $OMRELEASEDIR directory, it already exists."
    else
        mkdir -p $OMRELEASEDIR
    fi

    if [[ -d "$CONFDIR" ]]
    then
        echo "Skipping creating $CONFDIR directory, it already exists."
    else
        mkdir -p $CONFDIR
    fi

    if [[ -d "$MONGODRELEASES" ]]
    then
        echo "Skipping creating $MONGODRELEASES directory, it already exists."
    else
        mkdir -p $MONGODRELEASES
    fi

    if [[ -f "$OMRELEASEDIR/omreleases.json" ]]
    then
        echo "The file omreleases.json already exist in $OMRELEASEDIR, skip downloadint it."
    else    
        sudo curl --output $OMRELEASEDIR/omreleases.json https://info-mongodb-com.s3.amazonaws.com/com-download-center/ops_manager_release_archive.json
    fi

    if [[ -d "$OMRELEASEDIR/mongodb-mms-automation" ]]
    then
        echo "Folder $OMRELEASEDIR/mongodb-mms-automation exists. Skip downloading a new Automation Agent"
    else
            wget -P $OMRELEASEDIR https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-10.17.0.6529-1.linux_x86_64.tar.gz 
            tar -xvzf $OMRELEASEDIR/mongodb-mms-automation-agent-10.17.0.6529-1.linux_x86_64.tar.gz --directory $OMRELEASEDIR
            mv $OMRELEASEDIR/mongodb-mms-automation-agent-10.17.0.6529-1.linux_x86_64 $OMRELEASEDIR/mongodb-mms-automation
    fi
}