#
# Author:: Siddheshwar More (<siddheshwar.more@clogeny.com>)
# Cookbook Name:: powershell
# Recipe:: powershell_module
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

# This recipe required following environment variables to be set
# ps_module_name = Its powershell module name.
# ps_module_path = Its local path of module.
# ps_module_url = Its remote url of module.
# ps_module_action = Its 'install' or 'uninstall' action

if ENV['ps_module_action'] == "install"
  powershell_module "install local powershell module" do
    module_name ENV['ps_module_name']
    module_path ENV['ps_module_path']
    action :install
  end

  powershell_module "install powershell module from remote" do
    module_name ENV['ps_module_name']
    download_from ENV['ps_module_url']
    action :install
  end
end

if ENV['ps_module_action'] == "uninstall"
  powershell_module "uninstall powershell module" do
    module_name ENV['ps_module_name']
    action :uninstall
  end
end