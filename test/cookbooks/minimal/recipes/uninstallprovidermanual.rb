include_recipe 'powershell::powershell5'
ps_get_provider_name = 'PowerShellGet'

if ::Windows::VersionHelper.nt_version(node) < 10
  ps_get_provider_name = 'PSModule'
end


powershell_package_provider 'NuGet' do
  file_name 'nuget-anycpu.exe'
  file_source 'https://az818661.vo.msecnd.net/providers/nuget-anycpu-2.8.5.127.exe'
  file_checksum '2dea5ef5cfc0fd13ad9e93709d33467111bb00e93c50f904a04ed476c2b2b8fa'
  action :install_manual
end
powershell_package_provider ps_get_provider_name

powershell_package_source 'ExampleSource' do
  package_provider ps_get_provider_name
  location 'https://www.example.com/'
  action :update
end

powershell_package_source 'PSGallery' do
  location 'https://www.powershellgallery.com/api/v2/'
  package_provider ps_get_provider_name
  trusted true
  action :update
end

powershell_package 'xTimeZone' do
  source 'PSGallery'
  version '1.3.0.0'
  action :install
end

powershell_package 'xTimeZone' do
  version '1.3.0.0'
  action :uninstall
end

powershell_package_source 'ExampleSource' do
  package_provider ps_get_provider_name
  action :unregister
end

powershell_package_provider 'NuGet' do
  file_name 'nuget-anycpu.exe'
  file_source 'https://az818661.vo.msecnd.net/providers/nuget-anycpu-2.8.5.127.exe'
  file_checksum '2dea5ef5cfc0fd13ad9e93709d33467111bb00e93c50f904a04ed476c2b2b8fa'
  action :uninstall_manual
end
