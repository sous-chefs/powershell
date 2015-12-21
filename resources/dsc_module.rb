property :name, String, default: 'xTimeZone'
property :source, String, default: 'PSGallery'
property :version, String, default: '1.3.0.0'

default_action :install

action :install do
  package_name = name
  powershell_script "install #{package_name} Powershell Module" do
    code "install-package -source '#{source}' -name '#{package_name}' -RequiredVersion '#{version}'"
    not_if "get-package -name '#{package_name}'"
  end
end

action :update do
end

action :uninstall do
end
