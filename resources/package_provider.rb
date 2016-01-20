class Chef
  class Resource::PowershellPackageProvider < ChefCompat::Resource
    resource_name :powershell_package_provider

    property :source_name, String, name_property: true

    default_action :install

    action :install do
      powershell_script "install package source_name #{source_name}" do
        code "Get-PackageProvider -Name '#{source_name}' -ForceBootstrap"
        only_if "(Get-PackageProvider | where {$_.Name -eq '#{source_name}'}) -eq $null"
      end
    end
  end
end
