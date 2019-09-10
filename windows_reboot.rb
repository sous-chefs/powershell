# this recipe can be called from any recipe for windows reboot. Just specify default['powershell']['reboot_notifier']
node.default['windows']['allow_pending_reboots'] = true
node.default['windows']['allow_reboot_on_failure'] = true
node.default['windows']['delay'] = 0

reboot 'powershell' do
  delay_mins node['windows']['delay']
  action :nothing
end
