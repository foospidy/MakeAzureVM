#!/usr/bin/env bash

if [ -z $1 ];
then
    echo 'Usage: ./makevm.sh <prefix>'
    exit
fi

make create-resource-group PREFIX=$1

make create-storage-account PREFIX=$1

make create-storage-container PREFIX=$1

make list-keys PREFIX=$1

echo 'Enter the value for key1 from the output above followed by [ENTER]:'

read key

make upload-vhd PREFIX=$1 KEY=$key

make create-disk PREFIX=$1

make create-vm-managed-image PREFIX=$1
