# Overview of the new changes to the Terraform Code

The new Terraform code now deploys the helm charts using the Helm Provider within Terraform/Hashicorp.

This means there will be no need for the following:

- ArgoCD
- ArgoCD Cluster deployment
- ArgoCD Scripts
- ArgoCD Userguide/installation/Deployment README

This takes the complexity of the deployment down and makes it a lot easier for user installation.

## Terraform Code Changes

Additions made to the code are as follows

### Helm Provider

This will call the Helm provider so it can make connection to the newly created cluster. It is taking the host and connection certs straight from the azurerm cluster creation

```HCL
# Get cluster host, certs etc
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.icap-deploy.kube_config.0.host

    client_certificate     = base64decode(azurerm_kubernetes_cluster.icap-deploy.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.icap-deploy.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.icap-deploy.kube_config.0.cluster_ca_certificate)
    }
}
```

### Removal of Service Principle

I removed the below lines that will pull the Service Principle created previously from the specified key vault and use it for the deployment.

```HCL
  service_principal {
    client_id     = data.azurerm_key_vault_secret.spusername.value
    client_secret = data.azurerm_key_vault_secret.sppassword.value
  }
```

In it's place I have added

```HCL
  identity {
    type = "SystemAssigned"
  }
```

Which will create a service principle on creation of the cluster. I'm not 100% sure but this may remove the need to create a service principle at the beginning. We need to test this but would remove a few steps.

### Addition of Helm_Release code

Finally I added the Helm Release code that will deploy the charts to the newly created cluster. I have opted to use to pull some of the charts directly from the chart creators (nginx / cert-manager) as they were causing some errors and causing the tf apply to fail.

```HCL
# Deploy Ingress-Nginx helm chart
resource "helm_release" "ingress-nginx" {
  name             = var.release_name03
  namespace        = var.namespace03
  create_namespace = true
  chart            = var.chart_repo03
  wait             = true
  cleanup_on_fail  = true

  depends_on = [ 
    azurerm_kubernetes_cluster.icap-deploy,
   ]
}

# Deploy Administrastion helm chart
resource "helm_release" "administration" {
  name             = var.release_name04
  namespace        = var.namespace04
  create_namespace = true
  chart            = var.chart_path04
  wait             = false
  cleanup_on_fail  = true
  
  set {
        name  = "secrets"
        value = "null"
    }

  set {
        name  = "managementui.ingress.host"
        value = var.dns_name_02
    }

  set {
        name  = "identitymanagementservice.configuration.ManagementUIEndpoint"
        value = var.dns_name_03
    }

  depends_on = [ 
    azurerm_kubernetes_cluster.icap-deploy,
   ]
}
```

Some things to note: 

- The ```set``` statements are used to change values within the ```values.yaml``` this is going to be used in line with the tfvars changes to customise the DNS names etc.

- The ```deponds_on``` statements are there to make sure that ```terraform destory``` doesn't destroy the cluster first, leaving the charts orhpaned. 

