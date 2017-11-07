require 'spec_helper'

describe 'powershell::powershell5' do
  {
    # There is no fauxhai info for windows 8, so we use windows 2012R2 and change the product type from server to workstation
    'Windows 8.1' => { fauxhai_version: '2012R2', product_type: 1, timeout: 600 },
    'Windows Server 2008R2' => { fauxhai_version: '2008R2', timeout: 2700 },
    'Windows Server 2012' => { fauxhai_version: '2012', timeout: 2700 },
    'Windows Server 2012R2' => { fauxhai_version: '2012R2', timeout: 600 },
  }.each do |windows_version, test_conf|
    context "on #{windows_version}" do
      before do
        allow_any_instance_of(Chef::Resource).to receive(:reboot_pending?).and_return(false)
        @enable_reboot = false
      end

      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'windows', version: test_conf[:fauxhai_version], file_cache_path: 'c:\Chef') do |node|
          node.automatic['kernel']['os_info']['product_type'] = test_conf[:product_type] if test_conf[:product_type]
          node.normal['powershell']['powershell5']['url'] = 'https://powershelltest.com'
          node.normal['powershell']['powershell5']['checksum'] = '12345'
          node.normal['powershell']['installation_reboot_mode'] = 'yes' if @enable_reboot
        end.converge(described_recipe)
      end

      it 'includes ms_dotnet 4 recipe' do
        allow(::Powershell::VersionHelper).to receive(:powershell_version?).and_return false
        expect(chef_run).to include_recipe('ms_dotnet::ms_dotnet4')
      end

      it 'does not includes powershell windows_reboot recipe by default' do
        expect(chef_run).to_not include_recipe('powershell::windows_reboot')
      end
      it 'includes powershell windows_reboot recipe when reboot enabled' do
        @enable_reboot = true
        expect(chef_run).to include_recipe('powershell::windows_reboot')
      end

      context 'when powershell is installed' do
        before do
          allow(::Powershell::VersionHelper).to receive(:powershell_version?).and_return true
        end

        it 'does not unzip WMF 5.1' do
          expect(chef_run).to_not unzip_windows_zipfile("#{Chef::Config['file_cache_path']}\\wmf51")
        end
        it 'does not install WMF 5.1' do
          expect(chef_run).to_not install_windows_package('Windows Management Framework Core 5.1')
        end
      end

      context 'when powershell does not exist' do
        before do
          allow(::Powershell::VersionHelper).to receive(:powershell_version?).and_return false
        end

        if windows_version == 'Windows Server 2008R2'
          it 'installs windows package windows management framework core 5.1' do
            expect(chef_run).to install_windows_package('Windows Management Framework Core 5.1').with(source: Chef::Util::PathHelper.canonical_path("#{Chef::Config['file_cache_path']}\\wmf51\\Win7AndW2K8R2-KB3191566-x64.msu", false), installer_type: :custom, options: '/quiet /norestart', timeout: test_conf[:timeout])
          end
        else
          it 'installs windows package windows management framework core 5.1' do
            expect(chef_run).to install_windows_package('Windows Management Framework Core 5.1').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom, options: '/quiet /norestart', timeout: test_conf[:timeout])
          end
        end
      end
    end
  end
end
