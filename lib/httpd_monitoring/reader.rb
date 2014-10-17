module HttpdMonitoring
  # Read line from w3c-log and then pass it to a HttpdMonitoring::Alarm
  class Reader < EventMachine::FileTail
    def initialize(path, alarm)
      super(path, -1)
      @alarm = alarm
      @buffer = BufferedTokenizer.new
    end

    # Taken from https://github.com/jordansissel/eventmachine-tail/blob/master/samples/tail.rb
    # Called for every new line
    def receive_data(data)
      @buffer.extract(data).each do |line|
        @alarm.process(line)
      end
    end
  end
end
