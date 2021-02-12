terraform {
	required_version = ">=0.14.4"
}

provider "helm" {
	features {}
}

provider "azurerm" {
	features {}
}