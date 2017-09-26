#!/usr/bin/env bash
# https://docs.microsoft.com/en-us/azure/virtual-machines/scripts/virtual-machines-linux-cli-sample-create-vm-vhd

set -e

if [ -z $1 ];
then
    echo 'Usage: ./make_vm_from_vhd.sh <prefix> <new-prefix> [location]'
    exit
fi

if [ -z $2 ];
then
    echo 'Usage: ./make_vm_from_vhd.sh <prefix> <new-prefix> [location]'
    exit
fi

if [ -z $3 ];
then
    LOCATION=eastus
else
    LOCATION=$3
fi

# Create new VM from image
az vm create \
        --resource-group ${1}rg \
        --location ${LOCATION} \
        --name ${2}vm \
        --image ${2}image \
        --admin-username azure \
        --generate-ssh-keys \
        --custom-data cloud-init-config.txt

if [ ! -f ~/.ssh/azure_id_rsa ];
then
    ssh-keygen -t rsa -b 4096 -C "azure@${2}vm" -f ~/.ssh/azure_id_rsa
fi

# Update user ssh key
az vm user update \
        --resource-group ${1}rg \
        --location ${LOCATION} \
        --name ${2}vm \
        --username azure \
        --ssh-key-value ~/.ssh/azure_id_rsa.pub

# Update the deploy user with your ssh key
#make reset-ssh-key PREFIX=${1} VIRTUAL_MACHINE=${2}vm

# Get public IP address for the VM
IP_ADDRESS=$(az vm list-ip-addresses --resource-group ${1}rg --name ${2}vm \
    --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" -o tsv)

echo "Done!"
echo "You can now ssh using: ssh -i ~/.ssh/azure_id_rsa azure@${2}vm.${LOCATION}.cloudapp.azure.com"
echo "Or, you can ssh using: ssh -i ~/.ssh/azure_id_rsa azure@${IP_ADDRESS}"