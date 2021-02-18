# Backend Storage for Statefile
terraform {
  backend "azurerm" {

  }
}

# Cluster Modules
module "create_aks_cluster_UKWest" {
	source					  =   "./modules/clusters/aks01"

	resource_group            =   "aks-rg-${var.suffix}"
	region                    =   "${var.azure_region}"
	cluster_name              =   "aks-clu-${var.suffix}"

	icap_port                 =   "${var.icap_port}"
	icap_tlsport              =   "${var.icap_tlsport}"
	dns_name_01               =   "icap-${var.suffix}"
	dns_name_04               =   "management-ui-${var.suffix}.${var.domain}"
	a_record_01				  =   "management-ui-${var.suffix}"


	kv_vault_name            =    "aks-kv-${var.suffix}"
	storage_resource         =    "aks-storage-${var.suffix}"

}

module "create_aks_cluster_file_drop_UKWest" {
	source					  =   "./modules/clusters/file-drop-cluster"

	resource_group            =   "fd-rg-${var.suffix}"
	region                    =   "${var.azure_region}"
	cluster_name              =   "fd-clu-${var.suffix}"
	file_drop_dns_name_01     =   "file-drop-${var.suffix}.${var.domain}"
	a_record_02				  =   "file-drop-${var.suffix}"
}

# Storage Account Modules
module "create_storage_account_UKWest" {
	source					  =   "./modules/storage-accounts/storage-account-ukw"

	resource_group_name       =   "aks-storage-${var.suffix}"
	region                    =   "${var.azure_region}"

}

# Key Vault Modules
module "create_key_vault_UKWest" {
	source					  =   "./modules/keyvaults/keyvault-ukw"

	resource_group            =   "aks-kv-rg-${var.suffix}"
	kv_name                   =   "aks-kv-${var.suffix}"
	icap_dns                  =   "icap-${var.suffix}.ukwest.cloudapp.azure.com"
	mgmt_dns                  =   "management-ui-${var.suffix}.${var.domain}"
	file_drop_dns             =   "file-drop-${var.suffix}.${var.domain}"

	enable_customer_cert     =   "${var.enable_customer_cert}"

}
