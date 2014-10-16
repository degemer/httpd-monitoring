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

    # Parse a w3c line, save parsed hash, and check if threshold has been hit
    def process(line)
      datas = HttpdMonitoring::Parser.parse_w3c(line)
      @data.insert(datas)
      alert_or_recover(@data.hits_2min, datas[:date])
    rescue HttpdMonitoring::W3cParseError => e
      @logger.warn("Could not parse: #{e.line}\n")
    end

    protected

    # Check if alert or recover is triggered
    def alert_or_recover(hits, date)
      alert(hits, date) if !@alert && hits >= @threshold
      recover(hits, date) if @alert && hits < @threshold
    end

    # Save alert state and print it
    def alert(hits, date)
      @alert = true
      @printer.print_alert(hits, date)
    end

    # Save recover state and print it
    def recover(hits, date)
      @alert = false
      @printer.print_recover(hits, date)
    end
  end
end
