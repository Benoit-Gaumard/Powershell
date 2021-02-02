Get-Module -Name az* -ListAvailable |
  ForEach-Object {
    write-host "Checking $($_.Name)"
    # Clean Up
    Uninstall-Module -Name $_.Name -AllVersions -Force -Verbose
  }