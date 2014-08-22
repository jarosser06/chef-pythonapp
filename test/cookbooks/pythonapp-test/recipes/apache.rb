include_recipe 'pythonapp-test'
include_recipe 'apache2'

python_app 'magic.com' do
  repository 'https://github.com/TAMUArch/magic.git'
  owner node['apache']['user']
  group node['apache']['group']
  path '/var/www/magic'
end
