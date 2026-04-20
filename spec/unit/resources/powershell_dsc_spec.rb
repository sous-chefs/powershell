# frozen_string_literal: true

require 'spec_helper'

describe 'powershell_dsc' do
  step_into :powershell_dsc
  platform 'windows', '2019'

  recipe do
    powershell_dsc 'default' do
      enable_https_transport true
      hostname 'node.example.com'
      thumbprint 'ABCDEF1234567890'
    end
  end

  it { is_expected.to install_powershell_wmf('4.0') }
  it do
    is_expected.to create_powershell_winrm('default').with(
      enable_https_transport: true,
      hostname: 'node.example.com',
      thumbprint: 'ABCDEF1234567890'
    )
  end
end
