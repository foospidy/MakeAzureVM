#!/usr/bin/env bash
#https://docs.microsoft.com/en-us/cli/azure/image?view=azure-cli-latest#az_image_create

set -e

if [ -z $1 ];
then
    echo 'Usage: ./make_image_from_vhd.sh <prefix> <new-prefix> [location]'
    exit
fi

if [ -z $2 ];
then
    echo 'Usage: ./make_image_from_vhd.sh <prefix> <new-prefix> [location]'
    exit
fi

if [ -z $3 ];
then
    LOCATION=eastus
else
    LOCATION=$3
fi

echo Create managed disk from vhd...
make create-managed-disk PREFIX=${1} MANAGED_DISK=${2}md

echo Create image from managed disk...
az image create \
        --resource-group ${1}rg \
        --location ${LOCATION} \
        --name ${2}image \
        --os-type Linux \
        --source ${2}md
