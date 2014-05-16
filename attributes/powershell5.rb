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
      default['powershell']['powershell5']['url'] = 'http://download.microsoft.com/download/5/5/2/55277C4B-75D1-40FB-B99C-4EAFA249F645/WindowsBlue-KB2894868-x86.msu'
      default['powershell']['powershell5']['checksum'] = 'd552a5747b2e11bc782e2b13d85468da14384b4a608b9cb44f40cc6c85ad2f76'
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'http://download.microsoft.com/download/5/5/2/55277C4B-75D1-40FB-B99C-4EAFA249F645/WindowsBlue-KB2894868-x64.msu'
      default['powershell']['powershell5']['checksum'] = 'fae8c9c62b834770df385e0634592d62992b2ee8ad4cd31b7ba52248911b2a07'
    end
  end
end
