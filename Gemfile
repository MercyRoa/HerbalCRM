source 'http://rubygems.org'
ruby '1.9.3'
gem 'rails', '3.2.9'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'
#gem 'libv8', '~> 3.11.8'
#gem "therubyracer", :platforms => :ruby

#gem 'execjs'
#gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS

gem "twitter-bootstrap-rails", :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'haml-rails'
gem 'htmlentities'
gem 'will_filter', github: 'jhenderson22/will_filter'
gem 'kaminari'

gem 'chosen-rails'
gem 'aloha-rails', :github => 'neohunter/aloha-rails', :submodules => true

gem 'devise'

gem 'ensure-encoding'

# Move this to development only
# gem 'rack-bug', :require => 'rack/bug', :git => 'git://github.com/brynary/rack-bug.git', :branch => 'rails3'

gem 'gmail'
gem 'pry'

group :development do
  gem 'debugger', :require => 'debugger'
  # gem "therubyracer"
  gem 'pry-rails'
  gem 'pry-remote'
end

gem 'mysql2'
group :development, :test do
#  gem 'sqlite3'
#  gem 'mysql2'
end
group :production do
#  gem 'pg'
#  gem 'mysql2'
  gem 'thin' #for heroku, its a robust web server

  # gem 'therubyracer-heroku'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'less' #need this if have less-rails?
  gem 'therubyracer', :platforms => :ruby
  #gem 'therubyracer', '0.11.0beta8' # with precompiled binaries... remove libv8
  gem 'uglifier', '>= 1.0.3'
  gem "less-rails"
  gem 'libv8', '~> 3.11.8'

end

gem 'jquery-rails'
gem 'jquery-ui-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', '~> 0.8.3', :require => false
end
