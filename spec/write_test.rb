require_relative 'test_log/test_log'

test = TestLog.new(File.dirname(__FILE__) + '/temp.log')
test.start
