#!/usr/bin/env bash
# https://docs.microsoft.com/en-us/azure/virtual-machines/scripts/virtual-machines-linux-cli-sample-create-vm-vhd

set -e

if [ -z $1 ];
then
    echo 'Usage: ./make_vm_from_vhd.sh <prefix> <new-vm-name> [location]'
    exit
fi

if [ -z $2 ];
then
    echo 'Usage: ./make_vm_from_vhd.sh <prefix> <new-vm-name> [location]'
    exit
fi

if [ -z $3 ];
then
    LOCATION=eastus
else
    LOCATION=$3
fi

# Create managed disk from vhd...
make create-managed-disk PREFIX=${1}

# Create the vm from the managed disk
az vm create --resource-group ${1}rg \
        --location ${LOCATION} \
        --name ${2} \
        --os-type linux \
        --attach-os-disk ${1}md 

# Update the deploy user with your ssh key
az vm user update --resource-group ${1}rg \
        --name ${2} \
        --username azure \
        --ssh-key-value "$(< ~/.ssh/azure_id_rsa.pub)"

# Get public IP address for the VM
IP_ADDRESS=$(az vm list-ip-addresses --resource-group ${1}rg --name ${2} \
    --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" -o tsv)

echo "Done!"
echo "You can now ssh using: ssh -i ~/.ssh/azure_id_rsa azure@${2}.${LOCATION}.cloudapp.azure.com"
echo "Or, you can ssh using: ssh -i ~/.ssh/azure_id_rsa azure@${IP_ADDRESS}"