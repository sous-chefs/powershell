# frozen_string_literal: true

require 'spec_helper'

describe 'powershell_lcm' do
  step_into :powershell_lcm
  platform 'windows', '2019'

  before do
    stub_command(<<~EOH).and_return(false)
      $LCM = (Get-DscLocalConfigurationManager)
      $LCM.ConfigurationMode -eq "ApplyOnly" -and
        $LCM.RefreshMode -eq "Push"
    EOH
    stub_command(<<~EOH).and_return(false)
      $LCM = (Get-DscLocalConfigurationManager)
      $LCM.RefreshMode -eq "Disabled"
    EOH
  end

  context 'with action :enable' do
    recipe do
      powershell_lcm 'default'
    end

    it { is_expected.to create_powershell_dsc('default') }
    it do
      is_expected.to create_directory('Creating temporary directory to store LCM MOF files').with(
        path: "#{Chef::Config[:file_cache_path]}\\lcm_mof"
      )
    end
    it { is_expected.to run_powershell_script('Configure and Enable LCM') }
  end

  context 'with action :disable' do
    recipe do
      powershell_lcm 'default' do
        action :disable
      end
    end

    it { is_expected.to install_powershell_wmf('5.1') }
    it { is_expected.to create_powershell_dsc('default') }
    it { is_expected.to run_powershell_script('Disable LCM') }
    it { is_expected.to delete_directory('Deleting temporary directory which stored LCM MOF files') }
  end
end
