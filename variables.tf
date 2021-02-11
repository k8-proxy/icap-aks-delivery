variable "azure_region" {
  description = "The Azure Region"
  type        = string
}

variable "suffix" {
  description = "This is a consolidated name based on org, environment, region"
  type        = string
}

variable "RESOURCE_GROUP_NAME" {
    description = "The Azure backend resource group"
    type = string
}

variable "VAULT_NAME" {
    description = "The Azure backend vault name"
    type = string
}

variable "STORAGE_ACCOUNT_NAME" {
    description = "The Azure backend storage account"
    type = string
}

variable "CONTAINER_NAME" {
    description = "The Azure backend container name"
    type = string
}