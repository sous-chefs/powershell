# frozen_string_literal: true

require 'chefspec'
require 'chefspec/berkshelf'

Dir[File.join(__dir__, '..', 'libraries', '*.rb')].sort.each { |f| require File.expand_path(f) }

if ENV['CHEFSPEC_NO_ZERO_SERVER']
  module ChefSpec
    class ZeroServer
      class << self
        def setup!; end

        def reset!; end

        def teardown!; end
      end
    end
  end
end

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
  config.server_runner_port = 0
end
