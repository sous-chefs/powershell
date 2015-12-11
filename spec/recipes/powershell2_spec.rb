require 'spec_helper'

describe 'powershell::powershell2' do
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

    it 'installs windows features' do
      expect(chef_run).to install_windows_feature('NetFx2-ServerCore')
      expect(chef_run).to install_windows_feature('NetFx2-ServerCore-WOW64')
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShell')
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShell-WOW64')
    end
  end

  context 'on Windows Server 2008' do
    let(:chef_run) do
      # There is no fauxhai info for windows server 2008, so we use 2008R2 and change the platform version
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2') do |node|
        node.automatic['platform_version'] = '6.0.6001'
        node.set['powershell']['powershell2']['url'] = 'https://powershelltest.com'
        node.set['powershell']['powershell2']['checksum'] = '12345'
      end.converge(described_recipe)
    end

    context 'when powershell2 does not exist' do
      before do
        allow(Chef::Win32::Registry).to receive(:new).and_return double('registry', data_exists?: false, value_exists?: false, key_exists?: false)
      end

      it 'installs windows package' do
        expect(chef_run).to include_recipe('ms_dotnet::ms_dotnet2')
        expect(chef_run).to install_windows_package('Windows Management Framework Core').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom, options: '/quiet /norestart')
      end
    end

    context 'when powershell2 exist' do
      before do
        allow(Chef::Win32::Registry).to receive(:new).and_return double('registry', data_exists?: true, value_exists?: true)
      end

      it 'only includes ms_dotnet2' do
        expect(chef_run).to include_recipe('ms_dotnet::ms_dotnet2')
        expect(chef_run).to_not install_windows_package('Windows Management Framework Core')
      end
    end
  end
end
