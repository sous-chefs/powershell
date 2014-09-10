#
# Author:: Mukta Aphale (<mukta.aphale@clogeny.com>)
# Cookbook Name:: powershell
# Recipe:: winrm
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

case node['platform']
when 'windows'

  # Check if winrm is already configured. if not then configure
  # Alternative way to check winrm config to the one below is - Use command Get-DSCResource
    powershell "enable winrm" do
      code <<-EOH
      $result = winrm get winrm/config
      if ($result -match "Error")
      {
        winrm quickconfig -q
        winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"}
        winrm set winrm/config @{MaxTimeoutms="1800000"}
        winrm set winrm/config/service @{AllowUnencrypted="false"}
        winrm set winrm/config/service/auth @{Basic="true"}
        netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" profile=public protocol=tcp localport=5985 remoteip=localsubnet new remoteip=any
      }
      EOH
    end

else
  Chef::Log.warn('WinRM can only be enabled on the Windows platform.')
end
