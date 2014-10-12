module HttpdMonitoring
  # Launch the program
  class CLI
    def initialize(args)
      @parsed_args = HttpdMonitoring::Options.new(args)
      @data = HttpdMonitoring::Data.new
      @parser = HttpdMonitoring::Processor.new(@data)
      @path = @parsed_args.path
      @reporter = HttpdMonitoring::Reporter.new(@data)
    end

    def run
      EventMachine.run do
        Signal.trap('INT')  { EventMachine.stop }
        Signal.trap('TERM') { EventMachine.stop }
        EventMachine.file_tail(@path, HttpdMonitoring::Reader, @parser)
        EventMachine::PeriodicTimer.new(10) do
          @reporter.report
        end
      end
    end
  end
end
