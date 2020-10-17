#!/bin/bash
#If running for the fist time follow below instructions:
local platform=$1
init(){
../om install --requirements --platform=$platform ## or [redhat/suse/ubuntu/debian]
cat om-template-config.json | jq '.mongodProcesses[].servers[0,1,2].hostname = $host' --arg host "$(hostname -f)" >om-config.json
echo "Initial configuration done: now you can edit om-config.json for desired Ops Manager versions then run -> sudo ./om install --config=om-config.json"
}