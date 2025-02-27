# Set variables
$localAdminPassword = Read-Host "Enter local admin password for the server after demotion" -AsSecureString
$forceDemotion = $false # Set to $true if this is the last DC in the domain and you want to force remove

# Perform the demotion
Uninstall-ADDSDomainController `
-NoGlobalCatalog:$false `
-LocalAdministratorPassword $localAdminPassword `
-Force:$forceDemotion `
-RemoveDnsDelegation:$true `
-Confirm:$false
