name 'powershell'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs/Configures PowerShell on the Windows platform'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '5.0.0'

recipe 'powershell::default', 'Makes sure RubyZip is installed (for powershell_module)'
recipe 'powershell::powershell2', 'Installs PowerShell 2.0'
recipe 'powershell::powershell3', 'Installs PowerShell 3.0'
recipe 'powershell::powershell4', 'Installs PowerShell 4.0'
recipe 'powershell::powershell5', 'Installs PowerShell 5.0'
recipe 'powershell::winrm', 'Configures WinRM'
recipe 'powershell::dsc', 'Desired State Configuration'
recipe 'powershell::enable_lcm', 'Enable the DSC Local Configuration Manager'
recipe 'powershell::disable_lcm', 'Disable the DSC Local Configuration Manager'

supports 'windows'
depends 'windows', '>= 1.44'
depends 'ms_dotnet', '>= 2.6'
depends 'chef_handler'

source_url 'https://github.com/chef-cookbooks/powershell'
issues_url 'https://github.com/chef-cookbooks/powershell/issues'

chef_version '>= 12.1' if respond_to?(:chef_version)
