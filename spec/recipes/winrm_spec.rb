require 'spec_helper'
require 'chef/win32/version'

describe 'powershell::winrm' do
  let(:chef_run) do 
    ChefSpec::Runner.new(platform: 'windows', version: '2012') do |node|
      end.converge(described_recipe)
  end

  it "installs windows package windows managemet framework core 5.0" do
    expect(chef_run).to run_powershell('enable winrm').with(code: "      winrm quickconfig -q\n")
  end
end