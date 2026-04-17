require 'bundler/setup'

ENV['RAILS_ENV'] ||= 'test'

require 'logger'
require 'gemika'
require 'rake'

require_relative 'support/rails_app'

Dir[File.expand_path('support/**/*.rb', __dir__)].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
