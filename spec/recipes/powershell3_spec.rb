require 'spec_helper'

describe 'powershell::powershell3' do
  {
    'Windows Server 2008R2' => { fauxhai_version: '2008R2', should_install_bits: false },
    # There is no fauxhai info for windows 7, so we use 2008R2 and change the product type from server to workstation
    'Windows 7' => { fauxhai_version: '2008R2', product_type: 1, should_install_bits: false },
  }.each do |windows_version, test_conf|
    context "on #{windows_version}" do
      before { allow_any_instance_of(Chef::Resource).to receive(:reboot_pending?).and_return(false) }

      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'windows', version: test_conf[:fauxhai_version]) do |node|
          node.automatic['platform_version'] = test_conf[:platform_version] if test_conf[:platform_version]
          node.automatic['kernel']['os_info']['product_type'] = test_conf[:product_type] if test_conf[:product_type]
          node.normal['powershell']['powershell3']['url'] = 'https://powershelltest.com'
          node.normal['powershell']['powershell3']['checksum'] = '12345'
          node.normal['powershell']['bits_4']['url'] = 'https://powershellbits.com'
          node.normal['powershell']['bits_4']['checksum'] = '99999'
        end.converge(described_recipe)
      end

      if test_conf[:should_install_bits]
        it 'installs windows package Windows Management Framework Bits' do
          allow(::Powershell::VersionHelper).to receive(:powershell_version?).and_return false
          expect(chef_run).to install_windows_package('Windows Management Framework Bits').with(source: 'https://powershellbits.com', checksum: '99999', installer_type: :custom, options: '/quiet /norestart')
        end
      else
        it 'does not install windows package Windows Management Framework Bits' do
          allow(::Powershell::VersionHelper).to receive(:powershell_version?).and_return false
          expect(chef_run).to_not install_windows_package('Windows Management Framework Bits')
        end
      end

      context 'when powershell 3 is installed' do
        before do
          allow(::Powershell::VersionHelper).to receive(:powershell_version?).and_return true
        end

        it 'only include ms_dotnet4' do
          expect(chef_run).to include_recipe('ms_dotnet::ms_dotnet4')
          expect(chef_run).to_not install_windows_package('Windows Management Framework Core 3.0')
        end
      end

      context 'when powershell 3 does not exist' do
        before do
          allow(::Powershell::VersionHelper).to receive(:powershell_version?).and_return false
        end

        it 'installs windows package windows management framework core 3.0' do
          expect(chef_run).to include_recipe('ms_dotnet::ms_dotnet4')
          expect(chef_run).to install_windows_package('Windows Management Framework Core 3.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom, options: '/quiet /norestart')
        end
      end
    end
  end
end
