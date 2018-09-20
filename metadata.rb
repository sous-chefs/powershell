name 'powershell'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs/Configures PowerShell on the Windows platform'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '6.1.3'

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
depends 'windows', '>= 3.0'
depends 'ms_dotnet', '>= 3.2.1'

source_url 'https://github.com/chef-cookbooks/powershell'
issues_url 'https://github.com/chef-cookbooks/powershell/issues'
chef_version '>= 12.6' if respond_to?(:chef_version)
