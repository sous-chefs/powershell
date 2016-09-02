require 'spec_helper'
require 'mixlib/shellout'

describe 'powershell::dsc' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012') do |node|
      node.normal['ms_dotnet']['v4']['version'] = '4.5'
    end.converge(described_recipe)
  end

  before do
    winrm_cmd = double('winrm_cmd', run_command: nil, stdout: 'Transport = HTTPS')
    allow(Mixlib::ShellOut).to receive(:new).with('powershell.exe winrm enumerate winrm/config/listener').and_return winrm_cmd
    allow(Chef::Win32::Registry).to receive(:new).and_return double('registry', data_exists?: false, value_exists?: false, key_exists?: false)
  end

  context 'When listener is enabled' do
    before do
      dsc_cmd = double('dsc_cmd', run_command: nil, exitstatus: 1)
      allow(Mixlib::ShellOut).to receive(:new).with('powershell.exe winrm get winrm/config/listener?Address=*+Transport=HTTP').and_return dsc_cmd
    end

    it 'runs dsc_script' do
      expect(chef_run).to include_recipe('powershell::powershell4')
      expect(chef_run).to include_recipe('powershell::winrm')
    end
  end

  context 'When listener is disabled' do
    before do
      dsc_cmd = double('dsc_cmd', run_command: nil, exitstatus: 0)
      allow(Mixlib::ShellOut).to receive(:new).with('powershell.exe winrm get winrm/config/listener?Address=*+Transport=HTTP').and_return dsc_cmd
    end

    it 'runs dsc_script' do
      expect(chef_run).to include_recipe('powershell::powershell4')
    end
  end
end
