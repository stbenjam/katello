ENV["RAILS_ENV"] = "test"

require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'minitest/rails'


class MiniTest::Rails::ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.fixture_path = File.expand_path('../fixtures/models', __FILE__)
end

def configure_vcr
  require "vcr"

  mode = ENV['mode'] ? ENV['mode'] : :all

  VCR.configure do |c|
    c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
    c.hook_into :webmock
    c.default_cassette_options = { :record => mode.to_sym } #record_mode } #forcing all requests to Pulp currently
  end
end


class CustomMiniTestRunner
  class Unit < MiniTest::Unit

    def before_suites
      # code to run before the first test
    end

    def after_suites
      # code to run after the last test
    end

    def _run_suites(suites, type)
      begin
        before_suites
        super(suites, type)
      ensure
        after_suites
      end
    end

    def _run_suite(suite, type)
      begin
        suite.before_suite if suite.respond_to?(:before_suite)
        super(suite, type)
      ensure
        suite.after_suite if suite.respond_to?(:after_suite)
      end
    end

  end
end

MiniTest::Unit.runner = CustomMiniTestRunner::Unit.new
