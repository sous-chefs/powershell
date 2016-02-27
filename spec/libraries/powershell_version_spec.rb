require 'spec_helper'

include Powershell
include Powershell::VersionHelper

shared_examples 'version retrieval' do |version, lower_semver_version, higher_version, higher_semver_version|
  it 'retrieves the Powershell version via helper' do
    expect(::Powershell::VersionHelper.powershell_version).to eq(version)
  end
  it 'returns true if queried with same version' do
    expect(::Powershell::VersionHelper.powershell_version?(version)).to be true
  end
  it 'returns true if queried with lower (SemVer) version' do
    expect(::Powershell::VersionHelper.powershell_version?(lower_semver_version)).to be true
  end
  it 'returns false if queried with higher version' do
    expect(::Powershell::VersionHelper.powershell_version?(higher_version)).not_to be true
  end
  it 'returns false if queried with higher (SemVer) version' do
    expect(::Powershell::VersionHelper.powershell_version?(higher_semver_version)).not_to be true
  end
end

describe PowershellVersionHelper do
  context 'without Powershell' do
    before do
      allow_any_instance_of(Powershell::PowershellVersionHelper).to receive(:registry_key_exists?).and_return(false)
    end

    it 'retrieves the Powershell version via helper' do
      ::Powershell::VersionHelper.powershell_version.nil? == true
    end

    it 'returns false if queried with any version' do
      ::Powershell::VersionHelper.powershell_version?('0.0') == false
    end
  end

  version_v1 = '1.0.101'
  version_v3 = '3.0.101'
  context 'with Powershell v1/v2' do
    before do
      allow_any_instance_of(Powershell::PowershellVersionHelper).to receive(:registry_value_exists?).and_return(true)
      allow_any_instance_of(Powershell::PowershellVersionHelper).to receive(:registry_key_exists?).with('HKLM\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine').and_return(true)
      allow_any_instance_of(Powershell::PowershellVersionHelper).to receive(:registry_key_exists?).with('HKLM\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine').and_return(false)
      allow_any_instance_of(Powershell::PowershellVersionHelper).to receive(:registry_get_values).with('HKLM\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine').and_return([{ name: 'PowerShellVersion', type: :string, data: version_v1 }])
      allow_any_instance_of(Powershell::PowershellVersionHelper).to receive(:registry_get_values).with('HKLM\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine').and_return([{ name: 'PowerShellVersion', type: :string, data: version_v3 }])
    end
    include_examples 'version retrieval', '1.0.101', '1.0.99', '1.0.102', '1.0.1000'
  end
  context 'with Powershell v3+' do
    before do
      allow_any_instance_of(Powershell::PowershellVersionHelper).to receive(:registry_value_exists?).and_return(true)
      allow_any_instance_of(Powershell::PowershellVersionHelper).to receive(:registry_key_exists?).with('HKLM\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine').and_return(true)
      allow_any_instance_of(Powershell::PowershellVersionHelper).to receive(:registry_key_exists?).with('HKLM\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine').and_return(true)
      allow_any_instance_of(Powershell::PowershellVersionHelper).to receive(:registry_get_values).with('HKLM\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine').and_return([{ name: 'PowerShellVersion', type: :string, data: version_v1 }])
      allow_any_instance_of(Powershell::PowershellVersionHelper).to receive(:registry_get_values).with('HKLM\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine').and_return([{ name: 'PowerShellVersion', type: :string, data: version_v3 }])
    end
    include_examples 'version retrieval', '3.0.101', '3.0.99', '3.0.102', '3.0.1000'
  end
end
