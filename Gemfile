source :rubygems

gem "rails", "3.0.3"
gem "mysql2", '0.2.6'

gem 'aasm', '2.2.0'
gem 'acts_as_list', '0.1.2'
gem 'authlogic', :git => 'git://github.com/jjb/authlogic.git'
gem 'haml', '3.0.25'
gem 'redirect_routing', '0.0.4'
gem 's3', '0.2.8'
gem 'will_paginate', '~> 3.0pre2'

group :staging, :production do
  gem 'whenever'
end

group :development, :test do
  gem "rspec-rails", '2.4.0'
end

group :test do
  gem "ZenTest", :require => "zentest"
  gem "rspec", '2.4.0'
  gem "factory_girl", '1.3.2'
  gem "factory_girl_rails"
  gem "webrat"
end

