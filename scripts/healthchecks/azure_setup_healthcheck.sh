#!/bin/bash

resource_group=$(az group exists -n $RESOURCE_GROUP_NAME)
storage_account=$(az storage account show --name $STORAGE_ACCOUNT_NAME 2>/dev/null | jq -r  '.name')
container=$(az storage container exists --account-name $STORAGE_ACCOUNT_NAME  --account-key $ARM_ACCESS_KEY --name $CONTAINER_NAME 2>/dev/null | jq '.exists')
keyvault=$(az keyvault show --name $VAULT_NAME 2>/dev/null | jq -r '.name')

red=`tput setaf 1`
white=`tput sgr 0`
green=`tput setaf 2`

# Check $RESOURCE_GROUP_NAME exists
if [ "$resource_group" = "true" ]; then
  echo ${green}
  echo "Resource group \"$RESOURCE_GROUP_NAME\" is present";
  echo ${white}

else
  echo ${red}
  echo "Resource group $RESOURCE_GROUP_NAME is not there";
  echo "Please run below command";
  echo "az group create --name $RESOURCE_GROUP_NAME --location $REGION --tags $TAGS"
  echo ${white}
fi

# Check $STORAGE_ACCOUNT_NAME exists
if [ "$storage_account" = "$STORAGE_ACCOUNT_NAME" ];  then
  echo ${green}
  echo "Storage account $STORAGE_ACCOUNT_NAME\" is preset";
  echo ${white}
else
  echo ${red}
  echo "Storage account \"$STORAGE_ACCOUNT_NAME\" is not present";
  echo "Please run below command";
  echo "az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob --tags $TAGS"
  echo ${white}

fi

# Check $ACCOUNT_KEY exists
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

if [ -z "$ACCOUNT_KEY" ]; then
  echo ${red}
  echo "ACCOUNT_KEY is not there";
  echo "Please fix below error";
  echo "$ACCOUNT_KEY"
  echo ${white}

else
  echo ${green}
  echo "ACCOUNT_KEY is verified";
  echo ${white}

fi

# Check $CONTAINER_NAME exists
if [ "$container" = "true" ]; then
  echo ${green}
  echo "Container \"$CONTAINER_NAME\" is present";
  echo ${white}

else
  echo ${red}
  echo "Container $CONTAINER_NAME is not there";
  echo "Please run below command";
  echo "az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY"
  echo ${white}
fi

# Check $KEY_VAULT exists
if [ "$keyvault" = "$VAULT_NAME" ]; then
  echo ${green}
  echo "Keyvault $VAULT_NAME is present";
  echo ${white}
  parent_resource=$(az keyvault show --name $VAULT_NAME 2>/dev/null | jq -r '.resourceGroup')

  if [ "$parent_resource"  != $RESOURCE_GROUP_NAME ]; then
      echo ${red}
      echo "$keyvault belongs to differnet resource group $RESOURCE_GROUP_NAME";
      echo "We suggest you to give unique keyvault name and try below command";
      echo "export $VAULT_NAME='' "
      echo "az keyvault create --name $VAULT_NAME --resource-group $RESOURCE_GROUP_NAME --location $REGION"
      echo ${white}
  fi

else
  echo ${red}
  echo "$keyvault is not there";
  echo "Please run below command";
  echo "az keyvault create --name $VAULT_NAME --resource-group $RESOURCE_GROUP_NAME --location $REGION"
  echo ${white}
fi


# Check terraform_backend_key is added to keyvault
terraform_backend_key=$(az keyvault secret show --name terraform-backend-key --vault-name $VAULT_NAME --query value -o tsv)
if [ -z "$terraform_backend_key" ]; then
  echo ${red}
  echo "$terraform_backend_key is not set in $VAULT_NAME";
  echo "Please run below command";
  echo "az keyvault secret set --vault-name $VAULT_NAME --name terraform-backend-key --value $ACCOUNT_KEY"
  echo ${white}

else
  echo ${green}
  echo "Secret \"terraform_backend_key\" is set in keyvault \"$VAULT_NAME\"";
  echo ${white}
fi





