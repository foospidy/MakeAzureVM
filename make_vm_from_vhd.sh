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
make create-managed-disk PREFIX=${1} MANAGED_DISK=${2}md

# Create the vm from the managed disk
#az vm create --resource-group ${1}rg \
#        --location ${LOCATION} \
#        --name ${2}vm \
#        --os-type linux \
#        --attach-os-disk ${2}md \
#        --custom-data cloud-init.txt

# https://docs.microsoft.com/en-us/azure/virtual-machines/scripts/virtual-machines-linux-cli-sample-create-vm-vhd
az vm create --resource-group ${1}rg \
            --location ${LOCATION} \
            --name ${2}vm \
            --os-type linux \
            --image "https://${PREFIX}sa.blob.core.windows.net/${PREFIX}sc/${PREFIX}.vhd" \
            --admin-username azure \
            --generate-ssh-keys \
            --custom-data cloud-init.txt


if [ ! -f ~/.ssh/azure_id_rsa ];
then
    ssh-keygen -t rsa -b 4096 -C "azure@${2}vm" -f ~/.ssh/azure_id_rsa
fi

# Update the deploy user with your ssh key
make reset-ssh-key PREFIX=${1} VIRTUAL_MACHINE=${2}vm

# Get public IP address for the VM
IP_ADDRESS=$(az vm list-ip-addresses --resource-group ${1}rg --name ${2} \
    --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" -o tsv)

echo "Done!"
echo "You can now ssh using: ssh -i ~/.ssh/azure_id_rsa azure@${2}.${LOCATION}.cloudapp.azure.com"
echo "Or, you can ssh using: ssh -i ~/.ssh/azure_id_rsa azure@${IP_ADDRESS}"