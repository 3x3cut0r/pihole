#!/bin/bash
#
# Author:   Julian Reith
# E-Mail:   julianreith@gmx.de
# Version:  0.01
# Date:     2021-12-17
#
# Description:
#  this script pulls the adlists from https://firebog.net and stores them 
#  in separate lists named by category and type (tick, nocross, all)
#

### GLOBAL VARS ###
listDir=lists


### FUNCTIONS ###
function createListDir() {
    mkdir -p $listDir
}

### START OF SCRIPT ###
pwd
createListDir
touch $listDir/list.php
