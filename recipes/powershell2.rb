#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
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

  require 'chef/win32/version'
  windows_version = Chef::ReservedNames::Win32::Version.new

  if (windows_version.windows_server_2012? || windows_version.windows_8?) && windows_version.core?
    # Windows Server 2012 Core does not come with Powershell 2.0 enabled

    windows_feature 'MicrosoftWindowsPowerShellV2' do
      action :install
    end
    windows_feature 'MicrosoftWindowsPowerShellV2-WOW64' do
      action :install
      only_if { node['kernel']['machine'] == 'x86_64' }
    end

  elsif (windows_version.windows_server_2008_r2? || windows_version.windows_7?) && windows_version.core?
    # Windows Server 2008 R2 Core does not come with .NET or Powershell 2.0 enabled

    windows_feature 'NetFx2-ServerCore' do
      action :install
    end
    windows_feature 'NetFx2-ServerCore-WOW64' do
      action :install
      only_if { node['kernel']['machine'] == 'x86_64' }
    end
    windows_feature 'MicrosoftWindowsPowerShell' do
      action :install
    end
    windows_feature 'MicrosoftWindowsPowerShell-WOW64' do
      action :install
      only_if { node['kernel']['machine'] == 'x86_64' }
    end

  elsif windows_version.windows_server_2008? || windows_version.windows_server_2003_r2? ||
        windows_version.windows_server_2003? || windows_version.windows_xp?

    include_recipe 'ms_dotnet2'

    windows_package 'Windows Management Framework Core' do
      source node['powershell']['powershell2']['url']
      checksum node['powershell']['powershell2']['checksum']
      installer_type :custom
      options '/quiet /norestart'
      action :install
      not_if do
        begin
          registry_data_exists?('HKLM\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine', { :name => 'PowerShellVersion', :type => :string, :data => '2.0' })
        rescue Chef::Exceptions::Win32RegKeyMissing
          false
        end
      end
    end
  else
    Chef::Log.warn("PowerShell 2.0 is not supported or already installed on this version of Windows: #{node['platform_version']}")
  end
else
  Chef::Log.warn('PowerShell 2.0 can only be installed on the Windows platform.')
end
