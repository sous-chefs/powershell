describe 'powershell::install_package'  {
    It "Should have package provider installed" {
      (Get-PackageProvider | Where-Object {$_.Name -eq 'NuGet'}).Name | Should Not Be $null
      (Get-PackageProvider | Where-Object {$_.Name -eq 'NuGet'}).Version.Major | Should Be "2"
      (Get-PackageProvider | Where-Object {$_.Name -eq 'NuGet'}).Version.Minor | Should Be "8"
      (Get-PackageProvider | Where-Object {$_.Name -eq 'NuGet'}).Version.Build | Should Be "5"
    }

    It "Should have package sources installed" {
      (Get-PackageSource | Where-Object {$_.Name -eq 'PSGallery'}).Name | Should Be 'PSGallery' 
      (Get-PackageSource | Where-Object {$_.Name -eq 'PSGallery'}).Location | Should Be 'https://www.powershellgallery.com/api/v2/' 
      (Get-PackageSource | Where-Object {$_.Name -eq 'PSGallery'}).IsTrusted | Should Be 'True' 
    }

    It "Should have package installed" {    
      (Get-Package 'xTimeZone').Name | Should Be 'xTimeZone' 
      (Get-Package 'xTimeZone').Source | Should Be 'https://www.powershellgallery.com/api/v2/' 
      (Get-Package 'xTimeZone').FromTrustedSource | Should Be $true
      (Get-Package 'xTimeZone').Version.ToString() | Should Be '1.3.0.0'
    }
}