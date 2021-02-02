Get-Module -Name az* -ListAvailable |
  ForEach-Object {
    $currentVersion = [Version] $_.Version
    $newVersion = [Version] (Find-Module -Name $_.Name).Version

    if ($newVersion -gt $currentVersion) {
      Write-Host -Object "Updating $_ Module from $currentVersion to $newVersion" -ForegroundColor Green
      Update-Module -Name $_.Name -RequiredVersion $newVersion -Force
      #Uninstall-Module -Name $_.Name -RequiredVersion $currentVersion -Force
    }
  }