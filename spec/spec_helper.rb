require 'rubygems'
require 'bundler/setup'
require 'webmock/rspec'

require 'simplecov'
SimpleCov.start do
  add_filter "/vendor/"
end

require 'reittiopas2'


RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
