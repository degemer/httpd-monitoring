module HttpdMonitoring
  # Receive w3c-log line, store it and then trigger alert if needed
  class Processor
    def initialize(data, reporter, threshold)
      @data = data
      @threshold = threshold
      @alert = false
      @reporter = reporter
    end

    def process(line)
      datas = HttpdMonitoring::Parser.parse_w3c(line)
      @data.insert(datas)
      alert_or_recover(@data.hits_2min, datas[:date])
    end

    protected

    def alert_or_recover(hits, date)
      alert(hits, date) if !@alert && hits >= @threshold
      recover(hits, date) if @alert && hits < @threshold
    end

    def alert(hits, date)
      @alert = true
      @reporter.alert(hits, date)
    end

    def recover(hits, date)
      @alert = false
      @reporter.recover(hits, date)
    end
  end
end
