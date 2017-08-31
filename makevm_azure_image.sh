#!/usr/bin/env bash
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-cli-complete

set -e

if [ -z $1 ];
then
    echo 'Usage: ./makevm_azure_image.sh <prefix>'
    exit
fi

make create-resource-group PREFIX=$1

make create-virtual-network PREFIX=$1

make create-public-ip PREFIX=$1

make create-network-security-group PREFIX=$1

make create-network-security-group-rule PREFIX=$1 SERVICE=SSH PORT=22 PRIORITY=1000

make create-network-security-group-rule PREFIX=$1 SERVICE=HTTP PORT=80 PRIORITY=1001

make create-virtual-nic PREFIX=$1

make create-availability-set PREFIX=$1

make create-vm-azure-image PREFIX=$1

if [ ! -f ~/.ssh/azure_id_rsa ];
then
    make generate-ssh-keys PREFIX=$1
fi

make reset-ssh-key PREFIX=$1

echo "Done!"
echo "You can now ssh using: ssh -i ~/.ssh/azure_id_rsa azure@${1}.eastus.cloudapp.azure.com"
