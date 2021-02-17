variable "resource_group" {
  description = "This is a consolidated name based on org, environment, region"
  type        = string
  default 	  = "gw-icap-aks-delivery"
}

variable "region" {
  description = "The Azure Region"
  type        = string
  default     = "UKWEST"
}

variable "cluster_name" {
  description = "This is a consolidated name based on org, environment, region"
  type        = string
  default     = "gw-icap-aks-delivery-ukw"
}

variable "node_name" {
  description = "This is the resource group containing the Azure Key Vault"
  type        = string
  default     = "gwicapnode"
}

variable "min_count" {
  description = "This is the minimum node count for the autoscaler"
  type        = string
  default     = "4"
}

variable "max_count" {
  description = "This is the maximum node count for the autoscaler"
  type        = string
  default     = "100"
}

# Chart Variables
## Adaptation Chart
variable "release_name01" {
  description = "This is the name of the release"
  type        = string
  default 	  = "adaptation-service"
}

variable "namespace01" {
  description = "This is the name of the namespace"
  type        = string
  default 	  = "icap-adaptation"
}

variable "chart_path01" {
  description = "This is the path to the chart"
  type        = string
  default 	  = "./charts/icap-infrastructure/adaptation"
}

variable "dns_name_01" {
  description = "DNS name for Icap-Service"
  type = string
  default = "icap-client-ukw"
}

variable "icap_port" {
  description = "Public port for the non-tls icap-service"
  type = number
  default = "1344"
}

variable "icap_tlsport" {
  description = "Public port for the tls icap-service"
  type = number
  default = "1345"
}

## Cert-Manager Chart
variable "release_name02" {
  description = "This is the name of the release"
  type        = string
  default 	  = "cert-manager"
}

variable "namespace02" {
  description = "This is the name of the namespace"
  type        = string
  default 	  = "cert-manager"
}

variable "chart_repo02" {
  description = "This is the path to the chart"
  type        = string
  default 	  = "./charts/icap-infrastructure/cert-manager-chart"
}

## Nginx Chart
variable "release_name03" {
  description = "This is the name of the release"
  type        = string
  default 	  = "ingress-nginx"
}

variable "namespace03" {
  description = "This is the name of the namespace"
  type        = string
  default 	  = "ingress-nginx"
}

variable "chart_repo03" {
  description = "This is the path to the chart"
  type        = string
  default 	  = "./charts/icap-infrastructure/ingress-nginx"
}

## Administration Chart
variable "release_name04" {
  description = "This is the name of the release"
  type        = string
  default 	  = "administration-service"
}

variable "namespace04" {
  description = "This is the name of the namespace"
  type        = string
  default 	  = "icap-administration"
}

variable "chart_path04" {
  description = "This is the path to the chart"
  type        = string
  default 	  = "./charts/icap-infrastructure/administration"
}

variable "dns_name_04" {
  description = "DNS name for Management-UI"
  type = string
  default = "management-ui-ukw.ukwest.cloudapp.azure.com"
}

## Rabbitmq-Operator Chart
variable "release_name05" {
  description = "This is the name of the release"
  type        = string
  default 	  = "rabbitmq-operator"
}

variable "namespace05" {
  description = "This is the name of the namespace"
  type        = string
  default 	  = "icap-rabbitmq-operator"
}

variable "chart_path05" {
  description = "This is the path to the chart"
  type        = string
  default 	  = "./charts/icap-infrastructure/rabbitmq-operator"
}

## Rabbitmq-Operator Chart
variable "release_name06" {
  description = "This is the name of the release"
  type        = string
  default 	  = "icap-ncfs"
}

variable "namespace06" {
  description = "This is the name of the namespace"
  type        = string
  default 	  = "icap-ncfs"
}

variable "chart_path06" {
  description = "This is the path to the chart"
  type        = string
  default 	  = "./charts/icap-infrastructure/ncfs"
}