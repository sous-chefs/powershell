#
# Author:: Julian C. Dunn (<jdunn@chef.io>)
# Cookbook:: powershell
# Recipe:: powershell3
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

# PowerShell 3.0 Download Page
# http://www.microsoft.com/en-us/download/details.aspx?id=34595

if platform_family?('windows')

  nt_version = ::Windows::VersionHelper.nt_version(node)

  # Powershell 3.0 is only compatible with:
  # * Windows NT 6.1 (Windows Server 2008R2 & Windows 7.1)
  if nt_version == 6.1

    # WMF 3.0 requires .NET 4.0
    include_recipe 'ms_dotnet::ms_dotnet4'

    # Reboot if user specifies doesn't specify no_reboot
    include_recipe 'powershell::windows_reboot' unless node['powershell']['installation_reboot_mode'] == 'no_reboot'

    windows_package 'Windows Management Framework Core 3.0' do # ~FC009
      source node['powershell']['powershell3']['url']
      checksum node['powershell']['powershell3']['checksum']
      installer_type :custom
      options '/quiet /norestart'
      returns [0, 42, 127, 3010, 2_359_302]
      action :install
      # Note that the :immediately is to immediately notify the other resource,
      # not to immediately reboot. The windows_reboot 'notifies' does that.
      notifies :reboot_now, 'reboot[powershell]', :immediately if node['powershell']['installation_reboot_mode'] != 'no_reboot'
      not_if { ::Powershell::VersionHelper.powershell_version?('3.0') }
    end
  else
    Chef::Log.warn("PowerShell 3.0 is not supported or already installed on this version of Windows: #{node['platform_version']}")
  end
else
  Chef::Log.warn('PowerShell 3.0 can only be installed on the Windows platform.')
end
