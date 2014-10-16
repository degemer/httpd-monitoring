module HttpdMonitoring
  # Parse error emited by HttpdMonitoring::Parser
  class W3cParseError < StandardError
    attr_reader :line

    def initialize(line)
      @line = line
    end
  end
end
