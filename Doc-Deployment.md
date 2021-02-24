#  Deployment of AKS
## If you haven't installed the pre-requisites and set up the environment, please follow steps [here](https://github.com/k8-proxy/icap-aks-delivery/blob/main/Doc-Install%26Usage.md)
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

## 6. Testing the solution.

### 6.1 Testing rebuild 

Run ICAP client locally

1. Find DNS of the ICAP-Server and Management UI

- Icap-server

    Run below command and switch to aks cluster by replacing `${suffix}` below
    ```
     kubectl config get-contexts
  
     kubectl config use-context  aks-clu-${suffix}
     kubectl get service  --all-namespaces
  
    ```

    - ICAP-server : EXTERNAL-IP of frontend-icap-lb 
    - Management-ui : EXTERNAL-IP of ingress-nginx-controller
    
- Management-ui: 
    ```
    kubectl get ingress -A
    
    ```
    
- File-Drop    

     Run below command and switch to file-drop cluster by replacing `${suffix}` below
  ```
     kubectl config get-contexts
  
     kubectl config use-context  fd-clu-${suffix}
     kubectl get ingress -A
  ```
      

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
### 3 Uninstall AKS-Solution

#### **Only if you want to uninstall AKS solution completely from your system, then proceed**

- Run below script to destroy all cluster ,resources, keyvaults,storage containers and service principal.

```
./scripts/terraform-scripts/uninstall_icap_aks_setup.sh
```
[Go to top](#Deployment-of-AKS)
