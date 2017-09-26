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
echo "You can now run any of the following..."
echo "    ./make_vhd_from_image.sh ${1} ${LOCATION}"
echo "    ./make_vm_from_custom_image.sh ${1} <new-prefix> ${LOCATION}"