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
  default['powershell']['powershell5']['version'] = '5.0.10586.51'

  case node['platform_version'].split('.')[0..1].join('.')
  when '6.1'
    case node['kernel']['machine']
    when 'i386'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7-KB3094176-x86.msu'
      default['powershell']['powershell5']['checksum'] = 'dfac22163aa6c51eaf0f0ae59a3f9632558aa08229350d0f272d742bd02f7109'
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K8R2-KB3094176-x64.msu'
      default['powershell']['powershell5']['checksum'] = '22d4a4ff739a3734e1efa410bd9f745c668c31efeeffa170f7968d42022c641f'
    end
  when '6.2'
    case node['kernel']['machine']
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K12-KB3094175-x64.msu'
      default['powershell']['powershell5']['checksum'] = 'cfda8048978708fe4f31adb6c045e848db4af5decf88f64e38aa511db92e1d49'
    end
  when '6.3'
    case node['kernel']['machine']
    when 'i386'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1-KB3094174-x86.msu'
      default['powershell']['powershell5']['checksum'] = '8e3a1414e57211623c2a6097dbdf982855f2e53fee65859dfa36891bf0be8e87'
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K12R2-KB3094174-x64.msu'
      default['powershell']['powershell5']['checksum'] = 'cfda8048978708fe4f31adb6c045e848db4af5decf88f64e38aa511db92e1d49'
    end
  end
end
