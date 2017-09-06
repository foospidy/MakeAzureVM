#!/usr/bin/env bash
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/download-vhd
# https://docs.microsoft.com/en-us/azure/virtual-machines/scripts/virtual-machines-linux-cli-sample-copy-snapshot-to-storage-account

set -e

tmpfile='/tmp/aztmp.txt'

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

echo Stopping VM...
make stop-vm PREFIX=${1}

# get disk name
echo Getting disk name...
disk=$(make list-disks PREFIX=${1} LOCATION=${2} | grep ${1}vm_OsDisk | grep '"id"' | cut -d'/' -f 9 | cut -d'"' -f 1)

# get storage account key data to check if storage account exists
storage_account_key=$(make list-keys PREFIX=${1})

if [[ storage_account_key == *"was not found." ]];
then
    # storage account was not found so create it
    echo Creating storage account and container...
    make create-storage-account PREFIX=${1} LOCATION=${2}

    make create-storage-container PREFIX=${1}
fi

# get storage account key
echo Getting storage account key...
key=$(make list-keys PREFIX=${1} | grep -A 2 key1 | grep value | cut -d'"' -f 4)

# create a snapshot
echo Creating snapshot...
make create-snapshot PREFIX=${1} LOCATION=${2} DISK=${disk}

# grant access to snapshot and get sas
echo Grant access to snapshot and get temporary SAS URL...
sas=$(make grant-access-snapshot PREFIX=${1})

# copy the snapshot to storage container
echo Copying snapshot to storage container...
make copy-storage-blob PREFIX=${1} KEY=$key SAS="${sas}"

# monitor copy status
echo Copy status...
for i in {1..1000}
do
    status=`az storage blob show --account-name=${1}sa --container-name ${1}sc --name ${1}.vhd | grep -A 5 copy | grep status | cut -d'"' -f 4`
    echo $status

    if [[ $status == "success" ]]
    then
        break
    fi

    sleep 5
done
