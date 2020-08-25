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
     --include \
     --request POST "http://$omhost:8080/api/public/v1.0/unauth/users?pretty=true&whitelist=0.0.0.0" \
     --data '
       {
         "username": "'$username'",
         "password": "'$password'",
         "firstName": "'$firstname'",
         "lastName": "'$lastname'"
       }'   
}
