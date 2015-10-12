require 'spec_helper'
require 'chef/win32/version'

describe 'powershell::powershell2' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012') do |node|
      node.set['powershell']['powershell2']['url'] = 'https://powershelltest.com'
      node.set['powershell']['powershell2']['checksum'] = '12345'
    end.converge(described_recipe)
  end

  before do
    allow_any_instance_of(Chef::DSL::RebootPending).to receive(:reboot_pending?).and_return(true)
  end

  context 'when windows_version is windows_server_2012 and windows_version is core ' do
    before do
      @windows_version = double(windows_server_2012?: true, windows_8?: false, core?: true)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
    end

    it 'installs windows features' do
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShellV2')
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShellV2-WOW64')
    end
  end

  context 'when windows_version is windows_8 and windows_version is core ' do
    before do
      @windows_version = double(windows_server_2012?: false, windows_8?: true, core?: true)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
    end

    it 'installs windows features' do
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShellV2')
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShellV2-WOW64')
    end
  end

  context 'when windows_version is windows_server_2008_r2 and windows_version is core ' do
    before do
      @windows_version = double(windows_server_2008_r2?: true, windows_7?: false, core?: true, windows_server_2012?: false, windows_8?: false)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
    end

    it 'installs windows feature' do
      expect(chef_run).to install_windows_feature('NetFx2-ServerCore')
      expect(chef_run).to install_windows_feature('NetFx2-ServerCore-WOW64')
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShell')
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShell-WOW64')
    end
  end

  context 'when windows_version is windows_7 and windows_version is core' do
    before do
      @windows_version = double(windows_server_2008_r2?: false, windows_7?: true, core?: true, windows_server_2012?: false, windows_8?: false)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
    end

    it 'installs windows feature' do
      expect(chef_run).to install_windows_feature('NetFx2-ServerCore')
      expect(chef_run).to install_windows_feature('NetFx2-ServerCore-WOW64')
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShell')
      expect(chef_run).to install_windows_feature('MicrosoftWindowsPowerShell-WOW64')
    end
  end

  context 'when windows_version is windows_server_2008' do
    before do
      @windows_version = double(windows_server_2008?: true, windows_server_2003_r2?: false, windows_server_2003?: false, windows_xp?: false, windows_server_2008_r2?: false, windows_7?: false, core?: false, windows_server_2012?: false, windows_8?: false)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
      registry = double
      allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
      allow(registry).to receive(:data_exists?).and_return(false)
    end

    it 'installs windows package when powershell2 doesnot exist' do
      expect(chef_run).to include_recipe('ms_dotnet2')
      expect(chef_run).to install_windows_package('Windows Management Framework Core').with(source: 'https://powershelltest.com', checksum: '12345', installer_type: :custom, options: '/quiet /norestart')
    end
  end

  context 'when windows_version is windows_server_2008' do
    before do
      @windows_version = double(windows_server_2008?: true, windows_server_2003_r2?: false, windows_server_2003?: false, windows_xp?: false, windows_server_2008_r2?: false, windows_7?: false, core?: false, windows_server_2012?: false, windows_8?: false)
      allow(Chef::ReservedNames::Win32::Version).to receive(:new).and_return(@windows_version)
      registry = double
      allow(Chef::Win32::Registry).to receive(:new).and_return(registry)
      allow(registry).to receive(:data_exists?).and_return(true)
    end

    it 'only includes ms_dotnet2 when powershell2 exist' do
      expect(chef_run).to include_recipe('ms_dotnet2')
    end
  end
end
