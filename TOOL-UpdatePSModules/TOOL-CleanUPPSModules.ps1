Get-Module -Name az* -ListAvailable |
  ForEach-Object {
    # Clean Up
    Uninstall-Module -Name $_.Name -AllVersions -Force -Verbose
  }