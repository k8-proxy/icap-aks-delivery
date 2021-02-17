# Backend Storage for Statefile
terraform {
  backend "azurerm" {
  }
}

# Cluster Modules
module "create_aks_cluster_UKWest" {
	source					  =   "./modules/clusters/aks01"

	resource_group            =   "gw-icap-aks-${var.suffix}"
	region                    =   "${var.azure_region}"
	cluster_name              =   "gw-icap-aks-${var.suffix}-ukw"
	dns_name_01               =   "icap-client-ukw-${var.suffix}"
	icap_port                 =   "${var.icap_port}"
	icap_tlsport              =   "${var.icap_tlsport}"
	dns_name_04               =   "management-ui-ukw-${var.suffix}.ukwest.cloudapp.azure.com"

	kv_vault_name            =    "aks-${var.suffix}-keyvault-01"
	storage_resource         =    "gw-icap-aks-${var.suffix}-storage"

}

module "create_aks_cluster_file_drop_UKWest" {
	source					  =   "./modules/clusters/file-drop-cluster"

	resource_group            =   "gw-icap-aks-fd-${var.suffix}-ukw"
	region                    =   "${var.azure_region}"
	cluster_name              =   "gw-icap-aks-fd-${var.suffix}"
	file_drop_dns_name_01     =   "file-drop-ukw-${var.suffix}.ukwest.cloudapp.azure.com"

}

# Storage Account Modules
module "create_storage_account_UKWest" {
	source					  =   "./modules/storage-accounts/storage-account-ukw"

	resource_group_name       =   "gw-icap-aks-${var.suffix}-storage"
	region                    =   "${var.azure_region}"

}

# Key Vault Modules
module "create_key_vault_UKWest" {
	source					  =   "./modules/keyvaults/keyvault-ukw"

	resource_group            =   "gw-icap-aks-${var.suffix}-keyvault"
	kv_name                   =   "aks-${var.suffix}-keyvault-01"
	icap_dns                  =   "icap-client-ukw-${var.suffix}.ukwest.cloudapp.azure.com"
	mgmt_dns                  =   "management-ui-ukw-${var.suffix}.ukwest.cloudapp.azure.com"
	file_drop_dns             =   "file-drop-ukw-${var.suffix}.ukwest.cloudapp.azure.com"

	enable_cutomser_cert     =  "${var.enable_cutomser_cert}"

}
