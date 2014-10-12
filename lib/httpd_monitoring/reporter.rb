module HttpdMonitoring
  class Reporter
    def initialize(data)
      @data = data
    end

    def report
      print 'Report'
    end
  end
end
