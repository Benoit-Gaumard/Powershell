<#
.SYNOPSIS
    Retrieve token of the current Azure Context session
.DESCRIPTION
    Retrieve token of the current Azure Context session
    This is using the Get-AzContext cmdlets from the module Az.Account and assume a session is already opened.
.NOTES
    File Name : MarketplaceUpdater.ps1
    Author    : Matt McSpirit
    Version   : 1.0
    Date      : 28-June-2019
    Update    : 28-June-2019
    Requires  : PowerShell Version 5.0 or above
    Module    : Tested with AzureRM 2.5.0 and Azure Stack 1.7.2 already installed
.EXAMPLE
    $token=Get-AzToken
    $uri = "https://management.azure.com/tenants?api-version=2019-11-01"
    invoke-restmethod -method get -uri $uri -Headers @{Authorization="Bearer $token";'Content-Type'='application/json'}
    This leverate the token of the current session to query the Azure Management
    API and retrieves all the tenants information

#>

[CmdletBinding()]
Param()
try{
    $currentAzureContext = Get-AzContext
    $azureRmProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile;
    $profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azureRmProfile)
    $profileClient.AcquireAccessToken($currentAzureContext.Subscription.TenantId).AccessToken
}catch{
    throw $_
}



