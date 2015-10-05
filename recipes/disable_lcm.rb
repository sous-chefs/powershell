#
# Author:: Aliasgar Batterywala (<aliasgar.batterywala@clogeny.com>)
# Cookbook Name:: powershell
# Recipe:: disable_lcm
#
# Copyright:: Copyright (c) 2015 Chef Software, Inc.
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

include_recipe 'powershell::powershell5'
include_recipe 'powershell::dsc'

case node['platform']
when 'windows'

  directory 'Creating temporary directory to store LCM MOF files' do
    path node['lcm']['mof']['temp_dir']
    rights :read, 'Everyone'
    action :create
  end

  powershell_script 'Disable LCM' do
    code <<-EOH

      Configuration DisableLCM
      {
        Node "localhost"
        {
          LocalConfigurationManager
          {
            RefreshMode = "#{node['lcm']['config']['disable']['refresh_mode']}"
          }
        }
      }

      DisableLCM -OutputPath "#{node['lcm']['mof']['temp_dir']}"

      Set-DscLocalConfigurationManager -Path "#{node['lcm']['mof']['temp_dir']}"
    EOH
    not_if <<-EOH
      $LCM = (Get-DscLocalConfigurationManager)
      $LCM.RefreshMode -eq "#{node['lcm']['config']['disable']['refresh_mode']}"
    EOH
  end

  directory 'Deleting temporary directory which stored LCM MOF files' do
    path node['lcm']['mof']['temp_dir']
    recursive true
    action :delete
  end
else
  Chef::Log.warn('LCM configuration can only be executed on the Windows platform.')
end
