require 'spec_helper'

describe 'powershell::dsc' do
  let(:chef_run) { ChefSpec::Runner.new(platform: 'windows', version: '2012').converge(described_recipe) }

  before do
    @command = "Environment 'testdsc'\n{\n  Name = 'TESTDSC'\n  Value = 'Test Success'\n}\n"
    @shell_obj = double(:exitstatus => 1)
  end

  it 'runs dsc_script' do
    expect(chef_run).to include_recipe('powershell::powershell4')
    expect(chef_run).to include_recipe('powershell::winrm')

    expect(chef_run).to run_dsc_script('test dsc').with(code: @command)
  end
end
