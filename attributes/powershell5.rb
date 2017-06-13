#
# Author:: Julian C. Dunn (<jdunn@chef.io>)
# Cookbook:: powershell
# Attribute:: powershell5
#
# Copyright:: 2014-2017, Chef Software, Inc.
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
  default['powershell']['powershell5']['version'] = '5.1'

  # Make sure .NET 4.5 (minimum) is available.
  default['ms_dotnet']['v4']['version'] = '4.5'

  case node['platform_version'].split('.')[0..1].join('.')
  when '6.1'
    case node['kernel']['machine']
    when 'i386'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7-KB3191566-x86.zip'
      default['powershell']['powershell5']['checksum'] = 'eb7e2c4ce2c6cb24206474a6cb8610d9f4bd3a9301f1cd8963b4ff64e529f563'
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip'
      default['powershell']['powershell5']['checksum'] = 'f383c34aa65332662a17d95409a2ddedadceda74427e35d05024cd0a6a2fa647'
    end
    default['powershell']['powershell5']['timeout'] = 2700
  when '6.2'
    case node['kernel']['machine']
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/W2K12-KB3191565-x64.msu'
      default['powershell']['powershell5']['checksum'] = '4a1385642c1f08e3be7bc70f4a9d74954e239317f50d1a7f60aa444d759d4f49'
    end
    default['powershell']['powershell5']['timeout'] = 2700
  when '6.3'
    case node['kernel']['machine']
    when 'i386'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1-KB3191564-x86.msu'
      default['powershell']['powershell5']['checksum'] = 'f3430a90be556a77a30bab3ac36dc9b92a43055d5fcc5869da3bfda116dbd817'
    when 'x86_64'
      default['powershell']['powershell5']['url'] = 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu'
      default['powershell']['powershell5']['checksum'] = 'a8d788fa31b02a999cc676fb546fc782e86c2a0acd837976122a1891ceee42c0'
    end
    default['powershell']['powershell5']['timeout'] = 600
  else
    default['powershell']['powershell5']['timeout'] = 600
  end
end
