$ErrorActionPreference = 'Stop'

./connect-to-azure.ps1 `
    -appveyor_api_key $args[0] `
    -appveyor_url https://ci.appveyor.com `
    -use_current_azure_login `
    -azure_location eastus2 `
    -azure_vm_size Standard_D4s_v3 `
    -common_prefix batectci `
    -image_description 'Windows Server 2019 on Azure for batect' `
    -skip_disclaimer
