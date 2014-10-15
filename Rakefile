require 'rake'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require_relative 'spec/test_log'
require_relative 'lib/httpd_monitoring'

desc 'Run RuboCop'
RuboCop::RakeTask.new(:syntax)

desc 'Run Rspec'
RSpec::Core::RakeTask.new(:spec)

desc 'Short test (just trigger)with generated w3c file'
task :short_test do
  scenario = [10, 0, 0.01, 1, 0, 1]
  TestLog.run(scenario, 1200)
end

desc 'Long test with generated w3c file'
task :long_test do
  scenario = [10, 0, 0.01, 0.1, 0.1, 0.1, 10, 1, 1, 10, 1, 1, 1, 1,
              10, 1, 0.1, 0, 0.1, 0.1, 10, 1, 1, 10, 1, 1, 1, 1]
  TestLog.run(scenario, 1200)
end

task default: [:syntax, :spec, :long_test]
