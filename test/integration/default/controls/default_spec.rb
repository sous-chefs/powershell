# frozen_string_literal: true

control 'powershell-version-01' do
  impact 1.0
  title 'PowerShell 5.1 or newer is available'

  describe command('powershell.exe -NoLogo -NoProfile -NonInteractive -Command "$PSVersionTable.PSVersion.ToString()"', timeout: 30) do
    its('stdout') { should match(/^5\.1/) }
  end
end
