# powershell_winrm

Configures WinRM for DSC and remote PowerShell usage.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Enables WinRM and optionally creates an HTTPS listener (default) |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | String | name property | Resource name |
| `enable_https_transport` | Boolean | `false` | Whether to create an HTTPS listener |
| `thumbprint` | String | `''` | Certificate thumbprint used for HTTPS transport |
| `hostname` | String | `''` | Hostname bound to the HTTPS listener |

## Examples

```ruby
powershell_winrm 'default'
```

```ruby
powershell_winrm 'default' do
  enable_https_transport true
  hostname 'node.example.com'
  thumbprint 'ABCDEF1234567890'
end
```
