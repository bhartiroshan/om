#!/bin/bash

download_mms(){

    local DOWNLOADURL=$1
    local MMSFOLDER=$2
    curl --output $MMSFOLDER.tar.gz $DOWNLOAD_URL

}