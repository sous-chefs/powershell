require 'spec_helper'

describe 'powershell::powershell5' do
  {
    # There is no fauxhai info for windows 8, so we use windows 2012R2 and change the product type from server to workstation
    'Windows 8.1' => { fauxhai_version: '2012R2', product_type: 1, timeout: 600 },
    'Windows Server 2008R2' => { fauxhai_version: '2008R2', timeout: 2700},
    'Windows Server 2012' => { fauxhai_version: '2012', timeout: 2700 },
    'Windows Server 2012R2' => { fauxhai_version: '2012R2', timeout: 600 }
  }.each do |windows_version, test_conf|
    context "on #{windows_version}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'windows', version: test_conf[:fauxhai_version]) do |node|
          node.automatic['kernel']['os_info']['product_type'] = test_conf[:product_type] if test_conf[:product_type]
          node.set['powershell']['powershell5']['url'] = 'https://powershelltest.com'
          node.set['powershell']['powershell5']['checksum'] = '12345'
        end.converge(described_recipe)
      end

      it 'includes powershell 2 recipe' do
        allow(Chef::Win32::Registry).to receive(:new).and_return double('registry', data_exists?: false, value_exists?: false, key_exists?: false)
        expect(chef_run).to include_recipe('powershell::powershell2')
      end

      context 'when powershell is installed' do
        before do
          allow(Chef::Win32::Registry).to receive(:new).and_return double('registry', data_exists?: true, value_exists?: true)
        end

        it 'does not install WMF 5' do
          expect(chef_run).to_not install_windows_package('Windows Management Framework Core 5.0')
        end
      end

      context 'when powershell does not exist' do
        before do
          allow(Chef::Win32::Registry).to receive(:new).and_return double('registry', data_exists?: false, value_exists?: false, key_exists?: false)
        end

        it 'installs windows package windows management framework core 5.0' do
          expect(chef_run).to install_windows_package('Windows Management Framework Core 5.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom, options: '/quiet /norestart', timeout: test_conf[:timeout])
        end
      end
    end
  end
end
