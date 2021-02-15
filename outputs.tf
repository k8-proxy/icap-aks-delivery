output "aks01_cluster_outputs" {
	value 	  = module.create_aks_cluster_UKWest
	sensitive = true
}

output "storage_acccount_outputs" {
	value = module.create_storage_account_NEU
}