require 'rake'
require 'rubocop/rake_task'
require_relative 'spec/write_test'

desc 'Run RuboCop'
RuboCop::RakeTask.new(:syntax)

desc 'Test with generated w3c file'
task :test_log do
  run_w3c_test
end

task default: [:syntax, :test_log]
