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

  # Configure winrm
  # use attributes to add other configuration
  powershell 'enable winrm' do
    code <<-EOH
      winrm quickconfig -q
    EOH
  end
else
  Chef::Log.warn('WinRM can only be enabled on the Windows platform.')
end
