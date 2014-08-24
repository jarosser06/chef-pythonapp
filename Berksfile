source "https://supermarket.getchef.com"

cookbook 'genericapp', git: 'git@github.com:jarosser06/rackspace-genericapp.git'

group :integration do
  cookbook 'pythonapp-test', path: 'test/cookbooks/pythonapp-test'
  cookbook 'nginx'
  cookbook 'apt'
  cookbook 'yum-epel'
  cookbook 'build-essential'
  cookbook 'python'
  cookbook 'nodejs'
  cookbook 'supervisor'
end

metadata
