##############################################################################
# Export all Yammer users through the Yammer REST API with PowerShell
###############################################################################

# Variables
$baererToken = "YourBaererToken"
$yammerBaseUrl = "https://www.yammer.com/api/v1"

# Function Get-BaererToken
Function Get-BaererToken()
{
    $headers = @{ Authorization=("Bearer " + $baererToken) }
    return $headers
}

# Function Get-YamUsers
Function Get-YamUsers($page, $allUsers)
{
    if ($page -eq $null)
    {
        $page = 1
    }

    if ($allUsers -eq $null)
    {
        $allUsers = New-Object System.Collections.ArrayList($null)
    }

    # Users API
    $urlToCall = "$($yammerBaseUrl)/users.json"
    $urlToCall += "?page=" + $page;

    $headers = Get-BaererToken

    Write-Host $urlToCall
    $webRequest = Invoke-WebRequest –Uri $urlToCall –Method Get -Headers $headers

    if ($webRequest.StatusCode -eq 200)
    {
        $results = $webRequest.Content | ConvertFrom-Json

        if ($results.Length -eq 0)
        {
            return $allUsers
        }
        $allUsers.AddRange($results)
    }

    if ($allUsers.Count % 50 -eq 0)
    {
        $page = $page + 1
        return Get-YamUsers $page $allUsers
    }
    else
    {
        return $allUsers
    }
}

# Call Get-YamUsers function
$allUsers = Get-YamUsers

# Export to CSV
$AllUsers| Export-Csv -path .\YAMMER-All-Users-$(Get-Date -format "d-M-y-hh-mm-ss").csv -Append -NoTypeInformation -Delimiter ';'