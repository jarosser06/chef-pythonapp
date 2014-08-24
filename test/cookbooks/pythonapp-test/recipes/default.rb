package 'git'

directory '/var/www' do
  action :create
  owner node['apache']['user']
  group node['apache']['group']
end

include_recipe 'build-essential'
include_recipe 'python::pip'
include_recipe 'nginx'

case node.platform_family
when 'debian'
  python_dev = 'python-dev'
when 'fedora', 'rhel'
  python_dev = 'python-devel'
end

## Required by uwsgi
package python_dev do
  action :install
end

python_app 'tessera.example.com' do
  repository 'git://github.com/urbanairship/tessera.git'
  owner node['nginx']['user']
  group node['nginx']['group']
  web_server 'nginx'
  revision 'master'
  eggs %w(uwsgi)
  path '/var/www/tessera'
end
