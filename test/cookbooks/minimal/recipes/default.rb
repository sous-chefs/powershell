#
# powershell_module 'posh-git' do
#   package_name 'posh-git'
#   source 'https://github.com/dahlbyk/posh-git/zipball/master'
# end

include_recipe 'powershell::powershell5'


powershell_package_source 'PSGallery' do
  action :update
end

powershell_dsc_module 'xTimeZone' do
  action :install
end

# powershell_dsc_module 'xTimeZone' do
#   action :update
# end

# powershell_dsc_module 'xTimeZone' do
#   action :uninstall
# end
