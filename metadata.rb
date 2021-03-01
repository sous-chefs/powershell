name              'powershell'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs/Configures PowerShell on the Windows platform'
version           '6.2.1'
source_url        'https://github.com/sous-chefs/powershell'
issues_url        'https://github.com/sous-chefs/powershell/issues'
chef_version      '>= 13.0'

supports 'windows'

depends 'windows', '>= 3.0'
depends 'ms_dotnet', '>= 3.2.1'
