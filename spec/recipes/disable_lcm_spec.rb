require 'spec_helper'
require 'chefspec'

describe 'powershell::disable_lcm' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012') do |node|
      node.normal['powershell']['powershell5']['url'] = 'https://powershelltest.com'
      node.normal['powershell']['powershell5']['checksum'] = '12345'
      node.normal['lcm']['mof']['temp_dir'] = 'c:\\chef\\cache\\lcm_mof'
      node.normal['lcm']['config']['disable']['refresh_mode'] = 'Disabled'
    end.converge(described_recipe)
  end

  before do
    @config_code = <<-EOH

      Configuration DisableLCM
      {
        Node "localhost"
        {
          LocalConfigurationManager
          {
            RefreshMode = "Disabled"
          }
        }
      }

      DisableLCM -OutputPath "c:\\chef\\cache\\lcm_mof"

      Set-DscLocalConfigurationManager -Path "c:\\chef\\cache\\lcm_mof"
    EOH

    guard_condition = <<-EOH
      $LCM = (Get-DscLocalConfigurationManager)
      $LCM.RefreshMode -eq "Disabled"
    EOH
    stub_command(guard_condition).and_return(false)
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('powershell::powershell5').and_return(true)
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('powershell::dsc').and_return(true)
  end

  it 'disables LCM', skip: not_windows? do
    expect(chef_run).to create_directory('Creating temporary directory to store LCM MOF files').with(
      path: 'c:\\chef\\cache\\lcm_mof',
      rights: [permissions: :read, principals: 'Everyone']
    )
    expect(chef_run).to run_powershell_script('Disable LCM').with(
      code: @config_code
    )
    expect(chef_run).to delete_directory('Deleting temporary directory which stored LCM MOF files').with(
      path: 'c:\\chef\\cache\\lcm_mof',
      recursive: true
    )
  end
end
