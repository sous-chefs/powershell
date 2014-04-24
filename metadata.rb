name             'powershell'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@getchef.com'
license          'Apache 2.0'
description      'Installs/Configures PowerShell on the Windows platform'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.0.3'

recipe 'powershell::default', 'Does nothing; choose the right version of Powershell by selecting the correct recipe'
recipe 'powershell::powershell2', 'Installs PowerShell 2.0'
recipe 'powershell::powershell3', 'Installs PowerShell 3.0'
recipe 'powershell::powershell4', 'Installs PowerShell 4.0'

supports         'windows'
depends          'windows', '>= 1.2.8'
depends          'ms_dotnet45'
depends          'ms_dotnet4'
depends          'ms_dotnet2'
