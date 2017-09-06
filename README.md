# MakeAzureVM
Make a Linux (Ubuntu) based Azure VM!

# Prerequisites

1. [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli#install-on-debianubuntu-with-apt-get)

# Instructions - simple

1. `./make_vm_from_azure_image.sh <prefix> [location]`
2. SSH into VM and install/configure (customize to your needs).
3. `./make_image_from_vm.sh <prefix> [location]`
4. Either...
    - `./make_vhd_from_image.sh <prefix> [location]`
        - `./make_vm_from_vhd.sh <prefix> <new-vm-name> [location]`
    - or
    - `./make_vm_from_custom_image.sh <prefix> <new prefix> [location]`
        - tbd

# Instructions - advanced

Work in progress, do not use.

1. make build-setup
2. make build-image  [IMAGE_SIZE=n] [RELEASE=jessie]

# References

## VM Setup
- https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/virtual-machines/linux/upload-vhd.md
- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-upload-ubuntu
- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/debian-create-upload-vhd
- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-custom-images
- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/capture-image
- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/copy-vm

## VM Config
- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-automate-vm-deployment
- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-portal#install-nginx

## Download VHD from VM

- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/download-vhd
- https://docs.microsoft.com/en-us/azure/virtual-machines/scripts/virtual-machines-linux-cli-sample-copy-snapshot-to-storage-account
