#!/bin/bash

#terraform destroy -auto-approve
echo "terraform destroy -auto-approve"
terraform destroy

#deletes keyvault
echo "deletes keyvault"
az keyvault delete --name $VAULT_NAME --resource-group $RESOURCE_GROUP_NAME

#deletes container
echo "deletes container"
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
az storage container delete --account-key $ACCOUNT_KEY --account-name $STORAGE_ACCOUNT_NAME --name $CONTAINER_NAME

#deletes storage account
echo "deletes storage account"
az storage account delete -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -y

#deletes resource
echo "deletes resource"
az group delete -n $RESOURCE_GROUP_NAME -y

#Hard delete keyvault
echo "Hard delete keyvault"
az keyvault purge --name $VAULT_NAME

#deletes resource group NetworkWatcherRG
echo "deletes resource group NetworkWatcherRG"
az group delete -n "NetworkWatcherRG" -y
