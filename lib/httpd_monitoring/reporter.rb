module HttpdMonitoring
  # Print a report to console when asked
  class Reporter
    def initialize(data)
      @data = data
    end

    def report
      print 'Report'
    end
  end
end
