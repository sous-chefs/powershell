describe 'powershell::uninstall_package'  {
    It "Should have not package sources installed" {
      (Get-PackageSource | where {$_.Name -eq 'ExampleSource'}) | Should Be $null 
    }

    It "Should not have package installed" {    
      (Get-Package 'xTimeZone') | Should Throw
    }
}