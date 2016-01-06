require 'spec_helper'

describe 'minimal::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  describe 'package provider installation' do
    describe file("#{ENV['ProgramW6432']}\\PackageManagement\\ProviderAssemblies\\nuget-anycpu.exe") do
      it { should exist }
    end
    describe command("(Get-PackageProvider | where {$_.Name -eq 'NuGet'}).Name") do
      its(:stdout) { should match 'NuGet' }
    end
    describe command("(Get-PackageProvider | where {$_.Name -eq 'NuGet'}).Version.ToString()") do
      its(:stdout) { should match '2.8.5.127' }
    end
  end
  describe 'package source installation' do
    describe command("(Get-PackageSource | where {$_.Name -eq 'PSGallery'}).Name") do
      its(:stdout) { should match 'PSGallery' }
    end
    describe command("(Get-PackageSource | where {$_.Name -eq 'PSGallery'}).Location") do
      its(:stdout) { should match 'https://www.powershellgallery.com/api/v2/' }
    end
    describe command("(Get-PackageSource | where {$_.Name -eq 'PSGallery'}).IsTrusted") do
      its(:stdout) { should match 'True' }
    end
  end
  describe 'package installation' do 
    describe command("(Get-Package 'xTimeZone').Name") do
      its(:stdout) { should match 'xTimeZone' }
    end
    describe command("(Get-Package 'xTimeZone').Source") do
      its(:stdout) { should match 'https://www.powershellgallery.com/api/v2/' }
    end
    describe command("(Get-Package 'xTimeZone').FromTrustedSource") do
      its(:stdout) { should match 'True' }
    end
    describe command("(Get-Package 'xTimeZone').Version.ToString()") do
      its(:stdout) { should match '1.3.0.0' }
    end
  end
end

