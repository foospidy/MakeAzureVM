#!/usr/bin/env bash
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-custom-images
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/capture-image

set -e

if [ -z $1 ];
then
    echo 'Usage: ./make_vm_from_custom_image.sh <prefix> <new prefix> [location]'
    exit
fi

if [ -z $2 ];
then
    echo 'Usage: ./make_vm_from_custom_image.sh <prefix> <new prefix> [location]'
    exit
fi

if [ -z $3 ];
then
    LOCATION=eastus
else
    LOCATION=$3
fi

make create-vm-generalized-image PREFIX=$1 NEW_PREFIX=$2 LOCATION=$LOCATION

if [ ! -f ~/.ssh/azure_id_rsa ];
then
    ssh-keygen -t rsa -b 4096 -C "azure@${2}vm" -f ~/.ssh/azure_id_rsa
fi

az vm user update --resource-group ${1}vm --name ${2}vm --username azure --ssh-key-value ~/.ssh/azure_id_rsa.pub

echo "Done!"
echo "You can now ssh using: ssh -i ~/.ssh/azure_id_rsa azure@${2}.${LOCATION}.cloudapp.azure.com"