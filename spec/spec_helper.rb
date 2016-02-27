require 'chefspec'
require 'chefspec/berkshelf'
require 'helpers/matchers'

def not_windows?
  (RUBY_PLATFORM =~ /mswin|mingw|windows/).nil?
end

# Require all our libraries
Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }
