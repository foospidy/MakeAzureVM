#!/usr/bin/env bash
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-cli-complete

set -e

if [ -z $1 ];
then
    echo 'Usage: ./make_vm_from_azure_image.sh <prefix> [location]'
    exit
fi

if [ -z $2 ];
then
    LOCATION=eastus
else
    LOCATION=$2
fi

make create-resource-group PREFIX=$1 LOCATION=$LOCATION

make create-virtual-network PREFIX=$1 LOCATION=$LOCATION

make create-public-ip PREFIX=$1 LOCATION=$LOCATION

make create-network-security-group PREFIX=$1 LOCATION=$LOCATION

make create-network-security-group-rule PREFIX=$1 LOCATION=$LOCATION SERVICE=SSH PORT=22 PRIORITY=1000

make create-network-security-group-rule PREFIX=$1 LOCATION=$LOCATION SERVICE=HTTP PORT=80 PRIORITY=1001

make create-virtual-nic PREFIX=$1 LOCATION=$LOCATION

make create-availability-set PREFIX=$1 LOCATION=$LOCATION

make create-vm-azure-image PREFIX=$1 LOCATION=$LOCATION

if [ ! -f ~/.ssh/azure_id_rsa ];
then
    make generate-ssh-keys PREFIX=$1 LOCATION=$LOCATION
fi

make reset-ssh-key PREFIX=$1 LOCATION=$LOCATION

echo "Done!"
echo "You can now ssh using: ssh -i ~/.ssh/azure_id_rsa azure@${1}.${LOCATION}.cloudapp.azure.com"