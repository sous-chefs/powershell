require 'spec_helper'
require 'chefspec'

describe 'powershell::enable_lcm' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012') do |node|
      node.normal['lcm']['mof']['temp_dir'] = 'c:\\chef\\cache\\lcm_mof'
      node.normal['lcm']['config']['enable']['config_mode'] = 'ApplyOnly'
      node.normal['lcm']['config']['enable']['reboot_node'] = false
      node.normal['lcm']['config']['enable']['refresh_mode'] = 'Push'
    end.converge(described_recipe)
  end

  before do
    @config_code = <<-EOH

      Configuration EnableLCM
      {
        Node "localhost"
        {
          LocalConfigurationManager
          {
            ConfigurationMode = "ApplyOnly"
            RebootNodeIfNeeded = $false
            RefreshMode = "Push"
          }
        }
      }

      EnableLCM -OutputPath "c:\\chef\\cache\\lcm_mof"

      Set-DscLocalConfigurationManager -Path "c:\\chef\\cache\\lcm_mof"
    EOH

    guard_condition = <<-EOH
      $LCM = (Get-DscLocalConfigurationManager)
      $LCM.ConfigurationMode -eq "ApplyOnly" -and
        $LCM.RefreshMode -eq "Push"
    EOH
    stub_command(guard_condition).and_return(false)

    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('powershell::dsc').and_return(true)
  end

  it 'enables LCM', skip: not_windows? do
    expect(chef_run).to create_directory('Creating temporary directory to store LCM MOF files').with(
      path: 'c:\\chef\\cache\\lcm_mof'
    )
    expect(chef_run).to run_powershell_script('Configure and Enable LCM').with(
      code: @config_code
    )
    expect(chef_run.powershell_script('Configure and Enable LCM'))
      .to notify('directory[Deleting temporary directory which stored LCM MOF files]')
      .to(:delete)
      .immediately
  end
end
