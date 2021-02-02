Get-PSRepository
Get-Module -Name az* -ListAvailable |
  ForEach-Object {
    write-host "Checking $($_.Name)"
    $currentVersion = [Version] $_.Version
    $newVersion = [Version] (Find-Module -Name $_.Name).Version

    if ($newVersion -gt $currentVersion) {
        Write-Host -Object "New version available $_ Module from $currentVersion to $newVersion" -ForegroundColor Green
    }
    Else
    {
        Write-Host -Object "No new version available $_ Module from $currentVersion" -ForegroundColor Yellow
    }
  }