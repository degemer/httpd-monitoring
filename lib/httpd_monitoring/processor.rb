module HttpdMonitoring
  class Processor
    def initialize(data)
      @data = data
      @parser = HttpdMonitoring::Parser.new
    end

    def process(line)
      @data.insert(@parser.parse(line))
      alert if @data.hits_reached?
    end

    def alert
    end
  end
end
