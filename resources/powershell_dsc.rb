# frozen_string_literal: true

provides :powershell_dsc
unified_mode true

use '_partial/_winrm_listener'

default_action :create

action :create do
  unless platform_family?('windows')
    Chef::Log.warn('DSC can only be configured on the Windows platform.')
    return
  end

  powershell_wmf '4.0'

  powershell_winrm new_resource.name do
    enable_https_transport new_resource.enable_https_transport
    thumbprint new_resource.thumbprint
    hostname new_resource.hostname
  end
end
