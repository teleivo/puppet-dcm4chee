#!/usr/bin/env bash

# usage is: validate_dcm4chee_jboss_installed.sh <path-to-dcm4chee-home>

DCM4CHEE_HOME=$1
if [ -z $DCM4CHEE_HOME ]; then
    echo 'DCM4CHEE_HOME not specified'
    exit 2
fi

DCM4CHEE_BIN="${DCM4CHEE_HOME}/bin"

if [ -f "${DCM4CHEE_BIN}/run.jar" ]; then
    echo "jboss installed"
    exit 0
else
    echo "jboss not installed"
    exit 1
fi

