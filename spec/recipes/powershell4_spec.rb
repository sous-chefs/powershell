require 'spec_helper'
require 'chef/win32/version'

describe 'powershell::powershell4' do
  context 'when installation_reboot_mode is no_reboot' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012') do |node|
        node.set['powershell']['powershell4']['url'] = 'https://powershelltest.com'
        node.set['powershell']['powershell4']['checksum'] = '12345'
        node.set['powershell']['installation_reboot_mode'] = 'no_reboot'
      end.converge(described_recipe)
    end

    context 'when windows_version is windows_server_2008_r2' do
      before do
        @windows_version = double(windows_server_2008_r2?: true, windows_7?: false, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(true)
        allow(registry).to receive(:value_exists?).and_return(true)
        allow(registry).to receive(:key_exists?).and_return(true)
      end

      it 'only includes ms_dotnet45 when powershell 4 is installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
      end
    end

    context 'when windows_version is windows_server_2008_r2' do
      before do
        @windows_version = double(windows_server_2008_r2?: true, windows_7?: false, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(false)
        allow(registry).to receive(:value_exists?).and_return(false)
        allow(registry).to receive(:key_exists?).and_return(false)
      end

      it 'installs windows package windows managemet framework core 4.0 when powershell 4 is not installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
        expect(chef_run).to install_windows_package('Windows Management Framework Core4.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom)
      end
    end

    context 'when windows_version is windows_7' do
      before do
        @windows_version = double(windows_server_2008_r2?: false, windows_7?: true, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(true)
        allow(registry).to receive(:value_exists?).and_return(true)
        allow(registry).to receive(:key_exists?).and_return(true)
      end

      it 'only includes ms_dotnet45 when powershell 4 is installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
      end
    end

    context 'when windows_version is windows_7' do
      before do
        @windows_version = double(windows_server_2008_r2?: false, windows_7?: true, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(false)
        allow(registry).to receive(:value_exists?).and_return(false)
        allow(registry).to receive(:key_exists?).and_return(false)
      end

      it 'installs windows package windows managemet framework core 4.0 when powershell 4 is not installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
        expect(chef_run).to install_windows_package('Windows Management Framework Core4.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom)
      end
    end

    context 'when windows_version is windows_server_2012' do
      before do
        @windows_version = double(windows_server_2008_r2?: false, windows_7?: false, windows_server_2012?: true)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(false)
        allow(registry).to receive(:value_exists?).and_return(false)
        allow(registry).to receive(:key_exists?).and_return(false)
      end

      it 'installs windows package windows managemet framework core 4.0' do
        expect(chef_run).to install_windows_package('Windows Management Framework Core4.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom)
      end
    end
  end

  context 'when installation_reboot_mode is delayed_reboot' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012') do |node|
        node.set['powershell']['powershell4']['url'] = 'https://powershelltest.com'
        node.set['powershell']['powershell4']['checksum'] = '12345'
        node.set['powershell']['installation_reboot_mode'] = 'delayed_reboot'
      end.converge(described_recipe)
    end

    context 'when windows_version is windows_server_2008_r2' do
      before do
        @windows_version = double(windows_server_2008_r2?: true, windows_7?: false, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(true)
        allow(registry).to receive(:value_exists?).and_return(true)
        allow(registry).to receive(:key_exists?).and_return(true)
      end

      it 'only includes ms_dotnet45 when powershell 4 is installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
      end
    end

    context 'when windows_version is windows_server_2008_r2' do
      before do
        @windows_version = double(windows_server_2008_r2?: true, windows_7?: false, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(false)
        allow(registry).to receive(:value_exists?).and_return(false)
        allow(registry).to receive(:key_exists?).and_return(false)
      end

      it 'installs windows package windows managemet framework core 4.0 when powershell 4 is not installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
        expect(chef_run).to install_windows_package('Windows Management Framework Core4.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom)
      end
    end

    context 'when windows_version is windows_7' do
      before do
        @windows_version = double(windows_server_2008_r2?: false, windows_7?: true, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(true)
        allow(registry).to receive(:value_exists?).and_return(true)
        allow(registry).to receive(:key_exists?).and_return(true)
      end

      it 'only includes ms_dotnet45 when powershell 4 is installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
      end
    end

    context 'when windows_version is windows_7' do
      before do
        @windows_version = double(windows_server_2008_r2?: false, windows_7?: true, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(false)
        allow(registry).to receive(:value_exists?).and_return(false)
        allow(registry).to receive(:key_exists?).and_return(false)
      end

      it 'installs windows package windows managemet framework core 4.0 when powershell 4 is not installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
        expect(chef_run).to install_windows_package('Windows Management Framework Core4.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom)
      end
    end

    context 'when windows_version is windows_server_2012' do
      before do
        @windows_version = double(windows_server_2008_r2?: false, windows_7?: false, windows_server_2012?: true)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(false)
        allow(registry).to receive(:value_exists?).and_return(false)
        allow(registry).to receive(:key_exists?).and_return(false)
      end

      it 'installs windows package windows managemet framework core 4.0' do
        expect(chef_run).to install_windows_package('Windows Management Framework Core4.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom)
      end
    end
  end

  context 'when installation_reboot_mode is immediate_reboot' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012') do |node|
        node.set['powershell']['powershell4']['url'] = 'https://powershelltest.com'
        node.set['powershell']['powershell4']['checksum'] = '12345'
        node.set['powershell']['installation_reboot_mode'] = 'immediate_reboot'
      end.converge(described_recipe)
    end

    context 'when windows_version is windows_server_2008_r2' do
      before do
        @windows_version = double(windows_server_2008_r2?: true, windows_7?: false, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(true)
        allow(registry).to receive(:value_exists?).and_return(true)
        allow(registry).to receive(:key_exists?).and_return(true)
      end

      it 'only includes ms_dotnet45 when powershell 4 is installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
      end
    end

    context 'when windows_version is windows_server_2008_r2' do
      before do
        @windows_version = double(windows_server_2008_r2?: true, windows_7?: false, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(false)
        allow(registry).to receive(:value_exists?).and_return(false)
        allow(registry).to receive(:key_exists?).and_return(false)
      end

      it 'installs windows package windows managemet framework core 4.0 when powershell 4 is not installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
        expect(chef_run).to install_windows_package('Windows Management Framework Core4.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom)
      end
    end

    context 'when windows_version is windows_7' do
      before do
        @windows_version = double(windows_server_2008_r2?: false, windows_7?: true, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(true)
        allow(registry).to receive(:value_exists?).and_return(true)
        allow(registry).to receive(:key_exists?).and_return(true)
      end

      it 'only includes ms_dotnet45 when powershell 4 is installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
      end
    end

    context 'when windows_version is windows_7' do
      before do
        @windows_version = double(windows_server_2008_r2?: false, windows_7?: true, windows_server_2012?: false)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(false)
        allow(registry).to receive(:value_exists?).and_return(false)
        allow(registry).to receive(:key_exists?).and_return(false)
      end

      it 'installs windows package windows managemet framework core 4.0 when powershell 4 is not installed' do
        expect(chef_run).to include_recipe('ms_dotnet45')
        expect(chef_run).to install_windows_package('Windows Management Framework Core4.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom)
      end
    end

    context 'when windows_version is windows_server_2012' do
      before do
        @windows_version = double(windows_server_2008_r2?: false, windows_7?: false, windows_server_2012?: true)
        allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
        registry = double
        allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
        allow(registry).to receive(:data_exists?).and_return(false)
        allow(registry).to receive(:value_exists?).and_return(false)
        allow(registry).to receive(:key_exists?).and_return(false)
      end

      it 'installs windows package windows managemet framework core 4.0' do
        expect(chef_run).to install_windows_package('Windows Management Framework Core4.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom)
      end
    end
  end
end
