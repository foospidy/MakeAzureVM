PREFIX?=foo

# Compute Resources
RESOURCE_GROUP?=$(PREFIX)rg
STORAGE_ACCOUNT?=$(PREFIX)sa
STORAGE_CONTAINER?=$(PREFIX)sc
MANAGED_DISK?=$(PREFIX)md
VIRTUAL_MACHINE?=$(PREFIX)vm

# Networking Resources
NETWORK_SECURITY_GROUP?=$(PREFIX)nsg
NETWORK_SECURITY_GROUP_RULE?=$(PREFIX)nsgr

# Other
LOCATION?=eastus
SERVICE?=SSH
PORT?=22
PRIORITY?=1000
PROTOCOL?=tcp
IMAGE_SIZE?=2
RELEASE?=jessie
KEY?=setme

.PHONY: create-resource-group create-storage create-vm

build-setup:
	mkdir -p build
	cd build && git clone https://github.com/credativ/azure-manage
	cd build/azure-manage && cp config.yml.example config.yml

build-image:
	cd build/azure-manage && sudo azure_build_image --option release=$(RELEASE) --option image_size_gb=$(IMAGE_SIZE) --option image_prefix=debian-$(RELEASE)-azure --option password=pumpernickel $(RELEASE)
	sudo chown -R $$(whoami):$$(whoami) build/

login:
	az login

create-resource-group:
	az group create --name $(RESOURCE_GROUP) --location $(LOCATION)

create-storage-account:
	az storage account create --resource-group $(RESOURCE_GROUP) --location $(LOCATION) --name $(STORAGE_ACCOUNT) --kind Storage --sku Standard_LRS

create-storage-container:
	az storage container create --account-name $(STORAGE_ACCOUNT) --name $(STORAGE_CONTAINER)

create-disk:
	az disk create --resource-group $(RESOURCE_GROUP) --name $(MANAGED_DISK) --source https://$(STORAGE_ACCOUNT).blob.core.windows.net/$(STORAGE_CONTAINER)/$(STORAGE_CONTAINER).vhd

create-virtual-network:
	az network vnet create --resource-group $(RESOURCE_GROUP) --name $(PREFIX)vnet --address-prefix 192.168.0.0/16 --subnet-name $(PREFIX)subnet --subnet-prefix 192.168.1.0/24

create-public-ip:
	az network public-ip create --resource-group $(RESOURCE_GROUP) --name $(PREFIX)publicip --dns-name $(PREFIX)

create-network-security-group:
	az network nsg create --resource-group $(RESOURCE_GROUP) --name $(NETWORK_SECURITY_GROUP)

create-network-security-group-rule:
	az network nsg rule create \
		--resource-group $(RESOURCE_GROUP) \
		--nsg-name $(NETWORK_SECURITY_GROUP) \
		--name $(NETWORK_SECURITY_GROUP_RULE)$(SERVICE) \
		--protocol $(PROTOCOL) \
		--priority $(PRIORITY) \
		--destination-port-range $(PORT) \
		--access allow

create-virtual-nic:
	az network nic create \
    --resource-group $(RESOURCE_GROUP) \
    --name $(PREFIX)nic \
    --vnet-name $(PREFIX)vnet \
    --subnet $(PREFIX)subnet \
    --public-ip-address $(PREFIX)publicip \
    --network-security-group $(NETWORK_SECURITY_GROUP) \
	--api-version 2016-12-01

create-availability-set:
	az vm availability-set create \
    	--resource-group $(RESOURCE_GROUP) \
    	--name $(PREFIX)as

create-vm-azure-image:
	#az vm create --resource-group $(RESOURCE_GROUP) --name $(VIRTUAL_MACHINE) --image UbuntuLTS --generate-ssh-keys
	#az vm create --resource-group $(RESOURCE_GROUP) --name $(VIRTUAL_MACHINE) --image Debian --generate-ssh-keys
	az vm create \
    	--resource-group $(RESOURCE_GROUP) \
    	--name $(VIRTUAL_MACHINE) \
   		--location $(LOCATION) \
   		--availability-set $(PREFIX)as \
    	--nics $(PREFIX)nic \
    	--image UbuntuLTS \
    	--admin-username azure \
    	--generate-ssh-keys

create-vm-managed-image:
	az vm create --resource-group $(RESOURCE_GROUP) --name $(VIRTUAL_MACHINE) --attach-os-disk $(MANAGED_DISK) --os-type linux

upload-vhd:
	az storage blob upload --account-key $(KEY) --account-name $(STORAGE_ACCOUNT) --container-name $(STORAGE_CONTAINER) --type page --file $$(ls build/azure-manage/*.vhd) --name $(STORAGE_CONTAINER).vhd

list-groups:
	az group list

list-resources:
	az resource list --location $(LOCATION) --resource-group $(RESOURCE_GROUP)

list-keys:
	az storage account keys list --resource-group $(RESOURCE_GROUP) --account-name $(STORAGE_ACCOUNT)

list-disks:
	az disk list --resource-group $(RESOURCE_GROUP) --query '[].{Name:name,URI:creationData.sourceUri}' --output table

delete-resource-group:
	az group delete --name $(RESOURCE_GROUP)

clean:
	rm -rf build