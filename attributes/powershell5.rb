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
      default['powershell']['powershell5']['url'] = 'http://download.microsoft.com/download/E/E/9/EE9AF7A0-83B5-4475-AE56-B4BA40B479E2/WindowsBlue-KB2969050-x86.msu'
      default['powershell']['powershell5']['checksum'] = '5967af18a34b6f19d7a02de626fb8e821351945d5b568ff972ec9eb96cc253cb'
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'http://download.microsoft.com/download/E/E/9/EE9AF7A0-83B5-4475-AE56-B4BA40B479E2/WindowsBlue-KB2969050-x64.msu'
      default['powershell']['powershell5']['checksum'] = 'ce20b76b7d8c287a730f7ffa890af18c553d371ca93fc3567353f576cbb0379c'
    end
  end
end
