require 'spec_helper'
require 'mixlib/shellout'

describe 'powershell::dsc' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'windows', version: '2012').converge(described_recipe) }

  context 'When listener is enabled' do
    before do
      command = 'powershell.exe winrm get winrm/config/listener?Address=*+Transport=HTTP'

      shell_obj = instance_double('Mixlib::ShellOut')
      allow(Mixlib::ShellOut).to receive(:new).with(command).and_return(shell_obj)
      allow(shell_obj).to receive(:run_command)
      allow(shell_obj).to receive(:exitstatus).and_return(1)
    end

    it 'runs dsc_script' do
      expect(chef_run).to include_recipe('powershell::powershell4')
      expect(chef_run).to include_recipe('powershell::winrm')
    end
  end

  context 'When listener is disabled' do
    before do
      command = 'powershell.exe winrm get winrm/config/listener?Address=*+Transport=HTTP'

      shell_obj = instance_double('Mixlib::ShellOut')
      allow(Mixlib::ShellOut).to receive(:new).with(command).and_return(shell_obj)
      allow(shell_obj).to receive(:run_command)
      allow(shell_obj).to receive(:exitstatus).and_return(0)
    end

    it 'runs dsc_script' do
      expect(chef_run).to include_recipe('powershell::powershell4')
    end
  end
end
