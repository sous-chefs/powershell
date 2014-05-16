#
# Author:: Julian C. Dunn (<jdunn@getchef.com>)
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

# PowerShell 5.0 Preview Download Page
# http://www.microsoft.com/en-us/download/details.aspx?id=42316

include_recipe 'powershell::powershell2'

case node['platform']
when 'windows'

  require 'chef/win32/version'
  windows_version = Chef::ReservedNames::Win32::Version.new

  if windows_version.windows_server_2012_r2? || windows_version.windows_8_1

    windows_package 'Windows Management Framework Core 5.0' do
      source node['powershell']['powershell5']['url']
      checksum node['powershell']['powershell5']['checksum']
      installer_type :custom
      options '/quiet /norestart'
      action :install
      not_if { registry_data_exists?('HKLM\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine', { :name => 'PowerShellVersion', :type => :string, :data => '5.0.9701.0' }) }
    end

  else
    Chef::Log.warn("PowerShell 5.0 is not supported or already installed on this version of Windows: #{node['platform_version']}")
  end

else
  Chef::Log.warn('PowerShell 5.0 can only be installed on the Windows platform.')
end
