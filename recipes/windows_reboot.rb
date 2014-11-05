# this recipe can be called from any recipe for windows reboot. Just specify default['powershell']['reboot_notifier']
node.default['windows']['allow_pending_reboots'] = true
node.default['windows']['allow_reboot_on_failure'] = true

include_recipe 'windows::reboot_handler'

windows_reboot 'rebooter' do 
	reason 'Reboot after successful/unsuccessful powershell installation' 
	timeout 60 
	notifies :run, node['powershell']['reboot_notifier'], :immediately 
	not_if { false }
end