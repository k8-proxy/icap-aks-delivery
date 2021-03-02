#!/bin/bash
# Script adapted from https://docs.microsoft.com/en-us/azure/terraform/terraform-backend.
# We cannot create this storage account and blob container using Terraform itself since
# We are creating the remote state storage for Terraform and Terraform needs this storage in terraform init phase.
# We are also creating the Azure Container Registry to store the icap images.

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $REGION --tags $TAGS

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob --tags $TAGS

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

az keyvault create --name $VAULT_NAME --resource-group $RESOURCE_GROUP_NAME --location $REGION

az keyvault secret set --vault-name $VAULT_NAME --name terraform-backend-key --value $ACCOUNT_KEY

# Create ACR
az acr create --resource-group $RESOURCE_GROUP_NAME --name $CONTAINER_REGISTRY_NAME --sku Premium

# Obtain the full registry ID for subsequent command args
ACR_REGISTRY_ID=$(az acr show --name $CONTAINER_REGISTRY_NAME --query id --output tsv)

# Create the service principal with rights scoped to the registry.
# Default permissions are for docker pull access. Modify the '--role'
# argument value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# owner:       push, pull, and assign roles
DH_SA_PASSWORD=$(az ad sp create-for-rbac --name http://$SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpull --query password --output tsv)
DH_SA_USERNAME=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)

echo "resource group": $RESOURCE_GROUP_NAME
echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"
echo "keyVault": $VAULT_NAME
echo "container_registry: $CONTAINER_REGISTRY_NAME"
echo "Service principal ID: $DH_SA_USERNAME"
echo "Service principal password: $DH_SA_PASSWORD"
