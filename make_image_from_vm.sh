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

echo 'Open another terminal and complete the following steps before continuing:'
echo ''
echo "ssh -i ~/.ssh/azure_id_rsa azure@${1}.eastus.cloudapp.azure.com"
echo 'sudo waagent -deprovision+user -force'
echo 'exit'
echo ''
echo 'Press [ENTER] to continue...'

read nothing

make deallocate-vm PREFIX=$1 LOCATION=$LOCATION

make generalize-vm PREFIX=$1 LOCATION=$LOCATION

make create-generalized-image PREFIX=$1 LOCATION=$LOCATION

echo "Done!"
echo "You can now run ./make_vm_from_custom_image.sh ${1} <new prefix> ${LOCATION}"