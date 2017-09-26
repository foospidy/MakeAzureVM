#!/usr/bin/env bash
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-custom-images
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/capture-image

set -e

if [ -z $1 ];
then
    echo 'Usage: ./make_image_from_vm.sh <prefix> [location]'
    exit
fi

if [ -z $2 ];
then
    LOCATION=eastus
else
    LOCATION=$2
fi

ssh -t -oStrictHostKeyChecking=no -i ~/.ssh/azure_id_rsa azure@${1}.${LOCATION}.cloudapp.azure.com "sudo waagent -deprovision+user -force"

make deallocate-vm PREFIX=$1 LOCATION=$LOCATION

make generalize-vm PREFIX=$1 LOCATION=$LOCATION

make create-generalized-image PREFIX=$1 LOCATION=$LOCATION

echo "Done!"
