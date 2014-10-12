module HttpdMonitoring
  class Reader < EventMachine::FileTail
    def initialize(path, processor)
      super(path, -1)
      @processor = processor
      @buffer = BufferedTokenizer.new
    end

    def receive_data(data)
      @buffer.extract(data).each do |line|
        # @processor.process(line)
        print line + "\n"
      end
    end
  end
end
