#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: powershell
# Recipe:: powershell2
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

# PowerShell 2.0 Download Page
# http://support.microsoft.com/kb/968929/en-us

if platform_family?('windows')

  nt_version = ::Windows::VersionHelper.nt_version(node)

  include_recipe 'ms_dotnet::ms_dotnet2'

  if nt_version.between?(6.1, 6.2) && ::Windows::VersionHelper.core_version?(node)
    feature_suffix = 'V2' if nt_version == 6.2

    windows_feature "MicrosoftWindowsPowerShell#{feature_suffix}" do
      action :install
    end

    windows_feature "MicrosoftWindowsPowerShell#{feature_suffix}-WOW64" do
      action :install
      only_if { node['kernel']['machine'] == 'x86_64' }
    end
  else
    Chef::Log.warn("PowerShell 2.0 is not supported or already installed on this version of Windows: #{node['platform_version']}")
  end
else
  Chef::Log.warn('PowerShell 2.0 can only be installed on the Windows platform.')
end
