$LOAD_PATH.unshift File.expand_path File.dirname(__FILE__)

require 'simplecov'
require 'coveralls'
require 'pry'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter 'spec'
end

require 'flatrack'
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run focus: true
  config.before(:each){ Flatrack.reset! }
end
