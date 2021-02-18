variable "azure_region" {
  description = "Metadata Azure Region"
  type        = string
  default     = "UKWEST"
}

variable "resource_group" {
  description = "Azure Resource Group"
  type        = string
  default     = "gw-icap-aks-delivery-keyvault"
}

variable "kv_name" {
  description = "The name of the key vault"
  type        = string
  default  = "aks-delivery-keyvault-01"
}

variable "icap_dns" {
  description = "Name of the common name used for the certs"
  type        = string
  default     = "icap-client.ukwest.cloudapp.azure.com"
}

variable "mgmt_dns" {
  description = "Name of the common name used for the certs"
  type        = string
  default     = "management-ui.ukwest.cloudapp.azure.com"
}

variable "file_drop_dns" {
  description = "Name of the common name used for the certs"
  type        = string
  default     = "file-drop.ukwest.cloudapp.azure.com"
}

variable "enable_customer_cert" {
    description = "The Azure backend storage account"
    type = bool
    default = false
}


