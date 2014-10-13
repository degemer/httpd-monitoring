module HttpdMonitoring
  # Print a report to console when asked
  class Reporter
    def initialize(data)
      @data = data
    end

    def report
      print @data.select_data_10s.to_s + "\n"
    end
  end
end
