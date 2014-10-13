require 'fileutils'
require_relative 'test_log/test_log'
require_relative '../lib/httpd_monitoring'

def run_w3c_test
  log_file = File.dirname(__FILE__) + '/temp.log'
  FileUtils.touch(log_file)
  thread = Thread.new do
    HttpdMonitoring::CLI.new([log_file]).run
  end
  test = TestLog.new(log_file)
  test.start

  thread.exit
end
