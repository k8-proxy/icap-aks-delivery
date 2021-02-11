# Instructions
## Table of contents

- [Instructions](#instructions)
  * [1. Pre-requisites](#1-pre-requisites)
    + [1.1 Installation of Pre-requisites](#11-installation-of-pre-requisites)
    + [Terraform install](#terraform-install)
    + [Kubectl install](#kubectl-install)
    + [Open SSL](#open-ssl)
    + [JSON processor (jq)](#json-processor)
  * [2. Usage](#2-usage)
    + [2.1 Clone Repo](#21-clone-repo)
    + [2.2 Firstly make sure you are logged in and using the correct subscription.](#22-firstly-make-sure-you-are-logged-in-and-using-the-correct-subscription)
    + [2.3 Create azure initial setup](#23-create-azure-initial-setup)
    + [2.4 Create terraform service principle](#24-create-terraform-service-principle)
    + [2.5 Add Secrets to main KeyVault](#25-add-secrets-to-main-keyvault)
    + [2.6 Add Terraform Backend Key to Environment](#26-add-terraform-backend-key-to-environment)
    + [2.7 File Modifications](#27-file-modifications)
  * [3. Deployment](#3-deployment)
    + [3.1 Setup and Initialise Terraform](#31-setup-and-initialise-terraform)
    + [3.2 Switch Context](#32-switch-context)
    + [3.3 Loading Secrets into key vault.](#33-loading-secrets-into-key-vault)
    + [3.4 Creating SSL Certs](#34-creating-ssl-certs)
    + [3.5 Create Namespaces and Secrets.](#35-create-namespaces-and-secrets)
    + [3.6 Guide to Setup ArgoCD](#36-guide-to-setup-argocd)
    + [3.7 Deploy Using ArgoCD](#37-deploy-using-argocd)
  * [4. Sync an ArgoCD App](#4-sync-an-argocd-app)
    + [4.1 Sync From CLI](#41-sync-from-cli)
    + [4.2 Sync From UI](#42-sync-from-ui)
  * [5. Testing the solution.](#5-testing-the-solution)
    + [5.1 Healthcheck](#51-healthcheck)
    + [5.2 Testing rebuild](#52-testing-rebuild)
    + [6 Uninstall AKS-Solution.](#6-uninstall-aks-solution)

## 1. Pre-requisites
- Terraform 14.4+
- Kubectl
- Argocd
- Helm
- Openssl
- Microsoft account
- Dockerhub account
- Azure CLI 
- Azure Subscription
- Bash terminal or terminal able to execute bash scripts
- JSON processor (jq)

### 1.1 Installation of Pre-requisites
### Terraform install

**MacOS**

- Install terraform by running

    ```
    brew install terraform
    ```

- Confirm version

    ```
    terraform -version
    ```
 
**Windows**

1. Download the terraform package from portal either 32/64 bit version.
2. Make a folder in C drive in program files if its 32 bit package you have to create folder inside on programs(x86) folder or else inside programs(64 bit) folder.
3. Extract a downloaded file in this location or copy terraform.exe file into this folder. copy this path location like C:\Programfile\terraform\
4. Then goto 
    ```
    
    Control Panel -> System -> System settings -> Environment Variables
    Open system variables, select the path > edit > new > place the terraform.exe file location like > C:\Programfile\terraform\ and Save it.
    
    ```
5. Open new terminal and now check the terraform.
 
    ```   
        --With Chocolatey run
         choco install terraform
    ```

**Linux**

1. Copy and paste the following command:
    ```
            $ sudo tall -y yum-utils
            $ sudo yum-config-manager --add-repo      	https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
            $ sudo yum -y install terraform
     ```
2. Confirm installation was successful by verifying its version .
    ```
            $ terraform --version
            Terraform v0.14.3
    ```
 
### Kubectl install
**MacOS**

- Copy and paste the following command
    ```
     brew install kubectl 
    ```
 
**Windows**

1. To install kubectl on Windows you can use Chocolatey package manager 
    ```
    choco install kubernetes-cli
    ```
2. Test to ensure the version you installed is up-to-date:
    
    ```
    kubectl version --client
    ```
3. Navigate to your home directory:

    ```
    # If you're using cmd.exe, run: cd %USERPROFILE%
    cd ~
    ```
4. Create the .kube directory:
    ```
     mkdir .kube
    ```
5. Change to the .kube directory you just created:
    ```
    cd .kube
    ```
6. Configure kubectl to use a remote Kubernetes cluster:

     `New-Item config -type file`
     
**Linux**

1. Download the latest release with the command
    ```
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    ```
 
2. Install kubectl
    ```
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    ```
3. Confirm the version is up to date
    ```
    kubectl version –client
    ```
 
### Open SSL 

**MacOs**  

```
brew info openssl

#check version
openssl version -a
```
**Windows**

Follow the instructions [here](https://www.xolphin.com/support/OpenSSL/OpenSSL_-_Installation_under_Windows)

**Linux**

OpenSSL has been installed from source on Linux Ubuntu and CentOS

### JSON processor

**MacOS**
```
brew install jq

```
**Windows**

```
chocolatey install jq
```

**Linux**
```
sudo apt-get install jq
```

### Azure Subscription Pre Requisite

- There should be atleast one subscription assosiated to azure account
- The subscription should have **Controbutor** role allows a user to create and manage virtual machines
- This documentation will provision a managed Azure Kubernetes (AKS) cluster on which to deploy the application. 
- This cluster has configured to auto scaling and  runs on a minimum of 4 nodes and maximum of 100 nodes.
- The specification of the nodes is defined in the `modules/aks01` configuration of this deployment
- The default configuration is to run 4 nodes of which will consume one virtual CPU’s (vCPU) of  type **Standard_DS4_v2** type anf **100 gb** on disk size  -
- The total amount of vCPU available in an Azure region is determined by the subscription itself.
- When deploying, it is essential to ensure that there is enough vCPU available within your subscription to provision the node type and count specified.
  

## Inputs

These are the variables required for the deployment

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_region | The cloud region | `string` | n/a | yes |
| suffix | Short Suffix used for cluster names | `string` | n/a | yes |
| DH_SA_USERNAME| Dockerhub username | `string` | n/a | yes |
| DH_SA_PASSWORD| Dockerhub password | `string` | n/a | yes |
| SmtpUser | SMTP Username | `string` | n/a | yes |
| SmtpPass | SMTP Password | `string` | n/a | yes |
| client\_id | Service Principal ClientID | `string` | n/a | yes |
| client\_secret | Service Principal Secret | `string` | n/a | yes |
| RESOURCE_GROUP_NAME | Resource group name for initial azure setup | `string` | n/a | yes |
| STORAGE_ACCOUNT_NAME | Storage account name for initial azure setup | `string` | n/a | yes |
| CONTAINER_NAME | Container Name for initial azure setup | `number` | n/a | yes |
| VAULT_NAME | Vault Name for initial azure setup | `string` | n/a | yes |
| key | state key name for terraform | `string` | n/a | yes |

## 2. Usage

### 2.1 Clone Repo

```
git clone https://github.com/k8-proxy/icap-aks-delivery.git
cd icap-aks-delivery
git submodule init
git submodule update

```
   
### 2.2 Firstly make sure you are logged in and using the correct subscription.

```bash

az login

az account list --output table

az account set -s <subscription ID>

```
### 2.3 Create terraform service principle

**PLEASE NOTE THIS ONLY NEEDS TO BE DONE ONCE FOR A SINGLE SUBSCRIPTION**

This next part will create a service principle, with the least amount of privileges, to perform the AKS Deployment.

```
./scripts/terraform-scripts/createTerraormServicePrinciple.sh
```

- When prompted `The provider.tf file exists.  Do you want to overwrite? ` , Enter `Y`

- The output will be similar to this. Keep a copy of `client id` and `client secret`

```
{
  "appId": "xyz",
  "displayName": "xyz",
  "name": "xyz",
  "password": "xyz",
  "tenant": "xyz"
}
subscription_id = "xyz"
client_id       = "xyz"
client_secret   = "xyz"
tenant_id       = "xyz"

```
### 2.4. Add required credentails

- All the required secrets and variables are listed in  are ".env.example"

- Run below

```
cp .env.example .env
vim .env
```

- Edit all the required details. 
- Run
```
export $(xargs<.env)
```
### 2.5 Create azure initial setup

- Run below script

```     
./scripts/terraform-scripts/create_azure_setup.sh

```

### 2.5 Add Secrets to main KeyVault 

- Run below scrip once you have done step 2.4
( You can also do this in Azure portal.Login to azure account and search <KEY_VAULT_NAME>,Go to secrets and add the above secrets. )

```
./scripts/terraform-scripts/load_keyvault_secrets.sh
```

### 2.6 Add Terraform Backend Key to Environment

- Check you have access to keyvault using below command
```
az keyvault secret show --name terraform-backend-key --vault-name $VAULT_NAME --query value -o tsv
```
- Next export the environment variable "ARM_ACCESS_KEY" to be able to initialise terraform

```
export ARM_ACCESS_KEY=$(az keyvault secret show --name terraform-backend-key --vault-name $VAULT_NAME --query value -o tsv)
```
 
- Now check to see if you can access it through variable
```
echo $ARM_ACCESS_KEY
```
### 2.7 File Modifications

- Currently below needs modifications

- main.tf
```
resource_group_name  = "gw-icap-tfstate"
storage_account_name = "tfstate263sam"
container_name       = "gw-icap-tfstate"
key = "test1.upwork.terraform.tfstate"

Note : First 3 values should be same as export values in step 2.3 
```

- modules/clusters/aks01/variables.tf
```
Change "default" field in location, resource_group , cluster_name

```
- modules/clusters/argocd-cluster/variables.tf
```
Change "default" field in location,resource_group , cluster_name

```

- modules/clusters/keyvaults/keyvault-ukw/variables.tf

```
Change "default" field in location, resource_group , kv_name
```

- modules/clusters/storage-accounts/storage-accounts-ukw/variables.tf
```
Change "default" field in location, resource_group_name
```

- scripts/az-secret-script/create-az-secret.sh
```
change UKW_VAULT to kv_name default value
```
- scripts\k8s_scripts\create-ns-docker-secret-uks.sh
```
Context used in kubectl config use-context to aks cluster
RESOURCE_GROUP= resource group in storage-account
VAULT_NAME= kv_name default vault
```

- scripts\argocd-scripts\argocd-app-deloy.sh
```
Context used in kubectl config use-context to argocd cluster
UKW_RESOURCE_GROUP -  resource_group of aks
UKW_CONTEXT - cluster_name of aks
```

### 2.8 Creating SSL Certs


```bash

mkdir -p certs/icap-cert

mkdir -p certs/mgmt-cert
```

#### Self signed quick start

**For evaluation use we have provided scripts to generate and apply self signed certificates**

- Now the directories for the certs have been created, you can now create the certs using the following scripts:

```bash
./scripts/gen-certs/icap-cert/icap-gen-certs.sh icap-client.ukwest.cloudapp.azure.com
```

- Management-UI
```bash
./scripts/gen-certs/mgmt-cert/mgmt-gen-certs.sh management-ui.ukwest.cloudapp.azure.com
```

#### Customer Certificates

**If you have your own certificates for production use then follow below steps**

- There will be two set of certificate, one for `icap-client` domain and other for `management-ui` domain

- Rename `.crt` file to certificate.crt and `.key` file to `tls.key` for both domain certificates

- Copy `icap-client certificates` to `certs/icap-cert`

- Copy `management-ui certificates` to  `certs/mgmt-cert`

- Run 

```
az storage blob directory upload -c $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME -s "./certs/*" -d certs --recursive
```


## 3. Pre deployment

## 4. Deployment
### 4.1 Setup and Initialise Terraform

- Next you'll need to use the following:
```
terraform init
```
- Next run terraform validate/refresh to check for changes within the state, and also to make sure there aren't any issues.
```
terraform validate
#Success! The configuration is valid.

terraform refresh
terraform plan
```

- Now you're ready to run apply and it should give you the following output
``` 
terraform apply 

Do you want to perform these actions?
Terraform will perform the actions described above.
Only 'yes' will be accepted to approve.
Enter a value: 
Enter "yes"

```
### 4.2 Switch Context 

-Run:

```
./scripts/get-kube-context/get-kube-context-sh
```

### 4.3 Loading Secrets into key vault.

- Run
```
./scripts/az-secret-script/create-az-secret.sh
```

### 4.4 Create Namespaces & Secrets.
```
./scripts/k8s_scripts/create-ns-docker-secret-uks.sh

```
### 4.5 Guide to Setup ArgoCD

Next we will deploy the services using either Helm or Argocd. Both of the Readme's for each can be found below:

- [ArgoCD Installation guide Readme](/argocd/installation-guide/README.md)
- [ArgoCD deployment guide Readme](/argocd/deployment-guide/README.md)
- [ArgoCD user guide Readme](/argocd/user-guide/README.md)

### 4.6 Deploy Using ArgoCD

- Before deploying confirm you are on the right context (server)
```
argocd context
```

- if the right context is not selected switch to the right one running

```
argocd context <name of the server>
```
- Deploy ArgoCD
```
./scripts/argocd-scripts/argocd-app-deloy.sh
```
 
## 5. Sync an ArgoCD App
### 5.1 Sync From CLI
Get Repo information from
```
./scripts/argocd-scripts/argocd-app-sync.sh
```
### 5.2 Sync From UI
- Access argocd UI using argocd public
```
   kubectl get svc -n argocd argocd-server

```
 
- Login to argocd UI

You can deploy and sync each service from argoCD UI in the following order 1-RabbitMQ Operator, 2-Cert Manager, the rest can follow in any order
 
## 6. Testing the solution.

### 6.1 Healthcheck

- Make sure all the applications are healthy and synced from argocd UI

### 6.2 Testing rebuild 

Run ICAP client locally 

1. Open local terminal window 
2. Run:

        git clone https://github.com/k8-proxy/icap-client-docker.git
    
3. Run: 

        cd icap-client-docker/
        sudo docker build -t c-icap-client .
    
4. Run: 
       
        ./icap-client.sh {IP of frontend-icap-lb} JS_Siemens.pdf
        
        (check Respond Headers: HTTP/1.0 200 OK to verify rebuild is successful)
    
5. Run: 

        open rebuilt/rebuilt-file.pdf  
    
       (and notice "Glasswall Proccessed" watermark on the right hand side of the page)
    
6. Open original `./JS_Siemens.pdf` file in Adobe reader and notice the Javascript and the embedded file 
7. Open `https://file-drop.co.uk/` or `https://glasswall-desktop.com/` and drop both files (`./JS_Siemens.pdf ( original )` and `rebuilt/rebuilt-file.pdf (rebuilt) `) and compare the differences

### 7 Uninstall AKS-Solution. 

#### **Only if you want to uninstall AKS solution completely from your system, then proceed**

- Run below script to destroy all cluster ,resources, keyvaults,storage containers and service principle. 

```
./scripts/terraform-scripts/uninstall_icap_aks_setup.sh
```
[Go to top](#instructions)
