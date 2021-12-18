#!/bin/bash
#
# Author:   Julian Reith
# E-Mail:   julianreith@gmx.de
# Version:  0.03
# Date:     2021-12-17
#
# Description:
#  this script pulls the adlists from https://firebog.net and stores them 
#  in separate lists named by category and type (tick, nocross, all)
#

### GLOBAL VARS ###
TZ='Europe/Berlin'
listDir=lists


### FUNCTIONS ###
function createListDir() {
    mkdir -p $listDir
}

function getFirebogLists {
    # firebog list types, see https://v.firebog.net/hosts/lists.php
    wget -c https://v.firebog.net/hosts/lists.php?type=tick -O $listDir/firebog_tick.list
    wget -c https://v.firebog.net/hosts/lists.php?type=nocross -O $listDir/firebog_nocross.list
    wget -c https://v.firebog.net/hosts/lists.php?type=all -O $listDir/firebog_all.list
}

function updateTimeStamp {
    # at least one file must be updated to prevent git action errors
    TZ=$TZ date +"%Y-%m-%d %H:%m:%S %Z" > $listDir/.timestamp
}


### START OF SCRIPT ###
createListDir
getFirebogLists
updateTimeStamp
