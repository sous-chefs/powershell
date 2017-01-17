require 'spec_helper'

describe 'powershell::powershell4' do
  {
    # There is no fauxhai info for windows 7, so we use windows 2008R2 and change the product type from server to workstation
    'Windows 7' => { fauxhai_version: '2008R2', product_type: 1 },
    'Windows Server 2008R2' => { fauxhai_version: '2008R2' },
    'Windows Server 2012' => { fauxhai_version: '2012' },
  }.each do |windows_version, test_conf|
    context "on #{windows_version}" do
      let(:normal_attributes) { ::Chef::Node::VividMash.new(double('fake_node').as_null_object) }
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'windows', version: test_conf[:fauxhai_version]) do |node|
          node.automatic['kernel']['os_info']['product_type'] = test_conf[:product_type] if test_conf[:product_type]
          normal_attributes.each { |k, v| node.normal[k] = v }
        end.converge(described_recipe)
      end

      before { allow_any_instance_of(Chef::Resource).to receive(:reboot_pending?).and_return(false) }

      context 'when ms_dotnet::ms_dotnet4 is not configured for .NET 4.5' do
        before { normal_attributes['ms_dotnet']['v4']['version'] = '4.0' }
        it 'fails' do
          expect { chef_run }.to raise_error
        end
      end

      context 'when ms_dotnet::ms_dotnet4 is configured for .NET 4.5' do
        before { normal_attributes['ms_dotnet']['v4']['version'] = '4.5' }

        context 'when powershell 4 is installed' do
          before do
            allow_any_instance_of(::Chef::Resource).to receive(:reboot_pending?).and_return false
            allow(::Powershell::VersionHelper).to receive(:powershell_version?).and_return true
          end
          it 'includes ms_dotnet::ms_dotnet4' do
            expect(chef_run).to include_recipe('ms_dotnet::ms_dotnet4')
          end
          it 'does not install windows package WMFC 4.0' do
            expect(chef_run).to_not install_windows_package('Windows Management Framework Core 4.0')
          end
        end

        context 'when powershell 4 does not exist' do
          before do
            normal_attributes['powershell']['powershell4']['url'] = 'https://powershelltest.com'
            normal_attributes['powershell']['powershell4']['checksum'] = '12345'
            normal_attributes['powershell']['installation_reboot_mode'] = 'no_reboot'
            allow_any_instance_of(::Chef::Resource).to receive(:reboot_pending?).and_return false
            allow(::Powershell::VersionHelper).to receive(:powershell_version?).and_return false
          end
          it 'includes ms_dotnet::ms_dotnet4' do
            expect(chef_run).to include_recipe('ms_dotnet::ms_dotnet4')
          end
          it 'installs windows package WMFC 4.0' do
            expect(chef_run).to install_windows_package('Windows Management Framework Core 4.0').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom)
          end
        end
      end
    end
  end
end
