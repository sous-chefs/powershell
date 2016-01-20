#
# Author:: Trevor Hess (<trevor.ghess@gmail.com>)
# Cookbook Name:: powershell
# Recipe::install_nuget_provider_manual
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

file_source = node['powershell']['nuget_provider']['source']
file_checksum = node['powershell']['nuget_provider']['checksum']

directory "#{ENV['ProgramW6432']}\\PackageManagement\\ProviderAssemblies" do
  recursive true
  action :create
end

remote_file "#{ENV['ProgramW6432']}\\PackageManagement\\ProviderAssemblies\\nuget-anycpu.exe" do
  source file_source
  checksum file_checksum
  action :create_if_missing
end
