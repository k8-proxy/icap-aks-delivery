#!/bin/bash
unique=$(uuidgen)

cat <<EOF >backend.tfvars
resource_group_name="${RESOURCE_GROUP_NAME}"
storage_account_name="${STORAGE_ACCOUNT_NAME}"
container_name="${CONTAINER_NAME}"
key="${unique}.gw.delivery.terraform.tfstate"
EOF