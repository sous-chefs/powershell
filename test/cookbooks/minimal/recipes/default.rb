include_recipe 'powershell::default'

powershell_module 'posh-git' do
  package_name 'posh-git'
  source 'https://github.com/dahlbyk/posh-git/zipball/master'
end
