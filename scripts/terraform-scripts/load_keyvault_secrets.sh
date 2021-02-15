az keyvault secret set --vault-name $VAULT_NAME  --name token-username --value $token_username

az keyvault secret set --vault-name $VAULT_NAME --name spusername --value $spusername

az keyvault secret set --vault-name $VAULT_NAME --name sppassword --value $sppassword

az keyvault secret set --vault-name $VAULT_NAME --name TF-VAR-client-id --value $TF_VAR_client_id

az keyvault secret set --vault-name $VAULT_NAME  --name TF-VAR-client-secret --value $TF_VAR_client_secret

az keyvault secret set --vault-name $VAULT_NAME  --name DH-SA-USERNAME --value $DH_SA_USERNAME

az keyvault secret set --vault-name $VAULT_NAME  --name DH-SA-PASSWORD --value $DH_SA_PASSWORD

az keyvault secret set --vault-name $VAULT_NAME  --name SmtpUser --value $SmtpUser

az keyvault secret set --vault-name $VAULT_NAME  --name SmtpPass --value $SmtpPass

az keyvault secret set --vault-name $VAULT_NAME  --name manage-endpoint --value $manage_endpoint