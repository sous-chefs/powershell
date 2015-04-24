require 'spec_helper'
require 'chef/win32/version'

describe 'powershell::powershell3' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012') do |node|
      node.set['powershell']['powershell3']['url'] = 'https://powershelltest.com'
      node.set['powershell']['powershell3']['checksum'] = '12345'
      node.set['powershell']['bits_4']['url'] = 'https://powershellbits.com'
      node.set['powershell']['bits_4']['checksum'] = '99999'
    end.converge(described_recipe)
  end

  context 'when windows_version is windows_server_2008' do
    before do
      @windows_version = double(:windows_server_2008? => true, :windows_server_2008_r2? => false, :windows_7? => false)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
      registry = double
      allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
      allow(registry).to receive(:data_exists?).and_return(false)
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_return(true)
    end

    it 'installs windows package windows managemet framework bits and windows management framework core 3.0' do
      expect(chef_run).to install_windows_package('Windows Management Framework Bits').with(source: 'https://powershellbits.com', checksum: '99999', installer_type: :custom, options: '/quiet /norestart')
      expect(chef_run).to install_windows_package('Windows Management Framework Core 3.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom, options: '/quiet /norestart')
    end
  end

  context 'when windows_version is windows_server_2008_r2' do
    before do
      @windows_version = double(:windows_server_2008? => false, :windows_server_2008_r2? => true, :windows_7? => false)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
      registry = double
      allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
      allow(registry).to receive(:data_exists?).and_return(true)
    end

    it 'only include ms_dotnet4 when powershell 3 is installed' do
      expect(chef_run).to include_recipe('ms_dotnet4')
    end
  end

  context 'when windows_version is windows_server_2008_r2' do
    before do
      @windows_version = double(:windows_server_2008? => false, :windows_server_2008_r2? => true, :windows_7? => false)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
      registry = double
      allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
      allow(registry).to receive(:data_exists?).and_return(false)
    end

    it 'installs windows package windows management framework core 3.0 when powershell 3 doesnot exist' do
      expect(chef_run).to include_recipe('ms_dotnet4')
      expect(chef_run).to install_windows_package('Windows Management Framework Core 3.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom, options: '/quiet /norestart')
    end
  end

  context 'when windows_version is windows_7' do
    before do
      @windows_version = double(:windows_server_2008? => false, :windows_server_2008_r2? => false, :windows_7? => true)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
      registry = double
      allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
      allow(registry).to receive(:data_exists?).and_return(true)
    end

    it 'only include ms_dotnet4 when powershell 3 is installed' do
      expect(chef_run).to include_recipe('ms_dotnet4')
    end
  end

  context 'when windows_version is windows_7' do
    before do
      @windows_version = double(:windows_server_2008? => false, :windows_server_2008_r2? => false, :windows_7? => true)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
      registry = double
      allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
      allow(registry).to receive(:data_exists?).and_return(false)
    end

    it 'installs windows package windows management framework core 3.0 when powershell 3 doesnot exist' do
      expect(chef_run).to include_recipe('ms_dotnet4')
      expect(chef_run).to install_windows_package('Windows Management Framework Core 3.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom, options: '/quiet /norestart')
    end
  end
end
