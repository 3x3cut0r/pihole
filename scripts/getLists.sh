#!/bin/bash
#
# Author:   Julian Reith
# E-Mail:   julianreith@gmx.de
# Version:  0.05
# Date:     2021-12-21
#
# Description:
#  this script pulls the adlists from https://firebog.net and stores them
#  in separate lists named by category and type (tick, nocross, all)
#

### GLOBAL VARS ###
TZ='Europe/Berlin'
blacklistDir=blacklists
whitelistDir=whitelists


### FUNCTIONS ###
function createListDirs() {
    mkdir -p $blacklistDir/regex
    mkdir -p $whitelistDir/regex
}

function getFirebogSectionList () {                                                                        # getFirebogSectionList 'Suspicious Lists'

    # get section
    sectionBegin=$(grep -wn "$1" firebog.html | cut -d: -f1)                                                # 42
    sectionLength=$(tail -n +"$sectionBegin" firebog.html | grep -wn "</ul>" | cut -d: -f1 | head -n 1)     # 19
    tail -n +"$sectionBegin" firebog.html | head -n +"$sectionLength" > section.html                        # section only in html

    # get greenURLs
    sectionFileName=$(echo "Firebog $1 Green.list" | tr '[:upper:]' '[:lower:]' | sed 's/\ lists//g' | sed 's/\&amp\;/and/g' | sed 's/\ /_/g')
    touch $blacklistDir/$sectionFileName
    cat section.html | grep 'li class="bdTick"' | awk -F 'href="' '{print $3 FS ""}' | cut -d'"' -f1 > $blacklistDir/$sectionFileName # cut urls with ticks
    # get orangeURLs
    sectionFileName=$(echo "Firebog $1 Orange.list" | tr '[:upper:]' '[:lower:]' | sed 's/\ lists//g' | sed 's/\&amp\;/and/g' | sed 's/\ /_/g')
    touch $blacklistDir/$sectionFileName
    cat section.html | grep '<li>' | awk -F 'href="' '{print $3 FS ""}' | cut -d'"' -f1 > $blacklistDir/$sectionFileName # cut urls without ticks and crosses
    # get redURLs
    sectionFileName=$(echo "Firebog $1 Red.list" | tr '[:upper:]' '[:lower:]' | sed 's/\ lists//g' | sed 's/\&amp\;/and/g' | sed 's/\ /_/g')
    touch $blacklistDir/$sectionFileName
    cat section.html | grep 'li class="bdCross"' | awk -F 'href="' '{print $3 FS ""}' | cut -d'"' -f1 > $blacklistDir/$sectionFileName # cut urls with crosses

    rm -f section.html
}

function getFirebogLists {

    # firebog list types, see https://v.firebog.net/hosts/lists.php
    wget -c https://v.firebog.net/hosts/lists.php?type=tick -O $blacklistDir/firebog_tick.list
    wget -c https://v.firebog.net/hosts/lists.php?type=nocross -O $blacklistDir/firebog_nocross.list
    wget -c https://v.firebog.net/hosts/lists.php?type=all -O $blacklistDir/firebog_all.list

    wget -c https://firebog.net -O firebog.html
    getFirebogSectionList 'Suspicious Lists'
    getFirebogSectionList 'Advertising Lists'
    getFirebogSectionList 'Tracking &amp; Telemetry Lists'
    getFirebogSectionList 'Malicious Lists'
    getFirebogSectionList 'Other Lists'
    rm -f firebog.html
}

function getPiholeUpdatelistsConf {

    # get pihole-updatelists-template.conf
    wget -c https://raw.githubusercontent.com/3x3cut0r/pihole/main/template/pihole-updatelists-template.conf -O pihole-updatelists.conf
}

function updateTimeStamp {

    # at least one file must be updated to prevent git action errors
    TZ=$TZ date +"%Y-%m-%d %H:%m:%S %Z" > .timestamp
}


### START OF SCRIPT ###
createDirs
getFirebogLists
updateTimeStamp
