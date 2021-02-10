az keyvault secret set --vault-name $VAULT_NAME  --name token-username --value $token-username

az keyvault secret set --vault-name $VAULT_NAME --name spusername --value $spusername

az keyvault secret set --vault-name $VAULT_NAME --name sppassword --value $sppassword

az keyvault secret set --vault-name $VAULT_NAME --name TF-VAR-client-id --value $TF-VAR-client-id

az keyvault secret set --vault-name $VAULT_NAME  --name TF-VAR-client-secret --value $TF-VAR-client-secre

az keyvault secret set --vault-name $VAULT_NAME  --name DH-SA-USERNAME--value $DH-SA-USERNAME

az keyvault secret set --vault-name $VAULT_NAME  --name DH-SA-PASSWORD --value $DH-SA-PASSWORD

az keyvault secret set --vault-name $VAULT_NAME  --name SmtpUser --value $SmtpUser

az keyvault secret set --vault-name $VAULT_NAME  --name SmtpPass --value $SmtpPass

az keyvault secret set --vault-name $VAULT_NAME  --name manage-endpoint --value $manage-endpoint