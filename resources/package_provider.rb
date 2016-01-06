class Chef
  class Resource::PowershellPackageProvider < ChefCompat::Resource
    resource_name :powershell_package_provider

    property :source_name, String, name_property: true
    property :file_name, String
    property :file_source, String
    property :file_checksum, String

    default_action :install

    action :install do
      powershell_script "install package source_name #{source_name}" do
        code "Get-PackageProvider -Name '#{source_name}' -ForceBootstrap"
        only_if "(Get-PackageProvider | where {$_.Name -eq '#{source_name}'}) -eq $null"
      end
    end

    action :install_manual do
      if new_resource.file_source.nil? then Chef::Log.fatal "#{new_resource.file_source} did not specify a file source, cannot manually add a provider without!" end
      if new_resource.file_name.nil? then Chef::Log.fatal "#{new_resource.file_name} did not specify a file name, cannot manually add a provider without!" end
      if new_resource.file_checksum.nil? then Chef::Log.fatal "#{new_resource.file_checksum} did not specify a file checksum, cannot manually add a provider without!" end
      directory "#{ENV['ProgramW6432']}\\PackageManagement\\ProviderAssemblies" do
        recursive true
        action :create
      end
      remote_file "#{ENV['ProgramW6432']}\\PackageManagement\\ProviderAssemblies\\#{file_name}" do
        source new_resource.file_source
        checksum new_resource.file_checksum
        action :create_if_missing
      end
    end

    action :uninstall_manual do
      if new_resource.file_source.nil? then Chef::Log.fatal "#{new_resource.file_source} did not specify a file source, cannot manually remove a provider without!" end
      if new_resource.file_name.nil? then Chef::Log.fatal "#{new_resource.file_name} did not specify a file name, cannot manually remove a provider without!" end
      if new_resource.file_checksum.nil? then Chef::Log.fatal "#{new_resource.file_checksum} did not specify a file checksum, cannot manually remove a provider without!" end
      remote_file "#{ENV['ProgramW6432']}\\PackageManagement\\ProviderAssemblies\\#{file_name}" do
        source new_resource.file_source
        checksum new_resource.file_checksum
        action :delete
      end
    end
  end
end
