##############################################################################
# Export Yammer group members from the Yammer REST API with PowerShell
###############################################################################
<#
L’API REST de Yammer documentée ici : https://developer.yammer.com/docs/rest-api-rate-limits vous permet de liste les utilisateurs de l’entreprise. L’appel à cette API renvoie les utilisateurs par lots de 50. Vous devez appeler plusieurs fois l’API pour obtenir tous vos utilisateurs de l’annuaire si vous en avez plus de 50.

Vous trouverez ci-dessous un script PowerShell permettant de faire les appels nécessaires à l’API Yammer afin de vous retourner la liste complète des utilisateurs de votre réseau.

Enregistrer une application afin de pouvoir générer un access token
Connectez-vous en tant qu’administrateur vérifié à votre réseau Yammer
Une fois connecté, tapez l’adresse https://www.yammer.com/client_applications
Enregistrez une nouvelle application en cliquant sur Register New App
Vous pouvez spécifier n’importe quelle adresse à l’URL de redirection attendue, celle-ci ne sera pas utilisée dans notre cas
Une fois inscrit, générez un token pour cette application en cliquant sur Generate a developer token for this application
Notez le soigneusement car celui-ci disparaîtra lorsque vous essayerez d’y accéder plus tard. Il faudra en générer un nouveau si vous avez perdu celui-ci.

#>

# Variables
$baererToken = "2027689-o9kGz5a6XYATzIyJvgrsuQ" #eg. 2027689-o9kGz5a6XYATzIyJvgrsuQ
$yammerBaseUrl = "https://www.yammer.com/api/v1"
$GroupId = "10128859136"  #eg. 1234556

# Function Get-BaererToken
Function Get-BaererToken()
{
    $headers = @{ Authorization=("Bearer " + $baererToken) }
    return $headers
}

# Function Get-Yammer-Users-From-GroupId
Function Get-Yammer-Users-From-GroupId($page, $allUsers)
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
    $urlToCall = "$($yammerBaseUrl)/users/in_group/$GroupId.json"
    
    $urlToCall += "?page=" + $page;
    $urlToCall 
    $body=@{group_id="$GroupId"}

    $headers = Get-BaererToken

    Write-Host "Parsing page : $($page) $($urlToCall)"

    $webRequest = Invoke-WebRequest –Uri $urlToCall –Method Get -Headers $headers -Body $body


    if ($webRequest.StatusCode -eq 200)
    {
        $results = $webRequest.Content | ConvertFrom-Json

        if ($results.users.Length -eq 0)
        {
            return $allUsers
        }
        $allUsers.AddRange($results.users)
    }

    if ($results.more_available)
    {
        $page = $page + 1
        return Get-Yammer-Users-From-GroupId $page $allUsers
    }
    else
    {
        return $allUsers
    }
}

# Call Get-Yammer-Users-From-GroupId function
$allUsers = Get-Yammer-Users-From-GroupId
write-host "$($allUsers.count) users found"

# Export to CSV
$AllUsers | Export-Csv -path .\YAMMER-All-Users-From-Group-$GroupId$(Get-Date -format "d-M-y-hh-mm-ss").csv -Append -NoTypeInformation -Delimiter ';'