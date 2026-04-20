# powershell_wmf

Installs a legacy Windows Management Framework release when the target platform requires it.

## Actions

| Action | Description |
|--------|-------------|
| `:install` | Installs the requested WMF release (default) |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `version` | String | name property | WMF version to install (`2.0`, `3.0`, `4.0`, `5.1`) |
| `download_url` | String | computed | Override the Microsoft package URL |
| `checksum` | String | computed | Override the Microsoft package checksum |
| `package` | String | computed | Override the inner package name for zipped WMF archives |
| `timeout` | Integer | computed | Override the installer timeout |
| `dotnet_version` | String | computed | .NET Framework version requested from `ms_dotnet` |
| `reboot_mode` | String | `'no_reboot'` | Reboot strategy after installation |
| `reboot_timeout_seconds` | Integer | `10` | Delay used for delayed reboot requests |

## Examples

```ruby
powershell_wmf '5.1'
```

```ruby
powershell_wmf '4.0' do
  reboot_mode 'delayed_reboot'
end
```
