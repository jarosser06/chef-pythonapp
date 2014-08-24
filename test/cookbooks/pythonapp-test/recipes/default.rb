package 'git'

directory '/var/www' do
  action :create
  owner node['nginx']['user']
  group node['nginx']['group']
end

node.default['nginx']['default_site_enabled'] = false

include_recipe 'build-essential'
include_recipe 'supervisor'
include_recipe 'nginx'
include_recipe 'nodejs::npm'

case node.platform_family
when 'debian'
  python_dev = 'python-dev'
when 'fedora', 'rhel'
  python_dev = 'python-devel'
end

nodejs_npm 'grunt-cli' do
  action :install
end

python_app 'tessera.example.com' do
  repository 'git://github.com/urbanairship/tessera.git'
  owner node['nginx']['user']
  group node['nginx']['group']
  web_server 'nginx'
  revision 'master'
  eggs %w(gunicorn)
  path '/var/www/tessera'
  after_checkout do
    execute "npm_install_grunt" do
      command '/usr/bin/npm install grunt'
      cwd '/var/www/tessera'
      environment('HOME' => '/root')
      user 'root'
    end

    %w(watch concat handlebars).each do |grunt_lib|
      lib_name = "grunt-contrib-#{grunt_lib}"
      execute "npm_install_#{lib_name}" do
        user 'root'
        cwd '/var/www/tessera'
        command "/usr/bin/npm install #{lib_name}"
        environment('HOME' => '/root')
      end
    end

    execute 'generate_js' do
      cwd '/var/www/tessera'
      command '/usr/bin/grunt'
      action :run
    end

    ## TODO: This can probably be handled by the genericapp resource
    directory '/var/log/tessera' do
      action :create
      owner node['nginx']['user']
      group node['nginx']['group']
    end
  end
  web_params(port: 80,
             access_log: '/var/log/tessera/access.log',
             error_log: '/var/log/tessera/error.log')
  notifies :restart, 'supervisor_service[tessera]', :delayed
end

supervisor_service 'tessera' do
  action [:enable, :start]
  user node['nginx']['user']
  command 'gunicorn tessera:app'
  autostart true
  directory '/var/www/tessera'
end
