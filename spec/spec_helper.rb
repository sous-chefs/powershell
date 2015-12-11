require 'chefspec'
require 'chefspec/berkshelf'
require 'helpers/matchers'

def not_windows?
  (RUBY_PLATFORM =~ /mswin|mingw|windows/).nil?
end
