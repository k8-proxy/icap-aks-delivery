#  Deployment of AKS
- [1. Pre deployment](#1-pre-deployment)
  * [ICAP Port customization](#icap-port-customization)
- [2 Setup and Initialise Terraform](#2-setup-and-initialise-terraform)
- [3. Testing the solution.](#3-testing-the-solution)
  * [3.1 Testing rebuild](#31-testing-rebuild)
- [4 Uninstall AKS-Solution](#4-uninstall-aks-solution)


## 1. Pre deployment

### ICAP Port customization
- By default icap-server will run on port 1344 for SSL and 1345 for TLS
- If you want to customize the above port, please follow below procedure
```
vim terraform.tfvars
```
- Edit variables `icap_port` and `icap_tlsport` according to requirement and Save it.

Note : Please avoide port 80, 443 since this will be used for file-drop UI.

    
## 2 Setup and Initialise Terraform

- Next you'll need to use the following:
```
terraform init -backend-config="backend.tfvars" 

```
- Next run terraform validate/refresh to check for changes within the state, and also to make sure there aren't any issues.
```
terraform validate
#Success! The configuration is valid.

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

## 3. Testing the solution.

### 3.1 Testing rebuild 

Run ICAP client locally

1. Find DNS of the ICAP-Server and Management UI

- Icap-server

    Run below command and 
    ```
     kubectl get service  --all-namespaces
    ```

    - ICAP-server : EXTERNAL-IP of frontend-icap-lb 
    
- File-Drop    

 Run below command and 
    ```
     kubectl get service  --all-namespaces
    ```

    - File-Drop  : EXTERNAL-IP of file-drop-lb   

- Management-ui: 
        ```
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

### 4 Uninstall AKS-Solution

#### **Only if you want to uninstall AKS solution completely from your system, then proceed**

- Run below script to destroy all cluster ,resources, keyvaults,storage containers and service principal.

```
./scripts/terraform-scripts/uninstall_icap_aks_setup.sh
```
[Go to top](#Deployment-of-AKS)
