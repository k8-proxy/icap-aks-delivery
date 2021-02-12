terraform=$(terraform -version --json | jq '.terraform_version')
kubectl=$(kubectl version  --client --short | awk '{print $3}')
opnessl=$(openssl version|awk '{print $2}')
helm=$(helm version --short)
azure=$(az version 2>/dev/null | jq -r '."azure-cli"')
jq=$(jq --version)
bash=$(echo ${BASH_VERSION})
argocd=$(argocd version)

red=`tput setaf 1`
white=`tput sgr 0`
green=`tput setaf 2`

check_version(){
  library=$1
  current_version=$2
  verify_string=$3
  requiredver=$4

  if [[ $current_version =~ $verify_string ]]; then

  currentver=$current_version
  requiredver=$4

  if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then
        echo "${green}$library Greater than or equal to ${requiredver}${white}"
  else
        echo "${red}$library Less than ${requiredver}${white}"
  fi
  else
      echo ${red}
      echo "$library is NOT installed"
      echo "Please refer document for installtion"
      echo ${white}
  fi

}

#check Jq version
check_version "jq" $jq  "jq-1." "jq-1.6"
#check Terraform version
check_version "terraform" $terraform  "0.1" "0.14"
#check helm version
check_version "helm" $helm  "v3." "v3.4"
#check OpenSsl version
check_version "OpenSsl" $opnessl  "1.1" "1.1.1h"
#check Kubectl version
check_version "Kubectl" $kubectl  "v1." "v1.19"
#check Azure version
check_version "AZ CLI" $azure  "2." "2.17"
#check Azure version
check_version "AZ CLI" $azure  "2." "2.17"

