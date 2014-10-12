module HttpdMonitoring
  # Command line parsing
  class Options
    def initialize(args)
    end

    def path
      './spec/temp.log'
    end

    def threshold
      1000
    end
  end
end
