# frozen_string_literal: true

require 'spec_helper'

describe 'powershell_wmf' do
  step_into :powershell_wmf

  before do
    allow_any_instance_of(Chef::Resource).to receive(:include_recipe).and_return(true)
    allow(Powershell::VersionHelper).to receive(:powershell_version?).and_return(false)
  end

  context 'when installing PowerShell 2.0 on Windows Server 2012' do
    platform 'windows', '2012'

    recipe do
      powershell_wmf '2.0'
    end

    it { is_expected.to install_windows_feature('MicrosoftWindowsPowerShellV2') }
    it { is_expected.to install_windows_feature('MicrosoftWindowsPowerShellV2-WOW64') }
  end

  context 'when installing PowerShell 3.0 on Windows Server 2008 R2' do
    platform 'windows', '2012'

    recipe do
      node.automatic['platform_version'] = '6.1'
      powershell_wmf '3.0'
    end

    it { is_expected.to include_recipe('ms_dotnet::ms_dotnet4') }
    it do
      is_expected.to install_windows_package('Windows Management Framework Core 3.0').with(
        source: 'http://download.microsoft.com/download/E/7/6/E76850B8-DA6E-4FF5-8CCE-A24FC513FD16/Windows6.1-KB2506143-x64.msu',
        checksum: '8a8e35fa0e613fcc54644b8336d7dabbe5c6b57a1895e9caac2d0065746d1f8d',
        installer_type: :custom,
        options: '/quiet /norestart'
      )
    end
  end

  context 'when installing PowerShell 4.0 with an invalid .NET requirement' do
    platform 'windows', '2012'

    recipe do
      powershell_wmf '4.0' do
        dotnet_version '4.0'
      end
    end

    it 'raises an error' do
      expect { chef_run }.to raise_error(RuntimeError, /dotnet_version/)
    end
  end

  context 'when installing PowerShell 5.1 on Windows Server 2008 R2' do
    platform 'windows', '2012'

    recipe do
      node.automatic['platform_version'] = '6.1'
      powershell_wmf '5.1'
    end

    it { is_expected.to include_recipe('ms_dotnet::ms_dotnet4') }
    it do
      is_expected.to create_remote_file("#{Chef::Config[:file_cache_path]}\\wmf51.zip").with(
        source: 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip',
        checksum: 'f383c34aa65332662a17d95409a2ddedadceda74427e35d05024cd0a6a2fa647'
      )
    end
    it do
      is_expected.to extract_archive_file("#{Chef::Config[:file_cache_path]}\\wmf51.zip").with(
        destination: "#{Chef::Config[:file_cache_path]}\\wmf51",
        overwrite: true
      )
    end
    it do
      is_expected.to install_msu_package('Windows Management Framework Core 5.1').with(
        source: "#{Chef::Config[:file_cache_path]}\\wmf51\\Win7AndW2K8R2-KB3191566-x64.msu",
        timeout: 2700,
        ignore_failure: true
      )
    end
  end

  context 'when PowerShell 5.1 is already bundled with the platform' do
    platform 'windows', '2019'

    recipe do
      powershell_wmf '5.1'
    end

    it { is_expected.to_not install_msu_package('Windows Management Framework Core 5.1') }
  end
end
