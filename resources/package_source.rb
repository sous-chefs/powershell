class Chef
  class Resource::PowershellPackageSource < ChefCompat::Resource
    resource_name :powershell_package_source

    property :source_name, String, name_property: true
    property :location, String
    property :package_provider, String, required: true # Specifying PSModule doesn't seem to work for Register-PackageSource
    property :trusted, [TrueClass, FalseClass], default: false

    default_action :register

    action :register do
      if new_resource.location.nil? then Chef::Log.fatal "#{new_resource.location} did not specify a package source location, cannot add a source without!" end
      powershell_script "register package source #{new_resource.source_name}" do
        code "Register-PackageSource -Name '#{new_resource.source_name}' -ProviderName '#{new_resource.package_provider}' -Location '#{new_resource.location}' #{new_resource.trusted ? '-Trusted' : ''}"
        not_if "Get-PackageSource | where {$_.Name -eq '#{new_resource.source_name}'}"
      end
    end

    action :unregister do
      powershell_script "unregister package source #{new_resource.source_name}" do
        code "Unregister-PackageSource -Name '#{new_resource.source_name}' -Provider '#{new_resource.package_provider}'"
        only_if "Get-PackageSource | where {$_.Name -eq '#{new_resource.source_name}'}"
      end
    end

    action :update do
      if new_resource.location.nil? then Chef::Log.fatal "#{new_resource.location} did not specify a package source location, cannot update a source without!" end
      powershell_script "update registered package source #{new_resource.source_name}" do
        code "Register-PackageSource -Name '#{new_resource.source_name}' -ProviderName '#{new_resource.package_provider}' -Location '#{new_resource.location}' #{new_resource.trusted ? '-Trusted' : ''} -Force"
        only_if "(Get-PackageSource | where {$_.Name -eq '#{new_resource.source_name}' -and $_.ProviderName -eq '#{new_resource.package_provider}' -and $_.Location -eq '#{new_resource.location}' -and $_.IsTrusted -eq #{new_resource.trusted ? '$true' : '$false'}}) -eq $null"
      end
    end
  end
end
