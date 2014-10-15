require 'rake'
require 'rubocop/rake_task'
require_relative 'spec/test_log'
require_relative 'lib/httpd_monitoring'

desc 'Run RuboCop'
RuboCop::RakeTask.new(:syntax)

desc 'Test with generated w3c file'
task :test_log do
  log_file = File.dirname(__FILE__) + '/temp.log'
  FileUtils.touch(log_file)
  thread = Thread.current
  Thread.new do
    TestLog.new(log_file).start
    thread.exit
  end
  HttpdMonitoring::CLI.new(['-l', '1200', log_file]).run
end

task default: [:syntax, :test_log]
