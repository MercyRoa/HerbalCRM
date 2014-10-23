# Load the rails application
require File.expand_path('../application', __FILE__)

# Turn off auto TLS for e-mail
ActionMailer::Base.smtp_settings[:openssl_verify_mode] = false
ActionMailer::Base.smtp_settings[:enable_starttls_auto] = false

# Initialize the rails application
HerbalCRM::Application.initialize!
