#
# Author:: Siddheshwar More (<siddheshwar.more@clogeny.com>)
#
# Copyright:: 2014, Chef, Inc.
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
  state_attrs :enabled

  provides :powershell_module, :on_platforms => ['windows']

  def initialize(name, run_context = nil)
    super
    @resource_name = :powershell_module
    @allowed_actions.push(:install)
    @allowed_actions.push(:uninstall)
    @action = :install
    provider(PowershellModuleProvider)

    # resource default attributes
    @destination = "#{ENV['PROGRAMW6432']}/WindowsPowerShell/Modules/"
    @source = name
    @enabled = nil
  end

  def destination(arg = nil)
    set_or_return(:destination, arg, :kind_of => String)
  end

  def enabled(arg = nil)
    set_or_return(
      :enabled,
      arg,
      :kind_of => [TrueClass, FalseClass]
    )
  end
end
