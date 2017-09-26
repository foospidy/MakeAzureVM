# MakeAzureVM
Make a Linux (Ubuntu) based Azure VM!

# Prerequisites

1. [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli#install-on-debianubuntu-with-apt-get)

# Instructions

Create VHD to be used for creating new VMs.

1. `./make_vm_from_azure_image.sh <prefix> [location]` This step will create the VM with the `cloud-init.txt` file.
2. SSH into VM and customize (if needed).
3. `./make_image_from_vm.sh <prefix> [location]`
4. `./make_vhd_from_image.sh <prefix> [location]`

Create VM from VHD.

1. `./make_image_from_vhd.sh <prefix> <new-prefix> [location]`
2. `./make_vm_from_vhd.sh <prefix> <new-prefix> [location]` This step will create the VM with the `cloud-init.txt` file.

# References

## VM Setup
- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/capture-image?toc=%2Fazure%2Fvirtual-machines%2Flinux%2Ftoc.json
- https://docs.microsoft.com/en-us/azure/marketplace-publishing/marketplace-publishing-vm-image-creation
- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/classic/create-upload-vhdtoc=%2fazure%2fvirtual-machines%2flinux%2fclassic%2ftoc.json
- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/classic/create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2fclassic%2ftoc.json


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
- https://docs.microsoft.com/en-us/azure/virtual-machines/linux/upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json