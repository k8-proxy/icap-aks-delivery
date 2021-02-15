# Backend Storage for Statefile
terraform {
  backend "azurerm" {
	resource_group_name  = "gw-icap-tfstate-sam-t8"
    storage_account_name = "tfstate263samt8"
    container_name       = "gw-icap-tfstate-sam-t8"
    key                  = "samt8.delivery.terraform.tfstate"
  }
}

# Cluster Modules
module "create_aks_cluster_UKWest" {
	source						="./modules/clusters/aks01"
}

# Storage Account Modules
module "create_storage_account_NEU" {
	source						="./modules/storage-accounts/storage-account-ukw"
}

# Key Vault Modules
module "create_key_vault_NEU" {
	source						="./modules/keyvaults/keyvault-ukw"
}
