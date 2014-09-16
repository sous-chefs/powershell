#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: powershell
# Attribute:: default
#
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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
  # INSTALLATION_REBOOT_MODE = "no_reboot". It skips reboot required after powershell installation.
  # INSTALLATION_REBOOT_MODE = "immediate_reboot". Used for immediate node reboot after powershell installation.
  # INSTALLATION_REBOOT_MODE = "delayed_reboot". Used for node reboot after chef-client run.
  default['powershell']['installation_reboot_mode'] = ENV['INSTALLATION_REBOOT_MODE'] || "no_reboot"
end