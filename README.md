# Powershell Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/powershell.svg)](https://supermarket.chef.io/cookbooks/powershell)
[![CI State](https://github.com/sous-chefs/powershell/workflows/ci/badge.svg)](https://github.com/sous-chefs/powershell/actions?query=workflow%3Aci)

This cookbook provides custom resources for managing legacy Windows Management Framework
(WMF) installers and the supporting WinRM / DSC configuration required by older Windows
platforms.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef
cookbook maintainers working together to maintain important cookbooks. If you would like to
know more, visit [sous-chefs.org](https://sous-chefs.org/).

## Requirements

- Chef Infra Client `>= 15.3`
- Windows
- `ms_dotnet` `>= 3.2.1`

## Resources

- `powershell_wmf`
- `powershell_winrm`
- `powershell_dsc`
- `powershell_lcm`

See [`LIMITATIONS.md`](LIMITATIONS.md) for the supported Microsoft download matrix and
lifecycle notes.

## Usage

Install WMF 5.1 when the target platform needs it:

```ruby
powershell_wmf '5.1'
```

Prepare WinRM for DSC with an HTTPS listener:

```ruby
powershell_dsc 'default' do
  enable_https_transport true
  hostname 'node.example.com'
  thumbprint 'ABCDEF1234567890'
end
```

Enable or disable the Local Configuration Manager:

```ruby
powershell_lcm 'default'

powershell_lcm 'default' do
  action :disable
end
```

## Testing

Local Vagrant runs use `kitchen.yml`. CI uses the exec driver with `kitchen.exec.yml`.

```shell
berks install
cookstyle
chef exec rspec --format documentation
kitchen test default-windows-2019 --destroy=always
```
