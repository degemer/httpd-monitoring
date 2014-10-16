module HttpdMonitoring
  # Launch the program
  class CLI
    def initialize(args)
      @args = Options.new(args)
      @logger = Logger.new(STDOUT)
      @logger.level = @args.debug? ? Logger::DEBUG : Logger::ERROR
      @data = Data.new
      @path = @args.path
      @printer = Printer.new
      @reporter = Reporter.new(@data, @printer, @args.limit_print)
      @parser = Processor.new(@data, @printer, @logger, @args.threshold)
    end

    def run
      EventMachine.run do
        Signal.trap('INT') do
          print "Exiting httpd-monitoring\n"
          EventMachine.stop
          Thread.exit
        end
        EventMachine.file_tail(@path, HttpdMonitoring::Reader, @parser)
        EventMachine::PeriodicTimer.new(10) do
          @reporter.report
        end
      end
    end
  end
end
