module HttpdMonitoring
  # Parse a w3c log line into a Hash
  class Parser
    MONTHS = { 'Jan' => 1, 'Feb' => 2, 'Mar' => 3, 'Apr' => 4, 'May' => 5,
               'Jun' => 6, 'Jul' => 7, 'Aug' => 8, 'Sep' => 9, 'Oct' => 10,
               'Nov' => 11, 'Dec' => 12 }
    REGEX_W3C = %r{^(.+)\s # Host
                    (.+)\s # user-identifier
                    (.+)\s # userid
                    \[(.+)\]\s # Date
                    "(\w+)\s(/[^/]*).*\s(.+)"\s # Request
                    (\d+)\s # Status code
                    (\d+|-)$ # Size
                  }x
    REGEX_TIME = %r{^(\d+)/(\w+)/(\d+):(\d+):(\d+):(\d+) (...)(..)$}

    def self.parse_w3c(line)
      matches = REGEX_W3C.match(line)
      fail W3cParseError, line unless matches
      result = {}
      result[:host] = matches[1]
      result[:date] = parse_time(matches[4])
      result[:path] = matches[6]
      result[:bytes] = matches[9].to_i
      result
    end

    def self.parse_time(time)
      matches = REGEX_TIME.match(time)
      fail W3cParseError, time unless matches
      Time.new(matches[3].to_i, MONTHS[matches[2]], matches[1].to_i,
               matches[4].to_i, matches[5].to_i, matches[6].to_i,
               matches[7] + ':' + matches[8])
    end
  end
end
