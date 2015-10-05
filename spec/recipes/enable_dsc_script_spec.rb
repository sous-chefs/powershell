require 'spec_helper'
require 'chefspec'

describe 'powershell::enable_dsc_script' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'windows', version: '2012').converge(described_recipe) }

  before do
    guard_condition = <<-EOH
      $LCM = (Get-DscLocalConfigurationManager)
      $LCM.ConfigurationMode -eq "ApplyOnly" -and
        $LCM.RefreshMode -eq "Push"
    EOH
    stub_command(guard_condition).and_return(false)
  end

  it 'includes enable_lcm recipe' do
    expect(chef_run).to include_recipe('powershell::enable_lcm')
  end
end
