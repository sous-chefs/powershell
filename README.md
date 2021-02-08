# Powershell Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/powershell.svg)](https://supermarket.chef.io/cookbooks/powershell)
[![CI State](https://github.com/sous-chefs/powershell/workflows/ci/badge.svg)](https://github.com/sous-chefs/powershell/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs and configures PowerShell 2.0, 3.0, 4.0 or 5.0.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

Not every version of Windows supports every version of Powershell. The following table illustrates Powershell support across the Windows family. **Included** means that the base installation of the operating system includes the indicated version of Powershell.

Windows Version                     | PowerShell 2.0 | PowerShell 3.0 | PowerShell 4.0 | PowerShell 5.0
----------------------------------- | -------------- | -------------- | -------------- | --------------
Windows Server 2008 R2              | Included       | Supported      | Supported      | Supported
Windows Server 2012 / Windows 8     | Included       | Included       | Supported      | Supported
Windows Server 2012R2 / Windows 8.1 | Included       | Not Available  | Included       | Supported

### Chef

- Chef 13+

### Cookbooks

- windows 3.0+

PowerShell also requires the appropriate version of the Microsoft .NET Framework to be installed, if the operating system does not ship with that version. The following community cookbooks are used to install the correct version of the .NET Framework:

- ms_dotnet

## Resources

### `powershell_module`

#### Deprecated

The `powershell_module` has been removed from this cookbook as it was non-functional for most needs and has been replaced with built in resources in chef:

- [powershell_package_source](https://docs.chef.io/resource_powershell_package_source.html)
- [powershell_package](https://docs.chef.io/resource_powershell_package.html)

## Usage

**Note**: The installation may require a restart of the node being configured before PowerShell can be used.

### default

The default recipe contains no resources and will do nothing if included on a run_list.

### powershell2

Include the `powershell2` recipe in a run list, to ensure PowerShell 2.0 is installed. If the platform is not supported, a warning will be logged.

### powershell3

Include the `powershell3` recipe in a run list, to install PowerShell 3.0 is installed on applicable platforms. If the platform is not supported, a warning will be logged.

### powershell4

Include the `powershell4` recipe in a run list, to install PowerShell 4.0 is installed on applicable platforms. If the platform is not supported, a warning will be logged.

### powershell5

Include the `powershell5` recipe in a run list, to install PowerShell 5.0 is installed on applicable platforms. If the platform is not supported, a warning will be logged.

## References

- Installing [Windows Management Framework 2.0](http://support.microsoft.com/kb/968929)
- Installing [Windows Management Framework 3.0](http://www.microsoft.com/en-us/download/details.aspx?id=34595)
- Installing [Windows Management Framework 4.0](http://www.microsoft.com/en-us/download/details.aspx?id=40855)
- Installing [Windows Management Framework 5.0](https://www.microsoft.com/en-us/download/details.aspx?id=50395)

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
