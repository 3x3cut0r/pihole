#!/bin/bash
#
# Author:   Julian Reith
# E-Mail:   julianreith@gmx.de
# Version:  0.16
# Date:     2023-04-17
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
function createDirs() {
    mkdir -p $blacklistDir/regex
    mkdir -p $whitelistDir/regex
    mkdir -p template
}

function getFirebogSectionList () {                                                                        # getFirebogSectionList 'Suspicious Lists'

    # get section
    sectionBegin=$(grep -wn "$1" firebog.html | cut -d: -f1)                                                # 42
    sectionLength=$(tail -n +"$sectionBegin" firebog.html | grep -wn "</ul>" | cut -d: -f1 | head -n 1)     # 19
    tail -n +"$sectionBegin" firebog.html | head -n +"$sectionLength" > section.html                        # section only in html

    # get tickURLs
    sectionFileName=$(echo "Firebog $1 tick.list" | tr '[:upper:]' '[:lower:]' | sed 's/\ lists//g' | sed 's/\&amp\;/and/g' | sed 's/\ /_/g')
    touch $blacklistDir/$sectionFileName
    cat section.html | grep 'li class="bdTick"' | awk -F 'href="' '{print $3 FS ""}' | cut -d'"' -f1 > $blacklistDir/$sectionFileName # cut urls with ticks
    # get nocrossURLs
    sectionFileName=$(echo "Firebog $1 nocross.list" | tr '[:upper:]' '[:lower:]' | sed 's/\ lists//g' | sed 's/\&amp\;/and/g' | sed 's/\ /_/g')
    touch $blacklistDir/$sectionFileName
    cat section.html | grep '<li>' | awk -F 'href="' '{print $3 FS ""}' | cut -d'"' -f1 > $blacklistDir/$sectionFileName # cut urls without ticks and crosses
    # get crossURLs
    sectionFileName=$(echo "Firebog $1 cross.list" | tr '[:upper:]' '[:lower:]' | sed 's/\ lists//g' | sed 's/\&amp\;/and/g' | sed 's/\ /_/g')
    touch $blacklistDir/$sectionFileName
    cat section.html | grep 'li class="bdCross"' | awk -F 'href="' '{print $3 FS ""}' | cut -d'"' -f1 > $blacklistDir/$sectionFileName # cut urls with crosses

    rm -f section.html
}

function getLists {

    # firebog list types, see https://v.firebog.net/hosts/lists.php
    wget -O - https://v.firebog.net/hosts/lists.php?type=tick > $blacklistDir/firebog_tick.list
    wget -O - https://v.firebog.net/hosts/lists.php?type=nocross > $blacklistDir/firebog_nocross.list
    wget -O - https://v.firebog.net/hosts/lists.php?type=all > $blacklistDir/firebog_all.list

    # get section lists from firebog
    wget -O - https://firebog.net > firebog.html
    getFirebogSectionList 'Suspicious Lists'
    getFirebogSectionList 'Advertising Lists'
    getFirebogSectionList 'Tracking &amp; Telemetry Lists'
    getFirebogSectionList 'Malicious Lists'
    getFirebogSectionList 'Other Lists'
    rm -f firebog.html
}

function preparePiholeUpdatelistsConf {

    # get pihole-updatelists-template.conf
    rm -f pihole-updatelists.conf
    wget -O - https://raw.githubusercontent.com/3x3cut0r/pihole/main/template/pihole-updatelists-template.conf > pihole-updatelists.conf

    # ADLISTS_URL
    adlist="https://raw.githubusercontent.com/3x3cut0r/pihole/main/blacklists/firebog_tick.list"
    sed -i "s#ADLISTS_URL=\"\"#ADLISTS_URL=\"$adlist\"#g" pihole-updatelists.conf # on macos: sed -i '' "..." pihole-updatelists.conf

    # WHITELIST_URL
    whitelist="https://raw.githubusercontent.com/3x3cut0r/pihole/main/whitelists/default.list"
    whitelist+=" https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt" # dont foget the leading space!
    whitelist+=" https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/optional-list.txt"
    whitelist+=" https://raw.githubusercontent.com/mmotti/pihole-regex/master/whitelist.list"
    sed -i "s#WHITELIST_URL=\"\"#WHITELIST_URL=\"$whitelist\"#g" pihole-updatelists.conf

    # REGEX_WHITELIST_URL
    whitelistRegex="https://raw.githubusercontent.com/3x3cut0r/pihole/main/whitelists/regex/default.list"
    sed -i "s#REGEX_WHITELIST_URL=\"\ \"#REGEX_WHITELIST_URL=\"$whitelistRegex\"#g" pihole-updatelists.conf

    # BLACKLIST_URL
    blacklist=""
    sed -i "s#BLACKLIST_URL=\"\"#BLACKLIST_URL=\"$blacklist\"#g" pihole-updatelists.conf

    # REGEX_BLACKLIST_URL
    blacklistRegex="https://raw.githubusercontent.com/mmotti/pihole-regex/master/regex.list"
    sed -i "s#REGEX_BLACKLIST_URL=\"\ \"#REGEX_BLACKLIST_URL=\"$blacklistRegex\"#g" pihole-updatelists.conf

    # add 3x3cut0r's Section
    echo -e "\n[3x3_WL_Filehoster]" >> pihole-updatelists.conf
    echo -e 'WHITELIST_URL="https://raw.githubusercontent.com/3x3cut0r/pihole/main/whitelists/filehoster.list"' >> pihole-updatelists.conf
    echo -e 'GROUP_ID=-330' >> pihole-updatelists.conf
    echo -e 'COMMENT="3x3_WL_Filehoster"' >> pihole-updatelists.conf

    # currently not working
    # add blocklistproject groups
    # wget -O - https://raw.githubusercontent.com/3x3cut0r/pihole/main/template/pihole-updatelists.conf.groups > template/pihole-updatelists.conf.groups
    # cat template/pihole-updatelists.conf.groups >> pihole-updatelists.conf

}

function updateTimeStamp {

    # at least one file must be updated to prevent git action errors
    TZ=$TZ date +"%Y-%m-%d %H:%m:%S %Z" > .timestamp
}


### START OF SCRIPT ###
createDirs
getLists
preparePiholeUpdatelistsConf
updateTimeStamp
