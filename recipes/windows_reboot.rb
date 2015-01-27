# this recipe can be called from any recipe for windows reboot. Just specify default['powershell']['reboot_notifier']
node.default['windows']['allow_pending_reboots'] = true
node.default['windows']['allow_reboot_on_failure'] = true

include_recipe 'windows::reboot_handler'

windows_reboot 'powershell' do
  reason 'Reboot after successful/unsuccessful powershell installation'
  timeout node['powershell']['reboot_timeout_seconds']
  action :nothing
  notifies :run, 'ruby_block[end_chef_run]', :immediately if node['powershell']['installation_reboot_mode'] == 'immediate_reboot'
end

# The reboot handler only does something at the end of the chef run. If it
# needs to happen straight away to be useful, throw an exception...
ruby_block 'end_chef_run' do
  block do
    fail 'Requested sudden end to the run... I hope this was justified.'
  end
  action :nothing
end
