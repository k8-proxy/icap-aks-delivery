# Backend Storage for Statefile
terraform {
  backend "azurerm" {}
}

# Cluster Modules
module "create_aks_cluster_UKWest" {
	source					  =  "./modules/clusters/aks01"

	resource_group            =  "gw-icap-aks-${var.suffix}"
	cluster_name              =  "gw-icap-aks-${var.suffix}-ukw"
	region                    =  "${var.azure_region}"

	vault_resourcegroup_name  =  "${var.RESOURCE_GROUP_NAME}"
	keyvault_name             =  "${var.VAULT_NAME}"
}

module "create_aks_cluster_ARGOCD" {
	source					  =  "./modules/clusters/argocd-cluster"

	resource_group            =  "gw-icap-aks-argocd-${var.suffix}"
	cluster_name              =  "gw-icap-aks-argocd-${var.suffix}"
	region                    =  "${var.azure_region}"


	vault_resourcegroup_name  =  "${var.RESOURCE_GROUP_NAME}"
	keyvault_name             =  "${var.VAULT_NAME}"

}

# Storage Account Modules
module "create_storage_account_NEU" {
	source					  =  "./modules/storage-accounts/storage-account-ukw"

	resource_group_name       =  "gw-icap-aks-storage-${var.suffix}"
	region                    =  "${var.azure_region}"


}

# Key Vault Modules
module "create_key_vault_NEU" {
	source					  = "./modules/keyvaults/keyvault-ukw"

	resource_group            =  "gw-icap-aks-keyvault-${var.suffix}"
	kv_name                   =  "aks-keyvault-${var.suffix}"
	azure_region              =  "${var.azure_region}"
}
