property :name, String, default: 'PSGallery'
property :location, String, default: 'https://www.powershellgallery.com/api/v2/'
property :package_provider, String, default: 'PowerShellGet'
property :trusted, [TrueClass, FalseClass], default: false

# default_action :add

action :add do
  source_name = name
  # verify_provider_install
  powershell_script "install package package_provider #{package_provider}" do
    code "Get-PackageProvider -Name '#{package_provider}' -ForceBootstrap"
    only_if "(Get-PackageProvider | where {$_.Name -eq '#{package_provider}'}) -eq $null"
  end
  powershell_script "register package source #{source_name}" do
    code "Register-PackageSource -Name '#{source_name}' -ProviderName '#{package_provider}' -Location '#{location} #{trusted ? '-Trusted' : ''}"
    not_if "Get-PackageSource | where {$_.Name -eq '#{source_name}'}"
  end
end

action :remove do
end

action :update do
  source_name = name
  powershell_script "install package package_provider #{package_provider}" do
    code "Get-PackageProvider -Name '#{package_provider}' -ForceBootstrap"
    only_if "(Get-PackageProvider | where {$_.Name -eq '#{package_provider}'}) -eq $null"
  end
  powershell_script "register package source #{source_name}" do
    code "Register-PackageSource -Name '#{source_name}' -ProviderName '#{package_provider}' -Location '#{location}' #{trusted ? '' : '-Trusted'} -Force"
    only_if "(Get-PackageSource | where {$_.Name -eq '#{source_name}' -and $_.ProviderName -eq '#{package_provider}' -and $_.Location -eq '#{location}' -and $_.IsTrusted -eq #{trusted ? '$false' : '$true'}}) -eq $null"
  end
end

# def verify_provider_install

# end
