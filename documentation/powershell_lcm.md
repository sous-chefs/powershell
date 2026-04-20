# powershell_lcm

Configures the Windows Local Configuration Manager for Desired State Configuration.

## Actions

| Action | Description |
|--------|-------------|
| `:enable` | Generates and applies an LCM configuration (default) |
| `:disable` | Disables LCM refresh mode |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | String | name property | Resource name |
| `temp_dir` | String | cached path | Temporary directory used for generated MOF files |
| `config_mode` | String | `'ApplyOnly'` | LCM configuration mode |
| `reboot_node` | Boolean | `false` | Whether DSC is allowed to reboot the node |
| `refresh_mode` | String | `'Push'` | Refresh mode used by `:enable` |
| `disabled_refresh_mode` | String | `'Disabled'` | Refresh mode used by `:disable` |

## Examples

```ruby
powershell_lcm 'default'
```

```ruby
powershell_lcm 'default' do
  action :disable
end
```
