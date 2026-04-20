# frozen_string_literal: true

provides :powershell_lcm
unified_mode true

property :temp_dir, String, default: lazy { "#{Chef::Config[:file_cache_path]}\\lcm_mof" }
property :config_mode, String, default: 'ApplyOnly'
property :reboot_node, [true, false], default: false
property :refresh_mode, String, default: 'Push'
property :disabled_refresh_mode, String, default: 'Disabled'

default_action :enable

action_class do
  include Powershell::Helpers

  def powershell_boolean(value)
    value ? '$true' : '$false'
  end

  def enable_lcm_code
    <<~EOH

      Configuration EnableLCM
      {
        Node "localhost"
        {
          LocalConfigurationManager
          {
            ConfigurationMode = "#{new_resource.config_mode}"
            RebootNodeIfNeeded = #{powershell_boolean(new_resource.reboot_node)}
            RefreshMode = "#{new_resource.refresh_mode}"
          }
        }
      }

      EnableLCM -OutputPath "#{new_resource.temp_dir}"

      Set-DscLocalConfigurationManager -Path "#{new_resource.temp_dir}"
    EOH
  end

  def enable_lcm_guard
    <<~EOH
      $LCM = (Get-DscLocalConfigurationManager)
      $LCM.ConfigurationMode -eq "#{new_resource.config_mode}" -and
        $LCM.RefreshMode -eq "#{new_resource.refresh_mode}"
    EOH
  end

  def disable_lcm_code
    <<~EOH

      Configuration DisableLCM
      {
        Node "localhost"
        {
          LocalConfigurationManager
          {
            RefreshMode = "#{new_resource.disabled_refresh_mode}"
          }
        }
      }

      DisableLCM -OutputPath "#{new_resource.temp_dir}"

      Set-DscLocalConfigurationManager -Path "#{new_resource.temp_dir}"
    EOH
  end

  def disable_lcm_guard
    <<~EOH
      $LCM = (Get-DscLocalConfigurationManager)
      $LCM.RefreshMode -eq "#{new_resource.disabled_refresh_mode}"
    EOH
  end
end

action :enable do
  unless platform_family?('windows')
    Chef::Log.warn('LCM configuration can only be executed on the Windows platform.')
    return
  end

  powershell_dsc 'default'

  directory 'Creating temporary directory to store LCM MOF files' do
    path new_resource.temp_dir
    rights :read, 'Everyone'
    action :create
    not_if enable_lcm_guard
  end

  directory 'Deleting temporary directory which stored LCM MOF files' do
    path new_resource.temp_dir
    recursive true
    action :nothing
  end

  powershell_script 'Configure and Enable LCM' do
    code enable_lcm_code
    not_if enable_lcm_guard
    notifies :delete, 'directory[Deleting temporary directory which stored LCM MOF files]', :immediately
  end
end

action :disable do
  unless platform_family?('windows')
    Chef::Log.warn('LCM configuration can only be executed on the Windows platform.')
    return
  end

  powershell_wmf '5.1'
  powershell_dsc 'default'

  directory 'Creating temporary directory to store LCM MOF files' do
    path new_resource.temp_dir
    rights :read, 'Everyone'
    action :create
  end

  powershell_script 'Disable LCM' do
    code disable_lcm_code
    not_if disable_lcm_guard
  end

  directory 'Deleting temporary directory which stored LCM MOF files' do
    path new_resource.temp_dir
    recursive true
    action :delete
  end
end
