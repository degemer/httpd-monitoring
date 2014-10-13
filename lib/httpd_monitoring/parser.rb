module HttpdMonitoring
  # Parse a w3c log line into a Hash
  class Parser
    def initialize
      @months = { 'Jan' => 1, 'Feb' => 2, 'Mar' => 3, 'Apr' => 4, 'May' => 5,
                 'Jun' => 6, 'Jul' => 7, 'Aug' => 8, 'Sep' => 9, 'Oct' => 10,
                 'Nov' => 11, 'Dec' => 12 }
      @regex = %r{^(.+) (.+) (.+) \[(.+)\] "(\w+) (/[^/]*).* (.+)" (\d+) (\d+)$}
    end

    def parse(line)
      matches = @regex.match(line)
      result = {}
      result[:host] = matches[1]
      # result[:name]
      # result[:user]
      result[:date] = parse_time(matches[4])
      # result[:method]
      result[:path] = matches[6]
      # result[:protocol]
      # result[:status]
      result[:bytes] = matches[9].to_i
      result
    end

    protected

    def parse_time(time)
      matches = %r{^(\d+)/(\w+)/(\d+):(\d+):(\d+):(\d+) (...)(..)$}.match(time)
      Time.new(matches[3].to_i, parse_month(matches[2]), matches[1].to_i,
               matches[4].to_i, matches[5].to_i, matches[6].to_i,
               matches[7] + ':' + matches[8])
    end

    def parse_month(month)
      @months[month]
    end
  end
end
