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
  default['powershell']['powershell5']['version'] = '5.0.10514.6'
  default['ms_dotnet']['v4']['version'] = '4.5.2'

  case node['platform_version'].split('.')[0..1].join('.')
  when '6.1'
    case node['kernel']['machine']
    when 'i386'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/3/F/D/3FD04B49-26F9-4D9A-8C34-4533B9D5B020/Win7AndW2K8R2-KB3066439-x86.msu'
      default['powershell']['powershell5']['checksum'] = '8f019d7444b0995fe78bfc41115535c1f08ed9b08cd80f188d148bcd6c29d236'
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/3/F/D/3FD04B49-26F9-4D9A-8C34-4533B9D5B020/Win7AndW2K8R2-KB3066439-x64.msu'
      default['powershell']['powershell5']['checksum'] = '1c068cb6e342c2bc789bb009bc50d1bddc37e313106f696521c0b27b7cec3364'
    end
    default['powershell']['powershell5']['timeout'] = 2700
  when '6.2'
    case node['kernel']['machine']
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/3/F/D/3FD04B49-26F9-4D9A-8C34-4533B9D5B020/W2K12-KB3066438-x64.msu'
      default['powershell']['powershell5']['checksum'] = '281d85ec2317240f260f6a42c2c5c9dfbddfdb3bc361950f1ec29a7c06b8c857'
    end
    default['powershell']['powershell5']['timeout'] = 2700
  when '6.3'
    case node['kernel']['machine']
    when 'i386'
      default['powershell']['powershell5']['url'] = 'http://download.microsoft.com/download/3/F/D/3FD04B49-26F9-4D9A-8C34-4533B9D5B020/Win8.1AndW2K12R2-KB3066437-x86.msu'
      default['powershell']['powershell5']['checksum'] = '0810a0eebf2239adde959561be8550f923ffb00e8b7d3a843143261937a0a5ab'
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'http://download.microsoft.com/download/3/F/D/3FD04B49-26F9-4D9A-8C34-4533B9D5B020/Win8.1AndW2K12R2-KB3066437-x64.msu'
      default['powershell']['powershell5']['checksum'] = '9c57302ff0515a6b7eb53ab07bed0f5d420bd7204296d9f3fd17452fca1d5b3d'
    end
    default['powershell']['powershell5']['timeout'] = 600
  end
end
