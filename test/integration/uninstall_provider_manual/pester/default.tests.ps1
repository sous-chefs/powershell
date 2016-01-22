describe 'powershell::uninstall_package_manual'  {
    It "Should not have package provider executable" {
      ("$env:ProgramW6432\\PackageManagement\\ProviderAssemblies\\nuget-anycpu.exe") | Should Not Exist
    }

    It "Should have not package sources installed" {
      (Get-PackageSource | where {$_.Name -eq 'ExampleSource'}) | Should Be $null 
    }

    It "Should not have package installed" {    
      Get-Package 'xTimeZone' | Should Throw
    }
}