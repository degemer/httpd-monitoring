module HttpdMonitoring
  # Receive w3c-log line, store it and then trigger alert if needed
  class Processor
    def initialize(data, printer, logger, threshold)
      @data = data
      @threshold = threshold
      @logger = logger
      @alert = false
      @printer = printer
    end

    def process(line)
      datas = HttpdMonitoring::Parser.parse_w3c(line)
      if datas.nil?
        @logger.warn("Line could not be parsed: #{line}\n")
      else
        @data.insert(datas)
        alert_or_recover(@data.hits_2min, datas[:date])
      end
    end

    protected

    def alert_or_recover(hits, date)
      alert(hits, date) if !@alert && hits >= @threshold
      recover(hits, date) if @alert && hits < @threshold
    end

    def alert(hits, date)
      @alert = true
      @printer.print_alert(hits, date)
    end

    def recover(hits, date)
      @alert = false
      @printer.print_recover(hits, date)
    end
  end
end
