az keyvault secret set --vault-name $VAULT_NAME  --name token-username --value $token_username

az keyvault secret set --vault-name $VAULT_NAME  --name DH-SA-USERNAME --value $DH_SA_USERNAME

az keyvault secret set --vault-name $VAULT_NAME  --name DH-SA-PASSWORD --value $DH_SA_PASSWORD

az keyvault secret set --vault-name $VAULT_NAME  --name SmtpUser --value $SmtpUser

az keyvault secret set --vault-name $VAULT_NAME  --name SmtpPass --value $SmtpPass

az keyvault secret set --vault-name $VAULT_NAME  --name SmtpHost --value $SmtpHost

az keyvault secret set --vault-name $VAULT_NAME  --name SmtpPort --value $SmtpPort

az keyvault secret set --vault-name $VAULT_NAME  --name SmtpSecureSocketOptions --value $SmtpSecureSocketOptions



