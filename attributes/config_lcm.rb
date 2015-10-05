
## temporary directory related attributes ##
default['lcm']['mof']['temp_dir'] = "#{Chef::Config[:file_cache_path]}\\lcm_mof"

## lcm configuration related attributes ##
default['lcm']['config']['enable']['config_mode'] = 'ApplyOnly'
default['lcm']['config']['enable']['reboot_node'] = false
default['lcm']['config']['enable']['refresh_mode'] = 'Push'
default['lcm']['config']['disable']['refresh_mode'] = 'Disabled'
