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

require_relative '../spec_helper.rb'

describe 'PowershellModuleProvider' do
  before do
    @node = Chef::Node.new
    @events = Chef::EventDispatch::Dispatcher.new
    @run_context = Chef::RunContext.new(@node, {}, @events)
    @new_resource = PowershellModule.new('testmodule', @run_context)
    @provider = PowershellModuleProvider.new(@new_resource, @run_context)
  end

  describe 'when installing a module' do
    it 'raise error on module path or download from missing' do
      expect { @provider.run_action(:install) }.to raise_error(ArgumentError, "Required attribute 'destination' or 'source' for module installation") 
    end

    it 'install module' do
     @provider.should_receive(:install_module)
     expect { @provider.run_action(:install) }.to_not raise_error
    end
  end
end
