name 'powershell'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs/Configures PowerShell on the Windows platform'
version '6.1.4'

supports 'windows'
depends 'windows', '>= 3.0'
depends 'ms_dotnet', '>= 3.2.1'

source_url 'https://github.com/chef-cookbooks/powershell'
issues_url 'https://github.com/chef-cookbooks/powershell/issues'
chef_version '>= 13.0'
