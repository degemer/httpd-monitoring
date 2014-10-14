require 'fileutils'
require_relative 'test_log/test_log'
require_relative '../lib/httpd_monitoring'

def run_w3c_test
  log_file = File.dirname(__FILE__) + '/temp.log'
  FileUtils.touch(log_file)
  thread = Thread.new { HttpdMonitoring::CLI.new([log_file]).run }
  test = TestLog.new(log_file)
  trap('INT') do
    puts 'Exiting test'
    thread.exit
  end
  test.start

  thread.exit
end
