#  Deployment of AKS
### If you haven't installed the pre-requisites and set up the environment, please follow steps [here](https://github.com/k8-proxy/icap-aks-delivery/blob/main/Doc-Install%26Usage.md)
- [1. Setup and Initialise Terraform](#2-setup-and-initialise-terraform)
- [2. Testing the solution.](#3-testing-the-solution)
  * [2.1 Testing rebuild](#31-testing-rebuild)
- [3 Uninstall AKS-Solution](#4-uninstall-aks-solution)

    
## 1 Setup and Initialise Terraform

- Run the following:
```
terraform init -backend-config="backend.tfvars" 

```
- Run terraform validate/refresh to check for changes within the state, and also to make sure there aren't any issues.
```
terraform validate
#Output shoule be: Success! The configuration is valid.
```
- Run
```
terraform plan
```

- Now you're ready to run apply
``` 
terraform apply 

#When prompted below output enter "yes"
Do you want to perform these actions?
Terraform will perform the actions described above.
Only 'yes' will be accepted to approve.
Enter a value: 
```

## 2 Testing the solution.

1. Find DNS/IP of the ICAP-Server, Management-UI and File-Drop

- ICAP-server

    Run below command and switch to aks cluster by replacing `${suffix}` with the value you specified for suffix in terraform.tfvars
    ```
    kubectl config get-contexts  
    kubectl config use-context  aks-clu-${suffix}
    kubectl get service  --all-namespaces
  
    ```
    - ICAP-server EXTERNAL-IP is the IP under `frontend-icap-lb` namespace (second column)
    
- Management-UI: 
    - Management-ui EXTERNAL-IP is the IP under `ingress-nginx-controller` namespace (second column), results on running 
    ```
     kubectl get service  --all-namespaces
     ```
    - Management-ui hostaname can be seen when running:
     
    ```
    kubectl get ingress -A
    ```
    - Use hostname in your browser to access management-ui

![image](https://user-images.githubusercontent.com/70108899/109070073-55e27600-76f2-11eb-84ad-f6b2379b781f.png)
  
  
- File-Drop

     Run below command and switch to file-drop cluster by replacing `${suffix}` with the value you specified for suffix in terraform.tfvars
  ```
  kubectl config get-contexts
  kubectl config use-context  fd-clu-${suffix}
  kubectl get ingress -A
  ```
  
    - File-Drop hostname can be used in browser for accessing File-Drop

![image](https://user-images.githubusercontent.com/70108899/109070170-73afdb00-76f2-11eb-8427-eed0084d33d5.png)
    
    
2. Install and run ICAP client localy to verify ICAP-Server LB is working as expected

   2.1 Install Docker
   
   MacOS
   - From Docker Hub download Docker Desktop for Mac https://hub.docker.com/editions/community/docker-ce-desktop-mac/ and follow the instructions
   
   Windows
   - From Docker Hub download Docker Desktop for WIN https://hub.docker.com/editions/community/docker-ce-desktop-windows and follow the instructions
   
   Linux
   - Copy and paste the following commands
   ```
   sudo yum install -y yum-utils
   sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
   sudo yum install docker-ce docker-ce-cli containerd.io --allowerasing
   sudo systemctl start docker
   ```

   2.2 Install ICAP client 
   ```
   git clone https://github.com/k8-proxy/icap-client-docker.git
   cd icap-client-docker/
   sudo docker build -t c-icap-client .
   ```
   
   2.3 Run ICAP client by processing the file
   
   ```
   ./icap-client.sh {IP of frontend-icap-lb} JS_Siemens.pdf
   #(check Respond Headers: HTTP/1.0 200 OK to verify rebuild is successful)
   ```
   
   - Open rebuilt/rebuilt-file.pdf (in your OS, not via console) and notice "Glasswall Proccessed" watermark on the right hand side of the page)
   - Open original `./JS_Siemens.pdf` file in Adobe reader and notice the Javascript and the embedded file 
   - Open `https://file-drop.co.uk/` or `https://glasswall-desktop.com/` and drop both files (`./JS_Siemens.pdf ( original )` and `rebuilt/rebuilt-file.pdf (rebuilt)`) and compare the differences


### 3 Uninstall AKS-Solution

#### **Only if you want to uninstall AKS solution completely from your system, then proceed**

- From `icap-aks-delivery` folder run below script to destroy all clusters, resources, keyvaults, storage containers and service principal.

```
./scripts/terraform-scripts/uninstall_icap_aks_setup.sh
#When prompt enter: yes
```

- To verify everything is destroyed run `./scripts/healthchecks/azure_setup_healthcheck.sh` and you should get error that container and account key are not present
[Go to top](#Deployment-of-AKS)
