require 'spec_helper'

describe 'powershell::powershell2' do
  before { allow_any_instance_of(Chef::Resource).to receive(:reboot_pending?).and_return(false) }

  context 'on Windows Server 2012 Core' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012') do |node|
        node.automatic['kernel']['os_info']['operating_system_sku'] = 0x0D
      end.converge(described_recipe)
    end

    it 'installs windows features' do
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShellV2')
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShellV2-WOW64')
    end
  end

  context 'on Windows Server 2008R2 Core' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2') do |node|
        node.automatic['kernel']['os_info']['operating_system_sku'] = 0x0D
      end.converge(described_recipe)
    end

    it 'includes the ms_dotnet cookbook' do
      expect(chef_run).to include_recipe('ms_dotnet::ms_dotnet2')
    end

    it 'installs windows features' do
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShell')
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShell-WOW64')
    end
  end
end
