source 'http://rubygems.org'

gem 'rails', '3.2.9'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

#gem "therubyracer"
#gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails", :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'haml-rails'
gem 'htmlentities'
gem 'will_filter'
gem 'kaminari'

gem 'chosen-rails'
gem 'aloha-rails', :github => 'neohunter/aloha-rails', :submodules => true

gem 'devise'

gem 'ensure-encoding'

# Move this to development only
# gem 'rack-bug', :require => 'rack/bug', :git => 'git://github.com/brynary/rack-bug.git', :branch => 'rails3'

gem 'gmail'

group :development do
  gem 'debugger', :require => 'debugger'
  #gem 'libv8', '~> 3.11.8'
  #gem "therubyracer"
end

group :development, :test do
  gem 'sqlite3'
  gem 'mysql2'
end
group :production do
  gem 'pg'
  gem 'thin' #for heroku, its a robust web server

  #gem 'therubyracer-heroku', :platforms => [:ruby]
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

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
