# Get cluster host, certs etc
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.file-drop.kube_config.0.host

    client_certificate     = base64decode(azurerm_kubernetes_cluster.file-drop.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.file-drop.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.file-drop.kube_config.0.cluster_ca_certificate)
    }
}

resource "azurerm_kubernetes_cluster" "file-drop" {
  name                = var.cluster_name
  location            = var.region
  resource_group_name = var.resource_group
  dns_prefix          = "${var.cluster_name}-k8s"

  default_node_pool {
    name            = var.node_name
    node_count      = 1
    vm_size         = "Standard_A4_v2"
    os_disk_size_gb = 40
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    created_by         = "Glasswall Solutions"
    deployment_version = "1.0.0"
  }
}

# Deploy File-Drop helm chart
resource "helm_release" "file-drop" {
  name             = var.release_name01
  namespace        = var.namespace01
  create_namespace = true
  chart            = var.chart_path01
  wait             = true
  cleanup_on_fail  = true
  
  set {
        name  = "secrets"
        value = "null"
    }
  
  set {
        name  = "nginx.ingress.host"
        value = var.dns_name_01
    }

  depends_on = [ 
    azurerm_kubernetes_cluster.file-drop,
    helm_release.cert-manager,
    helm_release.ingress-nginx,
   ]
}

# Deploy Cert-Manager helm chart
resource "helm_release" "cert-manager" {
  name             = var.release_name02
  chart            = var.chart_repo02
  wait             = true
  cleanup_on_fail  = true

  depends_on = [ 
    azurerm_kubernetes_cluster.file-drop,
   ]
}

# Deploy Ingress-Nginx helm chart
resource "helm_release" "ingress-nginx" {
  name             = var.release_name03
  namespace        = var.namespace03
  create_namespace = true
  chart            = var.chart_repo03
  wait             = true
  cleanup_on_fail  = true

  depends_on = [ 
    azurerm_kubernetes_cluster.file-drop,
   ]
}

resource "null_resource" "get_kube_context" {

 provisioner "local-exec" {

    command = "/bin/bash az aks get-credentials --resource-group ${var.resource_group} --name ${var.cluster_name} --overwrite-existing"
  }
  
  depends_on = [
    azurerm_kubernetes_cluster.file-drop,
  ]
}