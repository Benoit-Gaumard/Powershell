function Get-AzCachedAccessToken($Tenant_id)
{
    
    $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    if(-not $azProfile.Accounts.Count)
    {
        Write-host "Ensure you have logged in before calling this function."
        login-azaccount -Tenant $Tenant_id     
    }

    $NewAzureContext = Set-AzContext -Tenant $($Tenant_id) -ErrorAction Stop | Out-Null
    $currentAzureContext = Get-AzContext

    $profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azProfile)
    Write-Debug ("Getting access token for tenant" + $currentAzureContext.Tenant.TenantId)
    
    $token = $profileClient.AcquireAccessToken($currentAzureContext.Tenant.TenantId)
    
    $Headers = @{
    'Authorization' = "Bearer $($token.AccessToken)"
    'Accept' = "application/json"
    'x-ms-effective-locale' = "en.en-us"
    }

    return $Headers
}