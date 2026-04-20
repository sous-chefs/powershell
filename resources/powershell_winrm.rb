# frozen_string_literal: true

provides :powershell_winrm
unified_mode true

use '_partial/_winrm_listener'

default_action :create

action_class do
  def listener_hostname
    return node['fqdn'] if new_resource.hostname.to_s.empty?

    new_resource.hostname
  end
end

action :create do
  unless platform_family?('windows')
    Chef::Log.warn('WinRM can only be enabled on the Windows platform.')
    return
  end

  powershell_script 'enable winrm' do
    code 'winrm quickconfig -q'
    not_if '(Test-WSMan -ErrorAction SilentlyContinue) -ne $null'
  end

  return unless new_resource.enable_https_transport

  if new_resource.thumbprint.to_s.empty?
    Chef::Log.error('Please specify thumbprint for enabling https transport.')
    return
  end

  powershell_script 'winrm-create-https-listener' do
    code "winrm create 'winrm/config/Listener?Address=*+Transport=HTTPS' '@{Hostname=\"#{listener_hostname}\"; CertificateThumbprint=\"#{new_resource.thumbprint}\"}'"
    not_if "(winrm enumerate winrm/config/listener | Out-String) -match 'Transport = HTTPS'"
  end
end
