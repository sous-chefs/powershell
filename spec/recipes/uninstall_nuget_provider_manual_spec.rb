require 'spec_helper'

describe 'powershell::uninstall_nuget_provider_manual' do
  {
    # There is no fauxhai info for windows 8, so we use windows 2012R2 and change the product type from server to workstation
    'Windows 8.1' => { fauxhai_version: '2012R2' },
    'Windows Server 2008R2' => { fauxhai_version: '2008R2' },
    'Windows Server 2012' => { fauxhai_version: '2012' },
    'Windows Server 2012R2' => { fauxhai_version: '2012R2' }
  }.each do |windows_version, test_conf|
    context "on #{windows_version}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'windows', version: test_conf[:fauxhai_version]) do |node|
          node.automatic['kernel']['os_info']['product_type'] = test_conf[:product_type] if test_conf[:product_type]
        end.converge(described_recipe)
      end

      it 'includes creates directory and places file' do
        expect(chef_run).to delete_remote_file("#{ENV['ProgramW6432']}\\PackageManagement\\ProviderAssemblies\\nuget-anycpu.exe")
      end
    end
  end
end
