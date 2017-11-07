#
# Author:: Julian C. Dunn (<jdunn@chef.io>)
# Cookbook:: powershell
# Recipe:: powershell5
#
# Copyright:: 2014-2017, Chef Software, Inc.
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

# PowerShell 5.0 RTM Download Page
# https://www.microsoft.com/en-us/download/details.aspx?id=50395

if platform_family?('windows')

  include_recipe 'ms_dotnet::ms_dotnet4'
  include_recipe 'powershell::windows_reboot' unless node['powershell']['installation_reboot_mode'] == 'no_reboot'

  if ::Windows::VersionHelper.nt_version(node) == 6.1

    # For some reason, MSFT decided to ship the Win7/2008R2 version as a zip
    # with a helper script for installing it, which we don't need
    # thanks to the magic of the preceeding resources.

    windows_zipfile "#{Chef::Config['file_cache_path']}\\wmf51" do
      source node['powershell']['powershell5']['url']
      checksum node['powershell']['powershell5']['checksum']
      action :unzip
      not_if { ::Powershell::VersionHelper.powershell_version?(node['powershell']['powershell5']['version']) }
    end

    windows_package 'Windows Management Framework Core 5.1' do # ~FC009
      source "#{Chef::Config['file_cache_path']}\\wmf51\\Win7AndW2K8R2-KB3191566-x64.msu"
      installer_type :custom
      options '/quiet /norestart'
      timeout node['powershell']['powershell5']['timeout']
      action :install
      returns [0, 42, 127, 3010, 2_359_302]
      # Note that the :immediately is to immediately notify the other resource,
      # not to immediately reboot. The windows_reboot 'notifies' does that.
      notifies :reboot_now, 'reboot[powershell]', :immediately if node['powershell']['installation_reboot_mode'] != 'no_reboot'
      not_if { ::Powershell::VersionHelper.powershell_version?(node['powershell']['powershell5']['version']) }
    end

  elsif ::Windows::VersionHelper.nt_version(node) > 6.1

    windows_package 'Windows Management Framework Core 5.1' do # ~FC009
      source node['powershell']['powershell5']['url']
      checksum node['powershell']['powershell5']['checksum']
      installer_type :custom
      options '/quiet /norestart'
      timeout node['powershell']['powershell5']['timeout']
      action :install
      returns [0, 42, 127, 3010, 2_359_302]
      # Note that the :immediately is to immediately notify the other resource,
      # not to immediately reboot. The windows_reboot 'notifies' does that.
      notifies :reboot_now, 'reboot[powershell]', :immediately if node['powershell']['installation_reboot_mode'] != 'no_reboot'
      not_if { ::Powershell::VersionHelper.powershell_version?(node['powershell']['powershell5']['version']) }
    end

  else
    Chef::Log.warn("PowerShell 5.0 is not supported on this version of Windows: #{node['platform_version']}")
  end

else
  Chef::Log.warn('PowerShell 5.0 can only be installed on the Windows platform.')
end
