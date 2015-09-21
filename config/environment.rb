# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Startashop::Application.initialize!
#config.gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'


ENV['RAILS_ENV'] ||= 'production'
#Startashop::Application.config.action_controller.session_store = :active_record_store
