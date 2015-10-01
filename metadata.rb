name 'powershell'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs/Configures PowerShell on the Windows platform'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.2.0'

recipe 'powershell::default', 'Does nothing; choose the right version of Powershell by selecting the correct recipe'
recipe 'powershell::powershell2', 'Installs PowerShell 2.0'
recipe 'powershell::powershell3', 'Installs PowerShell 3.0'
recipe 'powershell::powershell4', 'Installs PowerShell 4.0'
recipe 'powershell::powershell5', 'Installs PowerShell 5.0'
recipe 'powershell::winrm', 'Configures WinRM'
recipe 'powershell::dsc', 'Desired State Configuration'
recipe 'powershell::enable_lcm', 'Configures LocalConfigurationManager (LCM).'
recipe 'powershell::enable_dsc_script', 'Alias for powershell::enable_lcm recipe.'
recipe 'powershell::disable_lcm', 'Disables LocalConfigurationManager (LCM).'

supports 'windows'
depends 'windows', '>= 1.2.8'
depends 'ms_dotnet45'
depends 'ms_dotnet4'
depends 'ms_dotnet2'
depends 'chef_handler'

source_url 'https://github.com/chef-cookbooks/powershell' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/powershell/issues' if respond_to?(:issues_url)
