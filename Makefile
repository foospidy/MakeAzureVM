RESOURCE_GROUP?=default-resourcegroup
LOCATION?=eastus
STORAGE?=defaultstorage

.PHONY: create-resource-group create-storage create-vm

login:
	az login

create-resource-group:
	az group create --name $(RESOURCE_GROUP) --location $(LOCATION)

create-storage:
	az storage account create --resource-group $(RESOURCE_GROUP) --location $(LOCATION) --name $(STORAGE) --kind Storage --sku Standard_LRS

create-vm:
	az vm create --resource-group $(RESOURCE_GROUP) --name defaultVM --image Debian --generate-ssh-keys

create-disk:
	az disk create --resource-group $(RESOURCE_GROUP) --name defaultDISK  --source https://mystorageaccount.blob.core.windows.net/mydisks/myDisk.vhd

list-keys:
	az storage account keys list --resource-group $(RESOURCE_GROUP) --account-name $(STORAGE)

list-disks:
	az disk list --resource-group $(RESOURCE_GROUP) --query '[].{Name:name,URI:creationData.sourceUri}' --output table

delete-resource-group:
	az group delete --name $(RESOURCE_GROUP)
