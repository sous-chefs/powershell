require 'spec_helper'

describe 'powershell::winrm' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012').converge(described_recipe)
  end

  before do
    winrm_cmd = double('winrm_cmd', run_command: nil, stdout: 'Transport = HTTPS')
    allow(Mixlib::ShellOut).to receive(:new).with('powershell.exe winrm enumerate winrm/config/listener').and_return winrm_cmd
  end

  it 'installs windows package windows managemet framework core 5.0' do
    expect(chef_run).to run_powershell_script('enable winrm').with(code: "      winrm quickconfig -q\n")
  end
end
