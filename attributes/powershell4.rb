#
# Author:: Julian C. Dunn (<jdunn@getchef.com>)
# Cookbook Name:: powershell
# Attribute:: powershell4
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
  when '6.1'
    case node['kernel']['machine']
    when 'i386'
      default['powershell']['powershell4']['url'] = 'http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-x86-MultiPkg.msu'
      default['powershell']['powershell4']['checksum'] = 'd5dd77c5cd6370984257c81269ce40f83466d20339e44bb6de40c22d96641b98'
    when 'x86_64'
      default['powershell']['powershell4']['url'] = 'http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-x64-MultiPkg.msu'
      default['powershell']['powershell4']['checksum'] = 'fbc0889528656a3bc096f27434249f94cba12e413142aa38946fcdd8edf6f4c5'
    end
  when '6.2'
    case node['kernel']['machine']
    when 'x86_64'
      default['powershell']['powershell4']['url'] = 'http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows8-RT-KB2799888-x64.msu'
      default['powershell']['powershell4']['checksum'] = 'a68da0b05dbe245510578d9affb60fd624e906d21a57bfa35741a6f677091c66'
    end
  end
end
