# frozen_string_literal: true

require 'spec_helper'

describe Powershell::PowershellVersionHelper do
  subject(:helper) { described_class.new }

  context 'when the registry contains a v3+ version' do
    before do
      allow(helper).to receive(:registry_key_exists?).with('HKLM\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine').and_return(true)
      allow(helper).to receive(:registry_key_exists?).with('HKLM\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine').and_return(true)
      allow(helper).to receive(:registry_value_exists?).and_return(true)
      allow(helper).to receive(:registry_get_values).with('HKLM\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine').and_return([{ name: 'PowerShellVersion', data: '5.1.19041.1' }])
    end

    it 'returns the installed version' do
      expect(helper.powershell_version).to eq('5.1.19041.1')
    end

    it 'compares versions semantically' do
      expect(helper.powershell_version?('5.1')).to be(true)
      expect(helper.powershell_version?('6.0')).to be(false)
    end
  end

  context 'when PowerShell is not installed' do
    before do
      allow(helper).to receive(:registry_key_exists?).and_return(false)
    end

    it 'returns nil for the version and false for comparisons' do
      expect(helper.powershell_version).to be_nil
      expect(helper.powershell_version?('5.1')).to be(false)
    end
  end
end
