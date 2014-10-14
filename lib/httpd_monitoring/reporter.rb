module HttpdMonitoring
  # Print a report to console when asked
  class Reporter
    def initialize(data)
      @data = data
    end

    def report
      print Time.now.to_s + @data.select_data_10s.to_s + "\n"
    end

    def alert(hits, time)
      print "High traffic generated an alert - hits = #{hits}, triggered at #{time}\n"
    end

    def recover(hits, time)
      print "Recover form alert - current hits = #{hits}, recovered at #{time}\n"
    end
  end
end
