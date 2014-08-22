source "https://supermarket.getchef.com"

cookbook 'genericapp', git: 'git@github.com:jarosser06/rackspace-genericapp.git'

group :integration do
  cookbook 'pythonapp-test', path: 'test/cookbooks/pythonapp-test'
  cookbook 'apache2'
  cookbook 'nginx'
  cookbook 'apt'
  cookbook 'yum-epel'
end

metadata
