include_recipe 'pythonapp-test'
include_recipe 'nginx'

python_app 'magic.com' do
  repository 'https://github.com/TAMUArch/magic.git'
  owner node['apache']['user']
  group node['apache']['group']
  web_server 'nginx'
  path '/var/www/magic'
end
