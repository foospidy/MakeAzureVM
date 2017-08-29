RESOURCE_GROUP?=default-resourcegroup
LOCATION?=eastus
STORAGE?=defaultstorage
VM?=defaultVM
DISK?=defaultDISK
IMAGE_SIZE?=2
RELEASE=jessie

.PHONY: create-resource-group create-storage create-vm

build-setup:
	mkdir -p build
	cd build && git clone https://github.com/credativ/azure-manage
	cd build/azure-manage && cp config.yml.example config.yml

build-image:
	cd build/azure-manage && sudo azure_build_image --option release=$(RELEASE) --option image_size_gb=$(IMAGE_SIZE) --option image_prefix=debian-$(RELEASE)-azure $(RELEASE)

login:
	az login

create-resource-group:
	az group create --name $(RESOURCE_GROUP) --location $(LOCATION)

create-storage:
	az storage account create --resource-group $(RESOURCE_GROUP) --location $(LOCATION) --name $(STORAGE) --kind Storage --sku Standard_LRS

create-vm:
	az vm create --resource-group $(RESOURCE_GROUP) --name $(VM) --image Debian --generate-ssh-keys

create-disk:
	az disk create --resource-group $(RESOURCE_GROUP) --name $(DISK)  --source https://mystorageaccount.blob.core.windows.net/mydisks/myDisk.vhd

list-keys:
	az storage account keys list --resource-group $(RESOURCE_GROUP) --account-name $(STORAGE)

list-disks:
	az disk list --resource-group $(RESOURCE_GROUP) --query '[].{Name:name,URI:creationData.sourceUri}' --output table

delete-resource-group:
	az group delete --name $(RESOURCE_GROUP)

clean:
	rm -rf build