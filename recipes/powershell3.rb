#
# Author:: Julian C. Dunn (<jdunn@getchef.com>)
# Cookbook Name:: powershell
# Recipe:: powershell3
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

# PowerShell 3.0 Download Page
# http://www.microsoft.com/en-us/download/details.aspx?id=34595

case node['platform']
when 'windows'

  require 'chef/win32/version'
  windows_version = Chef::ReservedNames::Win32::Version.new

  if windows_version.windows_server_2008? || windows_version.windows_server_2008_r2? || windows_version.windows_7?

    # For Windows Server 2008 ensure that Powershell 2 is already installed and so is BITS 4.0
    if windows_version.windows_server_2008?
      include_recipe 'powershell::powershell2'

      if node['kernel']['machine'] == 'i386'
        bits_4_package = 'http://download.microsoft.com/download/8/F/9/8F917766-5CBA-4B9A-81FB-10A97E851392/Windows6.0-KB960568-x86.msu'
        bits_4_checksum = '1df0d8ef257927b032990eb2da9690527d236e0b50ceadb5f476db632514985d'
      else
        bits_4_package = 'http://download.microsoft.com/download/D/D/3/DD3CECA2-0866-4DFB-9873-16B5F354EB9F/Windows6.0-KB960568-x64.msu'
        bits_4_checksum = 'bca64cef08156b50d8d5ae7f3c29ed88f90ddd0a73594bbb29c74c87b18ff893'
      end
      windows_package 'Windows Management Framework Bits' do
        source bits_4_package
        checksum bits_4_checksum
        installer_type :custom
        options '/quiet /norestart'
        action :install
      end
    end

    # WMF 3.0 requires .NET 4.0
    include_recipe 'ms_dotnet4'

    windows_package 'Windows Management Framework Core 3.0' do
      source node['powershell']['powershell3']['url']
      checksum node['powershell']['powershell3']['checksum']
      installer_type :custom
      options '/quiet /norestart'
      action :install
      not_if do
        begin
          registry_data_exists?('HKLM\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine', { :name => 'PowerShellVersion', :type => :string, :data => '3.0' }) 
        rescue Chef::Exceptions::Win32RegKeyMissing
          # whole tree is missing if Powershell 3 not installed; that's okay
          false
        end
      end
    end
  else
    Chef::Log.warn("PowerShell 3.0 is not supported or already installed on this version of Windows: #{node['platform_version']}")
  end
else
  Chef::Log.warn('PowerShell 3.0 can only be installed on the Windows platform.')
end
