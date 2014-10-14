module HttpdMonitoring
  # Launch the program
  class CLI
    def initialize(args)
      @args = HttpdMonitoring::Options.new(args)
      @data = HttpdMonitoring::Data.new
      @path = @args.path
      @reporter = HttpdMonitoring::Reporter.new(@data)
      @parser = HttpdMonitoring::Processor.new(@data, @reporter, @args.threshold)
    end

    def run
      EventMachine.run do
        Signal.trap('INT') do
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
