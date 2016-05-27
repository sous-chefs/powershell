#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook Name:: powershell
# Recipe:: powershell2
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

# PowerShell 2.0 Download Page
# http://support.microsoft.com/kb/968929/en-us

case node['platform']
when 'windows'
  nt_version = ::Windows::VersionHelper.nt_version(node)

  include_recipe 'ms_dotnet::ms_dotnet2'

  if nt_version.between?(6.1, 6.2) && ::Windows::VersionHelper.core_version?(node)
    feature_suffix = 'V2' if nt_version == 6.2

    windows_feature "MicrosoftWindowsPowerShell#{feature_suffix}" do
      action :install
    end

    windows_feature "MicrosoftWindowsPowerShell#{feature_suffix}-WOW64" do
      action :install
      only_if { node['kernel']['machine'] == 'x86_64' }
    end

  # WMF 2.0 is required and only compatible with:
  # * Windows NT 5.1 & 5.2 (Windows Server 2003 & Windows XP)
  # * Windows NT 6.0 server (Windows Server 2008 SP2 not vista)
  elsif nt_version.between?(5.1, 5.2) || (nt_version == 6.0 && ::Windows::VersionHelper.server_version?(node))
    # Reboot if user doesn't specify no_reboot
    include_recipe 'powershell::windows_reboot' unless node['powershell']['installation_reboot_mode'] == 'no_reboot'

    windows_package 'Windows Management Framework Core' do # ~FC009
      source node['powershell']['powershell2']['url']
      checksum node['powershell']['powershell2']['checksum']
      installer_type :custom
      options '/quiet /norestart'
      success_codes [0, 42, 127, 3010, 2_359_302]
      action :install
      # Note that the :immediately is to immediately notify the other resource,
      # not to immediately reboot. The windows_reboot 'notifies' does that.
      notifies :request, 'windows_reboot[powershell]', :immediately if reboot_pending? && node['powershell']['installation_reboot_mode'] != 'no_reboot'
      not_if { ::Powershell::VersionHelper.powershell_version?('2.0') }
    end
  else
    Chef::Log.warn("PowerShell 2.0 is not supported or already installed on this version of Windows: #{node['platform_version']}")
  end
else
  Chef::Log.warn('PowerShell 2.0 can only be installed on the Windows platform.')
end
