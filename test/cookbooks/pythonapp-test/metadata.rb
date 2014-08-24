name             'pythonapp-test'
maintainer       'Rackspace'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures pythonapp-test'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w(
  pythonapp
  nginx
  build-essential
  python
  supervisor
  nodejs
).each do |cookbook|
  depends cookbook
end
