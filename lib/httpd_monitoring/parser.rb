module HttpdMonitoring
  class Parser
    def initialize
    end

    def parse(line)
      line =~ /^(.+) (.+) (.+) \[(.+)\] "(\w+) (.+) (.+)" (\d+) (\d+)$/
      result = {}
      result[:host] = Regexp.last_match[1]
      result[:name] = Regexp.last_match[2]
      result[:user] = Regexp.last_match[3]
      result[:date] = Regexp.last_match[4]
      # result[:method]
      result[:path] = Regexp.last_match[6]
      # result[:protocol]
      # result[:status]
      result[:bytes] = Regexp.last_match[9]
      result
    end
  end
end
