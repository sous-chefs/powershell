#
# Author:: Julian C. Dunn (<jdunn@chef.io>)
# Cookbook Name:: powershell
# Recipe:: powershell4
#
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# PowerShell 4.0 Download Page
# http://www.microsoft.com/en-us/download/details.aspx?id=40855

if node['platform'] == 'windows'
  require 'chef/win32/version'
  windows_version = Chef::ReservedNames::Win32::Version.new

  if windows_version.windows_server_2008_r2? || windows_version.windows_7? || windows_version.windows_server_2012?

    # Ensure .NET 4.5 is installed or installation will fail silently per Microsoft. Only necessary for Windows 2008R2 or 7.
    include_recipe 'ms_dotnet45' if windows_version.windows_server_2008_r2? || windows_version.windows_7?

    # Reboot if user specifies doesn't specify no_reboot
    include_recipe 'powershell::windows_reboot' unless node['powershell']['installation_reboot_mode'] == 'no_reboot'

    windows_package 'Windows Management Framework Core4.0' do
      source node['powershell']['powershell4']['url']
      checksum node['powershell']['powershell4']['checksum']
      installer_type :custom
      options '/quiet /norestart'
      action :install
      success_codes [0, 42, 127, 3010]
      # Note that the :immediately is to immediately notify the other resource,
      # not to immediately reboot. The windows_reboot 'notifies' does that.
      notifies :request, 'windows_reboot[powershell]', :immediately if reboot_pending? && node['powershell']['installation_reboot_mode'] != 'no_reboot'
      not_if do
        begin
          registry_data_exists?('HKLM\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine', { :name => 'PowerShellVersion', :type => :string, :data => '4.0' })
        rescue Chef::Exceptions::Win32RegKeyMissing
          false
        end
      end
    end
  else
    Chef::Log.warn("PowerShell 4.0 is not supported or already installed on this version of Windows: #{node['platform_version']}")
  end

else
  Chef::Log.warn('PowerShell 4.0 can only be installed on the Windows platform.')
end
