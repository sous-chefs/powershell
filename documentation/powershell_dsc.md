# powershell_dsc

Installs the PowerShell prerequisites required for Desired State Configuration.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Installs WMF 4.0 prerequisites and configures WinRM (default) |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | String | name property | Resource name |
| `enable_https_transport` | Boolean | `false` | Whether WinRM should expose an HTTPS listener |
| `thumbprint` | String | `''` | Certificate thumbprint used for HTTPS transport |
| `hostname` | String | `''` | Hostname bound to the HTTPS listener |

## Examples

```ruby
powershell_dsc 'default'
```

```ruby
powershell_dsc 'default' do
  enable_https_transport true
  hostname 'node.example.com'
  thumbprint 'ABCDEF1234567890'
end
```
