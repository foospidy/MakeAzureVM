#!/usr/bin/env bash

if [ -z $1 ];
then
    echo 'Usage: ./s.sh <prefix> [location]'
    exit
fi

if [ -z $2 ];
then
    LOCATION=eastus
else
    LOCATION=$2
fi

ssh -i ~/.ssh/azure_id_rsa azure@${1}.${LOCATION}.cloudapp.azure.com