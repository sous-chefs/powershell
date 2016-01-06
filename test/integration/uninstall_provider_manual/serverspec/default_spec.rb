require 'spec_helper'

describe 'minimal::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  describe 'package provider installation' do
    describe file("#{ENV['ProgramW6432']}\\PackageManagement\\ProviderAssemblies\\nuget-anycpu.exe") do
      it { should_not exist }
    end
  end
  describe 'package source removal' do
    describe command("(Get-PackageSource | where {$_.Name -eq 'ExampleSource'}) -eq $null") do
      its(:stdout) { should match 'True' }
    end
  end
  describe 'package removal' do 
    describe command("(Get-Package 'xTimeZone') -eq $null") do
      its(:stdout) { should match 'True' }
    end
  end
end

