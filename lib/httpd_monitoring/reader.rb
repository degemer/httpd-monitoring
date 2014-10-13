module HttpdMonitoring
  # Read line from w3c-log and then pass it to a HttpdMonitoring::Processor
  class Reader < EventMachine::FileTail
    def initialize(path, processor)
      super(path, -1)
      @processor = processor
      @buffer = BufferedTokenizer.new
    end

    def receive_data(data)
      @buffer.extract(data).each do |line|
        @processor.process(line)
      end
    end
  end
end
