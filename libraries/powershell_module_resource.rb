#
# Author:: Siddheshwar More (<siddheshwar.more@clogeny.com>)
#
# Copyright:: 2014-2018, Chef Software, Inc
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

require 'chef'
require_relative 'powershell_module_provider'

class PowershellModule < Chef::Resource::Package
  resource_name :powershell_module
  provides :powershell_module

  allowed_actions :install, :uninstall
  default_action :install

  property :destination, String, default: "#{ENV['PROGRAMW6432']}/WindowsPowerShell/Modules/"
  property :source, String, name_property: true
  property :enabled, [TrueClass, FalseClass]
end
