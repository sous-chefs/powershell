# frozen_string_literal: true

provides :powershell_wmf
unified_mode true

property :version, String, name_property: true, equal_to: %w(2.0 3.0 4.0 5.1)
property :download_url, String
property :checksum, String
property :package, String
property :timeout, Integer
property :dotnet_version, String
property :reboot_mode, String, default: 'no_reboot', equal_to: %w(no_reboot immediate_reboot delayed_reboot)
property :reboot_timeout_seconds, Integer, default: 10

default_action :install

action_class do
  include Powershell::Helpers

  def default_dotnet_version
    case new_resource.version
    when '3.0'
      '4.0'
    when '4.0', '5.1'
      '4.5'
    end
  end

  def requested_dotnet_version
    new_resource.dotnet_version || default_dotnet_version
  end

  def install_dotnet_dependency
    case new_resource.version
    when '3.0', '4.0', '5.1'
      if new_resource.version == '4.0' && Gem::Version.new(requested_dotnet_version) < Gem::Version.new('4.5')
        raise 'dotnet_version must be 4.5 or newer when installing PowerShell 4.0'
      end

      node.override['ms_dotnet']['v4']['version'] = requested_dotnet_version
      include_recipe 'ms_dotnet::ms_dotnet4'
    end
  end

  def installer_details
    defaults = wmf_download_details(new_resource.version)

    {
      url: new_resource.download_url || defaults[:url],
      checksum: new_resource.checksum || defaults[:checksum],
      package: new_resource.package || defaults[:package],
      timeout: new_resource.timeout || defaults[:timeout] || 600,
    }
  end

  def declare_reboot_resource
    return unless requested_reboot?

    reboot 'powershell reboot' do
      reason "PowerShell #{new_resource.version} installation requires a reboot"
      delay_mins [(new_resource.reboot_timeout_seconds / 60.0).ceil, 1].max
      action :nothing
    end
  end

  def maybe_notify_reboot(installer)
    return unless requested_reboot?

    installer.notifies reboot_action, 'reboot[powershell reboot]', :immediately
  end

  def unsupported_message
    "PowerShell #{new_resource.version} is not supported or already bundled on Windows #{node['platform_version']}"
  end
end

action :install do
  unless platform_family?('windows')
    Chef::Log.warn("PowerShell #{new_resource.version} can only be installed on the Windows platform.")
    return
  end

  unless supported_wmf_version?(new_resource.version)
    Chef::Log.warn(unsupported_message)
    return
  end

  if bundled_wmf?(new_resource.version)
    Chef::Log.warn("PowerShell #{new_resource.version} is bundled with Windows #{node['platform_version']}")
    return
  end

  install_dotnet_dependency
  declare_reboot_resource

  case new_resource.version
  when '2.0'
    windows_feature powershell_feature_name do
      action :install
    end

    windows_feature powershell_feature_wow64_name do
      action :install
      only_if { wow64? }
    end
  when '3.0'
    details = installer_details

    windows_package 'Windows Management Framework Core 3.0' do
      source details[:url]
      checksum details[:checksum]
      installer_type :custom
      options '/quiet /norestart'
      returns [0, 42, 127, 3010, 2_359_302]
      action :install
      not_if { Powershell::VersionHelper.powershell_version?('3.0') }
      only_if { !details[:url].nil? && !details[:checksum].nil? }

      maybe_notify_reboot(self)
    end
  when '4.0'
    details = installer_details

    windows_package 'Windows Management Framework Core 4.0' do
      source details[:url]
      checksum details[:checksum]
      installer_type :custom
      options '/quiet /norestart'
      returns [0, 42, 127, 3010, 2_359_302]
      action :install
      not_if { Powershell::VersionHelper.powershell_version?('4.0') }
      only_if { !details[:url].nil? && !details[:checksum].nil? }

      maybe_notify_reboot(self)
    end
  when '5.1'
    details = installer_details

    if nt_version == '6.1'
      remote_file "#{Chef::Config[:file_cache_path]}\\wmf51.zip" do
        source details[:url]
        checksum details[:checksum]
        action :create
        not_if { Powershell::VersionHelper.powershell_version?('5.1') }
      end

      archive_file "#{Chef::Config[:file_cache_path]}\\wmf51.zip" do
        destination "#{Chef::Config[:file_cache_path]}\\wmf51"
        overwrite true
        action :extract
        not_if { Powershell::VersionHelper.powershell_version?('5.1') }
      end

      msu_package 'Windows Management Framework Core 5.1' do
        source "#{Chef::Config[:file_cache_path]}\\wmf51\\#{details[:package]}"
        timeout details[:timeout]
        ignore_failure true
        action :install
        not_if { Powershell::VersionHelper.powershell_version?('5.1') }

        maybe_notify_reboot(self)
      end
    else
      msu_package 'Windows Management Framework Core 5.1' do
        source details[:url]
        checksum details[:checksum]
        timeout details[:timeout]
        ignore_failure true
        action :install
        not_if { Powershell::VersionHelper.powershell_version?('5.1') }
        only_if { !details[:url].nil? && !details[:checksum].nil? }

        maybe_notify_reboot(self)
      end
    end
  end
end
