#
# Author:: Julian C. Dunn (<jdunn@chef.io>)
# Cookbook Name:: powershell
# Recipe:: powershell5
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

# PowerShell 5.0 RTM Download Page
# https://www.microsoft.com/en-us/download/details.aspx?id=50395
case node['platform']
when 'windows'

  if ::Windows::VersionHelper.nt_version(node) >= 6.1
    include_recipe 'powershell::powershell2'

    include_recipe 'powershell::windows_reboot' unless node['powershell']['installation_reboot_mode'] == 'no_reboot'

    windows_package 'Windows Management Framework Core 5.0' do # ~FC009
      source node['powershell']['powershell5']['url']
      checksum node['powershell']['powershell5']['checksum']
      installer_type :custom
      options '/quiet /norestart'
      timeout node['powershell']['powershell5']['timeout']
      action :install
      success_codes [0, 42, 127, 3010, 2_359_302]
      # Note that the :immediately is to immediately notify the other resource,
      # not to immediately reboot. The windows_reboot 'notifies' does that.
      notifies :request, 'windows_reboot[powershell]', :immediately if reboot_pending? && node['powershell']['installation_reboot_mode'] != 'no_reboot'
      not_if { ::Powershell::VersionHelper.powershell_version?(node['powershell']['powershell5']['version']) }
    end

  else
    Chef::Log.warn("PowerShell 5.0 is not supported or already installed on this version of Windows: #{node['platform_version']}")
  end

else
  Chef::Log.warn('PowerShell 5.0 can only be installed on the Windows platform.')
end
