require 'fileutils'
require_relative 'test_log/test_log'
require_relative '../lib/httpd_monitoring'

def run_w3c_test
  log_file = File.dirname(__FILE__) + '/temp.log'
  FileUtils.touch(log_file)
  thread = Thread.current
  Thread.new do
    TestLog.new(log_file).start
    thread.exit
  end
  HttpdMonitoring::CLI.new([log_file]).run
end
