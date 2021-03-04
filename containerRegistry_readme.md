# Instructions


## 1. Pre-requisites
- Terraform 
- Kubectl
- Helm
- Openssl
- Azure CLI 
- Bash terminal or terminal able to execute bash scripts
- yq
- Git
- Microsoft account
- Azure Subscription
- Dockerhub account 

## 2. Usage

### 2.1 Clone Repo.

```
git clone https://github.com/filetrust/icap-infrastructure.git
cd icap-infrastructure
git checkout add-image-registry

```

### 2.2 Login to Glasswall docker hub with PTA token

- You should have Docker-PAT-username	(Glasswall will supply the Docker username) and Docker-PAT (Glasswall will supply the Docker personal access token) and login to docker hub following command:
```
docker login --username <Docker-PAT-username>
Password :<Docker-PAT>
```
### Pull docker image to local.
```
chmod +x pull_images.sh
./pull_images.sh

```

### Create Container Registry on azure
```
az acr create --resource-group $RESOURCE_GROUP_NAME --name $CONTAINER_REGISTRY --sku Basic
```
### Push image to container registry

- Download push image script from 
``` 
https://github.com/filetrust/Glasswall-ICAP-Platform/blob/main/container-images/push_images.sh

```
- Push image to container registry
```
./push_images.sh <container registry name>

Example : ./push_images.sh ICAP_Container_registry.azurecr.io
```

- This action take long time to upload file to Azure based on network speed ( over 1.5 GB uploadded)