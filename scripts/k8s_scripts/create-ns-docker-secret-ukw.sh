#!/bin/bash

# This script will run create the neccesary namespaces and add the docker service account to the required namespace.

# Naming Variables
RESOURCE_GROUP=$1
VAULT_NAME=$2
CLUSTER_NAME=$3

# Secret Variables
DOCKER_SERVER="$CONTAINER_REGISTRY_NAME.azurecr.io"
USER_EMAIL="mpigram@glasswallsolutions.com"
DOCKER_USERNAME=$(az keyvault secret show --name DH-SA-USERNAME --vault-name $VAULT_NAME --query value -o tsv)
DOCKER_PASSWORD=$(az keyvault secret show --name DH-SA-password --vault-name $VAULT_NAME --query value -o tsv)
FILESHARE_ACCOUNT_NAME=$(az storage account list -g $RESOURCE_GROUP --query "[].name" | awk 'FNR == 2' | tr -d '"[]\040')
FILESHARE_KEY=$(az storage account keys list -g $RESOURCE_GROUP -n $FILESHARE_ACCOUNT_NAME --query "[].value" | awk 'FNR == 2' | tr -d '",\040')
TOKEN_USERNAME=$(az keyvault secret show --name token-username --vault-name $VAULT_NAME --query value -o tsv)
TOKEN_PASSWORD=$(az keyvault secret show --name token-password --vault-name $VAULT_NAME --query value -o tsv)
TOKEN_SECRET=$(az keyvault secret show --name token-secret --vault-name $VAULT_NAME --query value -o tsv)
TRANSACTION_CSV=$(az storage account show-connection-string -g $RESOURCE_GROUP -n $FILESHARE_ACCOUNT_NAME --query connectionString | tr -d '"')
ENCRYPTION_SECRET=$(az keyvault secret show --name encryption-secret --vault-name $VAULT_NAME --query value -o tsv)

SMTPHOST=$(az keyvault secret show --name SmtpHost --vault-name $VAULT_NAME --query value -o tsv)
SMTPPORT=$(az keyvault secret show --name SmtpPort --vault-name $VAULT_NAME --query value -o tsv)
SMTPUSER=$(az keyvault secret show --name SmtpUser --vault-name $VAULT_NAME --query value -o tsv)
SMTPPASS=$(az keyvault secret show --name SmtpPass --vault-name $VAULT_NAME --query value -o tsv)
SMTPSECURESOCKETOPTIONS=$(az keyvault secret show --name SmtpSecureSocketOptions --vault-name $VAULT_NAME --query value -o tsv)

# Namspace Variables
NAMESPACE01="icap-adaptation"
NAMESPACE02="icap-ncfs"
NAMESPACE03="icap-administration"

kubectl config use-context $CLUSTER_NAME

# Create namespaces for deployment
kubectl create ns $NAMESPACE01
kubectl create ns $NAMESPACE02
kubectl create ns $NAMESPACE03

# Create secret for Docker Registry - this only needs to be added to the 'icap-adaptation' and 'icap-administration' namespaces
kubectl create -n $NAMESPACE01 secret docker-registry regcred \
	--docker-server=$DOCKER_SERVER \
	--docker-username=$DOCKER_USERNAME \
	--docker-password="$DOCKER_PASSWORD" \
	--docker-email=$USER_EMAIL

# Create secret for Docker Registry - this only needs to be added to the 'icap-adaptation' and 'icap-administration' namespaces
kubectl create -n $NAMESPACE03 secret docker-registry containerregistry \
	--docker-server=$DOCKER_SERVER \
	--docker-username=$DOCKER_USERNAME \
	--docker-password="$DOCKER_PASSWORD" \
	--docker-email=$USER_EMAIL
	
# Create secrets for the 'icap-adaptation' namespace
kubectl create -n $NAMESPACE01 secret generic policyupdateservicesecret --from-literal=username=$TOKEN_USERNAME --from-literal=password=$TOKEN_PASSWORD

kubectl create -n $NAMESPACE01 secret generic ncfspolicyupdateservicesecret --from-literal=username=$TOKEN_USERNAME --from-literal=password=$TOKEN_PASSWORD

kubectl create -n $NAMESPACE01 secret generic transactionstoresecret --from-literal=azurestorageaccountname=$FILESHARE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$FILESHARE_KEY

kubectl create -n $NAMESPACE01 secret generic transactionqueryservicesecret --from-literal=username=$TOKEN_USERNAME --from-literal=password=$TOKEN_PASSWORD

# Create secret for file share - needs to be part of the 'icap-administration' namespace
kubectl create -n $NAMESPACE03 secret generic smtpsecret \
	--from-literal=SmtpHost=$SMTPHOST \
	--from-literal=SmtpPort=$SMTPPORT \
	--from-literal=SmtpUser=$SMTPUSER \
	--from-literal=SmtpPass=$SMTPPASS \
	--from-literal=SmtpSecureSocketOptions=$SMTPSECURESOCKETOPTIONS

kubectl create -n $NAMESPACE03 secret generic policyupdateserviceref --from-literal=username=$TOKEN_USERNAME --from-literal=password=$TOKEN_PASSWORD 

kubectl create -n $NAMESPACE03 secret generic userstoresecret --from-literal=azurestorageaccountname=$FILESHARE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$FILESHARE_KEY --from-literal=EncryptionSecret=$ENCRYPTION_SECRET

kubectl create -n $NAMESPACE03 secret generic identitymanagementservicesecrets --from-literal=TokenSecret="$TOKEN_SECRET"

kubectl create -n $NAMESPACE03 secret generic policystoresecret --from-literal=azurestorageaccountname=$FILESHARE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$FILESHARE_KEY

kubectl create -n $NAMESPACE03 secret generic transactionqueryserviceref --from-literal=username=$TOKEN_USERNAME --from-literal=password=$TOKEN_PASSWORD

kubectl create -n $NAMESPACE03 secret generic ncfspolicyupdateserviceref --from-literal=username=$TOKEN_USERNAME --from-literal=password=$TOKEN_PASSWORD

# Create secret for file share - needs to be part of the 'icap-ncfs' namespace
kubectl create -n $NAMESPACE02 secret generic ncfspolicyupdateservicesecret --from-literal=username=$TOKEN_USERNAME --from-literal=password=$TOKEN_PASSWORD

# Create secret for TLS certs & keys - needs to be part of the 'icap-adaptation' namespace
(cd ./certs/icap-cert/; kubectl create -n $NAMESPACE01 secret tls icap-service-tls-config --key tls.key --cert certificate.crt)

# Create secret for TLS certs & keys - needs to be part of the 'icap-administration' namespace
(cd ./certs/mgmt-cert/; kubectl create -n $NAMESPACE03 secret tls tls-secret --key tls.key --cert certificate.crt)