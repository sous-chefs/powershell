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

  provides :powershell_module, :on_platforms => ["windows"]

  def initialize(name, run_context)
    super
    @resource_name = :powershell_module
    @module_path = nil
    @download_from = nil
    @allowed_actions.push(:install)
    @action = :install
    provider(PowershellModuleProvider)
  end

  def module_path(arg=nil)
    set_or_return(
      :module_path,
      arg,
      :kind_of => String
    )
  end

  def module_name(arg=nil)
    set_or_return(
      :module_name,
      arg,
      :kind_of => String,
      :name_attribute => true
    )
  end

  def download_from(arg=nil)
    set_or_return(
      :download_from,
      arg,
      :kind_of => String
    )
  end    
end