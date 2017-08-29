PREFIX?=foo
RESOURCE_GROUP?=resourcegroup
LOCATION?=eastus
STORAGE?=storage
VM?=vm
DISK?=disk
IMAGE_SIZE?=2
RELEASE=jessie

.PHONY: create-resource-group create-storage create-vm

build-setup:
	mkdir -p build
	cd build && git clone https://github.com/credativ/azure-manage
	cd build/azure-manage && cp config.yml.example config.yml

build-image:
	cd build/azure-manage && sudo azure_build_image --option release=$(RELEASE) --option image_size_gb=$(IMAGE_SIZE) --option image_prefix=debian-$(RELEASE)-azure $(RELEASE)
	sudo chown -R $$(whoami):$$(whoami) build/

login:
	az login

create-resource-group:
	az group create --name $(PREFIX)$(RESOURCE_GROUP) --location $(LOCATION)

create-storage-account:
	az storage account create --resource-group $(PREFIX)$(RESOURCE_GROUP) --location $(LOCATION) --name $(PREFIX)$(STORAGE) --kind Storage --sku Standard_LRS

create-vm:
	az vm create --resource-group $(PREFIX)$(RESOURCE_GROUP) --name $(PREFIX)$(VM) --image Debian --generate-ssh-keys

create-storage-container:
	az storage container create --account-name $(PREFIX)$(STORAGE) --name $(DISK)

create-disk:
	az disk create --resource-group $(PREFIX)$(RESOURCE_GROUP) --name $(PREFIX)$(DISK) --source https://mystorageaccount.blob.core.windows.net/mydisks/myDisk.vhd

upload-vhd:
	az storage blob upload --account-name $(PREFIX)$(STORAGE) --container-name $(DISK) --type page --file $$(ls build/azure-manage/*.vhd) --name $(DISK).vhd

list-groups:
	az group list

list-resources:
	az resource list --location $(LOCATION) --resource-group $(PREFIX)$(RESOURCE_GROUP)

list-keys:
	az storage account keys list --resource-group $(PREFIX)$(RESOURCE_GROUP) --account-name $(PREFIX)$(STORAGE)

list-disks:
	az disk list --resource-group $(PREFIX)$(RESOURCE_GROUP) --query '[].{Name:name,URI:creationData.sourceUri}' --output table

delete-resource-group:
	az group delete --name $(PREFIX)$(RESOURCE_GROUP)

clean:
	rm -rf build