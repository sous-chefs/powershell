#
# Author:: Julian C. Dunn (<jdunn@getchef.com>)
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
      default['powershell']['powershell5']['url'] = 'http://download.microsoft.com/download/3/7/0/3703817C-26C8-4D6D-9CF0-548E589EFCD8/Windows8.1-KB2894868-x86.msu'
      default['powershell']['powershell5']['checksum'] = 'ca8526023e0090b442d07b093484cab6aede9110679e99fbd7b6f764985cae77'
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'http://download.microsoft.com/download/3/7/0/3703817C-26C8-4D6D-9CF0-548E589EFCD8/Windows8.1-KB2894868-x64.msu'
      default['powershell']['powershell5']['checksum'] = '116f49e5bead7aa9fe71b37db3b0cc25a57091bf4a38840a735619d2819e292f'
    end
  end
end
