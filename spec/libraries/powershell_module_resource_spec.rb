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

require_relative '../../libraries/powershell_module_resource'

describe 'PowershellModule' do
  before(:all) do
    ohai_reader = Ohai::System.new
    ohai_reader.all_plugins('platform')

    new_node = Chef::Node.new
    new_node.consume_external_attrs(ohai_reader.data, {})

    events = Chef::EventDispatch::Dispatcher.new

    @run_context = Chef::RunContext.new(new_node, {}, events)
  end

  let(:new_resource) do
    PowershellModule.new('testmodule', @run_context)
  end

  it 'creates powershell module resource object' do
    expect(new_resource.name).to eq('testmodule')
  end

  it 'allowed install actions' do
    expect(new_resource.allowed_actions.include?(:install)).to eq(true)
  end

  it 'have provider PowershellModuleProvider' do
    expect(new_resource.provider).to eq(PowershellModuleProvider)
  end

  it 'sets destination' do
    new_resource.destination('C:/temp')
    expect(new_resource.destination).to eq('C:/temp')
  end
end
