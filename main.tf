# Backend Storage for Statefile
terraform {
  backend "azurerm" {
	resource_group_name  = "gw-icap-tfstate"
    storage_account_name = "tfstate263"
    container_name       = "gw-icap-tfstate"
    key                  = "aks.delivery.terraform.tfstate"
  }
}

# Cluster Modules
module "create_aks_cluster_UKWest" {
	source						="./modules/clusters/aks01"
}

module "create_aks_cluster_file_drop_UKWest" {
	source						="./modules/clusters/file-drop-cluster"
}

# Storage Account Modules
module "create_storage_account_UKWest" {
	source						="./modules/storage-accounts/storage-account-ukw"
}

# Key Vault Modules
module "create_key_vault_UKWest" {
	source						="./modules/keyvaults/keyvault-ukw"
}
