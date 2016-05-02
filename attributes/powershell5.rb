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
  default['powershell']['powershell5']['version'] = '5.0.10586.117'

  case node['platform_version'].split('.')[0..1].join('.')
  when '6.1'
    case node['kernel']['machine']
    when 'i386'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7-KB3134760-x86.msu'
      default['powershell']['powershell5']['checksum'] = '0486901b4fd9c41a70644e3a427fe06dd23765f1ad8b45c14be3321203695464'
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7AndW2K8R2-KB3134760-x64.msu'
      default['powershell']['powershell5']['checksum'] = '077e864cc83739ac53750c97a506e1211f637c3cd6da320c53bb01ed1ef7a98b'
    end
    default['powershell']['powershell5']['timeout'] = 2700
  when '6.2'
    case node['kernel']['machine']
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K12-KB3134759-x64.msu'
      default['powershell']['powershell5']['checksum'] = '6e59cec4bd30c505f426a319673a13c4a9aa8d8ff69fd0582bfa89f522f5ff00'
    end
    default['powershell']['powershell5']['timeout'] = 2700
  when '6.3'
    case node['kernel']['machine']
    when 'i386'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1-KB3134758-x86.msu'
      default['powershell']['powershell5']['checksum'] = 'f9ee4bf2d826827bc56cd58fabd0529cb4b49082b2740f212851cc0cc4acba06'
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1AndW2K12R2-KB3134758-x64.msu'
      default['powershell']['powershell5']['checksum'] = 'bb6af4547545b5d10d8ef239f47d59de76daff06f05d0ed08c73eff30b213bf2'
    end
    default['powershell']['powershell5']['timeout'] = 600
  end
end
