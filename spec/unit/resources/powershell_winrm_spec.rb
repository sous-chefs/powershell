# frozen_string_literal: true

require 'spec_helper'

describe 'powershell_winrm' do
  step_into :powershell_winrm
  platform 'windows', '2019'

  before do
    stub_command('(Test-WSMan -ErrorAction SilentlyContinue) -ne $null').and_return(false)
    stub_command("(winrm enumerate winrm/config/listener | Out-String) -match 'Transport = HTTPS'").and_return(false)
  end

  context 'with default properties' do
    recipe do
      powershell_winrm 'default'
    end

    it { is_expected.to run_powershell_script('enable winrm').with(code: 'winrm quickconfig -q') }
    it { is_expected.to_not run_powershell_script('winrm-create-https-listener') }
  end

  context 'when enabling an HTTPS listener' do
    recipe do
      powershell_winrm 'default' do
        enable_https_transport true
        hostname 'node.example.com'
        thumbprint 'ABCDEF1234567890'
      end
    end

    it do
      is_expected.to run_powershell_script('winrm-create-https-listener').with(
        code: "winrm create 'winrm/config/Listener?Address=*+Transport=HTTPS' '@{Hostname=\"node.example.com\"; CertificateThumbprint=\"ABCDEF1234567890\"}'"
      )
    end
  end
end
