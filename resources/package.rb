class Chef
  class Resource::PowershellPackage < ChefCompat::Resource
    resource_name :powershell_package

    property :package_name, String, name_property: true
    property :source, String
    property :version, String, required: true

    default_action :install

    action :install do
      if new_resource.source.nil? then Chef::Log.fatal "#{new_resource.name} did not specify a source, cannot add module without!" end
      powershell_script "install #{new_resource.package_name} Powershell Module" do
        code "install-package -source '#{new_resource.source}' -name '#{new_resource.package_name}' -RequiredVersion '#{new_resource.version}'"
        not_if "get-package -name '#{new_resource.package_name}'"
      end
    end

    action :update do
      if new_resource.source.nil? then Chef::Log.fatal "#{new_resource.name} did not specify a source, cannot add module without!" end
      powershell_script "update #{new_resource.package_name} Powershell Module" do
        code "install-package -source '#{new_resource.source}' -name '#{new_resource.package_name}' -RequiredVersion '#{new_resource.version}' -Force"
        not_if "get-package -name '#{new_resource.package_name}'"
      end
    end

    action :uninstall do
      powershell_script "uninstall #{new_resource.package_name} Powershell Module" do
        code "uninstall-package -name '#{new_resource.package_name}' -RequiredVersion '#{new_resource.version}'"
        only_if "get-package -name '#{new_resource.package_name}'"
      end
    end
  end
end
