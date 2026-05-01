# frozen_string_literal: true

name              'powershell'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Provides custom resources for installing legacy Windows Management Framework releases and configuring DSC prerequisites.'
version           '7.0.1'
source_url        'https://github.com/sous-chefs/powershell'
issues_url        'https://github.com/sous-chefs/powershell/issues'
chef_version      '>= 15.3'

supports 'windows'

depends 'ms_dotnet', '>= 3.2.1'
