module HttpdMonitoring
  # Receive w3c-log line, store it and then trigger alert if needed
  class Processor
    def initialize(data, threshold)
      @data = data
      @parser = HttpdMonitoring::Parser.new
      @threshold = threshold
      @alert = false
    end

    def process(line)
      @data.insert(@parser.parse(line))
      alert_or_recover(@data.traffic_2min)
    end

    def alert_or_recover(hits)
      send_alert if !@alert && hits >= @threshold
      send_recover if @alert && hits < @threshold
    end

    def send_alert
      @alert = true
    end

    def send_recover
      @alert = false
    end
  end
end
