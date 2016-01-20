Powershell Cookbook
===================
[![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/et44rb1ac700hv9o/branch/master?svg=true)](https://ci.appveyor.com/project/smurawski/powershell/branch/master)
[![Travis Build Status](https://travis-ci.org/chef-cookbooks/powershell.svg?branch=master)](http://travis-ci.org/chef-cookbooks/powershell)
[![Cookbook Version](https://img.shields.io/cookbook/v/powershell.svg)](https://supermarket.chef.io/cookbooks/powershell)

Installs and configures PowerShell 2.0, 3.0, 4.0 or 5.0.

For users of Chef 10 without the `powershell_script` built-in resource, this cookbook also includes a resource/provider for executing scripts using the PowerShell interpreter.

Requirements
------------

### Platforms

Not every version of Windows supports every version of Powershell. The following table illustrates Powershell support across the Windows family. **Included** means that the base installation of the operating system includes the indicated version of Powershell.

<table>
  <tr>
    <th>Windows Version</th>
    <th>PowerShell 2.0</th>
    <th>PowerShell 3.0</th>
    <th>PowerShell 4.0</th>
    <th>PowerShell 5.0</th>
  </tr>
  <tr>
    <td>Windows XP</td>
    <td>Supported</td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>Windows Server 2003 / 2003 R2</td>
    <td>Supported</td>
    <td>Not Available</td>
    <td>Not Available</td>
    <td>Not Available</td>
  </tr>
  <tr>
    <td>Windows Server 2008 / Vista</td>
    <td>Supported</td>
    <td>Supported</td>
    <td>Not Available</td>
    <td>Not Available</td>
  </tr>
  <tr>
    <td>Windows Server 2008 R2</td>
    <td>Included</td>
    <td>Supported</td>
    <td>Supported</td>
    <td>Supported</td>
  </tr>
  <tr>
    <td>Windows Server 2012 / Windows 8</td>
    <td>Included</td>
    <td>Included</td>
    <td>Supported</td>
    <td>Supported</td>
  </tr>
  <tr>
    <td>Windows Server 2012R2 / Windows 8.1</td>
    <td>Included</td>
    <td>Not Available</td>
    <td>Included</td>
    <td>Supported</td>
  </tr>
</table>

### Cookbooks

* windows

PowerShell also requires the appropriate version of the Microsoft .NET Framework to be installed, if the operating system does not ship with that version. The following community cookbooks are used to install the correct version of the .NET Framework:

* ms_dotnet

Resource/Provider
-----------------

**Note**: In Chef 11, use the built-in [powershell_script](http://docs.chef.io/resource_powershell_script.html) resource.

### `powershell`

Execute a script using the PowerShell interpreter (much like the script resources for bash, csh, perl, python and ruby). A temporary file is created and executed like other script resources, rather than run inline. By their nature, Script resources are not idempotent, as they are completely up to the user's imagination. Use the `not_if` or `only_if` meta parameters to guard the resource for idempotence.

#### Actions

- :run: run the script

#### Attribute Parameters

- `command`: name attribute. Name of the command to execute.
- `code`: quoted string of code to execute.
- `creates`: a file this command creates - if the file exists, the command will not be run.
- `cwd`: current working directory to run the command from.
- `flags`: command line flags to pass to the interpreter when invoking.
- `environment`: A hash of environment variables to set before running this command.
- `user`: A user name or user ID that we should change to before running this command.
- `group`: A group name or group ID that we should change to before running this command.
- `returns`: The return value of the command (may be an array of accepted values). This resource raises an exception if the return value(s) do not match.
- `timeout`: How many seconds to let the command run before timing it out.

#### Examples

```ruby
# change the computer's hostname
powershell "rename hostname" do
  code <<-EOH
  $computer_name = Get-Content env:computername
  $new_name = 'test-hostname'
  $sysInfo = Get-WmiObject -Class Win32_ComputerSystem
  $sysInfo.Rename($new_name)
  EOH
end
```

```ruby
# write out to an interpolated path
powershell "write-to-interpolated-path" do
  code <<-EOH
  $stream = [System.IO.StreamWriter] "#{Chef::Config[:file_cache_path]}/powershell-test.txt"
  $stream.WriteLine("In #{Chef::Config[:file_cache_path]}...word.")
  $stream.close()
  EOH
end
```

```ruby
# use the change working directory attribute
powershell "cwd-then-write" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  $stream = [System.IO.StreamWriter] "C:/powershell-test2.txt"
  $pwd = pwd
  $stream.WriteLine("This is the contents of: $pwd")
  $dirs = dir
  foreach ($dir in $dirs) {
    $stream.WriteLine($dir.fullname)
  }
  $stream.close()
  EOH
end
```

```ruby
# cwd to a winodws env variable
powershell "cwd-to-win-env-var" do
  cwd ENV['TEMP']
  code <<-EOH
  $stream = [System.IO.StreamWriter] "./temp-write-from-chef.txt"
  $stream.WriteLine("chef on windows rox yo!")
  $stream.close()
  EOH
end
```

```ruby
# pass an env var to script
powershell "read-env-var" do
  cwd Chef::Config[:file_cache_path]
  environment ({'foo' => 'BAZ'})
  code <<-EOH
  $stream = [System.IO.StreamWriter] "./test-read-env-var.txt"
  $stream.WriteLine("FOO is $env:foo")
  $stream.close()
  EOH
end
```

### `powershell_module`

Installs or uninstalls a Powershell module. You either need to install rubyzip with chef_gem or
include the default recipe before using this resource.

#### Actions

- :install: install the powershell module
- :uninstall: uninstall the powershell module

#### Attribute Parameters

- `name`: name attribute. Name of the module to install or uninstall.
- `source`: quoted string of Local directory path(Not zipfile) or URL for the zipped module folder.
- `package_name`: quoted string of name of the module to install or uninstall.
- `destination`: location where module should be installed

#### Examples

```ruby
include_recipe 'powershell::default'

# Install module from local directory path
# change the package_name and source
powershell_module "PsUrl" do
  package_name "PsUrl"
  source "C:\\PsUrl"
end
```

```ruby
# Install from URL of zipped module folder
powershell_module "posh-git" do
  package_name "posh-git"
  source "https://github.com/dahlbyk/posh-git/zipball/master"
end
```

```ruby
# change the package_name
powershell_module "Uninstall PsUrl" do
  package_name "PsUrl"
  action :uninstall
end
```

```ruby
# Install without using 'source' attribute
powershell_module "https://github.com/dahlbyk/posh-git/zipball/master" do
  package_name "posh-git"  
end
```

### `powershell_package`

Installs or uninstalls a Powershell package. You either need to install WMF 5.0 or
include the powershell5 recipe before using this resource. You also need to be sure
your package provider and package source is set up. This uses the new resource provider model and
will only work with Chef 12 and above. 

#### Actions

- :install: install a powershell package 
- :uninstall: uninstall the powershell package
- :update: force install powershell package

#### Attribute Parameters

- `name`: name attribute. Name of the package provider to install.
- `source`: specifies one or more package sources. Multiple package source names must be separated by commas.
- `version`: specifies the exact allowed version of the package that you want to install.

#### Examples

```ruby
include_recipe 'powershell::powershell5'

# Install xTimeZone package from PSGallery at version 1.2.0.0
powershell_package 'xTimeZone' do
  source 'PSGallery'
  version '1.2.0.0'
  action :install
end
```

```ruby
# Update xTimeZone package from PSGallery to version 1.3.0.0
powershell_package 'xTimeZone' do
  source 'PSGallery'
  version '1.3.0.0'
  action :update
end
```

```ruby
# Uninstall xTimeZone package at version 1.3.0.0
powershell_package 'xTimeZone' do
  version '1.3.0.0'
  action :uninstall
end
```

### `powershell_package_provider`

Installs or uninstalls a Powershell package provider. You either need to install WMF 5.0 or
include the powershell5 recipe before using this resource. This uses the new resource provider model and
will only work with Chef 12 and above. 

#### Actions

- :install: install a powershell provider (will pull provider executable from Microsoft) 

#### Attribute Parameters

- `name`: name attribute. Name of the package provider to install.

#### Examples

```ruby
include_recipe 'powershell::powershell5'

# Install NuGet from Microsoft
powershell_package_provider 'NuGet' 
```

### `powershell_package_source`

Registers, updates or unregisters a Powershell package source. You either need to install WMF 5.0 or
include the powershell5 recipe before using this resource. This uses the new resource provider model and
will only work with Chef 12 and above. 

#### Actions

- :register: registers a new package source
- :unregister: unregisters a package source
- :update: updates an existing package source

#### Attribute Parameters

- `name`: name attribute. Name of the package source to register, update or unregister.
- `location`: specifies the uri of the package source
- `package_provider`: specifies the package provider for this package source
- `trusted`: `true, false` sets the trusted flag for package source

#### Examples

```ruby
include_recipe 'powershell::powershell5'

# Register example source as package source
powershell_package_source 'ExampleSource' do
  package_provider 'PSModule'
  location 'https://www.example.com/'
  action :register
end
```

```ruby
# Update package source to be trusted
powershell_package_source 'ExampleSource' do
  package_provider 'PSModule'
  location 'https://www.example.com/'
  trusted true
  action :update
end
```

```ruby
# Unregister Package Source
powershell_package_source 'ExampleSource' do
  package_provider 'PSModule'
  action :unregister
end
```

Mixin
-----

The `Chef::Mixin::PowershellOut` mixin has been moved to the [windows](http://ckbk.it/windows) cookbook.

Usage
-----

**Note**: The installation may require a restart of the node being configured before PowerShell can be used.

### default

The default recipe is needs to be included before using the powershell_module resource.

### powershell2

Include the `powershell2` recipe in a run list, to ensure PowerShell 2.0 is installed.

On the following versions of Windows the PowerShell 2.0 package will be downloaded from Microsoft and installed:

- Windows XP
- Windows Server 2003
- Windows Server 2008
- Windows Vista

On the following versions of Windows, PowerShell 2.0 is present and must just be enabled:

- Windows 7
- Windows Server 2008 R2
- Windows Server 2008 R2 Core

### powershell3

Include the `powershell3` recipe in a run list, to install PowerShell 3.0 is installed on applicable platforms. If a platform is not supported or if it already includes PowerShell 3.0, an exception will be raised.

### powershell4

Include the `powershell4` recipe in a run list, to install PowerShell 4.0 is installed on applicable platforms. If a platform is not supported or if it already includes PowerShell 4.0, an exception will be raised.

### powershell5

Note: Windows Management Framework 5 is in production preview.

#### Windows Management Framework 5 RTM had been released, but that has been pulled.  The attributes in the cookbook have been reverted to the Production Preview.  When a new release of RTM for WMF 5 ships, we'll release an updated version.
http://blogs.msdn.com/b/powershell/archive/2015/12/23/windows-management-framework-wmf-5-0-currently-removed-from-download-center.aspx

Include the `powershell5` recipe in a run list, to install PowerShell 5.0 is installed on applicable platforms. If a platform is not supported or if it already includes PowerShell 5.0, an exception will be raised.

### install_nuget_provider_manual
Allows manual installation of NuGet provider from an internally hosted repository.

#### Attribute Parameters
  * `default['powershell']['nuget_provider']['source']` - URL to the hosted nuget-anycpu.exe file
  * `default['powershell']['nuget_provider']['checksum']` - checksum for the hosted nuget-anycpu.exe file

### uninstall_nuget_provider_manual
Allows manual removal of NuGet provider that was installed from an internally hosted repository.


References
----------

* Installing [Windows Management Framework 2.0](http://support.microsoft.com/kb/968929)
* Installing [Windows Management Framework 3.0](http://www.microsoft.com/en-us/download/details.aspx?id=34595)
* Installing [Windows Management Framework 4.0](http://www.microsoft.com/en-us/download/details.aspx?id=40855)
* Installing [Windows Management Framework 5.0](https://www.microsoft.com/en-us/download/details.aspx?id=48729)

License & Authors
-----------------

- Author:: Seth Chisamore (<schisamo@chef.io>)
- Author:: Julian Dunn (<jdunn@chef.io>)

```text
Copyright:: 2011-2015, Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
