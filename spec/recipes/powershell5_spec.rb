require 'spec_helper'
require 'chef/win32/version'

describe 'powershell::powershell5' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'windows', version: '2012') do |node|
      node.set['powershell']['powershell5']['url'] = 'https://powershelltest.com'
      node.set['powershell']['powershell5']['checksum'] = '12345'
    end.converge(described_recipe)
  end

  before do
    Chef::Recipe.any_instance.stub(:include_recipe).with('powershell::powershell2').and_return(true)
  end

  context 'when windows_version is windows_server_2012_r2' do
    before do
      @windows_version = double(:windows_server_2012_r2? => true, :windows_8_1 => false)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
      registry = double
      allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
      allow(registry).to receive(:data_exists?).and_return(false)
    end

    it 'installs windows package windows managemet framework core 5.0 if powershell 5 not installed' do
      expect(chef_run).to install_windows_package('Windows Management Framework Core 5.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom, options: '/quiet /norestart')
    end
  end

  context 'when windows_version is windows_8_1' do
    before do
      @windows_version = double(:windows_server_2012_r2? => false, :windows_8_1 => true)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
      registry = double
      allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
      allow(registry).to receive(:data_exists?).and_return(false)
    end

    it 'installs windows package windows managemet framework core 5.0 if powershell not installed' do
      expect(chef_run).to install_windows_package('Windows Management Framework Core 5.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom, options: '/quiet /norestart')
    end
  end
end
