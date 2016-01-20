#
# Author:: Julian C. Dunn (<jdunn@chef.io>)
# Cookbook Name:: powershell
# Attribute:: nuget_provider
#
# Copyright:: Copyright (c) 2016 Chef Software, Inc.
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
  default['powershell']['nuget_provider']['source'] = 'https://az818661.vo.msecnd.net/providers/nuget-anycpu-2.8.5.127.exe'
  default['powershell']['nuget_provider']['checksum'] = '2dea5ef5cfc0fd13ad9e93709d33467111bb00e93c50f904a04ed476c2b2b8fa'
end
