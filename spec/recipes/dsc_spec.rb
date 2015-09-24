require 'spec_helper'
require 'mixlib/shellout'

describe 'powershell::dsc' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'windows', version: '2012').converge(described_recipe) }

  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('powershell::powershell4')
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('powershell::winrm')
  end

  context 'When listener is enabled' do
    before do
      command = 'powershell.exe winrm get winrm/config/listener?Address=*+Transport=HTTP'

      shell_obj = instance_double('Mixlib::ShellOut')
      allow(Mixlib::ShellOut).to receive(:new).with(command).and_return(shell_obj)
      allow(shell_obj).to receive(:run_command)
      allow(shell_obj).to receive(:exitstatus).and_return(1)
    end

    it 'runs dsc_script' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('powershell::powershell4')
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('powershell::winrm')
      chef_run
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
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('powershell::powershell4')
      chef_run
    end
  end
end
