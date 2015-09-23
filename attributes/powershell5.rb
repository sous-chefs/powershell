#
# Author:: Julian C. Dunn (<jdunn@chef.io>)
# Cookbook Name:: powershell
# Attribute:: powershell5
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

if node['platform_family'] == 'windows'
  case node['platform_version'].split('.')[0..1].join('.')
  when '6.3'
    case node['kernel']['machine']
    when 'i386'
      default['powershell']['powershell5']['version'] = '5.0.10514.6'
      default['powershell']['powershell5']['url'] = 'http://download.microsoft.com/download/3/F/D/3FD04B49-26F9-4D9A-8C34-4533B9D5B020/Win8.1AndW2K12R2-KB3066437-x86.msu'
      default['powershell']['powershell5']['checksum'] = '0810a0eebf2239adde959561be8550f923ffb00e8b7d3a843143261937a0a5ab'
    when 'x86_64'
      default['powershell']['powershell5']['version'] = '5.0.10514.6'
      default['powershell']['powershell5']['url'] = 'http://download.microsoft.com/download/3/F/D/3FD04B49-26F9-4D9A-8C34-4533B9D5B020/Win8.1AndW2K12R2-KB3066437-x64.msu'
      default['powershell']['powershell5']['checksum'] = '9c57302ff0515a6b7eb53ab07bed0f5d420bd7204296d9f3fd17452fca1d5b3d'
    end
  end
end
